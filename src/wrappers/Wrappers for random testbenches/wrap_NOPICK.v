`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2021 17:36:07
// Design Name: 
// Module Name: wrap_NOPICK
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


module wrap_NOPICK;

	parameter CLK_PERIOD = 10;
	parameter FLUX = 2;
	parameter PORTS = 2;
	parameter DATA_WIDTH = 8;
	parameter TAG_WIDTH = $clog2(FLUX);
	parameter WIDTH = DATA_WIDTH + TAG_WIDTH;
	parameter DEPTH = 4;
	parameter NUM_OP = 1;
	// dut
	reg clk, rst;
	
	//fifo 0
	reg in_port_write_fifo_0; 
	reg [WIDTH-1 : 0] in_port_datain_fifo_0;
	wire [FLUX-1:0] in_port_full_fifo_0;
	
	//fifo 1
	reg in_port_write_fifo_1; 
	reg [WIDTH-1 : 0] in_port_datain_fifo_1;
	wire [FLUX-1:0] in_port_full_fifo_1;
	
	//fifo nda
	reg in_port_write_fifo_nda; 
	reg [WIDTH-1 : 0] in_port_datain_fifo_nda;
	wire [FLUX-1:0] in_port_full_fifo_nda;
	
	//actor
	reg out_port_full;
	wire [WIDTH-1 : 0] out_port_dataout;
	wire out_port_write;

//CHOSE ONE MODULE TO TESTBENCH; THE OTHER IS NEEDED TO BE INSIDE A COMMENT 


//FIFO-FIFO-FIFO_NDA -> DDF
	wrap_DDF_MS #(
		.WIDTH(WIDTH),
		.FLUX(FLUX),
	    .PORTS(PORTS),
	    .DEPTH(DEPTH)
	) dut0 (
		.clk(clk), 
		.rst(rst),
		
        //fifo 0
		.in_port_write_fifo_0(in_port_write_fifo_0),
		.in_port_datain_fifo_0(in_port_datain_fifo_0),
		.in_port_full_fifo_0(in_port_full_fifo_0),
		
		//fifo 1
		.in_port_write_fifo_1(in_port_write_fifo_1),
		.in_port_datain_fifo_1(in_port_datain_fifo_1),
		.in_port_full_fifo_1(in_port_full_fifo_1),
		
		//fifo nda
		.in_port_write_fifo_nda(in_port_write_fifo_nda),
		.in_port_datain_fifo_nda(in_port_datain_fifo_nda),
		.in_port_full_fifo_nda(in_port_full_fifo_nda),
                
        //actor
		.out_port_write(out_port_write),
		.out_port_dataout(out_port_dataout),
		.out_port_full(out_port_full)
	);
	
//FIFO-FIFO -> CSDF
	wrap_CSDF_MS #(
		.WIDTH(WIDTH),
		.FLUX(FLUX),
	    .PORTS(PORTS),
        .NUM_OP(NUM_OP),
        .DEPTH(DEPTH)
	) dut1 (
		.clk(clk), 
		.rst(rst),
		
        //fifo 0
		.in_port_write_fifo_0(in_port_write_fifo_0),
		.in_port_datain_fifo_0(in_port_datain_fifo_0),
		.in_port_full_fifo_0(in_port_full_fifo_0),
		
		//fifo 1
		.in_port_write_fifo_1(in_port_write_fifo_1),
		.in_port_datain_fifo_1(in_port_datain_fifo_1),
		.in_port_full_fifo_1(in_port_full_fifo_1),
        
        //actor
		.out_port_write(out_port_write),
		.out_port_dataout(out_port_dataout),
		.out_port_full(out_port_full)
	);     


//FIFO-FIFO -> SDF	
	wrap_SDF_MS #(
		.WIDTH(WIDTH),
		.FLUX(FLUX),
	    .PORTS(PORTS),
        .NUM_OP(NUM_OP),
        .DEPTH(DEPTH)
	) dut2 (
		.clk(clk), 
		.rst(rst),
		
        //fifo 0
		.in_port_write_fifo_0(in_port_write_fifo_0),
		.in_port_datain_fifo_0(in_port_datain_fifo_0),
		.in_port_full_fifo_0(in_port_full_fifo_0),
		
		//fifo 1
		.in_port_write_fifo_1(in_port_write_fifo_1),
		.in_port_datain_fifo_1(in_port_datain_fifo_1),
		.in_port_full_fifo_1(in_port_full_fifo_1),
        
        //actor
		.out_port_write(out_port_write),
		.out_port_dataout(out_port_dataout),
		.out_port_full(out_port_full)
	);  
endmodule
