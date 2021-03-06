`timescale 1ns / 1ps
`include "../fifo/fifo_interface.sv"
`define DATA_WIDTH 32
`define DEPTH 8
`define FLUX 4

module wrapper_fifo_sr(
	input clk, rst,
	input [(`DATA_WIDTH + $clog2(`FLUX))-1 : 0] din,
	input write,
	output [`FLUX-1:0] full,
	output [(`DATA_WIDTH + $clog2(`FLUX))-1 : 0] dout,
	input [`FLUX-1:0] read,
	output [`FLUX-1:0] empty
	);
	
	write_interface #(`DATA_WIDTH,`FLUX) write_port (clk);
	read_interface #(`DATA_WIDTH,`FLUX) read_port (clk);
	fifo_sr #(`DATA_WIDTH, `DEPTH,`FLUX) dut (.*);
	
	assign write_port.din = din;
	assign write_port.write = write;
	assign full = write_port.full;
	assign dout = read_port.dout;
	assign read_port.read = read;
	assign empty = read_port.empty;
	
	
endmodule
