`timescale 1 ns / 1 ps
// ----------------------------------------------------------------------------
//
// Multi-Dataflow Composer tool - Platform Composer
// Multi-Dataflow Test Bench module 
// Date: 2021/04/20 17:50:12
//
// Please note that the testbench manages only common signals to dataflows
// - clock system signals
// - reset system signals
// - dataflow communication signals
//
// ----------------------------------------------------------------------------

/* uncomment the following line to print the output */
//`define PRINT_OUTPUT 1

module tb_top_ms;

	// test bench parameters
	// ----------------------------------------------------------------------------
	parameter clk_PERIOD = 10;
	
	parameter TAP = 8;
    parameter SIZE = 16;    // 4, 8, 16, 32, 64
	parameter V_ALPHA = 2;  // 0, 2, 4, 6
	parameter H_ALPHA = 2;  // 0, 2, 4, 6
	
	parameter IN_PORT_FILTER_8TAP_FILE = "input_16x16.mem";
	parameter IN_PORT_FILTER_8TAP_SIZE = (SIZE + TAP-1)*(SIZE + TAP-1);
	
	parameter FLUX = 2;
    parameter DEPTH = 16;
    parameter TAG_WIDTH = $clog2(FLUX);
    
	`ifdef PRINT_OUTPUT 
	parameter OUT_PORT_FILTER_8TAP_FILE = "C:/Users/utente/Desktop/output_16x16_v2_h2.mem"; 
	`else
	parameter OUT_PORT_FILTER_8TAP_FILE = "output_16x16_v2_h2.mem";
	`endif
	parameter OUT_PORT_FILTER_8TAP_SIZE = SIZE*SIZE;
	integer f;
	
	// ----------------------------------------------------------------------------
	
	// multi_dataflow signals
	// ----------------------------------------------------------------------------
	logic start_feeding;
	logic [7:0] in_port_filter_8tap_file_data [IN_PORT_FILTER_8TAP_SIZE-1:0];
	integer in_port_i = 0;	
	logic [7:0] out_port_filter_8tap_file_data [OUT_PORT_FILTER_8TAP_SIZE-1:0];
	integer out_port_i = 0;
	logic [6 : 0] ext_size_val;
	logic [2 : 0] v_alpha_val;
	logic [2 : 0] h_alpha_val;
	
	logic clk;
	logic rst;
	
	write_interface #(3,FLUX) v_alpha (.*);
    write_interface #(3,FLUX) h_alpha (.*);
    write_interface #(7,FLUX) ext_size (.*);
    write_interface #(8,FLUX) in_pel (.*);
    write_interface #(8,FLUX) out_pel (.*);
	
	// ----------------------------------------------------------------------------

	// network input and output files
	// ----------------------------------------------------------------------------
	initial
	 	$readmemh(IN_PORT_FILTER_8TAP_FILE, in_port_filter_8tap_file_data);
	initial
		begin
		`ifdef PRINT_OUTPUT
			f = $fopen(OUT_PORT_FILTER_8TAP_FILE,"w");
		`else
			$readmemh(OUT_PORT_FILTER_8TAP_FILE, out_port_filter_8tap_file_data);
		`endif
		end
	// ----------------------------------------------------------------------------

	// dut
	// ----------------------------------------------------------------------------
    top_ms #(DEPTH,FLUX) dut (        
        .clk(clk),
        
        .rst(rst),
                
        .write_port_v_alpha(v_alpha.fifo),
        
        .write_port_h_alpha(h_alpha.fifo),
        
        .write_port_ext_size(ext_size.fifo),
        
        .write_port_in_port(in_pel.fifo),
        
        .write_port_out_port(out_pel.actor)
	);	
	// ----------------------------------------------------------------------------

	// clks
	// ----------------------------------------------------------------------------
	always #(clk_PERIOD/2)
		clk = ~clk;
	// ----------------------------------------------------------------------------

	// signals evolution
	// ----------------------------------------------------------------------------
	initial
		begin
		// feeding flag initialization
		start_feeding = 0;

		// clks initialization
		clk = 0;
	
		// network signals initialization
		in_pel.din = 0;
		in_pel.write  = 1'b0;
		h_alpha.din = 0;
		h_alpha.write  = 1'b0; 
		ext_size.din = 0;
		ext_size.write  = 1'b0;
		v_alpha.din = 0;
		v_alpha.write  = 1'b0;
		out_pel.full = 1'b0;
	
		// initial rst
		rst = 0;
		#2
		rst = 1;
		#100
		rst = 0;
		#100

		// network inputs (output side)
		out_pel.full = 1'b0;
				 
		// executing filter_8tap
		start_feeding = 1;
		v_alpha_val = V_ALPHA;
		v_alpha.din = {1'b1,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA;
		h_alpha.din = {1'b1,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE + TAP-1;
		ext_size.din = {1'b1,ext_size_val};
		ext_size.write = 1;
		
		#(clk_PERIOD)
		v_alpha.din = 0;
		v_alpha.write = 0;
		h_alpha.din = 0;
		h_alpha.write = 0;
		ext_size.din = 0;
		ext_size.write = 0;
			
		while(in_port_i != IN_PORT_FILTER_8TAP_SIZE)
			#(clk_PERIOD);
		start_feeding = 0;
		in_pel.din = 0;
		in_pel.write  = 1'b0;
		in_port_i = 0;

		while(out_port_i != OUT_PORT_FILTER_8TAP_SIZE)
			#(clk_PERIOD);
		
		$stop;
		end
	// ----------------------------------------------------------------------------

	// input feeding
	// ----------------------------------------------------------------------------
	always@(*)
		if(start_feeding)
	 		begin
			while(in_port_i < IN_PORT_FILTER_8TAP_SIZE)
				begin
				#10
				if(in_pel.full[1] == 0)
					begin
					in_pel.din = {1'b1,in_port_filter_8tap_file_data[in_port_i]};
					in_pel.write  = 1'b1;
					in_port_i = in_port_i + 1;
					end
				else
					begin
					in_pel.din = 0;
					in_pel.write  = 1'b0;
					end
				end
			#10
			in_pel.din = 0;
			in_pel.write  = 1'b0;
			end

	// ----------------------------------------------------------------------------

	// output write
	// ----------------------------------------------------------------------------
	`ifdef PRINT_OUTPUT 
	always@(posedge clk)
		begin
		if(out_pel.write == 1)
			begin	
			$fwrite(f,"%x\n", out_pel.din);
			out_port_i = out_port_i + 1;
			end
		if(out_port_i == OUT_PORT_FILTER_8TAP_SIZE)
		    begin
			out_port_i = 0;
			$fclose(f);
			$stop;
			end
		end
	// ----------------------------------------------------------------------------
	
	// output check
	// ----------------------------------------------------------------------------
	`else
	always@(posedge clk)
		begin
		if(out_pel.write == 1)
			begin	
			if(out_pel.din[7:0] != out_port_filter_8tap_file_data[out_port_i])
				$display("Error on output %d: obtained %d, expected %d", out_port_i, out_pel.din[7:0], out_port_filter_8tap_file_data[out_port_i]);
			out_port_i = out_port_i + 1;
			end
		if(out_port_i == OUT_PORT_FILTER_8TAP_SIZE)
		     begin
			out_port_i = 0;
			$stop; 
			end
		end
	`endif
	// ----------------------------------------------------------------------------

endmodule
