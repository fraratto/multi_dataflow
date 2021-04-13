`timescale 1ns / 1ps

`ifndef FIFO_INTERFACE
`define FIFO_INTERFACE

	interface read_interface #(DATA_WIDTH = 8, FLUX = 2, PORTS = 2)
							(input clk);
        parameter WIDTH = DATA_WIDTH+$clog2(FLUX); 							
		logic [(WIDTH*PORTS)-1 : 0] dout;
		logic [(FLUX*PORTS)-1:0] read;
		logic [(FLUX*PORTS)-1:0] empty;
		
		modport fifo(input read, output dout, empty);
		modport actor(output read, input dout, empty);
		
		// This clocking block and the associated modport shall be used when testing a fifo
		clocking cb_fifo @(posedge clk);
			default input #1ns output #1ns;
			output read; 
			input dout, empty;
		endclocking 
		
		modport tb_fifo(input clk, clocking cb_fifo);
		
		// This clocking block and the associated modport shall be used when testing an actor
		clocking cb_actor @(posedge clk);
			default input #1ns output #1ns;
			input read; 
			output dout, empty;
		endclocking 
		
		modport tb_actor(input clk, clocking cb_actor);
		
		
	endinterface : read_interface



	interface write_interface #(DATA_WIDTH = 8, FLUX = 2, PORTS = 2)
							(input clk);
        parameter WIDTH = DATA_WIDTH+$clog2(FLUX); 
		logic [(WIDTH*PORTS)-1 : 0] din;
		logic write;
		logic [(FLUX*PORTS)-1:0] full;
		
		modport fifo(input din, write, output full);
		modport actor(output din, write, input full);
		
		
		// This clocking block and the associated modport shall be used when testing a fifo
		clocking cb_fifo @(posedge clk);
			default input #1ns output #1ns;
			output din, write;
			input full;
		endclocking 
		
		modport tb_fifo(input clk, clocking cb_fifo);
		

	endinterface : write_interface

`endif	