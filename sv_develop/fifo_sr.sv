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
    logic [WIDTH-1:0] mem_ram [0:DEPTH-1];              //data memory
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
    integer i;                                          //needed for for loops
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
                for(i=0;i<=FLUX-1;i=i+1)
                    begin
                        Rp[i]<=0;
                    end
            end
        else
            begin
                Wp<=Wpnxt;
                    for(i=0;i<=FLUX-1;i=i+1)
                        begin
                            Rp[i]<=Rpnxt[i];
                        end
            end            

    //signals' update - lastwrite            
    always_ff@(posedge clk)
        if(rst)
            begin
                for(i=0;i<=FLUX-1;i=i+1)
                        lastwrite[i]<=0;
            end                                 
        else if(write_port.write==1)  
            begin
                for(i=0;i<=FLUX-1;i=i+1)
                    if(tag==i)                 
                        lastwrite[i]<=Wp;                
            end

    //signals' update - statusreg
    always_ff@(posedge clk)
        if(rst)
            begin
                for(i=0;i<=DEPTH-1;i=i+1)
                        statusreg[i]<=0;
            end
        else if(write_port.write==1 | |read_port.read==1)
            begin
                if(write_port.write==1)
                    statusreg[Wp]<=1;                
                for(i=0;i<=FLUX-1;i=i+1)
                    begin
                        if(read_port.read[i]==1) 
                            statusreg[Rp[i]]<=0;
                    end
            end                                                                                                                    


    //signals' update - Rpstory            
    always_ff@(posedge clk)
        if(rst)
            begin
                for(i=0;i<=FLUX-1;i=i+1)
                        Rpstory[i]<=0;
            end                                 

        else if(write_port.write==1 | |read_port.read==1) 
            begin
                for(i=0;i<=FLUX-1;i=i+1)
                    begin
                        if(write_port.write & tag==i)                  
                            Rpstory[i]<=Rpstory[i]+1;
                        if(read_port.read[i]==1) 
                            Rpstory[i]<=Rpstory[i]-1;
                    end                                                        
            end

    //writing procedure
    always_ff@(posedge clk)
        if(write_port.write==1) 
                for(i=0;i<=FLUX-1;i=i+1)
                    begin
                        if(tag==i) 
                            begin
                                mem_ram[Wp]<=write_port.din;
                                if(Rpstory[i]!=0) 
                                    begin
                                        ram_nxt[lastwrite[i]]<=Wp;
                                    end
                            end
                    end       

    //reading procedure
    for(j=0;j<=FLUX-1;j=j+1)
        assign exits[j] = mem_ram[Rp[j]][j];               

    //empty locations detector
    always_comb   
        if(&statusreg)  
            nextloc = Wp;
        else
            for(i=DEPTH-1; i>=0; i=i-1)
                begin
                    if(statusreg[i]==0 && Wp!=i)
                        begin
                            nextloc = i;
                            break;
                        end
                    else 
                        nextloc = Wp; 
                end                

    //full evaluation data elaboration   
    always_comb
        begin
            Rptot=0;
                for(i=0;i<=FLUX-1;i=i+1)
                    begin
                        Rptot=Rptot+Rpstory[i];
                    end
        end


    //next write pointer updates
    always_comb    
        for(i=0;i<=FLUX-1;i=i+1)
            begin
                if(read_port.read[i]==1 & (Rptot==DEPTH | (Rptot==DEPTH-1 & write_port.write==1) ) )  
                   Wpnxt=Rp[i];
                else if(Rptot<DEPTH-1 & write_port.write==1)  
                   Wpnxt=nextloc;
                else 
                   Wpnxt=Wp;
            end

    //next read pointers updates
    always_comb 
        for(i=0;i<=FLUX-1;i=i+1)
            begin
                if(write_port.write==1 & tag==i & (Rpstory[i]==0 | (Rpstory[i]==1 & read_port.read==1) ) )   
                   Rpnxt[i]=Wp;
                else if(Rpstory[i]>1 & read_port.read[i]==1)  
                   Rpnxt[i]=ram_nxt[Rp[i]];
                else 
                   Rpnxt[i]=Rp[i];
            end

    //full/empty update
    always_comb 
        begin        
            if(Rptot==DEPTH)
                write_port.full=1;
            else 
                write_port.full=0;
                            
            for(i=0;i<=FLUX-1;i=i+1)
                begin
                    if(Rpstory[i]==0) 
                       read_port.empty[i]=1;
                    else 
                       read_port.empty[i]=0;
                end        
        end

endmodule