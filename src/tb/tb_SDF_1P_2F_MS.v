`timescale 1ns / 1ps

module tb_SDF_1P_2F_MS ;
	
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

	wrap_SDF_1P_2F_MS #(
		.WIDTH(WIDTH)
	) dut (
		.clk(clk), 
		.rst(rst),

		.in_port_write(in_port_write),
		.in_port_datain(in_port_datain),
		.in_port_full(in_port_full),

		.out_port_write(out_port_write),
		.out_port_dataout(out_port_dataout),
		.out_port_full(out_port_full)
	);

	// input/output
	parameter IN_SIZE = 4;
	parameter OUT_SIZE = 4;
	integer in_cnt, out_cnt;
	integer flag_error;
	reg [WIDTH-1 : 0] input_data [0 : IN_SIZE-1];
	reg [WIDTH-1 : 0] output_data [0 : OUT_SIZE-1];
	initial	
		begin
		in_cnt = 0;
		out_cnt = 0;
		flag_error = 0;
		$readmemh("input_SDF_1P_2F_MS.mem", input_data); 
		$readmemh("output_SDF_1P_2F_MS.mem", output_data);
		end
	
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
		
		#(3*CLK_PERIOD)
		while(in_cnt<IN_SIZE)
			begin
			if(!in_port_full) 
				begin
				in_port_write = 1;
				in_port_datain = input_data[in_cnt];
				end
			else 
				begin
				in_port_write = 0;
				end
			#(CLK_PERIOD);
			end
		in_port_write = 0;
		end 
		
	// update in_cnt
	always @(posedge clk)
	if(in_port_write)
		begin 
		in_cnt = in_cnt +1;
		end

	// check output
	always @(posedge clk)
		if(out_port_write)
			begin
			out_cnt <= out_cnt+1;
			if(out_port_dataout != output_data[out_cnt])
				begin
				$display("\nError at %d)Expectd: %h. Got: %h", out_cnt, output_data[out_cnt], out_port_dataout);
				flag_error = 1;
				end
			if(out_cnt == (OUT_SIZE - 1))
				begin
				#(10*CLK_PERIOD)
				if(!flag_error)
					$display("\nTest basic behavior: PASSED\n");
				$stop;
				end        
			end
          
endmodule