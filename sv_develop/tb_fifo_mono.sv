`timescale 1ns / 1ps
`include "fifo_interface.sv"


module test_fifo_mono (
	input clk,
	output logic rst,
	write_interface.tb_fifo write_port,
	read_interface.tb_fifo read_port
	);
	
	default clocking cb @(posedge clk);
	   output rst;
	endclocking
	
	initial
        begin
        $display("\nTesting of fifo_mono\n");
        cb.rst <= 1;
        write_port.cb_fifo.write <= 0;
        read_port.cb_fifo.read <= 0;
        
        ##2
        $display("Testing status after reset");
        cb.rst <= 0;
        
        ##1
        write_port.cb_fifo.write <= 1;
        write_port.cb_fifo.din <= 1;
        assert (read_port.cb_fifo.empty) else  $error("Test empty assertion after reset failed");
        assert (!write_port.cb_fifo.full)  else $error(" Test full deassertion after reset failed");
        $display("Testing empty after first write");
        
        ##1
        write_port.cb_fifo.write <= 0;
        
        ##1
        write_port.cb_fifo.write <= 1;
        write_port.cb_fifo.din <= 2;
        assert (!read_port.cb_fifo.empty) else  $error("Test empty deassertion after first write failed");
        $display("Testing full after complete filling");
        
        ##1
        write_port.cb_fifo.write <= 1;
        write_port.cb_fifo.din <= 3;
        
        ##1
        write_port.cb_fifo.write <= 1;
        write_port.cb_fifo.din <= 4;
        
        ##1
        write_port.cb_fifo.write <= 0;
        write_port.cb_fifo.din <= 0;   
        
        ##1
        read_port.cb_fifo.read <= 1;
        assert (write_port.cb_fifo.full) else  $error("Test full assertion after complete filling failed");    
        $display("Testing data correctness");
        
        ##1
        assert (read_port.cb_fifo.dout == 1) else $error("Test first data correctness failed");
        $display("Testing full after first read");
        
        ##1
        assert (!write_port.cb_fifo.full) else $error("Test full deassertion after first read failed");
        assert (read_port.cb_fifo.dout == 2) else $error("Test second data correctness failed");
        
        ##1
        assert (read_port.cb_fifo.dout == 3) else $error("Test third data correctness failed");
        
        ##1
        read_port.cb_fifo.read <= 0;
        assert (read_port.cb_fifo.dout == 4) else $error("Test fourth data correctness failed");
        
        ##1
        write_port.cb_fifo.write <= 1;
        write_port.cb_fifo.din <= 5;
        assert (read_port.cb_fifo.empty) else $error("Test empty assertion after complete emptying failed");
        $display("Testing simultaneous read/write");
        
        ##1
        write_port.cb_fifo.write <= 1;
        write_port.cb_fifo.din <= 6;
        read_port.cb_fifo.read <= 1;    
        
        ##1
        write_port.cb_fifo.write <= 0;
        write_port.cb_fifo.din <= 0;
        read_port.cb_fifo.read <= 1;
        assert (read_port.cb_fifo.dout == 5) else $error("Test data correctness during simultaneous read/write");
        assert (!read_port.cb_fifo.empty) else $error("Test empty during simultaneous read/write");
        
        ##1
        read_port.cb_fifo.read <= 0;
        assert (read_port.cb_fifo.dout == 6) else $error("Test second data correctness after simultaneous read/write");
        assert (!write_port.cb_fifo.full) else $error("Test full during simultaneous read/write");
        
        ##1
        assert (read_port.cb_fifo.empty) else $error("Test empty assertion after simultaneous read/write");
        
        ##1
        $display("\nTesting of fifo_mono finished");

        $stop;
    end

endmodule		
		



module tb_step_2;

    parameter CLK_PERIOD = 10;
    parameter WIDTH = 8;
    parameter DEPTH = 4;

	logic clk = 1;
	logic rst;
	
	always #(CLK_PERIOD/2) clk = !clk;
	
	write_interface #(WIDTH) write_port(.*);
	read_interface #(WIDTH) read_port(.*);
	fifo_mono #(WIDTH, DEPTH) dut (.*);
	test_fifo_mono main(.*);
	
endmodule
	

	