`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2021 11:41:01
// Design Name: 
// Module Name: wrap_DDF_1P_2F_MS_PICK
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wrap_DDF_1P_2F_MS_PICK #(
	parameter WIDTH = 8,
	parameter WIDTH_NDA = WIDTH,
	parameter FLUX = 2
	)(
	input clk, rst,
	
	//FIFO_0
	input in_port_write,
	input [WIDTH-1 : 0] in_port_datain,
	output [FLUX-1:0] in_port_full,
	
	//FIFO_NDA
	input in_port_write_nda,
	input [WIDTH_NDA-1 : 0] in_port_datain_nda,
	output [FLUX-1:0] in_port_full_nda,
	
	//ACTOR
	output out_port_write,
	output [WIDTH-1 : 0] out_port_dataout,
	input out_port_full
	);
	
	//FIFO_0
	wire [FLUX-1:0] act_empty;
	wire [FLUX-1:0] act_read;
	wire [WIDTH-1 : 0] act_datain;
	
	//FIFO_NDA
	wire [FLUX-1:0] act_empty_nda;
	wire [FLUX-1:0] act_read_nda;
	wire [WIDTH_NDA-1 : 0] act_datain_nda;
	
	FIFO_MS_PICK #(
		.WIDTH(WIDTH),
		.DEPTH(4),
		.FLUX(FLUX)
	) fifo_0 (
		.ck(clk),
		.rst(rst),
		.wr(in_port_write),
		.datain(in_port_datain),
		.rd(act_read),
		.full(in_port_full),
		.empty(act_empty),
		.dataout(act_datain)
	);

	FIFO_MS_PICK #(
		.WIDTH(WIDTH),
		.DEPTH(4),
		.FLUX(FLUX)
	) fifo_nda (
		.ck(clk),
		.rst(rst),
		.wr(in_port_write_nda),
		.datain(in_port_datain_nda),
		.rd(act_read_nda),
		.full(in_port_full_nda),
		.empty(act_empty_nda),
		.dataout(act_datain_nda)
	);

	DDF_1P_2F_PICK#(
		.WIDTH(WIDTH),
		.WIDTH_NDA(WIDTH_NDA)
	) actor_0 (
		.ck(clk),
		.rst(rst),
		.nda0_empty(act_empty_nda[0]),
		.nda1_empty(act_empty_nda[1]),
		.nda0_read(act_read_nda[0]),
		.nda1_read(act_read_nda[1]),
		.in0_empty(act_empty[0]),
		.in1_empty(act_empty[1]),
		.in0_read(act_read[0]),
		.in1_read(act_read[1]),
		.in_data(act_datain),
		.nda_data(act_datain_nda),
		.full(out_port_full),
		.wr(out_port_write),
		.out_data(out_port_dataout)
	);

endmodule
