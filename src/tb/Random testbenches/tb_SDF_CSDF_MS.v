`timescale 1ns / 1ps

//RANDOM VALUES TEST FOR CSDF AND SDF WITH PICK FUNCTION (8 BIT OF PAYLOAD, 2 FLUX, 4 NUM_OP) 
//RESULTS EXPECTED FROM THE TB: 
//2 CYCLES CORRECTLY COMPLETED FOR EACH FLUX
//NUMERICAL RESULTS: 
//FLUX 0: 008-008 (REMEMBER TAG)
//FLUX 1: 108-108 (REMEMBER TAG) 

module tb_SDF_CSDF_MS;
	
	// tb parameters
	parameter CLK_PERIOD = 10;
	parameter FLUX = 2;
	parameter PORTS = 2;
	parameter NUM_OP = 1;
	parameter DATA_WIDTH = 8;
	parameter DEPTH = 4;
	parameter TAG_WIDTH = $clog2(FLUX);
	parameter WIDTH = DATA_WIDTH + TAG_WIDTH;
	
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
	
	//actor
	reg out_port_full;
	wire [WIDTH-1 : 0] out_port_dataout;
	wire out_port_write;

//CHOSE ONE MODULE TO TESTBENCH; THE OTHER IS NEEDED TO BE INSIDE A COMMENT 


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

	// clock gen
	always #(CLK_PERIOD/2) clk = ~clk;

	// write input
	initial
		begin
		clk = 0;
		rst = 0;
		out_port_full = 0;
		in_port_write_fifo_0 = 0;
		in_port_write_fifo_1 = 0;
		
		#1
		rst = 1;
		
		#(3*CLK_PERIOD-1)
		rst = 0;
//SENDING DATA 
//X-Y -> X = flux, Y = number of data sent until that moment for that flux
 
		#CLK_PERIOD
		in_port_datain_fifo_1= {1'b0,8'd1};
		in_port_write_fifo_1=1;

		#CLK_PERIOD
		in_port_datain_fifo_0= {1'b1,8'd1};
		in_port_write_fifo_0=1;
		
		#CLK_PERIOD
		in_port_datain_fifo_1= {1'b1,8'd1};
		in_port_write_fifo_1=1;

		#CLK_PERIOD
		in_port_datain_fifo_0= {1'b0,8'd1};
		in_port_write_fifo_0=1;
		
		#CLK_PERIOD
		in_port_datain_fifo_1= {1'b0,8'd1};
		in_port_write_fifo_1=1;
		
		#CLK_PERIOD
		in_port_datain_fifo_0= {1'b0,8'd1};
		in_port_write_fifo_0=1;

		#CLK_PERIOD
		in_port_datain_fifo_0= {1'b0,8'd1};
		in_port_write_fifo_0=1;

		#CLK_PERIOD
		in_port_datain_fifo_1= {1'b1,8'd1};
		in_port_write_fifo_1=1;
	
		#CLK_PERIOD
		in_port_datain_fifo_0= {1'b0,8'd1};
		in_port_write_fifo_0=1;
		//FULL=1
		out_port_full=1;
		
		#CLK_PERIOD
		in_port_datain_fifo_1= {1'b1,8'd1};
		in_port_write_fifo_1=1;
		//FULL=0
		out_port_full=0;
		
		#CLK_PERIOD
		in_port_datain_fifo_0= {1'b1,8'd1};
		in_port_write_fifo_0=1;
		//FULL=1
		out_port_full=1;
		
		#CLK_PERIOD
		in_port_datain_fifo_1= {1'b0,8'd1};
		in_port_write_fifo_1=1;
		//FULL=0
		out_port_full=0;


		#CLK_PERIOD
		in_port_datain_fifo_0= {1'b1,8'd1};
		in_port_write_fifo_0=1;
		
		#CLK_PERIOD
		in_port_datain_fifo_1= {1'b1,8'd1};
		in_port_write_fifo_1=1;
		
		#CLK_PERIOD
		in_port_datain_fifo_0= {1'b1,8'd1};
		in_port_write_fifo_0=1;
		
		#CLK_PERIOD
		in_port_datain_fifo_1= {1'b0,8'd1};
		in_port_write_fifo_1=1;

		#CLK_PERIOD
		in_port_datain_fifo_0= {1'b0,8'd1};
		in_port_write_fifo_0=1;
//STOP		
		#CLK_PERIOD
		in_port_datain_fifo_0= {1'b0,8'd1};
		in_port_write_fifo_0=0;
				
		#(20*CLK_PERIOD)
		$stop;
    end
          
endmodule

