`timescale 1ns / 1ps
`include "fifo_interface.sv"
`define DATA_WIDTH 8
`define DEPTH 4
`define FLUX 2
`define PORTS 2
 
module wrapper_ddf(
	input clk, rst,
	output [(`DATA_WIDTH + $clog2(`FLUX))-1 : 0] din,
	output write,
	input full,
	input [((`DATA_WIDTH + $clog2(`FLUX))*`PORTS)-1 : 0] dout,
	output [(`FLUX*`PORTS)-1:0] read,
	input [(`FLUX*`PORTS)-1:0] empty,
	//nda ports
	input [(`DATA_WIDTH + $clog2(`FLUX))-1 : 0] nda_dout,
	input [`FLUX-1:0] nda_empty,
    output [`FLUX-1:0] nda_read	
	);
	
	write_interface #(`DATA_WIDTH,`FLUX,`PORTS) write_port (clk);
	read_interface #(`DATA_WIDTH,`FLUX,`PORTS) read_port (clk);
	read_interface #(`DATA_WIDTH,`FLUX, 1) nda_port (clk);
	ddf #(`DATA_WIDTH,`FLUX,`PORTS) dut (.*);
	
	assign din = write_port.din;
	assign write = write_port.write;
	assign write_port.full = full;
	assign read_port.dout = dout;
	assign read = read_port.read;
	assign read_port.empty = empty;
	
	//nda ports	 
    assign nda_read = nda_port.read;
	assign nda_port.empty = nda_empty;
	assign nda_port.dout = nda_dout;
	
endmodule
