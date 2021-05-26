`timescale 1ns / 1ps
`include "../fifo/fifo_interface.sv"


// variable parameters 
`define DEPTH 16
`define FLUX 2

// fixed parameters
`define DATA_WIDTH 8
`define ALPHA_WIDTH 3
`define SIZE_WIDTH 7
`define TAG_WIDTH $clog2(`FLUX)

 
module wrapper_hevc(
	// global signals
	input clk, rst,
	
	// in_port
	input [(`DATA_WIDTH + `TAG_WIDTH)-1 : 0] in_port_din,
	input in_port_write,
	output [`FLUX-1:0] in_port_full,
	
	// v_alpha
	input [(`ALPHA_WIDTH + `TAG_WIDTH)-1 : 0] v_alpha_din,
	input v_alpha_write,
	output [`FLUX-1:0] v_alpha_full,
	
	// h_alpha
	input [(`ALPHA_WIDTH + `TAG_WIDTH)-1 : 0] h_alpha_din,
	input h_alpha_write,
	output [`FLUX-1:0] h_alpha_full,

	// ext_size
	input [(`SIZE_WIDTH + `TAG_WIDTH)-1 : 0] ext_size_din,
	input ext_size_write,
	output [`FLUX-1:0] ext_size_full,
		
	// out_port
	output [(`DATA_WIDTH + `TAG_WIDTH)-1 : 0] out_port_din,
	output out_port_write,
	input [`FLUX-1:0] out_port_full
	);

    write_interface #(`DATA_WIDTH,`FLUX) write_port_in_port (.*);	
	write_interface #(`ALPHA_WIDTH,`FLUX) write_port_v_alpha (.*);
    write_interface #(`ALPHA_WIDTH,`FLUX) write_port_h_alpha (.*);
    write_interface #(`SIZE_WIDTH,`FLUX) write_port_ext_size (.*);
    write_interface #(`DATA_WIDTH,`FLUX) write_port_out_port (.*);
	
	top_ms #(`DEPTH,`FLUX) dut (.*);
	
	// assigns
	assign write_port_in_port.din = in_port_din;
	assign write_port_in_port.write = in_port_write;
	assign in_port_full = write_port_in_port.full;
	
	assign write_port_v_alpha.din = v_alpha_din;
	assign write_port_v_alpha.write = v_alpha_write;
	assign v_alpha_full = write_port_v_alpha.full;
	
	assign write_port_h_alpha.din = h_alpha_din;
	assign write_port_h_alpha.write = h_alpha_write;
	assign h_alpha_full = write_port_h_alpha.full;
	
	assign write_port_ext_size.din = ext_size_din;
	assign write_port_ext_size.write = ext_size_write;
	assign ext_size_full = write_port_ext_size.full;
	
	assign out_port_din = write_port_out_port.din;
	assign out_port_write = write_port_out_port.write;
	assign write_port_out_port.full = out_port_full;
	
endmodule
