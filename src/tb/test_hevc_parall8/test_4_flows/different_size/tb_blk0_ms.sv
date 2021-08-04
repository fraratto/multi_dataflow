`timescale 1 ns / 1 ps


module tb_blk0;

	// test bench parameters
	// ----------------------------------------------------------------------------
	parameter clk_PERIOD = 10;

	parameter N_CHANNELS = 8;	
	parameter TAP = 8;
    parameter SIZE_0 = 8;    // 4, 8, 16, 32, 64
	parameter V_ALPHA_0 = 2;  // 0, 2, 4, 6
	parameter H_ALPHA_0 = 0;  // 0, 2, 4, 6
    parameter SIZE_1 = 16;    // 4, 8, 16, 32, 64
	parameter V_ALPHA_1 = 2;  // 0, 2, 4, 6
	parameter H_ALPHA_1 = 2;  // 0, 2, 4, 6
    parameter SIZE_2 = 32;    // 4, 8, 16, 32, 64
	parameter V_ALPHA_2 = 6;  // 0, 2, 4, 6
	parameter H_ALPHA_2 = 4;  // 0, 2, 4, 6
    parameter SIZE_3 = 64;    // 4, 8, 16, 32, 64
	parameter V_ALPHA_3 = 2;  // 0, 2, 4, 6
	parameter H_ALPHA_3 = 2;  // 0, 2, 4, 6
	
	parameter IN_PORT_FLOW_0_FILE = "input_8x8.mem";
	parameter IN_PORT_FLOW_0_SIZE = (SIZE_0 + TAP)*(SIZE_0 + TAP) + TAP;
	parameter IN_PORT_FLOW_1_FILE = "input_16x16.mem";
	parameter IN_PORT_FLOW_1_SIZE = (SIZE_1 + TAP)*(SIZE_1 + TAP) + TAP;
	parameter IN_PORT_FLOW_2_FILE = "input_32x32.mem";
	parameter IN_PORT_FLOW_2_SIZE = (SIZE_2 + TAP)*(SIZE_2 + TAP) + TAP;
	parameter IN_PORT_FLOW_3_FILE = "input_64x64.mem";
	parameter IN_PORT_FLOW_3_SIZE = (SIZE_3 + TAP)*(SIZE_3 + TAP) + TAP;
	
	parameter FLUX = 4;
    parameter DEPTH = 2;
    
	parameter OUT_PORT_FLOW_0_FILE = "output_8x8_v2_h0.mem";
	parameter OUT_PORT_FLOW_0_SIZE = SIZE_0*SIZE_0;
	parameter OUT_PORT_FLOW_1_FILE = "output_16x16_v2_h2.mem";
	parameter OUT_PORT_FLOW_1_SIZE = SIZE_1*SIZE_1;
	parameter OUT_PORT_FLOW_2_FILE = "output_32x32_v6_h4.mem";
	parameter OUT_PORT_FLOW_2_SIZE = SIZE_2*SIZE_2;
	parameter OUT_PORT_FLOW_3_FILE = "output_64x64_v2_h2.mem";
	parameter OUT_PORT_FLOW_3_SIZE = SIZE_3*SIZE_3;
	
	parameter integer BLOCK_SIZE[0:FLUX-1] = {SIZE_0 + TAP, SIZE_1 + TAP, SIZE_2 + TAP, SIZE_3 + TAP}; // One row
	
	// ----------------------------------------------------------------------------
	
	// multi_dataflow signals
	// ----------------------------------------------------------------------------
	logic [7:0] in_port_flow_0_file_data [IN_PORT_FLOW_0_SIZE-1:0];
	logic [7:0] in_port_flow_1_file_data [IN_PORT_FLOW_1_SIZE-1:0];
	logic [7:0] in_port_flow_2_file_data [IN_PORT_FLOW_2_SIZE-1:0];
	logic [7:0] in_port_flow_3_file_data [IN_PORT_FLOW_3_SIZE-1:0];
	integer in_port_i_0 = 0;
	integer in_port_i_1 = 0;
	integer in_port_i_2 = 0;
	integer in_port_i_3 = 0;	
	logic [7:0] out_port_flow_0_file_data [OUT_PORT_FLOW_0_SIZE-1:0];
	logic [7:0] out_port_flow_1_file_data [OUT_PORT_FLOW_1_SIZE-1:0];
	logic [7:0] out_port_flow_2_file_data [OUT_PORT_FLOW_2_SIZE-1:0];
	logic [7:0] out_port_flow_3_file_data [OUT_PORT_FLOW_3_SIZE-1:0];
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
	logic [6 : 0] ext_size_val;
	logic [2 : 0] v_alpha_val;
	logic [2 : 0] h_alpha_val;
	integer select_flow = 0;
	integer cnt_elements = 0;
	
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
	    begin
	 	$readmemh(IN_PORT_FLOW_0_FILE, in_port_flow_0_file_data);
	 	$readmemh(IN_PORT_FLOW_1_FILE, in_port_flow_1_file_data);
	 	$readmemh(IN_PORT_FLOW_2_FILE, in_port_flow_2_file_data);
	 	$readmemh(IN_PORT_FLOW_3_FILE, in_port_flow_3_file_data);
	 	end
	initial
	    begin
		$readmemh(OUT_PORT_FLOW_0_FILE, out_port_flow_0_file_data);
		$readmemh(OUT_PORT_FLOW_1_FILE, out_port_flow_1_file_data);
		$readmemh(OUT_PORT_FLOW_2_FILE, out_port_flow_2_file_data);
		$readmemh(OUT_PORT_FLOW_3_FILE, out_port_flow_3_file_data);
		end
			
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
		in_pel_0.din = 0; in_pel_0.write  = 1'b0;
		in_pel_1.din = 0; in_pel_1.write  = 1'b0;
		in_pel_2.din = 0; in_pel_2.write  = 1'b0;
		in_pel_3.din = 0; in_pel_3.write  = 1'b0;
		in_pel_4.din = 0; in_pel_4.write  = 1'b0;
		in_pel_5.din = 0; in_pel_5.write  = 1'b0;
		in_pel_6.din = 0; in_pel_6.write  = 1'b0;
		in_pel_7.din = 0; in_pel_7.write  = 1'b0;
		h_alpha.din = 0;
		h_alpha.write  = 1'b0; 
		ext_size.din = 0;
		ext_size.write  = 1'b0;
		v_alpha.din = 0;
		v_alpha.write  = 1'b0;
		out_pel_0.full = 4'b0;
		out_pel_1.full = 4'b0;
		out_pel_2.full = 4'b0;
		out_pel_3.full = 4'b0;
		out_pel_4.full = 4'b0;
		out_pel_5.full = 4'b0;
		out_pel_6.full = 4'b0;
		out_pel_7.full = 4'b0;
	
		// initial rst
		rst = 0;
		#2
		rst = 1;
		#100
		rst = 0;
		#100
		
		// setup flow_0
		v_alpha_val = V_ALPHA_0;
		v_alpha.din = {2'd0,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA_0;
		h_alpha.din = {2'd0,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE_0 + TAP;
		ext_size.din = {2'd0,ext_size_val};
		ext_size.write = 1;
		t_req[0] = $time;
		t_req[1] = $time;
		t_req[2] = $time;
		t_req[3] = $time;
		t_start[0] = $time;
		
		#(clk_PERIOD)
		// setup flow_1
		v_alpha_val = V_ALPHA_1;
		v_alpha.din = {2'd1,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA_1;
		h_alpha.din = {2'd1,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE_1 + TAP;
		ext_size.din = {2'd1,ext_size_val};
		ext_size.write = 1;
		t_start[1] = $time;
		
		#(clk_PERIOD)
		// setup flow_2
		v_alpha_val = V_ALPHA_2;
		v_alpha.din = {2'd2,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA_2;
		h_alpha.din = {2'd2,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE_2 + TAP;
		ext_size.din = {2'd2,ext_size_val};
		ext_size.write = 1;
		t_start[2] = $time;
		
		#(clk_PERIOD)
		// setup flow_3
		v_alpha_val = V_ALPHA_3;
		v_alpha.din = {2'd3,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA_3;
		h_alpha.din = {2'd3,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE_3 + TAP;
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
		while((in_port_i_0 < IN_PORT_FLOW_0_SIZE) || (in_port_i_1 < IN_PORT_FLOW_1_SIZE) || (in_port_i_2 < IN_PORT_FLOW_2_SIZE) || (in_port_i_3 < IN_PORT_FLOW_3_SIZE))
		begin
			#(clk_PERIOD)
				case(select_flow)
		0:	if(!in_pel_0.full[0] & !in_pel_1.full[0] & !in_pel_1.full[0] & !in_pel_3.full[0] &
				!in_pel_4.full[0] & !in_pel_5.full[0] & !in_pel_6.full[0] & !in_pel_7.full[0])
				begin
				in_pel_0.din = {2'd0,in_port_flow_0_file_data[in_port_i_0 + 0]};
				in_pel_0.write  = 1'b1;
				in_pel_1.din = {2'd0,in_port_flow_0_file_data[in_port_i_0 + 1]};
				in_pel_1.write  = 1'b1;
				in_pel_2.din = {2'd0,in_port_flow_0_file_data[in_port_i_0 + 2]};
				in_pel_2.write  = 1'b1;
				in_pel_3.din = {2'd0,in_port_flow_0_file_data[in_port_i_0 + 3]};
				in_pel_3.write  = 1'b1;
				in_pel_4.din = {2'd0,in_port_flow_0_file_data[in_port_i_0 + 4]};
				in_pel_4.write  = 1'b1;
				in_pel_5.din = {2'd0,in_port_flow_0_file_data[in_port_i_0 + 5]};
				in_pel_5.write  = 1'b1;
				in_pel_6.din = {2'd0,in_port_flow_0_file_data[in_port_i_0 + 6]};
				in_pel_6.write  = 1'b1;
				in_pel_7.din = {2'd0,in_port_flow_0_file_data[in_port_i_0 + 7]};
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
				in_pel_0.din = {2'd1,in_port_flow_1_file_data[in_port_i_1 + 0]};
				in_pel_0.write  = 1'b1;
				in_pel_1.din = {2'd1,in_port_flow_1_file_data[in_port_i_1 + 1]};
				in_pel_1.write  = 1'b1;
				in_pel_2.din = {2'd1,in_port_flow_1_file_data[in_port_i_1 + 2]};
				in_pel_2.write  = 1'b1;
				in_pel_3.din = {2'd1,in_port_flow_1_file_data[in_port_i_1 + 3]};
				in_pel_3.write  = 1'b1;
				in_pel_4.din = {2'd1,in_port_flow_1_file_data[in_port_i_1 + 4]};
				in_pel_4.write  = 1'b1;
				in_pel_5.din = {2'd1,in_port_flow_1_file_data[in_port_i_1 + 5]};
				in_pel_5.write  = 1'b1;
				in_pel_6.din = {2'd1,in_port_flow_1_file_data[in_port_i_1 + 6]};
				in_pel_6.write  = 1'b1;
				in_pel_7.din = {2'd1,in_port_flow_1_file_data[in_port_i_1 + 7]};
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
				in_pel_0.din = {2'd2,in_port_flow_2_file_data[in_port_i_2 + 0]};
				in_pel_0.write  = 1'b1;
				in_pel_1.din = {2'd2,in_port_flow_2_file_data[in_port_i_2 + 1]};
				in_pel_1.write  = 1'b1;
				in_pel_2.din = {2'd2,in_port_flow_2_file_data[in_port_i_2 + 2]};
				in_pel_2.write  = 1'b1;
				in_pel_3.din = {2'd2,in_port_flow_2_file_data[in_port_i_2 + 3]};
				in_pel_3.write  = 1'b1;
				in_pel_4.din = {2'd2,in_port_flow_2_file_data[in_port_i_2 + 4]};
				in_pel_4.write  = 1'b1;
				in_pel_5.din = {2'd2,in_port_flow_2_file_data[in_port_i_2 + 5]};
				in_pel_5.write  = 1'b1;
				in_pel_6.din = {2'd2,in_port_flow_2_file_data[in_port_i_2 + 6]};
				in_pel_6.write  = 1'b1;
				in_pel_7.din = {2'd2,in_port_flow_2_file_data[in_port_i_2 + 7]};
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
				in_pel_0.din = {2'd3,in_port_flow_3_file_data[in_port_i_3 + 0]};
				in_pel_0.write  = 1'b1;
				in_pel_1.din = {2'd3,in_port_flow_3_file_data[in_port_i_3 + 1]};
				in_pel_1.write  = 1'b1;
				in_pel_2.din = {2'd3,in_port_flow_3_file_data[in_port_i_3 + 2]};
				in_pel_2.write  = 1'b1;
				in_pel_3.din = {2'd3,in_port_flow_3_file_data[in_port_i_3 + 3]};
				in_pel_3.write  = 1'b1;
				in_pel_4.din = {2'd3,in_port_flow_3_file_data[in_port_i_3 + 4]};
				in_pel_4.write  = 1'b1;
				in_pel_5.din = {2'd3,in_port_flow_3_file_data[in_port_i_3 + 5]};
				in_pel_5.write  = 1'b1;
				in_pel_6.din = {2'd3,in_port_flow_3_file_data[in_port_i_3 + 6]};
				in_pel_6.write  = 1'b1;
				in_pel_7.din = {2'd3,in_port_flow_3_file_data[in_port_i_3 + 7]};
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
		while((out_port0_i_0 < OUT_PORT_FLOW_0_SIZE) || (out_port0_i_1 < OUT_PORT_FLOW_1_SIZE)  || (out_port0_i_2 < OUT_PORT_FLOW_2_SIZE) || (out_port0_i_3 < OUT_PORT_FLOW_3_SIZE))
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
		if(cnt_elements < BLOCK_SIZE[select_flow])
			cnt_elements = cnt_elements + N_CHANNELS;
		else
			begin // each time a block is written it changes flow 
			cnt_elements = 0; 
			case(select_flow)
			0: if(in_port_i_1 < IN_PORT_FLOW_1_SIZE)	// unless the other flow has completed
				 select_flow = 1;
				else if(in_port_i_2 < IN_PORT_FLOW_2_SIZE)
					  select_flow = 2;
					 else if(in_port_i_3 < IN_PORT_FLOW_3_SIZE)
					  select_flow = 3;
			1: if(in_port_i_2 < IN_PORT_FLOW_2_SIZE)
				 select_flow = 2;
				else if(in_port_i_3 < IN_PORT_FLOW_3_SIZE)
					 select_flow = 3;
					else if(in_port_i_0 < IN_PORT_FLOW_0_SIZE)
					 select_flow = 0;
			2: if(in_port_i_3 < IN_PORT_FLOW_3_SIZE)
				 select_flow = 3;
				else if(in_port_i_0 < IN_PORT_FLOW_0_SIZE)
					 select_flow = 0;
					else if(in_port_i_1 < IN_PORT_FLOW_1_SIZE)	
					 select_flow = 1;
			3: if(in_port_i_0 < IN_PORT_FLOW_0_SIZE)
				 select_flow = 0;
				else if(in_port_i_1 < IN_PORT_FLOW_1_SIZE)	// unless the other flow has completed
				 select_flow = 1;
				else if(in_port_i_2 < IN_PORT_FLOW_2_SIZE)
					  select_flow = 2;
			default: $error("Error on select_flow!");
			endcase
			end
		
// output check
	// ----------------------------------------------------------------------------
	// check out_pel_0 and evaluate times
	always@(posedge clk)
		begin
		if(out_pel_0.write)
			case (out_pel_0.din[9:8])
			0: begin
				if(out_pel_0.din[7:0] != out_port_flow_0_file_data[out_port0_i_0])
				    $error("Error on output %d (channel out_pel_0) of flow %d: obtained %d, expected %d", out_port0_i_0, out_pel_0.din[9:8], out_pel_0.din[7:0], out_port_flow_0_file_data[out_port0_i_0]);
				out_port0_i_0 = out_port0_i_0 + N_CHANNELS;
				if(out_port0_i_0 == N_CHANNELS)
					t_first[0] = $time;
				if(out_port0_i_0 == OUT_PORT_FLOW_0_SIZE)
					t_end[0]= $time;
			   end
			1: begin
				if(out_pel_0.din[7:0] != out_port_flow_1_file_data[out_port0_i_1])
					$error("Error on output %d (channel out_pel_0) of flow %d: obtained %d, expected %d", out_port0_i_1, out_pel_0.din[9:8], out_pel_0.din[7:0], out_port_flow_1_file_data[out_port0_i_1]);
				out_port0_i_1 = out_port0_i_1 + N_CHANNELS;
				if(out_port0_i_1 == N_CHANNELS)
					t_first[1] = $time;
				if(out_port0_i_1 == OUT_PORT_FLOW_1_SIZE)
					t_end[1] = $time;
			   end
			2: begin
				if(out_pel_0.din[7:0] != out_port_flow_2_file_data[out_port0_i_2])
					$error("Error on output %d (channel out_pel_0) of flow %d: obtained %d, expected %d", out_port0_i_2, out_pel_0.din[9:8], out_pel_0.din[7:0], out_port_flow_2_file_data[out_port0_i_2]);
				out_port0_i_2 = out_port0_i_2 + N_CHANNELS;
				if(out_port0_i_2 == N_CHANNELS)
					t_first[2] = $time;
				if(out_port0_i_2 == OUT_PORT_FLOW_2_SIZE)
					t_end[2] = $time;
			   end
			3: begin
				if(out_pel_0.din[7:0] != out_port_flow_3_file_data[out_port0_i_3])
					$error("Error on output %d (channel out_pel_0) of flow %d: obtained %d, expected %d", out_port0_i_3, out_pel_0.din[9:8], out_pel_0.din[7:0], out_port_flow_3_file_data[out_port0_i_3]);
				out_port0_i_3 = out_port0_i_3 + N_CHANNELS;
				if(out_port0_i_3 == N_CHANNELS)
					t_first[3] = $time;
				if(out_port0_i_3 == OUT_PORT_FLOW_3_SIZE)
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
				if(out_pel_1.din[7:0] != out_port_flow_0_file_data[out_port1_i_0])
				    $error("Error on output %d (channel out_pel_1) of flow %d: obtained %d, expected %d", out_port1_i_0, out_pel_1.din[9:8], out_pel_1.din[7:0], out_port_flow_0_file_data[out_port1_i_0]);
				out_port1_i_0 = out_port1_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_1.din[7:0] != out_port_flow_1_file_data[out_port1_i_1])
					$error("Error on output %d (channel out_pel_1) of flow %d: obtained %d, expected %d", out_port1_i_1, out_pel_1.din[9:8], out_pel_1.din[7:0], out_port_flow_1_file_data[out_port1_i_1]);
				out_port1_i_1 = out_port1_i_1 + N_CHANNELS;
			   end
			2: begin
				if(out_pel_1.din[7:0] != out_port_flow_2_file_data[out_port1_i_2])
					$error("Error on output %d (channel out_pel_1) of flow %d: obtained %d, expected %d", out_port1_i_2, out_pel_1.din[9:8], out_pel_1.din[7:0], out_port_flow_2_file_data[out_port1_i_2]);
				out_port1_i_2 = out_port1_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_1.din[7:0] != out_port_flow_3_file_data[out_port1_i_3])
					$error("Error on output %d (channel out_pel_1) of flow %d: obtained %d, expected %d", out_port1_i_3, out_pel_1.din[9:8], out_pel_1.din[7:0], out_port_flow_3_file_data[out_port1_i_3]);
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
				if(out_pel_2.din[7:0] != out_port_flow_0_file_data[out_port2_i_0])
				    $error("Error on output %d (channel out_pel_2) of flow %d: obtained %d, expected %d", out_port2_i_0, out_pel_2.din[9:8], out_pel_2.din[7:0], out_port_flow_0_file_data[out_port2_i_0]);
				out_port2_i_0 = out_port2_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_2.din[7:0] != out_port_flow_1_file_data[out_port2_i_1])
					$error("Error on output %d (channel out_pel_2) of flow %d: obtained %d, expected %d", out_port2_i_1, out_pel_2.din[9:8], out_pel_2.din[7:0], out_port_flow_1_file_data[out_port2_i_1]);
				out_port2_i_1 = out_port2_i_1 + N_CHANNELS;
			   end
			 2: begin
				if(out_pel_2.din[7:0] != out_port_flow_2_file_data[out_port2_i_2])
					$error("Error on output %d (channel out_pel_2) of flow %d: obtained %d, expected %d", out_port2_i_2, out_pel_2.din[9:8], out_pel_2.din[7:0], out_port_flow_2_file_data[out_port2_i_2]);
				out_port2_i_2 = out_port2_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_2.din[7:0] != out_port_flow_3_file_data[out_port2_i_3])
					$error("Error on output %d (channel out_pel_2) of flow %d: obtained %d, expected %d", out_port2_i_3, out_pel_2.din[9:8], out_pel_2.din[7:0], out_port_flow_3_file_data[out_port2_i_3]);
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
				if(out_pel_3.din[7:0] != out_port_flow_0_file_data[out_port3_i_0])
				    $error("Error on output %d (channel out_pel_3) of flow %d: obtained %d, expected %d", out_port3_i_0, out_pel_3.din[9:8], out_pel_3.din[7:0], out_port_flow_0_file_data[out_port3_i_0]);
				out_port3_i_0 = out_port3_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_3.din[7:0] != out_port_flow_1_file_data[out_port3_i_1])
					$error("Error on output %d (channel out_pel_3) of flow %d: obtained %d, expected %d", out_port3_i_1, out_pel_3.din[9:8], out_pel_3.din[7:0], out_port_flow_1_file_data[out_port3_i_1]);
				out_port3_i_1 = out_port3_i_1 + N_CHANNELS;
			   end
			 2: begin
				if(out_pel_3.din[7:0] != out_port_flow_2_file_data[out_port3_i_2])
					$error("Error on output %d (channel out_pel_3) of flow %d: obtained %d, expected %d", out_port3_i_2, out_pel_3.din[9:8], out_pel_3.din[7:0], out_port_flow_2_file_data[out_port3_i_2]);
				out_port3_i_2 = out_port3_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_3.din[7:0] != out_port_flow_3_file_data[out_port3_i_3])
					$error("Error on output %d (channel out_pel_3) of flow %d: obtained %d, expected %d", out_port3_i_3, out_pel_3.din[9:8], out_pel_3.din[7:0], out_port_flow_3_file_data[out_port3_i_3]);
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
				if(out_pel_4.din[7:0] != out_port_flow_0_file_data[out_port4_i_0])
				    $error("Error on output %d (channel out_pel_4) of flow %d: obtained %d, expected %d", out_port4_i_0, out_pel_4.din[9:8], out_pel_4.din[7:0], out_port_flow_0_file_data[out_port4_i_0]);
				out_port4_i_0 = out_port4_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_4.din[7:0] != out_port_flow_1_file_data[out_port4_i_1])
					$error("Error on output %d (channel out_pel_4) of flow %d: obtained %d, expected %d", out_port4_i_1, out_pel_4.din[9:8], out_pel_4.din[7:0], out_port_flow_1_file_data[out_port4_i_1]);
				out_port4_i_1 = out_port4_i_1 + N_CHANNELS;
			   end
			 2: begin
				if(out_pel_4.din[7:0] != out_port_flow_2_file_data[out_port4_i_2])
					$error("Error on output %d (channel out_pel_4) of flow %d: obtained %d, expected %d", out_port4_i_2, out_pel_4.din[9:8], out_pel_4.din[7:0], out_port_flow_2_file_data[out_port4_i_2]);
				out_port4_i_2 = out_port4_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_4.din[7:0] != out_port_flow_3_file_data[out_port4_i_3])
					$error("Error on output %d (channel out_pel_4) of flow %d: obtained %d, expected %d", out_port4_i_3, out_pel_4.din[9:8], out_pel_4.din[7:0], out_port_flow_3_file_data[out_port4_i_3]);
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
				if(out_pel_5.din[7:0] != out_port_flow_0_file_data[out_port5_i_0])
				    $error("Error on output %d (channel out_pel_5) of flow %d: obtained %d, expected %d", out_port5_i_0, out_pel_5.din[9:8], out_pel_5.din[7:0], out_port_flow_0_file_data[out_port5_i_0]);
				out_port5_i_0 = out_port5_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_5.din[7:0] != out_port_flow_1_file_data[out_port5_i_1])
					$error("Error on output %d (channel out_pel_5) of flow %d: obtained %d, expected %d", out_port5_i_1, out_pel_5.din[9:8], out_pel_5.din[7:0], out_port_flow_1_file_data[out_port5_i_1]);
				out_port5_i_1 = out_port5_i_1 + N_CHANNELS;
			   end
			 2: begin
				if(out_pel_5.din[7:0] != out_port_flow_2_file_data[out_port5_i_2])
					$error("Error on output %d (channel out_pel_5) of flow %d: obtained %d, expected %d", out_port5_i_2, out_pel_5.din[9:8], out_pel_5.din[7:0], out_port_flow_2_file_data[out_port5_i_2]);
				out_port5_i_2 = out_port5_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_5.din[7:0] != out_port_flow_3_file_data[out_port5_i_3])
					$error("Error on output %d (channel out_pel_5) of flow %d: obtained %d, expected %d", out_port5_i_3, out_pel_5.din[9:8], out_pel_5.din[7:0], out_port_flow_3_file_data[out_port5_i_3]);
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
				if(out_pel_6.din[7:0] != out_port_flow_0_file_data[out_port6_i_0])
				    $error("Error on output %d (channel out_pel_6) of flow %d: obtained %d, expected %d", out_port6_i_0, out_pel_6.din[9:8], out_pel_6.din[7:0], out_port_flow_0_file_data[out_port6_i_0]);
				out_port6_i_0 = out_port6_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_6.din[7:0] != out_port_flow_1_file_data[out_port6_i_1])
					$error("Error on output %d (channel out_pel_6) of flow %d: obtained %d, expected %d", out_port6_i_1, out_pel_6.din[9:8], out_pel_6.din[7:0], out_port_flow_1_file_data[out_port6_i_1]);
				out_port6_i_1 = out_port6_i_1 + N_CHANNELS;
			   end
			 2: begin
				if(out_pel_6.din[7:0] != out_port_flow_2_file_data[out_port6_i_2])
					$error("Error on output %d (channel out_pel_6) of flow %d: obtained %d, expected %d", out_port6_i_2, out_pel_6.din[9:8], out_pel_6.din[7:0], out_port_flow_2_file_data[out_port6_i_2]);
				out_port6_i_2 = out_port6_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_6.din[7:0] != out_port_flow_3_file_data[out_port6_i_3])
					$error("Error on output %d (channel out_pel_6) of flow %d: obtained %d, expected %d", out_port6_i_3, out_pel_6.din[9:8], out_pel_6.din[7:0], out_port_flow_3_file_data[out_port6_i_3]);
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
				if(out_pel_7.din[7:0] != out_port_flow_0_file_data[out_port7_i_0])
				    $error("Error on output %d (channel out_pel_7) of flow %d: obtained %d, expected %d", out_port7_i_0, out_pel_7.din[9:8], out_pel_7.din[7:0], out_port_flow_0_file_data[out_port7_i_0]);
				out_port7_i_0 = out_port7_i_0 + N_CHANNELS;
			   end
			1: begin
				if(out_pel_7.din[7:0] != out_port_flow_1_file_data[out_port7_i_1])
					$error("Error on output %d (channel out_pel_7) of flow %d: obtained %d, expected %d", out_port7_i_1, out_pel_7.din[9:8], out_pel_7.din[7:0], out_port_flow_1_file_data[out_port7_i_1]);
				out_port7_i_1 = out_port7_i_1 + N_CHANNELS;
			   end
			 2: begin
				if(out_pel_7.din[7:0] != out_port_flow_2_file_data[out_port7_i_2])
					$error("Error on output %d (channel out_pel_7) of flow %d: obtained %d, expected %d", out_port7_i_2, out_pel_7.din[9:8], out_pel_7.din[7:0], out_port_flow_2_file_data[out_port7_i_2]);
				out_port7_i_2 = out_port7_i_2 + N_CHANNELS;
			   end
			3: begin
				if(out_pel_7.din[7:0] != out_port_flow_3_file_data[out_port7_i_3])
					$error("Error on output %d (channel out_pel_7) of flow %d: obtained %d, expected %d", out_port7_i_3, out_pel_7.din[9:8], out_pel_7.din[7:0], out_port_flow_3_file_data[out_port7_i_3]);
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
		