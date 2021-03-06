`timescale 1ns / 1ps
`include "fifo_interface.sv"
`include "ram_interface.sv"


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
    
	
    logic [DEPTH-1:0] statusreg;                        //memory status
        
    //signals
    logic [ADDR_WIDTH:0] Rpstory [0:FLUX-1];            //number of occupied locations for each flux                                                                            
    logic [ADDR_WIDTH:0] Rptot;                         //number of all occupied locations
    logic [ADDR_WIDTH-1:0] nextloc;                     //next writeable location in data memory 
    logic [ADDR_WIDTH-1:0] lastwrite [0:FLUX-1];        //last written location for each flux 
    logic [TAG_WIDTH-1:0] tag;                          //needed for tag recognition 
	logic [TAG_WIDTH-1:0] reader_id;					// binary code of the reader
	logic [ADDR_WIDTH-1:0]	addr_mem_port_dout;			// needed to update Rp
    
    assign tag = write_port.din[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)];
            
    //pointers    
    logic [ADDR_WIDTH-1:0] Wp;                          //write pointer
    logic [ADDR_WIDTH-1:0] Wpnxt;                       //next write pointer 
    logic [ADDR_WIDTH-1:0] Rp [0:FLUX-1];               //read_pointer for each flux
    logic [ADDR_WIDTH-1:0] Rpnxt [0:FLUX-1];            //next read pointer for each flux
                
    //loops
    integer i,k,l,m,n,p,q,r,t,u;                        //needed for loops
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

	assign reader_id = reader(read_port.read);

	// data_mem instantiation and connection
	ram_interface #(DATA_WIDTH, DEPTH) data_mem_port (clk);
	assign data_mem_port.din = write_port.din[DATA_WIDTH-1:0];
	assign data_mem_port.write_address = Wp;
	assign data_mem_port.read_address = Rp[reader_id];
	assign data_mem_port.write_en = write_port.write;
	assign read_port.dout = {reader_id, data_mem_port.dout};

	ram_dual_ported #(
		.DEPTH(DEPTH),
		.WIDTH(DATA_WIDTH)
		) data_mem (
		.port(data_mem_port.slave)
		);

	// addr_mem instantiation and connection
	ram_interface #(DATA_WIDTH, DEPTH) addr_mem_port (clk);
	assign addr_mem_port.din = Wp;
	assign addr_mem_port.write_address = lastwrite[tag];
	assign addr_mem_port.read_address = Rp[reader_id];
	assign addr_mem_port.write_en = write_port.write & (Rpstory[tag]!=0) ;
	assign addr_mem_port_dout = addr_mem_port.dout;

	ram_dual_ported #(
		.DEPTH(DEPTH),
		.WIDTH(ADDR_WIDTH)
		) addr_mem (
		.port(addr_mem_port.slave)
		);

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
        else if(write_port.write==1 & |read_port.read==1)
            begin
                statusreg[Wp]<=1;        
                statusreg[Rp[reader_id]]<=0;
            end       
        else if(write_port.write==1)
            begin
                statusreg[Wp]<=1;        
            end            
        else if(|read_port.read==1)
            begin
                statusreg[Rp[reader_id]]<=0;
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

    //signals' update - lastwrite            
    always_ff@(posedge clk)
        if(rst)
            begin
                for(l=0;l<=FLUX-1;l=l+1)
                        lastwrite[l]<=0;
            end                                 
        else if(write_port.write==1)  
            begin          
                lastwrite[tag]<=Wp;                
            end          

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
            begin
                if(|read_port.read==1 & (Rptot==DEPTH | (Rptot==DEPTH-1 & write_port.write==1) ) )  
                   Wpnxt=Rp[reader_id];
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
                   Rpnxt[t]=addr_mem_port_dout;
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