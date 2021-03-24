`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2021 17:36:07
// Design Name: 
// Module Name: wrap_PICK
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


module wrap_PICK;
	
	// tb parameters
	parameter CLK_PERIOD = 10;
	parameter FLUX = 2;
	parameter DATA_WIDTH = 8;
	parameter TAG_WIDTH = $clog2(FLUX);
	parameter WIDTH = DATA_WIDTH + TAG_WIDTH;
	parameter WIDTH_NDA=WIDTH;
	
	// dut
	reg clk, rst;
	reg in_port_write; 
	reg [WIDTH-1 : 0] in_port_datain;
	reg out_port_full;
	wire [FLUX-1:0] in_port_full;
	wire [WIDTH-1 : 0] out_port_dataout;
	wire out_port_write;
	
	//FIFO_NDA
	reg in_port_write_nda;
	reg [WIDTH_NDA-1:0] in_port_datain_nda;
	wire [FLUX-1:0] in_port_full_nda;

//CHOSE ONE MODULE TO TESTBENCH; THE OTHER IS NEEDED TO BE INSIDE A COMMENT 


//FIFO -> CSDF
	wrap_PICK_CSDF_MS #(
		.WIDTH(WIDTH)
	) dut0 (
		.clk(clk), 
		.rst(rst),

		.in_port_write(in_port_write),
		.in_port_datain(in_port_datain),
		.in_port_full(in_port_full),

		.out_port_write(out_port_write),
		.out_port_dataout(out_port_dataout),
		.out_port_full(out_port_full)
	);    

//FIFO -> SDF	
	wrap_PICK_SDF_MS #(
		.WIDTH(WIDTH)
	) dut1 (
		.clk(clk), 
		.rst(rst),

		.in_port_write(in_port_write),
		.in_port_datain(in_port_datain),
		.in_port_full(in_port_full),

		.out_port_write(out_port_write),
		.out_port_dataout(out_port_dataout),
		.out_port_full(out_port_full)
	);  

//FIFO - FIFO -> DDF
	wrap_PICK_DDF_MS #(
		.WIDTH(WIDTH),
		.WIDTH_NDA(WIDTH_NDA)
	) dut2 (
		.clk(clk), 
		.rst(rst),
		
        //FIFO_0
		.in_port_write(in_port_write),
		.in_port_datain(in_port_datain),
		.in_port_full(in_port_full),
		
		//FIFO_NDA
        .in_port_write_nda(in_port_write_nda),
		.in_port_datain_nda(in_port_datain_nda),
		.in_port_full_nda(in_port_full_nda),
		
		.out_port_write(out_port_write),
		.out_port_dataout(out_port_dataout),
		.out_port_full(out_port_full)
	);  

endmodule
