`timescale 1ns / 1ps
`include "../fifo/fifo_interface.sv"
`define DATA_WIDTH 8
`define DEPTH 8

module wrapper_fifo_mono(
	input clk, rst,
	input [`DATA_WIDTH-1 : 0] din,
	input  write,
	output full,
	output [`DATA_WIDTH-1 : 0] dout,
	input read,
	output empty
	);
	
	write_interface #(`DATA_WIDTH, 1) write_port (clk);
	read_interface #(`DATA_WIDTH, 1) read_port (clk);
	fifo_mono #(`DATA_WIDTH, `DEPTH) dut (.*);
	
	assign write_port.din = din;
	assign write_port.write = write;
	assign full = write_port.full;
	assign dout = read_port.dout;
	assign read_port.read = read;
	assign empty = read_port.empty;
	
	
endmodule
	
	
	