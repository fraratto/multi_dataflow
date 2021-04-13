`timescale 1ns / 1ps
`include "fifo_interface.sv"

module fifo_ms#(
    DATA_WIDTH = 8,
    DEPTH = 4, 
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
    
    //memories 
    logic [WIDTH-1:0] mem_ram [0:DEPTH-1][0:FLUX-1];    //data memory
    
    //signals
    logic WnR [0:FLUX-1];                               //write/read evaluation
    logic WnRnxt [0:FLUX-1];                            //next write/read evaluation
    logic [WIDTH-1:0] exits [0:FLUX-1];                 //needed for output mux
    logic [TAG_WIDTH-1:0] tag;                          //needed for tag recognition 
    
    assign tag = write_port.din[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)];    
            
    //pointers
    logic [ADDR_WIDTH-1:0] Wp [0:FLUX-1];               //write pointer for each flux
    logic [ADDR_WIDTH-1:0] Wpnxt [0:FLUX-1];            //next write pointer for each flux
    logic [ADDR_WIDTH-1:0] Rp [0:FLUX-1];               //read pointer for each flux
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
          
    assign    read_port.dout = exits[reader(read_port.read)];
    
    //pointers' and WnR update
    always_ff@(posedge clk)
        if(rst) 
            for(i=0;i<=FLUX-1;i=i+1)
                begin
                    Wp[i]<=0;
                    Rp[i]<=0;
                    WnR[i]<=0;
                end
        else
            for(i=0;i<=FLUX-1;i=i+1)
                begin
                    Rp[i]<=Rpnxt[i]; 
                    Wp[i]<=Wpnxt[i]; 
                    WnR[i]<=WnRnxt[i]; 
                end
        
    //writing procedure
    always_ff@(posedge clk) 
        if(write_port.write==1)
                for(i=0;i<=FLUX-1;i=i+1)
                    begin
                        if(tag==i) 
                            mem_ram[Wp[i]][i] <= write_port.din;
                    end
                
    //reading procedure
    for(j=0;j<=FLUX-1;j=j+1)
        assign exits[j] = mem_ram[Rp[j]][j];                                          
        
    //next write pointer updates
    always_comb
        for(i=0;i<=FLUX-1;i=i+1)
            begin
                if(write_port.write==1 & tag==i)  
                    Wpnxt[i]=Wp[i]+1;
                else 
                    Wpnxt[i]=Wp[i];
            end
        
    //next read pointers updates
    always_comb
        for(i=0;i<=FLUX-1;i=i+1)
            begin
                if(read_port.read[i]==1) 
                    Rpnxt[i]=Rp[i]+1;
                else  
                    Rpnxt[i]=Rp[i];
            end
        
    //next WnR updates
    always_comb
        for(i=0;i<=FLUX-1;i=i+1)
            begin
                if(write_port.write==1 & tag==i & read_port.read[i]==0)  
                    WnRnxt[i]=1;
                else if(read_port.read[i]==1 & ( write_port.write==0 | (write_port.write==1 & tag!=i) ) ) 
                    WnRnxt[i]=0;
                else 
                    WnRnxt[i]=WnR[i];
            end
    
    //full/empty update    
    always_comb 
        for(i=0;i<=FLUX-1;i=i+1)
            begin
                if(Wp[i]==Rp[i])
                    if(WnR[i]) 
                        begin 
                            write_port.full[i]=1; 
                            read_port.empty[i]=0; 
                        end
                    else
                        begin
                            write_port.full[i]=0;
                            read_port.empty[i]=1; 
                        end
                else
                    begin
                        read_port.empty[i]=0; 
                        write_port.full[i]=0; 
                    end
            end
endmodule
