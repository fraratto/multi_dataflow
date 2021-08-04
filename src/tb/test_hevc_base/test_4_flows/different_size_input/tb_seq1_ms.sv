`timescale 1 ns / 1 ps


module tb_seq1;

	// test bench parameters
	// ----------------------------------------------------------------------------
	parameter clk_PERIOD = 10;
	
	parameter TAP = 8;
    parameter SIZE_3 = 8;    // 4, 8, 16, 32, 64
	parameter V_ALPHA_3 = 2;  // 0, 2, 4, 6
	parameter H_ALPHA_3 = 0;  // 0, 2, 4, 6
    parameter SIZE_2 = 16;    // 4, 8, 16, 32, 64
	parameter V_ALPHA_2 = 2;  // 0, 2, 4, 6
	parameter H_ALPHA_2 = 2;  // 0, 2, 4, 6
    parameter SIZE_1 = 32;    // 4, 8, 16, 32, 64
	parameter V_ALPHA_1 = 6;  // 0, 2, 4, 6
	parameter H_ALPHA_1 = 4;  // 0, 2, 4, 6
    parameter SIZE_0 = 64;    // 4, 8, 16, 32, 64
	parameter V_ALPHA_0 = 2;  // 0, 2, 4, 6
	parameter H_ALPHA_0 = 2;  // 0, 2, 4, 6
	
	parameter IN_PORT_FLOW_0_FILE = "input_64x64.mem";
	parameter IN_PORT_FLOW_0_SIZE = (SIZE_0 + TAP-1)*(SIZE_0 + TAP-1);
	parameter IN_PORT_FLOW_1_FILE = "input_32x32.mem";
	parameter IN_PORT_FLOW_1_SIZE = (SIZE_1 + TAP-1)*(SIZE_1 + TAP-1);
	parameter IN_PORT_FLOW_2_FILE = "input_16x16.mem";
	parameter IN_PORT_FLOW_2_SIZE = (SIZE_2 + TAP-1)*(SIZE_2 + TAP-1);
	parameter IN_PORT_FLOW_3_FILE = "input_8x8.mem";
	parameter IN_PORT_FLOW_3_SIZE = (SIZE_3 + TAP-1)*(SIZE_3 + TAP-1);
	
	parameter FLUX = 4;
    parameter DEPTH = 16;
    
	parameter OUT_PORT_FLOW_0_FILE = "output_64x64_v2_h2.mem";
	parameter OUT_PORT_FLOW_0_SIZE = SIZE_0*SIZE_0;
	parameter OUT_PORT_FLOW_1_FILE = "output_32x32_v6_h4.mem";
	parameter OUT_PORT_FLOW_1_SIZE = SIZE_1*SIZE_1;
	parameter OUT_PORT_FLOW_2_FILE = "output_16x16_v2_h2.mem";
	parameter OUT_PORT_FLOW_2_SIZE = SIZE_2*SIZE_2;
	parameter OUT_PORT_FLOW_3_FILE = "output_8x8_v2_h0.mem";
	parameter OUT_PORT_FLOW_3_SIZE = SIZE_3*SIZE_3;
	
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
	integer out_port_i_0 = 0;
	integer out_port_i_1 = 0;
	integer out_port_i_2 = 0;
	integer out_port_i_3 = 0;
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
				 
		// setup flow_0
		v_alpha_val = V_ALPHA_0;
		v_alpha.din = {2'd0,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA_0;
		h_alpha.din = {2'd0,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE_0 + TAP-1;
		ext_size.din = {2'd0,ext_size_val};
		ext_size.write = 1;
		t_req[0] = $time;
		t_start[0] = $time;
		
		#(clk_PERIOD)
		v_alpha.din = 0;
		v_alpha.write = 0;
		h_alpha.din = 0;
		h_alpha.write = 0;
		ext_size.din = 0;
		ext_size.write = 0;
		
		// feed flow_0
		while(in_port_i_0 < IN_PORT_FLOW_0_SIZE)	
			begin
			#(clk_PERIOD)
			if(!in_pel.full[0])
				begin
				in_pel.din = {2'd0,in_port_flow_0_file_data[in_port_i_0]};
				in_pel.write  = 1'b1;
				in_port_i_0 = in_port_i_0 + 1;
				end	
			else
				begin
				in_pel.din = 0;
				in_pel.write  = 1'b0;
				end
			end
		#(clk_PERIOD)
		in_pel.din = 0;
		in_pel.write  = 1'b0;
			
		// wait flow_0 end
		while(out_port_i_0 < OUT_PORT_FLOW_0_SIZE)
			#(clk_PERIOD);				
		
		#(clk_PERIOD)
		// setup flow_1
		v_alpha_val = V_ALPHA_1;
		v_alpha.din = {2'd1,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA_1;
		h_alpha.din = {2'd1,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE_1 + TAP-1;
		ext_size.din = {2'd1,ext_size_val};
		ext_size.write = 1;
		t_req[1] = $time;
		t_start[1] = $time;
		
		#(clk_PERIOD)
		v_alpha.din = 0;
		v_alpha.write = 0;
		h_alpha.din = 0;
		h_alpha.write = 0;
		ext_size.din = 0;
		ext_size.write = 0;
			
		
		// feed flow_1
		while(in_port_i_1 < IN_PORT_FLOW_1_SIZE)	
			begin
			#(clk_PERIOD)
			if(!in_pel.full[1])
				begin
				in_pel.din = {2'd1,in_port_flow_1_file_data[in_port_i_1]};
				in_pel.write  = 1'b1;
				in_port_i_1 = in_port_i_1 + 1;
				end	
			else
				begin
				in_pel.din = 0;
				in_pel.write  = 1'b0;
				end
			end
		#(clk_PERIOD)
		in_pel.din = 0;
		in_pel.write  = 1'b0;
			
		// wait flow_1 end
		while(out_port_i_1 < OUT_PORT_FLOW_1_SIZE)
			#(clk_PERIOD);

		// setup flow_2
		v_alpha_val = V_ALPHA_2;
		v_alpha.din = {2'd2,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA_2;
		h_alpha.din = {2'd2,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE_2 + TAP-1;
		ext_size.din = {2'd2,ext_size_val};
		ext_size.write = 1;
		t_req[2] = $time;
		t_start[2] = $time;
		
		#(clk_PERIOD)
		v_alpha.din = 0;
		v_alpha.write = 0;
		h_alpha.din = 0;
		h_alpha.write = 0;
		ext_size.din = 0;
		ext_size.write = 0;
		
		// feed flow_2
		while(in_port_i_2 < IN_PORT_FLOW_2_SIZE)	
			begin
			#(clk_PERIOD)
			if(!in_pel.full[2])
				begin
				in_pel.din = {2'd2,in_port_flow_2_file_data[in_port_i_2]};
				in_pel.write  = 1'b1;
				in_port_i_2 = in_port_i_2 + 1;
				end	
			else
				begin
				in_pel.din = 0;
				in_pel.write  = 1'b0;
				end
			end
		#(clk_PERIOD)
		in_pel.din = 0;
		in_pel.write  = 1'b0;
			
		// wait flow_2 end
		while(out_port_i_2 < OUT_PORT_FLOW_2_SIZE)
			#(clk_PERIOD);	

		// setup flow_3
		v_alpha_val = V_ALPHA_3;
		v_alpha.din = {2'd3,v_alpha_val};  
		v_alpha.write = 1;
		h_alpha_val = H_ALPHA_3;
		h_alpha.din = {2'd3,h_alpha_val};
		h_alpha.write = 1;
		ext_size_val = SIZE_3 + TAP-1;
		ext_size.din = {2'd3,ext_size_val};
		ext_size.write = 1;
		t_req[3] = $time;
		t_start[3] = $time;
		
		#(clk_PERIOD)
		v_alpha.din = 0;
		v_alpha.write = 0;
		h_alpha.din = 0;
		h_alpha.write = 0;
		ext_size.din = 0;
		ext_size.write = 0;
		
		// feed flow_3
		while(in_port_i_3 < IN_PORT_FLOW_3_SIZE)	
			begin
			#(clk_PERIOD)
			if(!in_pel.full[3])
				begin
				in_pel.din = {2'd3,in_port_flow_3_file_data[in_port_i_3]};
				in_pel.write  = 1'b1;
				in_port_i_3 = in_port_i_3 + 1;
				end	
			else
				begin
				in_pel.din = 0;
				in_pel.write  = 1'b0;
				end
			end
		#(clk_PERIOD)
		in_pel.din = 0;
		in_pel.write  = 1'b0;
			
		// wait flow_3 end
		while(out_port_i_3 < OUT_PORT_FLOW_3_SIZE)
			#(clk_PERIOD);				
		
		#(clk_PERIOD)
		$display("Flow 3 execution time:\t%f us", (t_end[0]-t_start[0]) / 1000.0);
		$display("Flow 2 execution time:\t%f us", (t_end[1]-t_start[1]) / 1000.0);
		$display("Flow 1 execution time:\t%f us", (t_end[2]-t_start[2]) / 1000.0);
		$display("Flow 0 execution time:\t%f us", (t_end[3]-t_start[3]) / 1000.0);
		$display("Total execution time:\t%f us", (t_end[3]-t_start[0]) / 1000.0);
		
		$display("Flow 3 waiting time:\t%f us", (t_start[0]-t_req[0]) / 1000.0);
		$display("Flow 2 waiting time:\t%f us", (t_start[1]-t_req[1]) / 1000.0);
		$display("Flow 1 waiting time:\t%f us", (t_start[2]-t_req[2]) / 1000.0);
		$display("Flow 0 waiting time:\t%f us", (t_start[3]-t_req[3]) / 1000.0);
		
		$display("Flow 3 response time:\t%f us", (t_first[0]-t_req[0]) / 1000.0);
		$display("Flow 2 response time:\t%f us", (t_first[1]-t_req[1]) / 1000.0);
		$display("Flow 1 response time:\t%f us", (t_first[2]-t_req[2]) / 1000.0);
		$display("Flow 0 response time:\t%f us", (t_first[3]-t_req[3]) / 1000.0);
		
		$stop;
		end
	// ----------------------------------------------------------------------------
	
	// output check
	// ----------------------------------------------------------------------------
	always@(posedge clk)
		begin
		if(out_pel.write)
			case (out_pel.din[9:8])
			0: begin
				if(out_pel.din[7:0] != out_port_flow_0_file_data[out_port_i_0])
				    $error("Error on output %d of flow %d: obtained %d, expected %d", out_port_i_0, out_pel.din[9:8], out_pel.din[7:0], out_port_flow_0_file_data[out_port_i_0]);
				out_port_i_0 = out_port_i_0 + 1;
				if(out_port_i_0 == 1)
					t_first[0] = $time;
				if(out_port_i_0 == OUT_PORT_FLOW_0_SIZE)
					t_end[0]= $time;
			   end
			1: begin
				if(out_pel.din[7:0] != out_port_flow_1_file_data[out_port_i_1])
					$error("Error on output %d of flow %d: obtained %d, expected %d", out_port_i_1, out_pel.din[9:8], out_pel.din[7:0], out_port_flow_1_file_data[out_port_i_1]);
				out_port_i_1 = out_port_i_1 + 1;
				if(out_port_i_1 == 1)
					t_first[1] = $time;
				if(out_port_i_1 == OUT_PORT_FLOW_1_SIZE)
					t_end[1] = $time;
			   end
			2: begin
				if(out_pel.din[7:0] != out_port_flow_2_file_data[out_port_i_2])
					$error("Error on output %d of flow %d: obtained %d, expected %d", out_port_i_2, out_pel.din[9:8], out_pel.din[7:0], out_port_flow_2_file_data[out_port_i_2]);
				out_port_i_2 = out_port_i_2 + 1;
				if(out_port_i_2 == 1)
					t_first[2] = $time;
				if(out_port_i_2 == OUT_PORT_FLOW_2_SIZE)
					t_end[2] = $time;
			   end
			3: begin
				if(out_pel.din[7:0] != out_port_flow_3_file_data[out_port_i_3])
					$error("Error on output %d of flow %d: obtained %d, expected %d", out_port_i_3, out_pel.din[9:8], out_pel.din[7:0], out_port_flow_3_file_data[out_port_i_3]);
				out_port_i_3 = out_port_i_3 + 1;
				if(out_port_i_3 == 1)
					t_first[3] = $time;
				if(out_port_i_3 == OUT_PORT_FLOW_3_SIZE)
					t_end[3] = $time;
			   end
			 default: 
				begin 
				$error("Unexpected output tag"); 
				$stop; 
				end
			 endcase
		end		
		
endmodule		
