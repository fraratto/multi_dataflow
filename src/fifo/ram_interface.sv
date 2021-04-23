`timescale 1ns / 1ps

`ifndef RAM_INTERFACE
`define RAM_INTERFACE

interface ram_interface #(WIDTH=8, DEPTH=4)
						(input clk);
    logic [WIDTH-1 : 0] din;
    logic [$clog2(DEPTH)-1 :0] write_address;
    logic [$clog2(DEPTH)-1 :0] read_address;
    logic write_en;
    logic [WIDTH-1 : 0] dout;
	
	modport slave(input clk, input din, write_address, read_address, write_en, output dout);
	modport master(input clk, output din, write_address, read_address, write_en, input dout);
	
endinterface : ram_interface

`endif
