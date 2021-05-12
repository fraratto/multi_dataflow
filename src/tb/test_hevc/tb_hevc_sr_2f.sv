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


module tb_top_sr;

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
	integer in_port_i_0 = 0;
	integer in_port_i_1 = 0;	
	logic [7:0] out_port_filter_8tap_file_data [OUT_PORT_FILTER_8TAP_SIZE-1:0];
	integer out_port_i_0 = 0;
	integer out_port_i_1 = 0;
	integer select_flow;
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
    top_sr #(DEPTH,FLUX) dut (        
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
				 
		// setup first flow
		start_feeding = 1;
		v_alpha_val = V_ALPHA;
		v_alpha.din = {1'b0,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA;
		h_alpha.din = {1'b0,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE + TAP-1;
		ext_size.din = {1'b0,ext_size_val};
		ext_size.write = 1;
		
		// setup second flow
		#(clk_PERIOD)
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
			
		while(in_port_i_0 < IN_PORT_FILTER_8TAP_SIZE && 
			  in_port_i_1 < IN_PORT_FILTER_8TAP_SIZE)
			#(clk_PERIOD);
		start_feeding = 0;
		in_pel.din = 0;
		in_pel.write  = 1'b0;

		while(out_port_i_0 < OUT_PORT_FILTER_8TAP_SIZE || 
			 out_port_i_1 < OUT_PORT_FILTER_8TAP_SIZE)
			#(clk_PERIOD);
		
		#(10*clk_PERIOD) $stop;
		end
	// ----------------------------------------------------------------------------

	// input feeding
	// ----------------------------------------------------------------------------
	
	// flow alternation
	initial 
		begin
		select_flow = 0;
		@(posedge start_feeding)
		while((in_port_i_0 < IN_PORT_FILTER_8TAP_SIZE) || (in_port_i_1 < IN_PORT_FILTER_8TAP_SIZE))
			begin
			select_flow = 0;
			#(10*clk_PERIOD)
			select_flow = 1;
			#(10*clk_PERIOD)
			select_flow = -1;
			#(10*clk_PERIOD);
			end
		end
		
	initial 
		begin
		@(posedge start_feeding)
		// feed two flows
		while((in_port_i_0 < IN_PORT_FILTER_8TAP_SIZE) && (in_port_i_1 < IN_PORT_FILTER_8TAP_SIZE))
			begin
			#10
				case(select_flow)
				0:  if(!in_pel.full[0])
                        begin
                        in_pel.din = {1'b0,in_port_filter_8tap_file_data[in_port_i_0]};
                        in_pel.write  = 1'b1;
                        in_port_i_0 = in_port_i_0 + 1;
                        end
                    else
                        begin
                        in_pel.din = 0;
                        in_pel.write  = 1'b0;
                        end
				1:  if(!in_pel.full[1])
                        begin
                        in_pel.din = {1'b1,in_port_filter_8tap_file_data[in_port_i_1]};
                        in_pel.write  = 1'b1;
                        in_port_i_1 = in_port_i_1 + 1;
					    end
					 else
                        begin
                        in_pel.din = 0;
                        in_pel.write  = 1'b0;
                        end
				-1: begin
					in_pel.din = 'x;
					in_pel.write  = 1'b0;
					end
				endcase

			end
		// complete first flow
		while(in_port_i_0 < IN_PORT_FILTER_8TAP_SIZE)	
			begin
			#10
			if(in_pel.full[0] == 0)
				begin
				in_pel.din = {1'b0,in_port_filter_8tap_file_data[in_port_i_0]};
				in_pel.write  = 1'b1;
				in_port_i_0 = in_port_i_0 + 1;
				end	
			else
				begin
				in_pel.din = 0;
				in_pel.write  = 1'b0;
				end
			end
		
		// complete second flow
		while(in_port_i_1 < IN_PORT_FILTER_8TAP_SIZE)	
			begin
			#10
			if(in_pel.full[1] == 0)
				begin
				in_pel.din = {1'b1,in_port_filter_8tap_file_data[in_port_i_1]};
				in_pel.write  = 1'b1;
				in_port_i_1 = in_port_i_1 + 1;
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
			case (out_pel.din[8])
			0: begin
				if(out_pel.din[7:0] != out_port_filter_8tap_file_data[out_port_i_0])
				    $display("Error on output %d of flow %d: obtained %d, expected %d", out_port_i_0, out_pel.din[8], out_pel.din[7:0], out_port_filter_8tap_file_data[out_port_i_0]);
				out_port_i_0 = out_port_i_0 + 1;
				
				if(out_port_i_0 == OUT_PORT_FILTER_8TAP_SIZE)
					$display("Flow %d completed elaboration at time %f us",out_pel.din[8], ($time/1000.0));
			   end
			1: begin
				if(out_pel.din[7:0] != out_port_filter_8tap_file_data[out_port_i_1])
				$display("Error on output %d of flow %d: obtained %d, expected %d", out_port_i_1, out_pel.din[8], out_pel.din[7:0], out_port_filter_8tap_file_data[out_port_i_1]);
				out_port_i_1 = out_port_i_1 + 1;
				
				if(out_port_i_1 == OUT_PORT_FILTER_8TAP_SIZE)
					$display("Flow %d completed elaboration at time %f us",out_pel.din[8], ($time/1000.0));
			   end
			 default: begin $error("Unexpected output tag"); $stop; end
			 endcase
		end
	`endif
	// ----------------------------------------------------------------------------

endmodule
