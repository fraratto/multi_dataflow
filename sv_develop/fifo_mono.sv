`timescale 1ns / 1ps
`include "fifo_interface.sv"
`include "ram_interface.sv"

module fifo_mono #(
	WIDTH = 8,
	DEPTH = 4
	)(
	input clk,
	input rst,
	write_interface.fifo write_port,
	read_interface.fifo read_port
	);
    
	logic [$clog2(DEPTH)-1:0] Wp;		// write pointer
	logic [$clog2(DEPTH)-1:0] Rp;		// read pointer
	logic WnR;			                // last operation
	    
	// ram interface instantiation and connection
	ram_interface mem_port(clk);
    assign mem_port.din = write_port.din;
    assign mem_port.write_address = Wp;
    assign mem_port.read_address = Rp;
    assign mem_port.write_en = write_port.write;
    assign read_port.dout = mem_port.dout;
    
	ram_dual_ported #(
		.DEPTH(DEPTH),
		.WIDTH(WIDTH)
		) mem (
		.port(mem_port.slave)
		);
	
	// write pointer update
	always_ff @(posedge clk)
		if(rst)
			Wp <= 0;
		else
			if(write_port.write)  
				Wp = Wp + 1;
	
	// read pointer update  	
	always_ff @(posedge clk)
		if(rst)
			Rp <= 0;
		else
			if(read_port.read)   
				Rp <= Rp + 1;
				
	// last operation update
	always_ff @(posedge clk)
		if(rst)
			WnR <= 0;
		else 
			if(write_port.write && !read_port.read) 
				WnR <= 1;
			else if(!write_port.write && read_port.read) 
					WnR <= 0;
	
	// empty evaluation
	assign read_port.empty = ((Wp == Rp) && !WnR) ? 1 : 0;
			
	// full evaluation
	assign write_port.full = ((Wp == Rp) && WnR) ? 1 : 0;
	
endmodule


