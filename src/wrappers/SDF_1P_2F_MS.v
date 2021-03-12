module wrap_SDF_1P_2F_MS #(
	parameter WIDTH = 8,
	parameter FLUX = 2
	)(
	input clk, rst,
	
	input in_port_write,
	input [WIDTH-1 : 0] in_port_datain,
	output [FLUX-1:0] in_port_full,
	
	output out_port_write,
	output [WIDTH-1 : 0] out_port_dataout,
	input out_port_full
	);
	
	wire [FLUX-1:0] act_empty;
	wire [FLUX-1:0] act_read;
	wire [WIDTH-1 : 0] act_datain;
	
	
	FIFO_MS_PAR #(
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

	SDF_1P_2F#(
		.WIDTH(WIDTH)
	) actor_0 (
		.ck(clk),
		.rst(rst),
		.in0_empty(act_empty[0]),
		.in1_empty(act_empty[1]),
		.in0_read(act_read[0]),
		.in1_read(act_read[1]),
		.in_data(act_datain),
		.full(out_port_full),
		.wr(out_port_write),
		.out_data(out_port_dataout)
	);

endmodule