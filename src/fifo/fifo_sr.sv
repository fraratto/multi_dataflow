`timescale 1ns / 1ps
`include "fifo_interface.sv"
 
module fifo_sr#(
    DATA_WIDTH = 8, 
    DEPTH = 4,
    FLUX = 2
)(
    input clk,
    input rst,
    read_interface.fifo read_port,
    write_interface.fifo write_port 
);
    
    //local parameters 
    parameter TAG_WIDTH = $clog2(FLUX);
    parameter ADDR_WIDTH = $clog2(DEPTH);
    parameter WIDTH = DATA_WIDTH+TAG_WIDTH;
    
    //memories    
    logic [WIDTH-(TAG_WIDTH)-1:0] mem_ram [0:DEPTH-1];  //data memory
    logic [ADDR_WIDTH-1:0] ram_nxt [0:DEPTH-1];         //locations' order memory     
    logic [DEPTH-1:0] statusreg;                        //memory status
        
    //signals
    logic [ADDR_WIDTH:0] Rpstory [0:FLUX-1];            //number of occupied locations for each flux                                                                            
    logic [ADDR_WIDTH:0] Rptot;                         //number of all occupied locations
    logic [ADDR_WIDTH-1:0] nextloc;                     //next writeable location in data memory 
    logic [ADDR_WIDTH-1:0] lastwrite [0:FLUX-1];        //last written location for each flux 
    logic [WIDTH-1:0] exits [0:FLUX-1];                 //needed for output mux
    logic [TAG_WIDTH-1:0] tag;                          //needed for tag recognition 
    
    assign tag = write_port.din[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)];
            
    //pointers    
    logic [ADDR_WIDTH-1:0] Wp;                          //write pointer
    logic [ADDR_WIDTH-1:0] Wpnxt;                       //next write pointer 
    logic [ADDR_WIDTH-1:0] Rp [0:FLUX-1];               //read_pointer for each flux
    logic [ADDR_WIDTH-1:0] Rpnxt [0:FLUX-1];            //next read pointer for each flux
            
    //loops
    integer i,k,l,m,n,p,q,r,s,t,u;                      //needed for loops
    genvar j;                                           //needed for output mux 

    //output choice function (reader is the name of the function)
    function automatic [TAG_WIDTH-1 : 0] reader(input [FLUX-1 : 0] read_sig);
    /* read_sig is a one-hot signal. It shall be converted to binary to select the reader*/
    foreach(read_sig[i])
        if(read_sig[i])
            begin
                reader =  i;
                break;
            end
        else
            reader = 0;    
    endfunction
    
    //output choice      
    assign    read_port.dout = exits[reader(read_port.read)];

    //pointers' update
    always_ff@(posedge clk)
        if(rst)
            begin
                Wp<=0;
                for(k=0;k<=FLUX-1;k=k+1)
                    begin
                        Rp[k]<=0;
                    end
            end
        else
            begin
                Wp<=Wpnxt;
                    for(k=0;k<=FLUX-1;k=k+1)
                        begin
                            Rp[k]<=Rpnxt[k];
                        end
            end            

    //signals' update - statusreg
    always_ff@(posedge clk)
        if(rst)
            begin
                for(m=0;m<=DEPTH-1;m=m+1)
                        statusreg[m]<=0;
            end
        else if(write_port.write==1 | |read_port.read==1)
            begin
                if(write_port.write==1)
                    statusreg[Wp]<=1;                
                for(m=0;m<=FLUX-1;m=m+1)
                    begin
                        if(read_port.read[m]==1) 
                            statusreg[Rp[m]]<=0;
                    end
            end                                                                                                                    

    //signals' update - Rpstory            
    always_ff@(posedge clk)
        if(rst)
            begin
                for(n=0;n<=FLUX-1;n=n+1)
                        Rpstory[n]<=0;
            end                                 
        else if(write_port.write==1 | |read_port.read==1) 
            begin
                for(n=0;n<=FLUX-1;n=n+1)
                    begin                        
                        if(write_port.write & tag==n & read_port.read[n]==0)
                            begin                  
                                Rpstory[n]<=Rpstory[n]+1;
                            end
                        else if(read_port.read[n]==1 & ( write_port.write==0 | (write_port.write==1 & tag!=n) ) )
                            begin 
                                Rpstory[n]<=Rpstory[n]-1;
                            end    
                    end                                                        
            end

    //writing procedure
    always_ff@(posedge clk)
        if(write_port.write==1)
            begin
                mem_ram[Wp]<=write_port.din[WIDTH-(TAG_WIDTH)-1:0]; 
                for(p=0;p<=FLUX-1;p=p+1)
                    if(tag==p) 
                        begin
                            if(Rpstory[p]!=0) 
                                begin
                                    ram_nxt[lastwrite[p]]<=Wp;
                                end
                        end
            end                       

    //signals' update - lastwrite            
    always_ff@(posedge clk)
        if(rst)
            begin
                for(l=0;l<=FLUX-1;l=l+1)
                        lastwrite[l]<=0;
            end                                 
        else if(write_port.write==1)  
            begin
                for(l=0;l<=FLUX-1;l=l+1)
                    if(tag==l)                 
                        lastwrite[l]<=Wp;                
            end

    //reading procedure
    for(j=0;j<=FLUX-1;j=j+1)
        assign exits[j] = {j,mem_ram[Rp[j]]};               

    //empty locations detector
    always_comb   
        for(q=DEPTH-1; q>=0; q=q-1)
            begin
                if(statusreg[q]==0 && Wp!=q)
                    begin
                        nextloc = q;
                        break;
                    end
                else 
                    nextloc = Wp; 
            end                

    //full evaluation data elaboration   
    always_comb
        begin
            Rptot=0;
                for(r=0;r<=FLUX-1;r=r+1)
                    begin
                        Rptot=Rptot+Rpstory[r];
                    end
        end

    //next write pointer updates
    always_comb    
        for(s=0;s<=FLUX-1;s=s+1)
            begin
                if(read_port.read[s]==1 & (Rptot==DEPTH | (Rptot==DEPTH-1 & write_port.write==1) ) )  
                   Wpnxt=Rp[s];
                else if(Rptot<DEPTH-1 & write_port.write==1)  
                   Wpnxt=nextloc;
                else 
                   Wpnxt=Wp;
            end

    //next read pointers updates
    always_comb 
        for(t=0;t<=FLUX-1;t=t+1)
            begin
                if(write_port.write==1 & tag==t & (Rpstory[t]==0 | (Rpstory[t]==1 & read_port.read[t]==1) ) )    
                   Rpnxt[t]=Wp;
                else if(Rpstory[t]>1 & read_port.read[t]==1)  
                   Rpnxt[t]=ram_nxt[Rp[t]];
                else 
                   Rpnxt[t]=Rp[t];
            end

    //full/empty update
    always_comb 
        begin        
            if(Rptot==DEPTH)
                write_port.full='1;
            else 
                write_port.full='0;
                            
            for(u=0;u<=FLUX-1;u=u+1)
                begin
                    if(Rpstory[u]==0) 
                       read_port.empty[u]=1;
                    else 
                       read_port.empty[u]=0;
                end        
        end

endmodule