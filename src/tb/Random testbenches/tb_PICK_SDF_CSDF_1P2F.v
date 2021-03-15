`timescale 1ns / 1ps

//RANDOM VALUES TEST FOR CSDF AND SDF WITH PICK FUNCTION (8 BIT OF PAYLOAD, 2 FLUX) 
//RESULTS EXPECTED FROM THE TB: 
//2 CYCLES CORRECTLY COMPLETED FOR EACH FLUX
//NUMERICAL RESULTS: 
//FLUX 0: 004-004 (REMEMBER TAG)
//FLUX 1: 104-104 (REMEMBER TAG) 

module tb_PICK_SDF_CSDF_1P2F;
	
	// tb parameters
	parameter CLK_PERIOD = 10;
	parameter FLUX = 2;
	parameter DATA_WIDTH = 8;
	parameter TAG_WIDTH = $clog2(FLUX);
	parameter WIDTH = DATA_WIDTH + TAG_WIDTH;
	
	// dut
	reg clk, rst;
	reg in_port_write; 
	reg [WIDTH-1 : 0] in_port_datain;
	reg out_port_full;
	wire [FLUX-1:0] in_port_full;
	wire [WIDTH-1 : 0] out_port_dataout;
	wire out_port_write;

//CHOSE ONE MODULE TO TESTBENCH; THE OTHER IS NEEDED TO BE INSIDE A COMMENT 


//FIFO -> CSDF
/*	wrap_CSDF_1P_2F_MS_PICK #(
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
	); */   

//FIFO -> SDF	
	wrap_SDF_1P_2F_MS_PICK #(
		.WIDTH(WIDTH)
	) dut2 (
		.clk(clk), 
		.rst(rst),

		.in_port_write(in_port_write),
		.in_port_datain(in_port_datain),
		.in_port_full(in_port_full),

		.out_port_write(out_port_write),
		.out_port_dataout(out_port_dataout),
		.out_port_full(out_port_full)
	); 

	// clock gen
	always #(CLK_PERIOD/2) clk = ~clk;

	// write input
	initial
		begin
		clk = 0;
		rst = 0;
		out_port_full = 0;
		in_port_write = 0;
		
		#1
		rst = 1;
		
		#(3*CLK_PERIOD-1)
		rst = 0;
//SENDING DATA 
//X-Y -> X = flux, Y = number of data sent until that moment for that flux
 
//0-1
		#CLK_PERIOD
		in_port_datain= {1'b0,8'd1};
		in_port_write=1;
//1-1
		#CLK_PERIOD
		in_port_datain= {1'b1,8'd1};
		in_port_write=1;
//1-2		
		#CLK_PERIOD
		in_port_datain= {1'b1,8'd1};
		in_port_write=1;
//0-2
		#CLK_PERIOD
		in_port_datain= {1'b0,8'd1};
		in_port_write=1;
//0-3		
		#CLK_PERIOD
		in_port_datain= {1'b0,8'd1};
		in_port_write=1;
//0-4		
		#CLK_PERIOD
		in_port_datain= {1'b0,8'd1};
		in_port_write=1;
        //FULL=1
		out_port_full=1;
//0-5
		#CLK_PERIOD
		in_port_datain= {1'b0,8'd1};
		in_port_write=1;
//1-3
		#CLK_PERIOD
		in_port_datain= {1'b1,8'd1};
		in_port_write=1;
		//FULL=0
		out_port_full=0;
//0-6	
		#CLK_PERIOD
		in_port_datain= {1'b0,8'd1};
		in_port_write=1;
//1-4
		#CLK_PERIOD
		in_port_datain= {1'b1,8'd1};
		in_port_write=1;
//1-5		
		#CLK_PERIOD
		in_port_datain= {1'b1,8'd1};
		in_port_write=1;
//0-7		
		#CLK_PERIOD
		in_port_datain= {1'b0,8'd1};
		in_port_write=1;
//1-6
		#CLK_PERIOD
		in_port_datain= {1'b1,8'd1};
		in_port_write=1;
//1-7		
		#CLK_PERIOD
		in_port_datain= {1'b1,8'd1};
		in_port_write=1;
//1-8		
		#CLK_PERIOD
		in_port_datain= {1'b1,8'd1};
		in_port_write=1;
//0-8		
		#CLK_PERIOD
		in_port_datain= {1'b0,8'd1};
		in_port_write=1;
//STOP		
		#CLK_PERIOD
		in_port_datain= {1'b0,8'd1};
		in_port_write=0;
				
		#(20*CLK_PERIOD)
		$stop;
    end
          
endmodule
