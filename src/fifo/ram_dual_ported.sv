`timescale 1ns / 1ps

`include "ram_interface.sv"

module ram_dual_ported #(
    WIDTH = 8,
    DEPTH = 4
) (
    ram_interface.slave port
);
    reg [WIDTH-1:0] ram_block [0:DEPTH-1];
	
	integer i;
    initial begin
    for (i=0; i<DEPTH; i=i+1) ram_block[i] = 0;
    end
	
    always@(posedge port.clk)
        if(port.write_en)
            ram_block[port.write_address] <= port.din;
            
    assign port.dout = ram_block[port.read_address];

endmodule