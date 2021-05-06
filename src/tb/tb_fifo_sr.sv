`timescale 1ns / 1ps
`include "../fifo/fifo_interface.sv"

module test_fifo_sr (
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
        $display("\nTesting fifo_sr\n");
		
		/* Test con singolo flusso */
		$display("\nTesting of fifo_sr on a single flow");
        cb.rst <= 1;
        write_port.cb_fifo.write <= 0;
        read_port.cb_fifo.read <= 2'b00;
        
        ##2
        $display("Testing status after reset");
        cb.rst <= 0;
        
        ##1
        write_port.cb_fifo.write <= 1;
        write_port.cb_fifo.din <= 1;
        assert (&read_port.cb_fifo.empty) else  $error("Test empty assertion after reset failed");
        assert (~|write_port.cb_fifo.full)  else $error(" Test full deassertion after reset failed");
        $display("Testing empty after first write");
		
        ##1
        write_port.cb_fifo.write <= 0;		
		
        ##1
        write_port.cb_fifo.write <= 1;
        write_port.cb_fifo.din <= 2;
        assert (!read_port.cb_fifo.empty[0]) else  $error("Test empty deassertion after first write failed");
		assert (read_port.cb_fifo.empty[1]) else  $error("Test empty assertion after first write on other flow failed");
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
        read_port.cb_fifo.read <= 2'b01;
        assert (&write_port.cb_fifo.full) else  $error("Test full assertion after complete filling failed");
        $display("Testing data correctness");		

        ##1
        read_port.cb_fifo.read <= 2'b01;
        assert (read_port.cb_fifo.dout == 1) else $error("Test first data correctness failed");
        $display("Testing full after first read");

        ##1
        read_port.cb_fifo.read <= 2'b00;
        assert (!write_port.cb_fifo.full[0]) else $error("Test full deassertion after first read failed");
        assert (read_port.cb_fifo.dout == 2) else $error("Test second data correctness failed");

        ##1
        read_port.cb_fifo.read <= 2'b01;
		
        ##1
        read_port.cb_fifo.read <= 2'b01;
        assert (read_port.cb_fifo.dout == 3) else $error("Test third data correctness failed");
        
        ##1
        read_port.cb_fifo.read <= 2'b00;
        assert (read_port.cb_fifo.dout == 4) else $error("Test fourth data correctness failed");

        ##1
        write_port.cb_fifo.write <= 1;
        write_port.cb_fifo.din <= 5;
        assert (&read_port.cb_fifo.empty) else $error("Test empty assertion after complete emptying failed");
        $display("Testing simultaneous read/write");	

        ##1
        write_port.cb_fifo.write <= 1;
        write_port.cb_fifo.din <= 6;
        read_port.cb_fifo.read <= 2'b01;    
        
        ##1
        write_port.cb_fifo.write <= 0;
        write_port.cb_fifo.din <= 0;
        read_port.cb_fifo.read <= 2'b01;
        assert (read_port.cb_fifo.dout == 5) else $error("Test data correctness during simultaneous read/write");
        assert (!read_port.cb_fifo.empty[0]) else $error("Test empty during simultaneous read/write");

        ##1
        read_port.cb_fifo.read <= 0;
        assert (read_port.cb_fifo.dout == 6) else $error("Test second data correctness after simultaneous read/write");
        assert (!write_port.cb_fifo.full[0]) else $error("Test full during simultaneous read/write");
        
        ##1
        assert (read_port.cb_fifo.empty[0]) else $error("Test empty assertion after simultaneous read/write");
        
        ##1
        $display("Testing of fifo_sr with single flow finished");
		
		/* Test con due flussi */
		$display("\nTesting fifo_sr with multiple flows");
		cb.rst <= 1;
		
		##2
		cb.rst <= 0;
		
		##1
		write_port.cb_fifo.write <= 1;
		write_port.cb_fifo.din <= (0<<8) + 1;   // tag + payload
		
		##1
		write_port.cb_fifo.din <= (0<<8) + 2;
		
		##1
		write_port.cb_fifo.din <= (1<<8) + 1;
		
		##1
		write_port.cb_fifo.din <= (1<<8) + 2;    
		
		##1
		write_port.cb_fifo.write <= 0; 
		write_port.cb_fifo.din <= 0; 
        read_port.cb_fifo.read <= 2'b10;
        
        ##1
		assert (&write_port.cb_fifo.full) else $error("Test full assertion with multiple flows failed");
        assert (read_port.cb_fifo.dout == ((1<<8) + 1)) else $error("Test data correctness failed");

        ##1
        read_port.cb_fifo.read <= 2'b01;
        assert (read_port.cb_fifo.dout == ((1<<8) + 2)) else $error("Test data correctness failed");
        
        ##1
        assert (read_port.cb_fifo.dout == ((0<<8) + 1)) else $error("Test data correctness failed");        
   
        ##1	
        read_port.cb_fifo.read <= 2'b00;
		assert (read_port.cb_fifo.dout == ((0<<8) + 2)) else $error("Test data correctness failed");

        ##1
        assert (&read_port.cb_fifo.empty) else $error("Test empty assertion after after complete emptying failed");
       
        ##1
        $display("Testing of fifo_sr with multiple flows finished");
		
		/* Testing critical cases */
		$display("\nTesting fifo_sr in critical cases");
		$display("Testing simultaneous read/write in almost-empty state");
		cb.rst <= 1;
		
		##2
		cb.rst <= 0;
		
		##1
		write_port.cb_fifo.write <= 1;
		write_port.cb_fifo.din <= (0<<8) + 1;   // tag + payload
		
		##1
		read_port.cb_fifo.read <= 2'b01;
		write_port.cb_fifo.din <= (0<<8) + 2; 
		
		##1
		write_port.cb_fifo.write <= 0;
		read_port.cb_fifo.read <= 2'b00;
		assert (read_port.cb_fifo.dout == ((0<<8) + 1)) else $error("Test data correctness failed");
		
		##1
		$display("Testing simultaneous read/write in almost-full state");
		write_port.cb_fifo.write <= 1;
		write_port.cb_fifo.din <= (0<<8) + 3;
		
		##1
		write_port.cb_fifo.din <= (0<<8) + 4;
		
		##1
		write_port.cb_fifo.din <= (0<<8) + 5;
		read_port.cb_fifo.read <= 2'b01;
		
		##1
		write_port.cb_fifo.write <= 0;
		assert (read_port.cb_fifo.dout == ((0<<8) + 2)) else $error("Test data correctness failed");
		
		##1
		read_port.cb_fifo.read <= 2'b00;
		assert (read_port.cb_fifo.dout == ((0<<8) + 3)) else $error("Test data correctness failed");
		
		##1
		$display("Testing fifo_sr with critical cases finished");
        $stop;
        end
   endmodule 
   
   
   
module tb;

    parameter CLK_PERIOD = 10;
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 4;
    parameter FLUX = 2;

	logic clk = 1;
	logic rst;
	
	always #(CLK_PERIOD/2) clk = !clk;
	
	write_interface #(DATA_WIDTH, FLUX) write_port(.*);
	read_interface #(DATA_WIDTH, FLUX) read_port(.*);
	fifo_sr #(DATA_WIDTH, DEPTH, FLUX) dut (.*);
	test_fifo_sr main(.*);
endmodule