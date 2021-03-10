`timescale 1ns / 1ps

module tb_fifo_ms_sdf_2f;
	
	parameter CLK_PERIOD = 10;
	parameter WIDTH = 8;
	parameter FLUX = 2;
	
	reg clk, rst;
	reg fifo_wr; 
	reg [WIDTH-1 : 0] fifo_datain;
	reg act_full;
	
	wire fifo_full;
	wire [FLUX-1:0] act_empty;
	wire [FLUX-1:0] act_read;
	wire [WIDTH-1 : 0] act_in_data, act_out_data;
	wire act_write;
	

	FIFO_MS_PAR #(
		.WIDTH(WIDTH),
		.DEPTH(4),
		.FLUX(FLUX)
	) fifo (
		.ck(clk),
		.rst(rst),
		.wr(fifo_wr),
		.datain(fifo_datain),
		.rd(act_read),
		.full(fifo_full),
		.empty(act_empty),
		.dataout(act_in_data)
	);

	SDF_1P_2F#(
		.WIDTH(WIDTH)
	) dut (
		.ck(clk),
		.rst(rst),
		.in0_empty(act_empty[0]),
		.in1_empty(act_empty[1]),
		.in0_read(act_read[0]),
		.in1_read(act_read[1]),
		.in_data(act_in_data),
		.full(act_full),
		.wr(act_write),
		.out_data(act_out_data)
	);


	always #(CLK_PERIOD/2) clk = !clk;

	// WRITE INPUT
	initial
		begin
		clk = 0;
		rst = 0;
		act_full = 0;
		fifo_wr = 0;
		
		#1
		rst = 1;
		
		#(3*CLK_PERIOD-1)
		rst = 0;
		
		#(2*CLK_PERIOD)
		fifo_wr = 1;
		fifo_datain = {1'd0, 8'd1};
		
		#(4*CLK_PERIOD)
		fifo_wr = 0;
		end

	// CHECK OUTPUT
	integer out_cnt;
	initial
		begin
		out_cnt = 0;
	    end
	
	always @(posedge clk)
       if(act_write)
           begin
           out_cnt <= out_cnt+1;
           if(act_out_data == out_cnt)
            $display("OK!\n");
           else
            $display("ERROR at %d!\n", out_cnt);
           if(out_cnt == 3)
                begin
                #CLK_PERIOD
                $stop;
                end
           end
          
endmodule