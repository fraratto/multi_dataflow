`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2021 09:57:00
// Design Name: 
// Module Name: wrap_SDF_1P_2F_MS_PICK
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


module wrap_PICK_SDF_MS #(
	parameter WIDTH = 8,
	parameter FLUX = 2,
	parameter PORTS = 2,
    parameter NUM_OP = 4,
    parameter DEPTH = 4
	)(
	input clk, rst,
	
	//fifo 0
	input in_port_write_fifo_0,
	input [WIDTH-1 : 0] in_port_datain_fifo_0,
	output [FLUX-1:0] in_port_full_fifo_0,
	
	//fifo 1
	input in_port_write_fifo_1,
	input [WIDTH-1 : 0] in_port_datain_fifo_1,
	output [FLUX-1:0] in_port_full_fifo_1,
	
	//attore
	output out_port_write,
	output [WIDTH-1 : 0] out_port_dataout,
	input out_port_full
	
	);

    //act=wire
    
    //fifo 0
	wire [FLUX-1:0] act_empty_fifo_0;
	wire [FLUX-1:0] act_read_fifo_0;
	wire [WIDTH-1 : 0] act_datain_fifo_0;
	
	//fifo 1
	wire [FLUX-1:0] act_empty_fifo_1;
	wire [FLUX-1:0] act_read_fifo_1;
	wire [WIDTH-1 : 0] act_datain_fifo_1;
	

	
	PICK_FIFO_MS #(
		.WIDTH(WIDTH),
		.DEPTH(DEPTH),
		.FLUX(FLUX)
	) fifo_0 (
		.ck(clk),
		.rst(rst),
		.wr(in_port_write_fifo_0),
		.datain(in_port_datain_fifo_0),
		.rd(act_read_fifo_0),
		.full(in_port_full_fifo_0),
		.empty(act_empty_fifo_0),
		.dataout(act_datain_fifo_0)
	);
	
	PICK_FIFO_MS #(
		.WIDTH(WIDTH),
		.DEPTH(DEPTH),
		.FLUX(FLUX)
	) fifo_1 (
		.ck(clk),
		.rst(rst),
		.wr(in_port_write_fifo_1),
		.datain(in_port_datain_fifo_1),
		.rd(act_read_fifo_1),
		.full(in_port_full_fifo_1),
		.empty(act_empty_fifo_1),
		.dataout(act_datain_fifo_1)
	);
	
	PICK_SDF#(
        .PORTS(PORTS),
        .FLUX(FLUX),
        .WIDTH(WIDTH),
        .NUM_OP(NUM_OP)
	) actor_0 (
		.ck(clk),
		.rst(rst),
		.in_empty({act_empty_fifo_1[1], act_empty_fifo_0[1], act_empty_fifo_1[0], act_empty_fifo_0[0]}),
		.in_read({act_read_fifo_1[1],act_read_fifo_0[1],act_read_fifo_1[0],act_read_fifo_0[0]}),
		.in_data({act_datain_fifo_1,act_datain_fifo_0}),
		.out0_full(out_port_full),
		.out0_wr(out_port_write),
		.out0_data(out_port_dataout)
	);

endmodule