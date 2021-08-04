`timescale 1 ns / 1 ps


module tb_blk;

	// test bench parameters
	// ----------------------------------------------------------------------------
	parameter clk_PERIOD = 10;
	
	parameter N_CHANNELS = 8;
	parameter TAP = 8;
    parameter SIZE = 16;    // 4, 8, 16, 32, 64
	parameter V_ALPHA = 2;  // 0, 2, 4, 6
	parameter H_ALPHA = 2;  // 0, 2, 4, 6
	
	parameter IN_PORT_FILTER_8TAP_FILE = "input_16x16.mem";
	parameter IN_PORT_FILTER_8TAP_SIZE = (SIZE + TAP)*(SIZE + TAP) + TAP;
	
	parameter FLUX = 4;
    parameter DEPTH = 2;
    
	parameter OUT_PORT_FILTER_8TAP_FILE = "output_16x16_v2_h2.mem";
	parameter OUT_PORT_FILTER_8TAP_SIZE = SIZE*SIZE;
	
	parameter BLOCK_SIZE = (SIZE + TAP); // One row
	
	// ----------------------------------------------------------------------------
	
	// multi_dataflow signals
	// ----------------------------------------------------------------------------
	logic [7:0] in_port_filter_8tap_file_data [IN_PORT_FILTER_8TAP_SIZE-1:0];
	integer in_port_i_0 = 0;
	integer in_port_i_1 = 0;	
	integer in_port_i_2 = 0;
	integer in_port_i_3 = 0;
	logic [7:0] out_port_filter_8tap_file_data [OUT_PORT_FILTER_8TAP_SIZE-1:0];
	integer out_port0_i_0 = 0;
 	integer out_port0_i_1 = 0;
 	integer out_port0_i_2 = 0;
 	integer out_port0_i_3 = 0;
 	
	integer out_port1_i_0 = 1;
 	integer out_port1_i_1 = 1;
 	integer out_port1_i_2 = 1;
 	integer out_port1_i_3 = 1;
 	
	integer out_port2_i_0 = 2;
 	integer out_port2_i_1 = 2;
 	integer out_port2_i_2 = 2;
 	integer out_port2_i_3 = 2;
 	
	integer out_port3_i_0 = 3;
 	integer out_port3_i_1 = 3;
 	integer out_port3_i_2 = 3;
 	integer out_port3_i_3 = 3;
 	
	integer out_port4_i_0 = 4;
 	integer out_port4_i_1 = 4;
 	integer out_port4_i_2 = 4;
 	integer out_port4_i_3 = 4;
 	
	integer out_port5_i_0 = 5;
 	integer out_port5_i_1 = 5;
 	integer out_port5_i_2 = 5;
 	integer out_port5_i_3 = 5;
 	
	integer out_port6_i_0 = 6;
 	integer out_port6_i_1 = 6;
 	integer out_port6_i_2 = 6;
 	integer out_port6_i_3 = 6;
 	
	integer out_port7_i_0 = 7;
 	integer out_port7_i_1 = 7;
 	integer out_port7_i_2 = 7;
 	integer out_port7_i_3 = 7;
	
	integer select_flow = 0;
	integer cnt_elements = 0;
	logic [6 : 0] ext_size_val;
	logic [2 : 0] v_alpha_val;
	logic [2 : 0] h_alpha_val;
	
	logic clk;
	logic rst;
	
	write_interface #(3,FLUX) v_alpha (.*);
    write_interface #(3,FLUX) h_alpha (.*);
    write_interface #(7,FLUX) ext_size (.*);
    write_interface #(8,FLUX) in_pel_0 (.*);
	write_interface #(8,FLUX) in_pel_1 (.*);
	write_interface #(8,FLUX) in_pel_2 (.*);
	write_interface #(8,FLUX) in_pel_3 (.*);
	write_interface #(8,FLUX) in_pel_4 (.*);
	write_interface #(8,FLUX) in_pel_5 (.*);
	write_interface #(8,FLUX) in_pel_6 (.*);
	write_interface #(8,FLUX) in_pel_7 (.*);
    write_interface #(8,FLUX) out_pel_0 (.*);
	write_interface #(8,FLUX) out_pel_1 (.*);
	write_interface #(8,FLUX) out_pel_2 (.*);
	write_interface #(8,FLUX) out_pel_3 (.*);
	write_interface #(8,FLUX) out_pel_4 (.*);
	write_interface #(8,FLUX) out_pel_5 (.*);
	write_interface #(8,FLUX) out_pel_6 (.*);
	write_interface #(8,FLUX) out_pel_7 (.*);
	
	// ----------------------------------------------------------------------------
	
	// time variables
	// ----------------------------------------------------------------------------
	time t_req[0 : FLUX-1];	// request-to-access-the-accelerator time instant
	time t_start[0 : FLUX-1];	// first-input-processed time instant 
	time t_first[0 : FLUX-1];	// first-output-produced time instant
	time t_end[0 : FLUX-1];	// output-completion time instant 

	// network input and output files
	// ----------------------------------------------------------------------------
	initial
	 	$readmemh(IN_PORT_FILTER_8TAP_FILE, in_port_filter_8tap_file_data);
	initial
		$readmemh(OUT_PORT_FILTER_8TAP_FILE, out_port_filter_8tap_file_data);
			
	// ----------------------------------------------------------------------------

	// dut
	// ----------------------------------------------------------------------------
	top_8pixel_ms #(
		.DEPTH(DEPTH),
		.FLUX(FLUX)
	) dut (
	.clk(clk),
    .rst(rst),
    
    // Input(s)
    .write_port_in_port_0(in_pel_0),
    .write_port_in_port_1(in_pel_1),
    .write_port_in_port_2(in_pel_2),
    .write_port_in_port_3(in_pel_3),
    .write_port_in_port_4(in_pel_4),
    .write_port_in_port_5(in_pel_5),
    .write_port_in_port_6(in_pel_6),
    .write_port_in_port_7(in_pel_7),
    
    .write_port_h_alpha(h_alpha),
    
    .write_port_ext_size(ext_size),
    
    .write_port_v_alpha(v_alpha),
    
    // Output(s)
    .write_port_out_port_0(out_pel_0),
    .write_port_out_port_1(out_pel_1),
    .write_port_out_port_2(out_pel_2),
    .write_port_out_port_3(out_pel_3),
    .write_port_out_port_4(out_pel_4),
    .write_port_out_port_5(out_pel_5),
    .write_port_out_port_6(out_pel_6),
    .write_port_out_port_7(out_pel_7)   
); 	
	// ----------------------------------------------------------------------------

	// clk
	// ----------------------------------------------------------------------------
	always #(clk_PERIOD/2)
		clk = ~clk;
	// ----------------------------------------------------------------------------

	// input feeding
	// ----------------------------------------------------------------------------
	initial
		begin
		// clks initialization
		clk = 0;
	
		// network signals initialization
		in_pel_0.din = 0;
		in_pel_0.write  = 1'b0;
		in_pel_1.din = 0;
		in_pel_1.write  = 1'b0;
		in_pel_2.din = 0;
		in_pel_2.write  = 1'b0;
		in_pel_3.din = 0;
		in_pel_3.write  = 1'b0;
		in_pel_4.din = 0;
		in_pel_4.write  = 1'b0;
		in_pel_5.din = 0;
		in_pel_5.write  = 1'b0;
		in_pel_6.din = 0;
		in_pel_6.write  = 1'b0;
		in_pel_7.din = 0;
		in_pel_7.write  = 1'b0;
		h_alpha.din = 0;
		h_alpha.write  = 1'b0; 
		ext_size.din = 0;
		ext_size.write  = 1'b0;
		v_alpha.din = 0;
		v_alpha.write  = 1'b0;
		out_pel_0.full = 2'b0;
		out_pel_1.full = 2'b0;
		out_pel_2.full = 2'b0;
		out_pel_3.full = 2'b0;
		out_pel_4.full = 2'b0;
		out_pel_5.full = 2'b0;
		out_pel_6.full = 2'b0;
		out_pel_7.full = 2'b0;
	
		// initial rst
		rst = 0;
		#2
		rst = 1;
		#100
		rst = 0;
		#100
				 
		// setup flow_0
		v_alpha_val = V_ALPHA;
		v_alpha.din = {2'd0,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA;
		h_alpha.din = {2'd0,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE + TAP;
		ext_size.din = {2'd0,ext_size_val};
		ext_size.write = 1;
		t_req[0] = $time;
		t_req[1] = $time;
		t_req[2] = $time;
		t_req[3] = $time;
		t_start[0] = $time;
		
		#(clk_PERIOD)
		// setup flow_1
		v_alpha_val = V_ALPHA;
		v_alpha.din = {2'd1,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA;
		h_alpha.din = {2'd1,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE + TAP;
		ext_size.din = {2'd1,ext_size_val};
		ext_size.write = 1;
		t_start[1] = $time;
		
		#(clk_PERIOD)
		// setup flow_2
		v_alpha_val = V_ALPHA;
		v_alpha.din = {2'd2,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA;
		h_alpha.din = {2'd2,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE + TAP;
		ext_size.din = {2'd2,ext_size_val};
		ext_size.write = 1;
		t_start[2] = $time;
		
		#(clk_PERIOD)
		// setup flow_3
		v_alpha_val = V_ALPHA;
		v_alpha.din = {2'd3,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA;
		h_alpha.din = {2'd3,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE + TAP;
		ext_size.din = {2'd3,ext_size_val};
		ext_size.write = 1;
		t_start[3] = $time;
		
		#(clk_PERIOD)
		v_alpha.din = 0;
		v_alpha.write = 0;
		h_alpha.din = 0;
		h_alpha.write = 0;
		ext_size.din = 0;
		ext_size.write = 0;
		
		// feed all the flows
		while((in_port_i_0 < IN_PORT_FILTER_8TAP_SIZE) || (in_port_i_1 < IN_PORT_FILTER_8TAP_SIZE) || (in_port_i_2 < IN_PORT_FILTER_8TAP_SIZE) || (in_port_i_3 < IN_PORT_FILTER_8TAP_SIZE))
		begin
			#(clk_PERIOD)
				case(select_flow)
		0:	if(!in_pel_0.full[0] & !in_pel_1.full[0] & !in_pel_1.full[0] & !in_pel_3.full[0] &
				!in_pel_4.full[0] & !in_pel_5.full[0] & !in_pel_6.full[0] & !in_pel_7.full[0])
				begin
				in_pel_0.din = {2'd0,in_port_filter_8tap_file_data[in_port_i_0 + 0]};
				in_pel_0.write  = 1'b1;
				in_pel_1.din = {2'd0,in_port_filter_8tap_file_data[in_port_i_0 + 1]};
				in_pel_1.write  = 1'b1;
				in_pel_2.din = {2'd0,in_port_filter_8tap_file_data[in_port_i_0 + 2]};
				in_pel_2.write  = 1'b1;
				in_pel_3.din = {2'd0,in_port_filter_8tap_file_data[in_port_i_0 + 3]};
				in_pel_3.write  = 1'b1;
				in_pel_4.din = {2'd0,in_port_filter_8tap_file_data[in_port_i_0 + 4]};
				in_pel_4.write  = 1'b1;
				in_pel_5.din = {2'd0,in_port_filter_8tap_file_data[in_port_i_0 + 5]};
				in_pel_5.write  = 1'b1;
				in_pel_6.din = {2'd0,in_port_filter_8tap_file_data[in_port_i_0 + 6]};
				in_pel_6.write  = 1'b1;
				in_pel_7.din = {2'd0,in_port_filter_8tap_file_data[in_port_i_0 + 7]};
				in_pel_7.write  = 1'b1;
				in_port_i_0 = in_port_i_0 + N_CHANNELS;
				end	
			else
				begin
				in_pel_0.din = 0; in_pel_0.write  = 1'b0;
				in_pel_1.din = 0; in_pel_1.write  = 1'b0;
				in_pel_2.din = 0; in_pel_2.write  = 1'b0;
				in_pel_3.din = 0; in_pel_3.write  = 1'b0;
				in_pel_4.din = 0; in_pel_4.write  = 1'b0;
				in_pel_5.din = 0; in_pel_5.write  = 1'b0;
				in_pel_6.din = 0; in_pel_6.write  = 1'b0;
				in_pel_7.din = 0; in_pel_7.write  = 1'b0;
				end
				
		1:	if(!in_pel_0.full[1] & !in_pel_1.full[1] & !in_pel_1.full[1] & !in_pel_3.full[1] &
				!in_pel_4.full[1] & !in_pel_5.full[1] & !in_pel_6.full[1] & !in_pel_7.full[1])
				begin
				in_pel_0.din = {2'd1,in_port_filter_8tap_file_data[in_port_i_1 + 0]};
				in_pel_0.write  = 1'b1;
				in_pel_1.din = {2'd1,in_port_filter_8tap_file_data[in_port_i_1 + 1]};
				in_pel_1.write  = 1'b1;
				in_pel_2.din = {2'd1,in_port_filter_8tap_file_data[in_port_i_1 + 2]};
				in_pel_2.write  = 1'b1;
				in_pel_3.din = {2'd1,in_port_filter_8tap_file_data[in_port_i_1 + 3]};
				in_pel_3.write  = 1'b1;
				in_pel_4.din = {2'd1,in_port_filter_8tap_file_data[in_port_i_1 + 4]};
				in_pel_4.write  = 1'b1;
				in_pel_5.din = {2'd1,in_port_filter_8tap_file_data[in_port_i_1 + 5]};
				in_pel_5.write  = 1'b1;
				in_pel_6.din = {2'd1,in_port_filter_8tap_file_data[in_port_i_1 + 6]};
				in_pel_6.write  = 1'b1;
				in_pel_7.din = {2'd1,in_port_filter_8tap_file_data[in_port_i_1 + 7]};
				in_pel_7.write  = 1'b1;
				in_port_i_1 = in_port_i_1 + N_CHANNELS;
				end	
			else
				begin
				in_pel_0.din = 0; in_pel_0.write  = 1'b0;
				in_pel_1.din = 0; in_pel_1.write  = 1'b0;
				in_pel_2.din = 0; in_pel_2.write  = 1'b0;
				in_pel_3.din = 0; in_pel_3.write  = 1'b0;
				in_pel_4.din = 0; in_pel_4.write  = 1'b0;
				in_pel_5.din = 0; in_pel_5.write  = 1'b0;
				in_pel_6.din = 0; in_pel_6.write  = 1'b0;
				in_pel_7.din = 0; in_pel_7.write  = 1'b0;
				end
		2:	if(!in_pel_0.full[2] & !in_pel_1.full[2] & !in_pel_1.full[2] & !in_pel_3.full[2] &
				!in_pel_4.full[2] & !in_pel_5.full[2] & !in_pel_6.full[2] & !in_pel_7.full[2])
				begin
				in_pel_0.din = {2'd2,in_port_filter_8tap_file_data[in_port_i_2 + 0]};
				in_pel_0.write  = 1'b1;
				in_pel_1.din = {2'd2,in_port_filter_8tap_file_data[in_port_i_2 + 1]};
				in_pel_1.write  = 1'b1;
				in_pel_2.din = {2'd2,in_port_filter_8tap_file_data[in_port_i_2 + 2]};
				in_pel_2.write  = 1'b1;
				in_pel_3.din = {2'd2,in_port_filter_8tap_file_data[in_port_i_2 + 3]};
				in_pel_3.write  = 1'b1;
				in_pel_4.din = {2'd2,in_port_filter_8tap_file_data[in_port_i_2 + 4]};
				in_pel_4.write  = 1'b1;
				in_pel_5.din = {2'd2,in_port_filter_8tap_file_data[in_port_i_2 + 5]};
				in_pel_5.write  = 1'b1;
				in_pel_6.din = {2'd2,in_port_filter_8tap_file_data[in_port_i_2 + 6]};
				in_pel_6.write  = 1'b1;
				in_pel_7.din = {2'd2,in_port_filter_8tap_file_data[in_port_i_2 + 7]};
				in_pel_7.write  = 1'b1;
				in_port_i_2 = in_port_i_2 + N_CHANNELS;
				end	
			else
				begin
				in_pel_0.din = 0; in_pel_0.write  = 1'b0;
				in_pel_1.din = 0; in_pel_1.write  = 1'b0;
				in_pel_2.din = 0; in_pel_2.write  = 1'b0;
				in_pel_3.din = 0; in_pel_3.write  = 1'b0;
				in_pel_4.din = 0; in_pel_4.write  = 1'b0;
				in_pel_5.din = 0; in_pel_5.write  = 1'b0;
				in_pel_6.din = 0; in_pel_6.write  = 1'b0;
				in_pel_7.din = 0; in_pel_7.write  = 1'b0;
				end
		3:if(!in_pel_0.full[3] & !in_pel_1.full[3] & !in_pel_1.full[3] & !in_pel_3.full[3] &
				!in_pel_4.full[3] & !in_pel_5.full[3] & !in_pel_6.full[3] & !in_pel_7.full[3])
				begin
				in_pel_0.din = {2'd3,in_port_filter_8tap_file_data[in_port_i_3 + 0]};
				in_pel_0.write  = 1'b1;
				in_pel_1.din = {2'd3,in_port_filter_8tap_file_data[in_port_i_3 + 1]};
				in_pel_1.write  = 1'b1;
				in_pel_2.din = {2'd3,in_port_filter_8tap_file_data[in_port_i_3 + 2]};
				in_pel_2.write  = 1'b1;
				in_pel_3.din = {2'd3,in_port_filter_8tap_file_data[in_port_i_3 + 3]};
				in_pel_3.write  = 1'b1;
				in_pel_4.din = {2'd3,in_port_filter_8tap_file_data[in_port_i_3 + 4]};
				in_pel_4.write  = 1'b1;
				in_pel_5.din = {2'd3,in_port_filter_8tap_file_data[in_port_i_3 + 5]};
				in_pel_5.write  = 1'b1;
				in_pel_6.din = {2'd3,in_port_filter_8tap_file_data[in_port_i_3 + 6]};
				in_pel_6.write  = 1'b1;
				in_pel_7.din = {2'd3,in_port_filter_8tap_file_data[in_port_i_3 + 7]};
				in_pel_7.write  = 1'b1;
				in_port_i_3 = in_port_i_3 + N_CHANNELS;
				end	
			else
				begin
				in_pel_0.din = 0; in_pel_0.write  = 1'b0;
				in_pel_1.din = 0; in_pel_1.write  = 1'b0;
				in_pel_2.din = 0; in_pel_2.write  = 1'b0;
				in_pel_3.din = 0; in_pel_3.write  = 1'b0;
				in_pel_4.din = 0; in_pel_4.write  = 1'b0;
				in_pel_5.din = 0; in_pel_5.write  = 1'b0;
				in_pel_6.din = 0; in_pel_6.write  = 1'b0;
				in_pel_7.din = 0; in_pel_7.write  = 1'b0;
				end				
		default: begin
				in_pel_0.din = 0; in_pel_0.write  = 1'b0;
				in_pel_1.din = 0; in_pel_1.write  = 1'b0;
				in_pel_2.din = 0; in_pel_2.write  = 1'b0;
				in_pel_3.din = 0; in_pel_3.write  = 1'b0;
				in_pel_4.din = 0; in_pel_4.write  = 1'b0;
				in_pel_5.din = 0; in_pel_5.write  = 1'b0;
				in_pel_6.din = 0; in_pel_6.write  = 1'b0;
				in_pel_7.din = 0; in_pel_7.write  = 1'b0;
				end	
			endcase				
			end
		#(clk_PERIOD)
		in_pel_0.din = 0; in_pel_0.write  = 1'b0;
		in_pel_1.din = 0; in_pel_1.write  = 1'b0;
		in_pel_2.din = 0; in_pel_2.write  = 1'b0;
		in_pel_3.din = 0; in_pel_3.write  = 1'b0;
		in_pel_4.din = 0; in_pel_4.write  = 1'b0;
		in_pel_5.din = 0; in_pel_5.write  = 1'b0;
		in_pel_6.din = 0; in_pel_6.write  = 1'b0;
		in_pel_7.din = 0; in_pel_7.write  = 1'b0;
		
			
		// wait all the flows to end
		while((out_port0_i_0 < OUT_PORT_FILTER_8TAP_SIZE) || (out_port0_i_1 < OUT_PORT_FILTER_8TAP_SIZE)  || (out_port0_i_2 < OUT_PORT_FILTER_8TAP_SIZE) || (out_port0_i_3 < OUT_PORT_FILTER_8TAP_SIZE))
			#(clk_PERIOD);			
	
		#(clk_PERIOD)
		$display("Flow 0 execution time:\t%f us", (t_end[0]-t_start[0]) / 1000.0);
		$display("Flow 1 execution time:\t%f us", (t_end[1]-t_start[1]) / 1000.0);
		$display("Flow 2 execution time:\t%f us", (t_end[2]-t_start[2]) / 1000.0);
		$display("Flow 3 execution time:\t%f us", (t_end[3]-t_start[3]) / 1000.0);
		$display("Total execution time:\t%f us", (t_end[3]-t_start[0]) / 1000.0);
		
		$display("Flow 0 waiting time:\t%f us", (t_start[0]-t_req[0]) / 1000.0);
		$display("Flow 1 waiting time:\t%f us", (t_start[1]-t_req[1]) / 1000.0);
		$display("Flow 2 waiting time:\t%f us", (t_start[2]-t_req[2]) / 1000.0);
		$display("Flow 3 waiting time:\t%f us", (t_start[3]-t_req[3]) / 1000.0);
		
		$display("Flow 0 response time:\t%f us", (t_first[0]-t_req[0]) / 1000.0);
		$display("Flow 1 response time:\t%f us", (t_first[1]-t_req[1]) / 1000.0);
		$display("Flow 2 response time:\t%f us", (t_first[2]-t_req[2]) / 1000.0);
		$display("Flow 3 response time:\t%f us", (t_first[3]-t_req[3]) / 1000.0);
		
		$stop;
		end
		
	// ----------------------------------------------------------------------------
	// select_flow managing
	always @(posedge clk)
	if(in_pel_0.write)	
		if(cnt_elements < BLOCK_SIZE)
			cnt_elements = cnt_elements + N_CHANNELS;
		else
			begin // each time a block is written it changes flow 
			cnt_elements = 0;
            case(select_flow)
            0: if(in_port_i_1 < IN_PORT_FILTER_8TAP_SIZE)	// unless the other flow has completed
                 select_flow = 1;
                else
                 select_flow = 2;
            1: if(in_port_i_2 < IN_PORT_FILTER_8TAP_SIZE)
                 select_flow = 2;
                else
                 select_flow = 3;
            2: if(in_port_i_3 < IN_PORT_FILTER_8TAP_SIZE)
                 select_flow = 3;
                else
                 select_flow = 0;
            3: if(in_port_i_0 < IN_PORT_FILTER_8TAP_SIZE)
                 select_flow = 0;
                else
                 select_flow = 1;
            default: $error("Error on select_flow!");
            endcase
		    end
	// ----------------------------------------------------------------------------
	// output of the horizontal filter
	/*
	integer out_hor_i_0 = 0;
	integer out_hor_i_1 = 0;
	
		always@(posedge clk)
		begin
		if(dut.wr_remove_h_0_out_pel.write)
			case (dut.wr_remove_h_0_out_pel.din[18])
			0: begin
				    out_hor_i_0 = out_hor_i_0 + 1;
			   end
			1: begin
				    out_hor_i_1 = out_hor_i_1 + 1;
			   end
			 default: 
				begin 
				$error("Unexpected output tag"); 
				$stop; 
				end
			 endcase
		end
	*/
	// output check
	// ----------------------------------------------------------------------------
	
	// check out_pel_0 and evaluate times
	always@(posedge clk)
		begin
		if(out_pel_0.write)
			case (out_pel_0.din[9:8])
			0: begin
				if(out_pel_0.din[7:0] != out_port_filter_8tap_file_data[out_port0_i_0])
				    $error("Error on output %d (channel out_pel_0) of flow %d: obtained %d, expected %d", out_port0_i_0, out_pel_0.din[9:8], out_pel_0.din[7:0], out_port_filter_8tap_file_data[out_port0_i_0]);
				out_port0_i_0 = out_port0_i_0 + N_CHANNELS;
				if(out_port0_i_0 == N_CHANNELS)
					t_first[0] = $time;
				if(out_port0_i_0 == OUT_PORT_FILTER_8TAP_SIZE)
					t_end[0]= $time;
			   end
			1: begin
				if(out_pel_0.din[7:0] != out_port_filter_8tap_file_data[out_port0_i_1])
					$error("Error on output %d (channel out_pel_0) of flow %d: obtained %d, expected %d", out_port0_i_1, out_pel_0.din[9:8], out_pel_0.din[7:0], out_port_filter_8tap_file_data[out_port0_i_1]);
				out_port0_i_1 = out_port0_i_1 + N_CHANNELS;
				if(out_port0_i_1 == N_CHANNELS)
					t_first[1] = $time;
				if(out_port0_i_1 == OUT_PORT_FILTER_8TAP_SIZE)
					t_end[1] = $time;
			   end
			2: begin
				if(out_pel_0.din[7:0] != out_port_filter_8tap_file_data[out_port0_i_2])
					$error("Error on output %d (channel out_pel_0) of flow %d: obtained %d, expected %d", out_port0_i_2, out_pel_0.din[9:8], out_pel_0.din[7:0], out_port_filter_8tap_file_data[out_port0_i_2]);
				out_port0_i_2 = out_port0_i_2 + N_CHANNELS;
				if(out_port0_i_2 == N_CHANNELS)
					t_first[2] = $time;
				if(out_port0_i_2 == OUT_PORT_FILTER_8TAP_SIZE)
					t_end[2] = $time;
			   end
			3: begin
				if(out_pel_0.din[7:0] != out_port_filter_8tap_file_data[out_port0_i_3])
					$error("Error on output %d (channel out_pel_0) of flow %d: obtained %d, expected %d", out_port0_i_3, out_pel_0.din[9:8], out_pel_0.din[7:0], out_port_filter_8tap_file_data[out_port0_i_3]);
				out_port0_i_3 = out_port0_i_3 + N_CHANNELS;
				if(out_port0_i_3 == N_CHANNELS)
					t_first[3] = $time;
				if(out_port0_i_3 == OUT_PORT_FILTER_8TAP_SIZE)
					t_end[3] = $time;
			   end
			 default: 
				begin 
				$error("Unexpected output tag"); 
				$stop; 
				end
			 endcase
		end	

	// check out_pel_1
	always@(posedge clk)
		begin
		if(out_pel_1.write)
			case (out_pel_1.din[9:8])
			0: begin
				if(out_pel_1.din[7:0] != out_port_filter_8tap_file_data[out_port1_i_0])
				    $error("Error on output %d (channel out_pel_1) of flow %d: obtained %d, expected %d", out_port1_i_0, out_pel_1.din[9:8], out_pel_1.din[7:0], out_port_filter_8tap_file_data[out_port1_i_0]);
				out_port1_i_0 = out_port1_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_1.din[7:0] != out_port_filter_8tap_file_data[out_port1_i_1])
					$error("Error on output %d (channel out_pel_1) of flow %d: obtained %d, expected %d", out_port1_i_1, out_pel_1.din[9:8], out_pel_1.din[7:0], out_port_filter_8tap_file_data[out_port1_i_1]);
				out_port1_i_1 = out_port1_i_1 + N_CHANNELS;
			   end
			2: begin
				if(out_pel_1.din[7:0] != out_port_filter_8tap_file_data[out_port1_i_2])
					$error("Error on output %d (channel out_pel_1) of flow %d: obtained %d, expected %d", out_port1_i_2, out_pel_1.din[9:8], out_pel_1.din[7:0], out_port_filter_8tap_file_data[out_port1_i_2]);
				out_port1_i_2 = out_port1_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_1.din[7:0] != out_port_filter_8tap_file_data[out_port1_i_3])
					$error("Error on output %d (channel out_pel_1) of flow %d: obtained %d, expected %d", out_port1_i_3, out_pel_1.din[9:8], out_pel_1.din[7:0], out_port_filter_8tap_file_data[out_port1_i_3]);
				out_port1_i_3 = out_port1_i_3 + N_CHANNELS;
			   end
			 default: 
				begin 
				$error("Unexpected output tag"); 
				$stop; 
				end
			 endcase
		end	
		
	// check out_pel_2
	always@(posedge clk)
		begin
		if(out_pel_2.write)
			case (out_pel_2.din[9:8])
			0: begin
				if(out_pel_2.din[7:0] != out_port_filter_8tap_file_data[out_port2_i_0])
				    $error("Error on output %d (channel out_pel_2) of flow %d: obtained %d, expected %d", out_port2_i_0, out_pel_2.din[9:8], out_pel_2.din[7:0], out_port_filter_8tap_file_data[out_port2_i_0]);
				out_port2_i_0 = out_port2_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_2.din[7:0] != out_port_filter_8tap_file_data[out_port2_i_1])
					$error("Error on output %d (channel out_pel_2) of flow %d: obtained %d, expected %d", out_port2_i_1, out_pel_2.din[9:8], out_pel_2.din[7:0], out_port_filter_8tap_file_data[out_port2_i_1]);
				out_port2_i_1 = out_port2_i_1 + N_CHANNELS;
			   end
			 2: begin
				if(out_pel_2.din[7:0] != out_port_filter_8tap_file_data[out_port2_i_2])
					$error("Error on output %d (channel out_pel_2) of flow %d: obtained %d, expected %d", out_port2_i_2, out_pel_2.din[9:8], out_pel_2.din[7:0], out_port_filter_8tap_file_data[out_port2_i_2]);
				out_port2_i_2 = out_port2_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_2.din[7:0] != out_port_filter_8tap_file_data[out_port2_i_3])
					$error("Error on output %d (channel out_pel_2) of flow %d: obtained %d, expected %d", out_port2_i_3, out_pel_2.din[9:8], out_pel_2.din[7:0], out_port_filter_8tap_file_data[out_port2_i_3]);
				out_port2_i_3 = out_port2_i_3 + N_CHANNELS;
			   end
			 default: 
				begin 
				$error("Unexpected output tag"); 
				$stop; 
				end
			 endcase
		end
		
	// check out_pel_3
	always@(posedge clk)
		begin
		if(out_pel_3.write)
			case (out_pel_3.din[9:8])
			0: begin
				if(out_pel_3.din[7:0] != out_port_filter_8tap_file_data[out_port3_i_0])
				    $error("Error on output %d (channel out_pel_3) of flow %d: obtained %d, expected %d", out_port3_i_0, out_pel_3.din[9:8], out_pel_3.din[7:0], out_port_filter_8tap_file_data[out_port3_i_0]);
				out_port3_i_0 = out_port3_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_3.din[7:0] != out_port_filter_8tap_file_data[out_port3_i_1])
					$error("Error on output %d (channel out_pel_3) of flow %d: obtained %d, expected %d", out_port3_i_1, out_pel_3.din[9:8], out_pel_3.din[7:0], out_port_filter_8tap_file_data[out_port3_i_1]);
				out_port3_i_1 = out_port3_i_1 + N_CHANNELS;
			   end
			 2: begin
				if(out_pel_3.din[7:0] != out_port_filter_8tap_file_data[out_port3_i_2])
					$error("Error on output %d (channel out_pel_3) of flow %d: obtained %d, expected %d", out_port3_i_2, out_pel_3.din[9:8], out_pel_3.din[7:0], out_port_filter_8tap_file_data[out_port3_i_2]);
				out_port3_i_2 = out_port3_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_3.din[7:0] != out_port_filter_8tap_file_data[out_port3_i_3])
					$error("Error on output %d (channel out_pel_3) of flow %d: obtained %d, expected %d", out_port3_i_3, out_pel_3.din[9:8], out_pel_3.din[7:0], out_port_filter_8tap_file_data[out_port3_i_3]);
				out_port3_i_3 = out_port3_i_3 + N_CHANNELS;
			   end
			 default: 
				begin 
				$error("Unexpected output tag"); 
				$stop; 
				end
			 endcase
		end
		
	// check out_pel_4
	always@(posedge clk)
		begin
		if(out_pel_4.write)
			case (out_pel_4.din[9:8])
			0: begin
				if(out_pel_4.din[7:0] != out_port_filter_8tap_file_data[out_port4_i_0])
				    $error("Error on output %d (channel out_pel_4) of flow %d: obtained %d, expected %d", out_port4_i_0, out_pel_4.din[9:8], out_pel_4.din[7:0], out_port_filter_8tap_file_data[out_port4_i_0]);
				out_port4_i_0 = out_port4_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_4.din[7:0] != out_port_filter_8tap_file_data[out_port4_i_1])
					$error("Error on output %d (channel out_pel_4) of flow %d: obtained %d, expected %d", out_port4_i_1, out_pel_4.din[9:8], out_pel_4.din[7:0], out_port_filter_8tap_file_data[out_port4_i_1]);
				out_port4_i_1 = out_port4_i_1 + N_CHANNELS;
			   end
			 2: begin
				if(out_pel_4.din[7:0] != out_port_filter_8tap_file_data[out_port4_i_2])
					$error("Error on output %d (channel out_pel_4) of flow %d: obtained %d, expected %d", out_port4_i_2, out_pel_4.din[9:8], out_pel_4.din[7:0], out_port_filter_8tap_file_data[out_port4_i_2]);
				out_port4_i_2 = out_port4_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_4.din[7:0] != out_port_filter_8tap_file_data[out_port4_i_3])
					$error("Error on output %d (channel out_pel_4) of flow %d: obtained %d, expected %d", out_port4_i_3, out_pel_4.din[9:8], out_pel_4.din[7:0], out_port_filter_8tap_file_data[out_port4_i_3]);
				out_port4_i_3 = out_port4_i_3 + N_CHANNELS;
			   end
			 default: 
				begin 
				$error("Unexpected output tag"); 
				$stop; 
				end
			 endcase
		end
		
	// check out_pel_5
	always@(posedge clk)
		begin
		if(out_pel_5.write)
			case (out_pel_5.din[9:8])
			0: begin
				if(out_pel_5.din[7:0] != out_port_filter_8tap_file_data[out_port5_i_0])
				    $error("Error on output %d (channel out_pel_5) of flow %d: obtained %d, expected %d", out_port5_i_0, out_pel_5.din[9:8], out_pel_5.din[7:0], out_port_filter_8tap_file_data[out_port5_i_0]);
				out_port5_i_0 = out_port5_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_5.din[7:0] != out_port_filter_8tap_file_data[out_port5_i_1])
					$error("Error on output %d (channel out_pel_5) of flow %d: obtained %d, expected %d", out_port5_i_1, out_pel_5.din[9:8], out_pel_5.din[7:0], out_port_filter_8tap_file_data[out_port5_i_1]);
				out_port5_i_1 = out_port5_i_1 + N_CHANNELS;
			   end
			 2: begin
				if(out_pel_5.din[7:0] != out_port_filter_8tap_file_data[out_port5_i_2])
					$error("Error on output %d (channel out_pel_5) of flow %d: obtained %d, expected %d", out_port5_i_2, out_pel_5.din[9:8], out_pel_5.din[7:0], out_port_filter_8tap_file_data[out_port5_i_2]);
				out_port5_i_2 = out_port5_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_5.din[7:0] != out_port_filter_8tap_file_data[out_port5_i_3])
					$error("Error on output %d (channel out_pel_5) of flow %d: obtained %d, expected %d", out_port5_i_3, out_pel_5.din[9:8], out_pel_5.din[7:0], out_port_filter_8tap_file_data[out_port5_i_3]);
				out_port5_i_3 = out_port5_i_3 + N_CHANNELS;
			   end
			 default: 
				begin 
				$error("Unexpected output tag"); 
				$stop; 
				end
			 endcase
		end
		
	// check out_pel_6
	always@(posedge clk)
		begin
		if(out_pel_6.write)
			case (out_pel_6.din[9:8])
			0: begin
				if(out_pel_6.din[7:0] != out_port_filter_8tap_file_data[out_port6_i_0])
				    $error("Error on output %d (channel out_pel_6) of flow %d: obtained %d, expected %d", out_port6_i_0, out_pel_6.din[9:8], out_pel_6.din[7:0], out_port_filter_8tap_file_data[out_port6_i_0]);
				out_port6_i_0 = out_port6_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_6.din[7:0] != out_port_filter_8tap_file_data[out_port6_i_1])
					$error("Error on output %d (channel out_pel_6) of flow %d: obtained %d, expected %d", out_port6_i_1, out_pel_6.din[9:8], out_pel_6.din[7:0], out_port_filter_8tap_file_data[out_port6_i_1]);
				out_port6_i_1 = out_port6_i_1 + N_CHANNELS;
			   end
			 2: begin
				if(out_pel_6.din[7:0] != out_port_filter_8tap_file_data[out_port6_i_2])
					$error("Error on output %d (channel out_pel_6) of flow %d: obtained %d, expected %d", out_port6_i_2, out_pel_6.din[9:8], out_pel_6.din[7:0], out_port_filter_8tap_file_data[out_port6_i_2]);
				out_port6_i_2 = out_port6_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_6.din[7:0] != out_port_filter_8tap_file_data[out_port6_i_3])
					$error("Error on output %d (channel out_pel_6) of flow %d: obtained %d, expected %d", out_port6_i_3, out_pel_6.din[9:8], out_pel_6.din[7:0], out_port_filter_8tap_file_data[out_port6_i_3]);
				out_port6_i_3 = out_port6_i_3 + N_CHANNELS;
			   end
			 default: 
				begin 
				$error("Unexpected output tag"); 
				$stop; 
				end
			 endcase
		end
		
	// check out_pel_7
	always@(posedge clk)
		begin
		if(out_pel_7.write)
			case (out_pel_7.din[9:8])
			0: begin
				if(out_pel_7.din[7:0] != out_port_filter_8tap_file_data[out_port7_i_0])
				    $error("Error on output %d (channel out_pel_7) of flow %d: obtained %d, expected %d", out_port7_i_0, out_pel_7.din[9:8], out_pel_7.din[7:0], out_port_filter_8tap_file_data[out_port7_i_0]);
				out_port7_i_0 = out_port7_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_7.din[7:0] != out_port_filter_8tap_file_data[out_port7_i_1])
					$error("Error on output %d (channel out_pel_7) of flow %d: obtained %d, expected %d", out_port7_i_1, out_pel_7.din[9:8], out_pel_7.din[7:0], out_port_filter_8tap_file_data[out_port7_i_1]);
				out_port7_i_1 = out_port7_i_1 + N_CHANNELS;
			   end
			 2: begin
				if(out_pel_7.din[7:0] != out_port_filter_8tap_file_data[out_port7_i_2])
					$error("Error on output %d (channel out_pel_7) of flow %d: obtained %d, expected %d", out_port7_i_2, out_pel_7.din[9:8], out_pel_7.din[7:0], out_port_filter_8tap_file_data[out_port7_i_2]);
				out_port7_i_2 = out_port7_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_7.din[7:0] != out_port_filter_8tap_file_data[out_port7_i_3])
					$error("Error on output %d (channel out_pel_7) of flow %d: obtained %d, expected %d", out_port7_i_3, out_pel_7.din[9:8], out_pel_7.din[7:0], out_port_filter_8tap_file_data[out_port7_i_3]);
				out_port7_i_3 = out_port7_i_3 + N_CHANNELS;
			   end
			 default: 
				begin 
				$error("Unexpected output tag"); 
				$stop; 
				end
			 endcase
		end
	
endmodule		
