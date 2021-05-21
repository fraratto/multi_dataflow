`timescale 1ns / 1ps
`include "fifo_interface.sv"

module fifo_ms#(
    DATA_WIDTH = 8,
    DEPTH = 8, 
    FLUX = 2
)(
    input clk,
    input rst,
    read_interface.fifo read_port,
    write_interface.fifo write_port
);
    
    parameter TAG_WIDTH = $clog2(FLUX);
    parameter ADDR_WIDTH = $clog2(DEPTH);
    parameter WIDTH = DATA_WIDTH+TAG_WIDTH; 
    
    
    //signals
    logic WnR [0:FLUX-1];                                   //write/read evaluation
    logic WnRnxt [0:FLUX-1];                                //next write/read evaluation
    logic [WIDTH-1:0] exits [0:FLUX-1];                     //needed for output mux
    logic [TAG_WIDTH-1:0] tag;                              //needed for tag recognition 
    
    assign tag = write_port.din[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)];    
            
    //pointers
    logic [ADDR_WIDTH-1:0] Wp [0:FLUX-1];                   //write pointer for each flux
    logic [ADDR_WIDTH-1:0] Wpnxt [0:FLUX-1];                //next write pointer for each flux
    logic [ADDR_WIDTH-1:0] Rp [0:FLUX-1];                   //read pointer for each flux
    logic [ADDR_WIDTH-1:0] Rpnxt [0:FLUX-1];                //next read pointer for each flux
    
    //loops
    integer i,k,l,m,n,p,q;                                  //needed for for loops
    genvar j;                                               //needed for output mux 
    
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
	
	generate for(j=0; j<FLUX; j=j+1)
		begin
		ram_interface #(DATA_WIDTH, DEPTH) mem_port (clk);
		assign mem_port.din = write_port.din[DATA_WIDTH-1:0];
		assign mem_port.write_address = Wp[j];
		assign mem_port.read_address = Rp[j];
		assign mem_port.write_en = write_port.write & (tag==j);
		assign read_port.dout = mem_port.dout;
    
		ram_dual_ported #(
			.DEPTH(DEPTH),
			.WIDTH(DATA_WIDTH)
			) mem (
			.port(mem_port.slave)
			);
		end
	endgenerate
          
    assign    read_port.dout = exits[reader(read_port.read)];
    
    //pointers' and WnR update
    always_ff@(posedge clk)
        if(rst) 
            for(k=0;k<=FLUX-1;k=k+1)
                begin
                    Wp[k]<=0;
                    Rp[k]<=0;
                    WnR[k]<=0;
                end
        else
            for(k=0;k<=FLUX-1;k=k+1)
                begin
                    Rp[k]<=Rpnxt[k]; 
                    Wp[k]<=Wpnxt[k]; 
                    WnR[k]<=WnRnxt[k]; 
                end
        
    //writing procedure
    always_ff@(posedge clk) 
        if(write_port.write==1)
                for(l=0;l<=FLUX-1;l=l+1)
                    begin
                        if(tag==l) 
                            mem_ram[Wp[l] + (DEPTH*l)] <= write_port.din[DATA_WIDTH-1:0];
                    end
                
    //reading procedure
    for(j=0;j<=FLUX-1;j=j+1)
        assign exits[j] = {j, mem_ram[Rp[j] + (DEPTH*j)]};                                          
        
    //next write pointer updates
    always_comb
        for(m=0;m<=FLUX-1;m=m+1)
            begin
                if(write_port.write==1 & tag==m)  
                    Wpnxt[m]=Wp[m]+1;
                else 
                    Wpnxt[m]=Wp[m];
            end
        
    //next read pointers updates
    always_comb
        for(n=0;n<=FLUX-1;n=n+1)
            begin
                if(read_port.read[n]==1) 
                    Rpnxt[n]=Rp[n]+1;
                else  
                    Rpnxt[n]=Rp[n];
            end
        
    //next WnR updates
    always_comb
        for(p=0;p<=FLUX-1;p=p+1)
            begin
                if(write_port.write==1 & tag==p & read_port.read[p]==0)  
                    WnRnxt[p]=1;
                else if(read_port.read[p]==1 & ( write_port.write==0 | (write_port.write==1 & tag!=p) ) ) 
                    WnRnxt[p]=0;
                else 
                    WnRnxt[p]=WnR[p];
            end
    
    //full/empty update    
    always_comb 
        for(q=0;q<=FLUX-1;q=q+1)
            begin
                if(Wp[q]==Rp[q])
                    if(WnR[q]) 
                        begin 
                            write_port.full[q]=1; 
                            read_port.empty[q]=0; 
                        end
                    else
                        begin
                            write_port.full[q]=0;
                            read_port.empty[q]=1; 
                        end
                else
                    begin
                        read_port.empty[q]=0; 
                        write_port.full[q]=0; 
                    end
            end
endmodule

