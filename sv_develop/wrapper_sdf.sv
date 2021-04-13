`timescale 1ns / 1ps
`include "fifo_interface.sv"
`define DATA_WIDTH 8
`define DEPTH 4
`define FLUX 2
`define PORTS 2
`define NUM_OP 2
 
module wrapper_sdf(
	input clk, rst,
	output [(`DATA_WIDTH + $clog2(`FLUX))-1 : 0] din,
	output write,
	input full,
	input [((`DATA_WIDTH + $clog2(`FLUX))*`PORTS)-1 : 0] dout,
	output [(`FLUX*`PORTS)-1:0] read,
	input [(`FLUX*`PORTS)-1:0] empty
	);
	
	write_interface #(`DATA_WIDTH,`FLUX,`PORTS) write_port (clk);
	read_interface #(`DATA_WIDTH,`FLUX,`PORTS) read_port (clk);
	sdf #(`DATA_WIDTH,`FLUX,`PORTS,`NUM_OP) dut (.*);
	
	assign din = write_port.din;
	assign write = write_port.write;
	assign write_port.full = full;
	assign read_port.dout = dout;
	assign read = read_port.read;
	assign read_port.empty = empty;
	
	
endmodule
