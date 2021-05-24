// ----------------------------------------------------------------------------
//
// Multi-Dataflow Composer tool - Platform Composer
// Multi-Dataflow Network module 
// Date: 2021/04/20 17:50:12
//
// ----------------------------------------------------------------------------
`timescale 1ns / 1ps
`include "../fifo/fifo_interface.sv"


//ALL WIRES ARE AS THEY SHOULD BE; ONE MODULE HAS FAILED?


module top_sr 
#(
	parameter DEPTH = 4,
	parameter FLUX = 2
)(

	// System Signal(s)	        
    input clk,
    input rst,
    
	// Input(s)
    write_interface.fifo write_port_in_port,
	
    write_interface.fifo write_port_h_alpha, 
	
    write_interface.fifo write_port_ext_size,
	
    write_interface.fifo write_port_v_alpha,
	
	// Output(s)
    write_interface.actor write_port_out_port
	
	// Dynamic Parameter(s)
	
	
	// Monitoring
	
	// Configuration ID
		
);	

// internal signals
// ----------------------------------------------------------------------------


//ACTOR INTERFACES

    //DELAYS (x7)
    
        //delay_0
        read_interface #(8,FLUX) rd_delay_0_in_pel(clk);
        write_interface #(8,FLUX) wr_delay_0_out_pel(clk);
        
        //delay_1
        read_interface #(8,FLUX) rd_delay_1_in_pel(clk);
        write_interface #(8,FLUX) wr_delay_1_out_pel(clk);
        
        //delay_2
        read_interface #(8,FLUX) rd_delay_2_in_pel(clk);
        write_interface #(8,FLUX) wr_delay_2_out_pel(clk);
        
        //delay_3
        read_interface #(8,FLUX) rd_delay_3_in_pel(clk);
        write_interface #(8,FLUX) wr_delay_3_out_pel(clk);
        
        //delay_4
        read_interface #(8,FLUX) rd_delay_4_in_pel(clk);
        write_interface #(8,FLUX) wr_delay_4_out_pel(clk);
        
        //delay_5
        read_interface #(8,FLUX) rd_delay_5_in_pel(clk);
        write_interface #(8,FLUX) wr_delay_5_out_pel(clk);
        
        //delay_6
        read_interface #(8,FLUX) rd_delay_6_in_pel(clk);
        write_interface #(8,FLUX) wr_delay_6_out_pel(clk);
        
    //MUL_9 (x8)
    
        //mul_9_0
        read_interface #(7,FLUX) rd_mul_9_0_ext_size(clk);
        read_interface #(8,FLUX) rd_mul_9_0_opA(clk);
        read_interface #(9,FLUX) rd_mul_9_0_opB(clk);
        write_interface #(18,FLUX) wr_mul_9_0_prod(clk);
        
        //mul_9_1
        read_interface #(7,FLUX) rd_mul_9_1_ext_size(clk);
        read_interface #(8,FLUX) rd_mul_9_1_opA(clk);
        read_interface #(9,FLUX) rd_mul_9_1_opB(clk);
        write_interface #(18,FLUX) wr_mul_9_1_prod(clk);
        
        //mul_9_2
        read_interface #(7,FLUX) rd_mul_9_2_ext_size(clk);
        read_interface #(8,FLUX) rd_mul_9_2_opA(clk);
        read_interface #(9,FLUX) rd_mul_9_2_opB(clk);
        write_interface #(18,FLUX) wr_mul_9_2_prod(clk);
                
        //mul_9_3
        read_interface #(7,FLUX) rd_mul_9_3_ext_size(clk);
        read_interface #(8,FLUX) rd_mul_9_3_opA(clk);
        read_interface #(9,FLUX) rd_mul_9_3_opB(clk);
        write_interface #(18,FLUX) wr_mul_9_3_prod(clk);
        
        //mul_9_4
        read_interface #(7,FLUX) rd_mul_9_4_ext_size(clk);
        read_interface #(8,FLUX) rd_mul_9_4_opA(clk);
        read_interface #(9,FLUX) rd_mul_9_4_opB(clk);
        write_interface #(18,FLUX) wr_mul_9_4_prod(clk);
        
        //mul_9_5
        read_interface #(7,FLUX) rd_mul_9_5_ext_size(clk);
        read_interface #(8,FLUX) rd_mul_9_5_opA(clk);
        read_interface #(9,FLUX) rd_mul_9_5_opB(clk);
        write_interface #(18,FLUX) wr_mul_9_5_prod(clk);
        
        //mul_9_6
        read_interface #(7,FLUX) rd_mul_9_6_ext_size(clk);
        read_interface #(8,FLUX) rd_mul_9_6_opA(clk);
        read_interface #(9,FLUX) rd_mul_9_6_opB(clk);
        write_interface #(18,FLUX) wr_mul_9_6_prod(clk);
                
        //mul_9_7
        read_interface #(7,FLUX) rd_mul_9_7_ext_size(clk);
        read_interface #(8,FLUX) rd_mul_9_7_opA(clk);
        read_interface #(9,FLUX) rd_mul_9_7_opB(clk);
        write_interface #(18,FLUX) wr_mul_9_7_prod(clk);
    
    //MUL_18 (x8)
    
        //mul_18_0
        read_interface #(7,FLUX) rd_mul_18_0_real_size(clk);
        read_interface #(7,FLUX) rd_mul_18_0_ext_size(clk);
        read_interface #(18,FLUX) rd_mul_18_0_opA(clk);
        read_interface #(9,FLUX) rd_mul_18_0_opB(clk);
        write_interface #(27,FLUX) wr_mul_18_0_prod(clk);
    
        //mul_18_1
        read_interface #(7,FLUX) rd_mul_18_1_real_size(clk);
        read_interface #(7,FLUX) rd_mul_18_1_ext_size(clk);
        read_interface #(18,FLUX) rd_mul_18_1_opA(clk);
        read_interface #(9,FLUX) rd_mul_18_1_opB(clk);
        write_interface #(27,FLUX) wr_mul_18_1_prod(clk);
    
        //mul_18_2
        read_interface #(7,FLUX) rd_mul_18_2_real_size(clk);
        read_interface #(7,FLUX) rd_mul_18_2_ext_size(clk);
        read_interface #(18,FLUX) rd_mul_18_2_opA(clk);
        read_interface #(9,FLUX) rd_mul_18_2_opB(clk);
        write_interface #(27,FLUX) wr_mul_18_2_prod(clk);
    
        //mul_18_3
        read_interface #(7,FLUX) rd_mul_18_3_real_size(clk);
        read_interface #(7,FLUX) rd_mul_18_3_ext_size(clk);
        read_interface #(18,FLUX) rd_mul_18_3_opA(clk);
        read_interface #(9,FLUX) rd_mul_18_3_opB(clk);
        write_interface #(27,FLUX) wr_mul_18_3_prod(clk);
    
        //mul_18_4
        read_interface #(7,FLUX) rd_mul_18_4_real_size(clk);
        read_interface #(7,FLUX) rd_mul_18_4_ext_size(clk);
        read_interface #(18,FLUX) rd_mul_18_4_opA(clk);
        read_interface #(9,FLUX) rd_mul_18_4_opB(clk);
        write_interface #(27,FLUX) wr_mul_18_4_prod(clk);
    
        //mul_18_5
        read_interface #(7,FLUX) rd_mul_18_5_real_size(clk);
        read_interface #(7,FLUX) rd_mul_18_5_ext_size(clk);
        read_interface #(18,FLUX) rd_mul_18_5_opA(clk);
        read_interface #(9,FLUX) rd_mul_18_5_opB(clk);
        write_interface #(27,FLUX) wr_mul_18_5_prod(clk);
    
        //mul_18_6
        read_interface #(7,FLUX) rd_mul_18_6_real_size(clk);
        read_interface #(7,FLUX) rd_mul_18_6_ext_size(clk);
        read_interface #(18,FLUX) rd_mul_18_6_opA(clk);
        read_interface #(9,FLUX) rd_mul_18_6_opB(clk);
        write_interface #(27,FLUX) wr_mul_18_6_prod(clk);
    
        //mul_18_7
        read_interface #(7,FLUX) rd_mul_18_7_real_size(clk);
        read_interface #(7,FLUX) rd_mul_18_7_ext_size(clk);
        read_interface #(18,FLUX) rd_mul_18_7_opA(clk);
        read_interface #(9,FLUX) rd_mul_18_7_opB(clk);
        write_interface #(27,FLUX) wr_mul_18_7_prod(clk);
    
    //ADD_18 (x7)
    
        //add_18_0
        read_interface #(18,FLUX) rd_add_18_0_opA(clk);
        read_interface #(18,FLUX) rd_add_18_0_opB(clk);
        write_interface #(18,FLUX) wr_add_18_0_sum(clk);
        
        //add_18_1
        read_interface #(18,FLUX) rd_add_18_1_opA(clk);
        read_interface #(18,FLUX) rd_add_18_1_opB(clk);
        write_interface #(18,FLUX) wr_add_18_1_sum(clk);
        
        //add_18_2
        read_interface #(18,FLUX) rd_add_18_2_opA(clk);
        read_interface #(18,FLUX) rd_add_18_2_opB(clk);
        write_interface #(18,FLUX) wr_add_18_2_sum(clk);
        
        //add_18_3
        read_interface #(18,FLUX) rd_add_18_3_opA(clk);
        read_interface #(18,FLUX) rd_add_18_3_opB(clk);
        write_interface #(18,FLUX) wr_add_18_3_sum(clk);
        
        //add_18_4
        read_interface #(18,FLUX) rd_add_18_4_opA(clk);
        read_interface #(18,FLUX) rd_add_18_4_opB(clk);
        write_interface #(18,FLUX) wr_add_18_4_sum(clk);
        
        //add_18_5
        read_interface #(18,FLUX) rd_add_18_5_opA(clk);
        read_interface #(18,FLUX) rd_add_18_5_opB(clk);
        write_interface #(18,FLUX) wr_add_18_5_sum(clk);
        
        //add_18_6
        read_interface #(18,FLUX) rd_add_18_6_opA(clk);
        read_interface #(18,FLUX) rd_add_18_6_opB(clk);
        write_interface #(18,FLUX) wr_add_18_6_sum(clk);
        
    //ADD_27 (x7)
    
        //add_27_0
        read_interface #(27,FLUX) rd_add_27_0_opA(clk);
        read_interface #(27,FLUX) rd_add_27_0_opB(clk);
        write_interface #(27,FLUX) wr_add_27_0_sum(clk);
        
        //add_27_1
        read_interface #(27,FLUX) rd_add_27_1_opA(clk);
        read_interface #(27,FLUX) rd_add_27_1_opB(clk);
        write_interface #(27,FLUX) wr_add_27_1_sum(clk);
        
        //add_27_2
        read_interface #(27,FLUX) rd_add_27_2_opA(clk);
        read_interface #(27,FLUX) rd_add_27_2_opB(clk);
        write_interface #(27,FLUX) wr_add_27_2_sum(clk);
        
        //add_27_3
        read_interface #(27,FLUX) rd_add_27_3_opA(clk);
        read_interface #(27,FLUX) rd_add_27_3_opB(clk);
        write_interface #(27,FLUX) wr_add_27_3_sum(clk);
        
        //add_27_4
        read_interface #(27,FLUX) rd_add_27_4_opA(clk);
        read_interface #(27,FLUX) rd_add_27_4_opB(clk);
        write_interface #(27,FLUX) wr_add_27_4_sum(clk);
        
        //add_27_5
        read_interface #(27,FLUX) rd_add_27_5_opA(clk);
        read_interface #(27,FLUX) rd_add_27_5_opB(clk);
        write_interface #(27,FLUX) wr_add_27_5_sum(clk);
        
        //add_27_6
        read_interface #(27,FLUX) rd_add_27_6_opA(clk);
        read_interface #(27,FLUX) rd_add_27_6_opB(clk);
        write_interface #(27,FLUX) wr_add_27_6_sum(clk);
        
    //LINE BUFFER (x7)
    
        //line_buffer_0
        read_interface #(7,FLUX) rd_line_buffer_0_real_size(clk);
        read_interface #(7,FLUX) rd_line_buffer_0_ext_size(clk);
        read_interface #(18,FLUX) rd_line_buffer_0_in_pel(clk);    
        write_interface #(18,FLUX) wr_line_buffer_0_out_pel(clk);
    
        //line_buffer_1
        read_interface #(7,FLUX) rd_line_buffer_1_real_size(clk);
        read_interface #(7,FLUX) rd_line_buffer_1_ext_size(clk);
        read_interface #(18,FLUX) rd_line_buffer_1_in_pel(clk);    
        write_interface #(18,FLUX) wr_line_buffer_1_out_pel(clk);
    
        //line_buffer_2
        read_interface #(7,FLUX) rd_line_buffer_2_real_size(clk);
        read_interface #(7,FLUX) rd_line_buffer_2_ext_size(clk);
        read_interface #(18,FLUX) rd_line_buffer_2_in_pel(clk);    
        write_interface #(18,FLUX) wr_line_buffer_2_out_pel(clk);
        
        //line_buffer_3
        read_interface #(7,FLUX) rd_line_buffer_3_real_size(clk);
        read_interface #(7,FLUX) rd_line_buffer_3_ext_size(clk);
        read_interface #(18,FLUX) rd_line_buffer_3_in_pel(clk);    
        write_interface #(18,FLUX) wr_line_buffer_3_out_pel(clk);
        
        //line_buffer_4
        read_interface #(7,FLUX) rd_line_buffer_4_real_size(clk);
        read_interface #(7,FLUX) rd_line_buffer_4_ext_size(clk);
        read_interface #(18,FLUX) rd_line_buffer_4_in_pel(clk);    
        write_interface #(18,FLUX) wr_line_buffer_4_out_pel(clk);
        
        //line_buffer_5
        read_interface #(7,FLUX) rd_line_buffer_5_real_size(clk);
        read_interface #(7,FLUX) rd_line_buffer_5_ext_size(clk);
        read_interface #(18,FLUX) rd_line_buffer_5_in_pel(clk);    
        write_interface #(18,FLUX) wr_line_buffer_5_out_pel(clk);
    
        //line_buffer_6
        read_interface #(7,FLUX) rd_line_buffer_6_real_size(clk);
        read_interface #(7,FLUX) rd_line_buffer_6_ext_size(clk);
        read_interface #(18,FLUX) rd_line_buffer_6_in_pel(clk);    
        write_interface #(18,FLUX) wr_line_buffer_6_out_pel(clk);
    
    //COEFF_LUMA (x2)
    
        //coeff_luma_h
        read_interface #(3,FLUX) rd_coeff_luma_h_alpha(clk);
        write_interface #(9,FLUX) wr_coeff_luma_h_c0(clk);
        write_interface #(9,FLUX) wr_coeff_luma_h_c1(clk);
        write_interface #(9,FLUX) wr_coeff_luma_h_c2(clk);
        write_interface #(9,FLUX) wr_coeff_luma_h_c3(clk);
        write_interface #(9,FLUX) wr_coeff_luma_h_c4(clk);
        write_interface #(9,FLUX) wr_coeff_luma_h_c5(clk);
        write_interface #(9,FLUX) wr_coeff_luma_h_c6(clk);
        write_interface #(9,FLUX) wr_coeff_luma_h_c7(clk);
                    
        //coeff_luma_v
        read_interface #(3,FLUX) rd_coeff_luma_v_alpha(clk);
        write_interface #(9,FLUX) wr_coeff_luma_v_c0(clk);
        write_interface #(9,FLUX) wr_coeff_luma_v_c1(clk);
        write_interface #(9,FLUX) wr_coeff_luma_v_c2(clk);
        write_interface #(9,FLUX) wr_coeff_luma_v_c3(clk);
        write_interface #(9,FLUX) wr_coeff_luma_v_c4(clk);
        write_interface #(9,FLUX) wr_coeff_luma_v_c5(clk);
        write_interface #(9,FLUX) wr_coeff_luma_v_c6(clk);
        write_interface #(9,FLUX) wr_coeff_luma_v_c7(clk);
    
    //DERIVE REAL SIZE (x1)
        
        //derive_real_size
        read_interface #(7,FLUX) rd_derive_real_size_ext_size(clk);
        write_interface #(7,FLUX) wr_derive_real_size_real_size(clk);
            
    //REMOVE H (x1)
    
        //remove_h
        read_interface #(7,FLUX) rd_remove_h_ext_size(clk);
        read_interface #(18,FLUX) rd_remove_h_in_pel(clk);    
        write_interface #(18,FLUX) wr_remove_h_out_pel(clk);
            
    //REMOVE V (x1)
    
        //remove_v
        read_interface #(7,FLUX) rd_remove_v_real_size(clk);    
        read_interface #(7,FLUX) rd_remove_v_ext_size(clk);
        read_interface #(8,FLUX) rd_remove_v_in_pel(clk);    
        write_interface #(8,FLUX) wr_remove_v_out_pel(clk);

        assign wr_remove_v_out_pel.full=write_port_out_port.full;
        assign write_port_out_port.write = wr_remove_v_out_pel.write;
        assign write_port_out_port.din = wr_remove_v_out_pel.din;
    
    //CLIP (x1)
    
        //clip
        read_interface #(16,FLUX) rd_clip_in_pel(clk);
        write_interface #(8,FLUX) wr_clip_out_pel(clk);    
            
    //SHIFT (x1)
    
        //shift
        read_interface #(27,FLUX) rd_shift_in_pel(clk);
        write_interface #(16,FLUX) wr_shift_out_pel(clk);


//FORK SUPPPORT INTERFACES

    //FORK DELAY_0 - MUL9_0 ON INPORT
    
        // - INTERFACES   		
        write_interface #(8,FLUX) wr_fifo_delay_0_in_pel(clk);    		
        write_interface #(8,FLUX) wr_fifo_mul_9_0_opA(clk);      
                  
        // - FULL
        assign write_port_in_port.full = wr_fifo_delay_0_in_pel.full | wr_fifo_mul_9_0_opA.full;
        
        // - WRITE
        assign wr_fifo_delay_0_in_pel.write = write_port_in_port.write;
        assign wr_fifo_mul_9_0_opA.write = write_port_in_port.write;
        
        // - DATA
        assign wr_fifo_delay_0_in_pel.din = write_port_in_port.din;
        assign wr_fifo_mul_9_0_opA.din = write_port_in_port.din;  
    
    //FORK DELAY_1 - MUL9_1 ON DELAY_0
    
        // - INTERFACES   		
        write_interface #(8,FLUX) wr_fifo_delay_1_in_pel(clk);    		
        write_interface #(8,FLUX) wr_fifo_mul_9_1_opA(clk);   
             
        // - FULL
        assign wr_delay_0_out_pel.full = wr_fifo_delay_1_in_pel.full | wr_fifo_mul_9_1_opA.full;
        
        // - WRITE
        assign wr_fifo_delay_1_in_pel.write = wr_delay_0_out_pel.write;
        assign wr_fifo_mul_9_1_opA.write = wr_delay_0_out_pel.write;
        
        // - DATA
        assign wr_fifo_delay_1_in_pel.din = wr_delay_0_out_pel.din;
        assign wr_fifo_mul_9_1_opA.din = wr_delay_0_out_pel.din;    

    //FORK DELAY_2 - MUL9_2 ON DELAY_1       	
    	
    	// - INTERFACES
        write_interface #(8,FLUX) wr_fifo_delay_2_in_pel(clk);    		
        write_interface #(8,FLUX) wr_fifo_mul_9_2_opA(clk);     
           
        // - FULL
        assign wr_delay_1_out_pel.full = wr_fifo_delay_2_in_pel.full | wr_fifo_mul_9_2_opA.full;
        
        // - WRITE
        assign wr_fifo_delay_2_in_pel.write = wr_delay_1_out_pel.write;
        assign wr_fifo_mul_9_2_opA.write = wr_delay_1_out_pel.write;
        
        // - DATA
        assign wr_fifo_delay_2_in_pel.din = wr_delay_1_out_pel.din;
        assign wr_fifo_mul_9_2_opA.din = wr_delay_1_out_pel.din;
    
    //FORK DELAY_3 - MUL9_3 ON DELAY_2
        
        // - INTERFACES   		
        write_interface #(8,FLUX) wr_fifo_delay_3_in_pel(clk);    		
        write_interface #(8,FLUX) wr_fifo_mul_9_3_opA(clk); 
               
        // - FULL
        assign wr_delay_2_out_pel.full = wr_fifo_delay_3_in_pel.full | wr_fifo_mul_9_3_opA.full;
        
        // - WRITE
        assign wr_fifo_delay_3_in_pel.write = wr_delay_2_out_pel.write;
        assign wr_fifo_mul_9_3_opA.write = wr_delay_2_out_pel.write;
        
        // - DATA
        assign wr_fifo_delay_3_in_pel.din = wr_delay_2_out_pel.din;
        assign wr_fifo_mul_9_3_opA.din = wr_delay_2_out_pel.din;

    //FORK DELAY_4 - MUL9_4 ON DELAY_3
        
        // - INTERFACES   		
        write_interface #(8,FLUX) wr_fifo_delay_4_in_pel(clk);    		
        write_interface #(8,FLUX) wr_fifo_mul_9_4_opA(clk);   
             
        // - FULL
        assign wr_delay_3_out_pel.full = wr_fifo_delay_4_in_pel.full | wr_fifo_mul_9_4_opA.full;
        
        // - WRITE
        assign wr_fifo_delay_4_in_pel.write = wr_delay_3_out_pel.write;
        assign wr_fifo_mul_9_4_opA.write = wr_delay_3_out_pel.write;
        
        // - DATA
        assign wr_fifo_delay_4_in_pel.din = wr_delay_3_out_pel.din;
        assign wr_fifo_mul_9_4_opA.din = wr_delay_3_out_pel.din;

    //FORK DELAY_5 - MUL9_5 ON DELAY_4
        
        // - INTERFACES   		
        write_interface #(8,FLUX) wr_fifo_delay_5_in_pel(clk);    		
        write_interface #(8,FLUX) wr_fifo_mul_9_5_opA(clk); 
               
        // - FULL
        assign wr_delay_4_out_pel.full = wr_fifo_delay_5_in_pel.full | wr_fifo_mul_9_5_opA.full;
        
        // - WRITE
        assign wr_fifo_delay_5_in_pel.write = wr_delay_4_out_pel.write;
        assign wr_fifo_mul_9_5_opA.write = wr_delay_4_out_pel.write;
        
        // - DATA
        assign wr_fifo_delay_5_in_pel.din = wr_delay_4_out_pel.din;
        assign wr_fifo_mul_9_5_opA.din = wr_delay_4_out_pel.din;

    //FORK DELAY_6 - MUL9_6 ON DELAY_5
        
        // - INTERFACES   		
        write_interface #(8,FLUX) wr_fifo_delay_6_in_pel(clk);    		
        write_interface #(8,FLUX) wr_fifo_mul_9_6_opA(clk);
                
        // - FULL
        assign wr_delay_5_out_pel.full = wr_fifo_delay_6_in_pel.full | wr_fifo_mul_9_6_opA.full;
        
        // - WRITE
        assign wr_fifo_delay_6_in_pel.write = wr_delay_5_out_pel.write;
        assign wr_fifo_mul_9_6_opA.write = wr_delay_5_out_pel.write;
        
        // - DATA
        assign wr_fifo_delay_6_in_pel.din = wr_delay_5_out_pel.din;
        assign wr_fifo_mul_9_6_opA.din = wr_delay_5_out_pel.din;
     
    //FORK MUL_9_0 / MUL_9_1 / MUL_9_2 / MUL_9_3 / MUL_9_4 / MUL_9_5 / MUL_9_6 / MUL_9_7 / REMOVE_H ...
    //... / MUL_18_0 / MUL_18_1 / MUL_18_2 / MUL_18_3 / MUL_18_4 / MUL_18_5 / MUL_18_6 / MUL_18_7 ...
    //... / REMOVE_v / LINE_BUFFER_0 / LINE_BUFFER_1 / LINE_BUFFER_2 / LINE_BUFFER_3 / LINE_BUFFER_4 ...
    //... / LINE_BUFFER_5 / LINE_BUFFER_6  / DERIVE_REAL_SIZE...
    //... ON EXTSIZE 
        
        // - INTERFACES
        
            //MUL9 (x8)
            write_interface #(7,FLUX) wr_fifo_mul_9_0_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_9_1_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_9_2_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_9_3_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_9_4_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_9_5_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_9_6_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_9_7_ext_size (clk);
            
            //REMOVE H (x1)
            write_interface #(7,FLUX) wr_fifo_remove_h_ext_size (clk);
            
            //MUL18 (x8)
            write_interface #(7,FLUX) wr_fifo_mul_18_0_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_1_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_2_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_3_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_4_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_5_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_6_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_7_ext_size (clk);
            
            //REMOVE V (x1)
            write_interface #(7,FLUX) wr_fifo_remove_v_ext_size (clk);
            
            //LINE BUFFER (x7)
            write_interface #(7,FLUX) wr_fifo_line_buffer_0_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_line_buffer_1_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_line_buffer_2_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_line_buffer_3_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_line_buffer_4_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_line_buffer_5_ext_size (clk);
            write_interface #(7,FLUX) wr_fifo_line_buffer_6_ext_size (clk);            
                                    
            //DERIVE REAL SIZE (x1)
            write_interface #(7,FLUX) wr_fifo_derive_real_size_ext_size (clk);
                        
        // - FULL            
            assign write_port_ext_size.full =
            
            //MUL9 (x8)
            wr_fifo_mul_9_0_ext_size.full |
            wr_fifo_mul_9_1_ext_size.full |
            wr_fifo_mul_9_2_ext_size.full |
            wr_fifo_mul_9_3_ext_size.full |
            wr_fifo_mul_9_4_ext_size.full |
            wr_fifo_mul_9_5_ext_size.full |
            wr_fifo_mul_9_6_ext_size.full |
            wr_fifo_mul_9_7_ext_size.full |
            
            //REMOVE H (x1)
            wr_fifo_remove_h_ext_size.full |
            
            //MUL18 (x8)
            wr_fifo_mul_18_0_ext_size.full |
            wr_fifo_mul_18_1_ext_size.full |
            wr_fifo_mul_18_2_ext_size.full |
            wr_fifo_mul_18_3_ext_size.full |
            wr_fifo_mul_18_4_ext_size.full |
            wr_fifo_mul_18_5_ext_size.full |
            wr_fifo_mul_18_6_ext_size.full |
            wr_fifo_mul_18_7_ext_size.full |
            
            //REMOVE V (x1)
            wr_fifo_remove_v_ext_size.full |
            
            //LINE BUFFER (x7)
            wr_fifo_line_buffer_0_ext_size.full |
            wr_fifo_line_buffer_1_ext_size.full |
            wr_fifo_line_buffer_2_ext_size.full |
            wr_fifo_line_buffer_3_ext_size.full |
            wr_fifo_line_buffer_4_ext_size.full |
            wr_fifo_line_buffer_5_ext_size.full |
            wr_fifo_line_buffer_6_ext_size.full |            
                                    
            //DERIVE REAL SIZE (x1)
            wr_fifo_derive_real_size_ext_size.full ;             
                        
        // - WRITE
            
            //MUL9 (x8)
            assign wr_fifo_mul_9_0_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_9_1_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_9_2_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_9_3_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_9_4_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_9_5_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_9_6_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_9_7_ext_size.write = write_port_ext_size.write;
            
            //REMOVE H (x1)
            assign wr_fifo_remove_h_ext_size.write = write_port_ext_size.write;
            
            //MUL18 (x8)
            assign wr_fifo_mul_18_0_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_18_1_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_18_2_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_18_3_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_18_4_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_18_5_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_18_6_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_mul_18_7_ext_size.write = write_port_ext_size.write;
            
            //REMOVE V (x1)
            assign wr_fifo_remove_v_ext_size.write = write_port_ext_size.write;
            
            //LINE BUFFER (x7)
            assign wr_fifo_line_buffer_0_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_line_buffer_1_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_line_buffer_2_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_line_buffer_3_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_line_buffer_4_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_line_buffer_5_ext_size.write = write_port_ext_size.write;
            assign wr_fifo_line_buffer_6_ext_size.write = write_port_ext_size.write;            
                                    
            //DERIVE REAL SIZE (x1)
            assign wr_fifo_derive_real_size_ext_size.write = write_port_ext_size.write; 
                        
        // - DATA
            
            //MUL9 (x8)
            assign wr_fifo_mul_9_0_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_9_1_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_9_2_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_9_3_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_9_4_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_9_5_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_9_6_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_9_7_ext_size.din = write_port_ext_size.din;
            
            //REMOVE H (x1)
            assign wr_fifo_remove_h_ext_size.din = write_port_ext_size.din;
            
            //MUL18 (x8)
            assign wr_fifo_mul_18_0_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_18_1_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_18_2_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_18_3_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_18_4_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_18_5_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_18_6_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_mul_18_7_ext_size.din = write_port_ext_size.din;
            
            //REMOVE V (x1)
            assign wr_fifo_remove_v_ext_size.din = write_port_ext_size.din;
            
            //LINE BUFFER (x7)
            assign wr_fifo_line_buffer_0_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_line_buffer_1_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_line_buffer_2_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_line_buffer_3_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_line_buffer_4_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_line_buffer_5_ext_size.din = write_port_ext_size.din;
            assign wr_fifo_line_buffer_6_ext_size.din = write_port_ext_size.din;            
                                    
            //DERIVE REAL SIZE (x1)
            assign wr_fifo_derive_real_size_ext_size.din = write_port_ext_size.din;
            
    //FORK LINE_BUFFER_0 / LINE_BUFFER_1 / LINE_BUFFER_2 / LINE_BUFFER_3 / LINE_BUFFER_4 ...
    //... / LINE_BUFFER_5 / LINE_BUFFER_6  / REMOVE_V / MUL_18_0 / MUL_18_1 / MUL_18_2 ... 
    //... / MUL_18_3 / MUL_18_4 / MUL_18_5 / MUL_18_6 / MUL_18_7...
    //... ON DERIVE_REAL_SIZE 

        // - INTERFACES
            
            //MUL18 (x8)
            write_interface #(7,FLUX) wr_fifo_mul_18_0_real_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_1_real_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_2_real_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_3_real_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_4_real_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_5_real_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_6_real_size (clk);
            write_interface #(7,FLUX) wr_fifo_mul_18_7_real_size (clk);
            
            //REMOVE V (x1)
            write_interface #(7,FLUX) wr_fifo_remove_v_real_size (clk);
            
            //LINE BUFFER (x7)
            write_interface #(7,FLUX) wr_fifo_line_buffer_0_real_size (clk);
            write_interface #(7,FLUX) wr_fifo_line_buffer_1_real_size (clk);
            write_interface #(7,FLUX) wr_fifo_line_buffer_2_real_size (clk);
            write_interface #(7,FLUX) wr_fifo_line_buffer_3_real_size (clk);
            write_interface #(7,FLUX) wr_fifo_line_buffer_4_real_size (clk);
            write_interface #(7,FLUX) wr_fifo_line_buffer_5_real_size (clk);
            write_interface #(7,FLUX) wr_fifo_line_buffer_6_real_size (clk);            
                                                          
        // - FULL            
            assign wr_derive_real_size_real_size.full =
            
            //MUL18 (x8)
            wr_fifo_mul_18_0_real_size.full |
            wr_fifo_mul_18_1_real_size.full |
            wr_fifo_mul_18_2_real_size.full |
            wr_fifo_mul_18_3_real_size.full |
            wr_fifo_mul_18_4_real_size.full |
            wr_fifo_mul_18_5_real_size.full |
            wr_fifo_mul_18_6_real_size.full |
            wr_fifo_mul_18_7_real_size.full |
            
            //REMOVE V (x1)
            wr_fifo_remove_v_real_size.full |
            
            //LINE BUFFER (x7)
            wr_fifo_line_buffer_0_real_size.full |
            wr_fifo_line_buffer_1_real_size.full |
            wr_fifo_line_buffer_2_real_size.full |
            wr_fifo_line_buffer_3_real_size.full |
            wr_fifo_line_buffer_4_real_size.full |
            wr_fifo_line_buffer_5_real_size.full |
            wr_fifo_line_buffer_6_real_size.full ;            
                                                              
        // - WRITE
                        
            //MUL18 (x8)
            assign wr_fifo_mul_18_0_real_size.write = wr_derive_real_size_real_size.write;
            assign wr_fifo_mul_18_1_real_size.write = wr_derive_real_size_real_size.write;
            assign wr_fifo_mul_18_2_real_size.write = wr_derive_real_size_real_size.write;
            assign wr_fifo_mul_18_3_real_size.write = wr_derive_real_size_real_size.write;
            assign wr_fifo_mul_18_4_real_size.write = wr_derive_real_size_real_size.write;
            assign wr_fifo_mul_18_5_real_size.write = wr_derive_real_size_real_size.write;
            assign wr_fifo_mul_18_6_real_size.write = wr_derive_real_size_real_size.write;
            assign wr_fifo_mul_18_7_real_size.write = wr_derive_real_size_real_size.write;
            
            //REMOVE V (x1)
            assign wr_fifo_remove_v_real_size.write = wr_derive_real_size_real_size.write;
            
            //LINE BUFFER (x7)
            assign wr_fifo_line_buffer_0_real_size.write = wr_derive_real_size_real_size.write;
            assign wr_fifo_line_buffer_1_real_size.write = wr_derive_real_size_real_size.write;
            assign wr_fifo_line_buffer_2_real_size.write = wr_derive_real_size_real_size.write;
            assign wr_fifo_line_buffer_3_real_size.write = wr_derive_real_size_real_size.write;
            assign wr_fifo_line_buffer_4_real_size.write = wr_derive_real_size_real_size.write;
            assign wr_fifo_line_buffer_5_real_size.write = wr_derive_real_size_real_size.write;
            assign wr_fifo_line_buffer_6_real_size.write = wr_derive_real_size_real_size.write;            
                    
        // - DATA
                                
            //MUL18 (x8)
            assign wr_fifo_mul_18_0_real_size.din = wr_derive_real_size_real_size.din;
            assign wr_fifo_mul_18_1_real_size.din = wr_derive_real_size_real_size.din;
            assign wr_fifo_mul_18_2_real_size.din = wr_derive_real_size_real_size.din;
            assign wr_fifo_mul_18_3_real_size.din = wr_derive_real_size_real_size.din;
            assign wr_fifo_mul_18_4_real_size.din = wr_derive_real_size_real_size.din;
            assign wr_fifo_mul_18_5_real_size.din = wr_derive_real_size_real_size.din;
            assign wr_fifo_mul_18_6_real_size.din = wr_derive_real_size_real_size.din;
            assign wr_fifo_mul_18_7_real_size.din = wr_derive_real_size_real_size.din;
            
            //REMOVE V (x1)
            assign wr_fifo_remove_v_real_size.din = wr_derive_real_size_real_size.din;
            
            //LINE BUFFER (x7)
            assign wr_fifo_line_buffer_0_real_size.din = wr_derive_real_size_real_size.din;
            assign wr_fifo_line_buffer_1_real_size.din = wr_derive_real_size_real_size.din;
            assign wr_fifo_line_buffer_2_real_size.din = wr_derive_real_size_real_size.din;
            assign wr_fifo_line_buffer_3_real_size.din = wr_derive_real_size_real_size.din;
            assign wr_fifo_line_buffer_4_real_size.din = wr_derive_real_size_real_size.din;
            assign wr_fifo_line_buffer_5_real_size.din = wr_derive_real_size_real_size.din;
            assign wr_fifo_line_buffer_6_real_size.din = wr_derive_real_size_real_size.din;            

    //FORK LINE_BUFFER_0 - MUL18_0 ON REMOVE_H
    
        // - INTERFACES   		
        write_interface #(18,FLUX) wr_fifo_line_buffer_0_in_pel(clk);    		
        write_interface #(18,FLUX) wr_fifo_mul_18_0_opA(clk);      
                  
        // - FULL
        assign wr_remove_h_out_pel.full = wr_fifo_line_buffer_0_in_pel.full | wr_fifo_mul_18_0_opA.full;
        
        // - WRITE
        assign wr_fifo_line_buffer_0_in_pel.write = wr_remove_h_out_pel.write;
        assign wr_fifo_mul_18_0_opA.write = wr_remove_h_out_pel.write;
        
        // - DATA
        assign wr_fifo_line_buffer_0_in_pel.din = wr_remove_h_out_pel.din;
        assign wr_fifo_mul_18_0_opA.din = wr_remove_h_out_pel.din;  
    
    //FORK LINE_BUFFER_1 - MUL18_1 ON LINE_BUFFER_0
    
        // - INTERFACES   		
        write_interface #(18,FLUX) wr_fifo_line_buffer_1_in_pel(clk);    		
        write_interface #(18,FLUX) wr_fifo_mul_18_1_opA(clk);   
             
        // - FULL
        assign wr_line_buffer_0_out_pel.full = wr_fifo_line_buffer_1_in_pel.full | wr_fifo_mul_18_1_opA.full;
        
        // - WRITE
        assign wr_fifo_line_buffer_1_in_pel.write = wr_line_buffer_0_out_pel.write;
        assign wr_fifo_mul_18_1_opA.write = wr_line_buffer_0_out_pel.write;
        
        // - DATA
        assign wr_fifo_line_buffer_1_in_pel.din = wr_line_buffer_0_out_pel.din;
        assign wr_fifo_mul_18_1_opA.din = wr_line_buffer_0_out_pel.din;    

    //FORK LINE_BUFFER_2 - MUL18_2 ON LINE_BUFFER_1       	
    	
    	// - INTERFACES
        write_interface #(18,FLUX) wr_fifo_line_buffer_2_in_pel(clk);    		
        write_interface #(18,FLUX) wr_fifo_mul_18_2_opA(clk);     
           
        // - FULL
        assign wr_line_buffer_1_out_pel.full = wr_fifo_line_buffer_2_in_pel.full | wr_fifo_mul_18_2_opA.full;
        
        // - WRITE
        assign wr_fifo_line_buffer_2_in_pel.write = wr_line_buffer_1_out_pel.write;
        assign wr_fifo_mul_18_2_opA.write = wr_line_buffer_1_out_pel.write;
        
        // - DATA
        assign wr_fifo_line_buffer_2_in_pel.din = wr_line_buffer_1_out_pel.din;
        assign wr_fifo_mul_18_2_opA.din = wr_line_buffer_1_out_pel.din;
    
    //FORK LINE_BUFFER_3 - MUL18_3 ON LINE_BUFFER_2
        
        // - INTERFACES   		
        write_interface #(18,FLUX) wr_fifo_line_buffer_3_in_pel(clk);    		
        write_interface #(18,FLUX) wr_fifo_mul_18_3_opA(clk); 
               
        // - FULL
        assign wr_line_buffer_2_out_pel.full = wr_fifo_line_buffer_3_in_pel.full | wr_fifo_mul_18_3_opA.full;
        
        // - WRITE
        assign wr_fifo_line_buffer_3_in_pel.write = wr_line_buffer_2_out_pel.write;
        assign wr_fifo_mul_18_3_opA.write = wr_line_buffer_2_out_pel.write;
        
        // - DATA
        assign wr_fifo_line_buffer_3_in_pel.din = wr_line_buffer_2_out_pel.din;
        assign wr_fifo_mul_18_3_opA.din = wr_line_buffer_2_out_pel.din;

    //FORK LINE_BUFFER_4 - MUL18_4 ON LINE_BUFFER_3
        
        // - INTERFACES   		
        write_interface #(18,FLUX) wr_fifo_line_buffer_4_in_pel(clk);    		
        write_interface #(18,FLUX) wr_fifo_mul_18_4_opA(clk);   
             
        // - FULL
        assign wr_line_buffer_3_out_pel.full = wr_fifo_line_buffer_4_in_pel.full | wr_fifo_mul_18_4_opA.full;
        
        // - WRITE
        assign wr_fifo_line_buffer_4_in_pel.write = wr_line_buffer_3_out_pel.write;
        assign wr_fifo_mul_18_4_opA.write = wr_line_buffer_3_out_pel.write;
        
        // - DATA
        assign wr_fifo_line_buffer_4_in_pel.din = wr_line_buffer_3_out_pel.din;
        assign wr_fifo_mul_18_4_opA.din = wr_line_buffer_3_out_pel.din;

    //FORK LINE_BUFFER_5 - MUL18_5 ON LINE_BUFFER_4
        
        // - INTERFACES   		
        write_interface #(18,FLUX) wr_fifo_line_buffer_5_in_pel(clk);    		
        write_interface #(18,FLUX) wr_fifo_mul_18_5_opA(clk); 
               
        // - FULL
        assign wr_line_buffer_4_out_pel.full = wr_fifo_line_buffer_5_in_pel.full | wr_fifo_mul_18_5_opA.full;
        
        // - WRITE
        assign wr_fifo_line_buffer_5_in_pel.write = wr_line_buffer_4_out_pel.write;
        assign wr_fifo_mul_18_5_opA.write = wr_line_buffer_4_out_pel.write;
        
        // - DATA
        assign wr_fifo_line_buffer_5_in_pel.din = wr_line_buffer_4_out_pel.din;
        assign wr_fifo_mul_18_5_opA.din = wr_line_buffer_4_out_pel.din;

    //FORK LINE_BUFFER_6 - MUL18_6 ON LINE_BUFFER_5
        
        // - INTERFACES   		
        write_interface #(18,FLUX) wr_fifo_line_buffer_6_in_pel(clk);    		
        write_interface #(18,FLUX) wr_fifo_mul_18_6_opA(clk);
                
        // - FULL
        assign wr_line_buffer_5_out_pel.full = wr_fifo_line_buffer_6_in_pel.full | wr_fifo_mul_18_6_opA.full;
        
        // - WRITE
        assign wr_fifo_line_buffer_6_in_pel.write = wr_line_buffer_5_out_pel.write;
        assign wr_fifo_mul_18_6_opA.write = wr_line_buffer_5_out_pel.write;
        
        // - DATA
        assign wr_fifo_line_buffer_6_in_pel.din = wr_line_buffer_5_out_pel.din;
        assign wr_fifo_mul_18_6_opA.din = wr_line_buffer_5_out_pel.din;

                                        		
//COLOR BASED ORGANIZATION


//FIFO - FIRST HALF CIRCUIT

    //ORANGE: INPUT INPEL DELAYS (x7)
    
        //inport<->delay0
        fifo_sr #(8,DEPTH,FLUX) fifo_inport_delay0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_delay_0_in_pel.fifo),
        .read_port(rd_delay_0_in_pel.fifo)
        );
        
        //delay_0<->delay_1
        fifo_sr #(8,DEPTH,FLUX) fifo_delay0_delay1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_delay_1_in_pel.fifo),
        .read_port(rd_delay_1_in_pel.fifo)
        );

        //delay_1<->delay_2
        fifo_sr #(8,DEPTH,FLUX) fifo_delay1_delay2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_delay_2_in_pel.fifo),
        .read_port(rd_delay_2_in_pel.fifo)
        );

        //delay_2<->delay_3
        fifo_sr #(8,DEPTH,FLUX) fifo_delay2_delay3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_delay_3_in_pel.fifo),
        .read_port(rd_delay_3_in_pel.fifo)
        );        

        //delay_3<->delay_4
        fifo_sr #(8,DEPTH,FLUX) fifo_delay3_delay4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_delay_4_in_pel.fifo),
        .read_port(rd_delay_4_in_pel.fifo)
        );    

        //delay_4<->delay_5
        fifo_sr #(8,DEPTH,FLUX) fifo_delay4_delay5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_delay_5_in_pel.fifo),
        .read_port(rd_delay_5_in_pel.fifo)
        );    

        //delay_5<->delay_6
        fifo_sr #(8,DEPTH,FLUX) fifo_delay5_delay6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_delay_6_in_pel.fifo),
        .read_port(rd_delay_6_in_pel.fifo)
        );
                        
    //BLACK: INPUT ALPHA COEFF_LUMA (x2)
        
        //h_alpha<->coeff_luma_h
        fifo_sr #(3,DEPTH,FLUX) fifo_h_alpha_coeff_luma_h_alpha
        (
        .clk(clk),
        .rst(rst),
        .write_port(write_port_h_alpha),
        .read_port(rd_coeff_luma_h_alpha.fifo)
        ); 
        
        //v_aplha<->coeff_luma_v
        fifo_sr #(3,DEPTH,FLUX) fifo_v_alpha_coeff_luma_v_alpha
        (
        .clk(clk),
        .rst(rst),
        .write_port(write_port_v_alpha),
        .read_port(rd_coeff_luma_v_alpha.fifo)
        );        
        
    //GREEN: INPUT OPB ADD 18 (x7)
        
        //mul_9_0<->add_18_0
        fifo_sr #(18,DEPTH,FLUX) fifo_mul9_0_add18_0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_9_0_prod.fifo),
        .read_port(rd_add_18_0_opB.fifo)
        );

        //add_18_0<->add_18_1
        fifo_sr #(18,DEPTH,FLUX) fifo_add18_0_add18_1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_18_0_sum.fifo),
        .read_port(rd_add_18_1_opB.fifo)
        );                 

        //add_18_1<->add_18_2
        fifo_sr #(18,DEPTH,FLUX) fifo_add18_1_add18_2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_18_1_sum.fifo),
        .read_port(rd_add_18_2_opB.fifo)
        );

        //add_18_2<->add_18_3
        fifo_sr #(18,DEPTH,FLUX) fifo_add18_2_add18_3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_18_2_sum.fifo),
        .read_port(rd_add_18_3_opB.fifo)
        );

        //add_18_3<->add_18_4
        fifo_sr #(18,DEPTH,FLUX) fifo_add18_3_add18_4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_18_3_sum.fifo),
        .read_port(rd_add_18_4_opB.fifo)
        );

        //add_18_4<->add_18_5
        fifo_sr #(18,DEPTH,FLUX) fifo_add18_4_add18_5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_18_4_sum.fifo),
        .read_port(rd_add_18_5_opB.fifo)
        );

        //add_18_5<->add_18_6
        fifo_sr #(18,DEPTH,FLUX) fifo_add18_5_add18_6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_18_5_sum.fifo),
        .read_port(rd_add_18_6_opB.fifo)
        );
        
    //BORDEAUX: INPUT OPA ADD 18 (x7)

        //mul_9_1<->add_18_0
        fifo_sr #(18,DEPTH,FLUX) fifo_mul9_1_add18_0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_9_1_prod.fifo),
        .read_port(rd_add_18_0_opA.fifo)
        );

        //mul_9_2<->add_18_1
        fifo_sr #(18,DEPTH,FLUX) fifo_mul9_2_add18_1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_9_2_prod.fifo),
        .read_port(rd_add_18_1_opA.fifo)
        );
 
         //mul_9_3<->add_18_2
        fifo_sr #(18,DEPTH,FLUX) fifo_mul9_3_add18_2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_9_3_prod.fifo),
        .read_port(rd_add_18_2_opA.fifo)
        );

         //mul_9_4<->add_18_3
        fifo_sr #(18,DEPTH,FLUX) fifo_mul9_4_add18_3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_9_4_prod.fifo),
        .read_port(rd_add_18_3_opA.fifo)
        );

         //mul_9_5<->add_18_4
        fifo_sr #(18,DEPTH,FLUX) fifo_mul9_5_add18_4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_9_5_prod.fifo),
        .read_port(rd_add_18_4_opA.fifo)
        );

         //mul_9_6<->add_18_5
        fifo_sr #(18,DEPTH,FLUX) fifo_mul9_6_add18_5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_9_6_prod.fifo),
        .read_port(rd_add_18_5_opA.fifo)
        );

         //mul_9_7<->add_18_6
        fifo_sr #(18,DEPTH,FLUX) fifo_mul9_7_add18_6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_9_7_prod.fifo),
        .read_port(rd_add_18_6_opA.fifo)
        );
    
    //RED: INPUT EXTSIZE MUL9 (x8)
                
        //extsize<->mul_9_0        
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul9_0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_0_ext_size.fifo),
        .read_port(rd_mul_9_0_ext_size.fifo)
        );        
                
        //extsize<->mul_9_1
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul9_1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_1_ext_size.fifo),
        .read_port(rd_mul_9_1_ext_size.fifo)
        );
                
        //extsize<->mul_9_2
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul9_2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_2_ext_size.fifo),
        .read_port(rd_mul_9_2_ext_size.fifo)
        );
        
        //extsize<->mul_9_3
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul9_3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_3_ext_size.fifo),
        .read_port(rd_mul_9_3_ext_size.fifo)
        );
                
        //extsize<->mul_9_4
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul9_4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_4_ext_size.fifo),
        .read_port(rd_mul_9_4_ext_size.fifo)
        );
        
        //extsize<->mul_9_5
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul9_5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_5_ext_size.fifo),
        .read_port(rd_mul_9_5_ext_size.fifo)
        );        
        
        //extsize<->mul_9_6
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul9_6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_6_ext_size.fifo),
        .read_port(rd_mul_9_6_ext_size.fifo)
        );
                
        //extsize<->mul_9_7
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul9_7
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_7_ext_size.fifo),
        .read_port(rd_mul_9_7_ext_size.fifo)
        );
                
    //DARK YELLOW: INPUT OPA MUL9 (x8)

        //inport<->mul_9_0
        fifo_sr #(8,DEPTH,FLUX) fifo_inport_mul9_0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_0_opA.fifo),
        .read_port(rd_mul_9_0_opA.fifo)
        );
    
        //delay_0<->mul_9_1
        fifo_sr #(8,DEPTH,FLUX) fifo_delay0_mul9_1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_1_opA.fifo),
        .read_port(rd_mul_9_1_opA.fifo)
        );

        //delay_1<->mul_9_2
        fifo_sr #(8,DEPTH,FLUX) fifo_delay1_mul9_2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_2_opA.fifo),
        .read_port(rd_mul_9_2_opA.fifo)
        );
    
        //delay_2<->mul_9_3
        fifo_sr #(8,DEPTH,FLUX) fifo_delay2_mul_9_3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_3_opA.fifo),
        .read_port(rd_mul_9_3_opA.fifo)
        );

        //delay_3<->mul_9_4
        fifo_sr #(8,DEPTH,FLUX) fifo_delay3_mul9_4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_4_opA.fifo),
        .read_port(rd_mul_9_4_opA.fifo)
        );
    
        //delay_4<->mul_9_5
        fifo_sr #(8,DEPTH,FLUX) fifo_delay4_mul_9_5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_5_opA.fifo),
        .read_port(rd_mul_9_5_opA.fifo)
        );

        //delay_5<->mul_9_6
        fifo_sr #(8,DEPTH,FLUX) fifo_delay5_mul_9_6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_9_6_opA.fifo),
        .read_port(rd_mul_9_6_opA.fifo)
        );
    
        //delay_6<->mul_9_7
        fifo_sr #(8,DEPTH,FLUX) fifo_delay6_mul_9_7
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_delay_6_out_pel.fifo),
        .read_port(rd_mul_9_7_opA.fifo)
        );

                    
    //BEIGE: INPUT OPB MUL9 (x8)
        
        //coeff_luma_h<->mul_9_0
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_h_mul_9_0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_h_c7.fifo),
        .read_port(rd_mul_9_0_opB.fifo)
        );        

        //coeff_luma_h<->mul_9_1
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_h_mul_9_1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_h_c6.fifo),
        .read_port(rd_mul_9_1_opB.fifo)
        );
        
        //coeff_luma_h<->mul_9_2
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_h_mul_9_2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_h_c5.fifo),
        .read_port(rd_mul_9_2_opB.fifo)
        );        

        //coeff_luma_h<->mul_9_3
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_h_mul_9_3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_h_c4.fifo),
        .read_port(rd_mul_9_3_opB.fifo)
        );        

        //coeff_luma_h<->mul_9_0
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_h_mul_9_4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_h_c3.fifo),
        .read_port(rd_mul_9_4_opB.fifo)
        );        

        //coeff_luma_h<->mul_9_5
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_h_mul_9_5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_h_c2.fifo),
        .read_port(rd_mul_9_5_opB.fifo)
        );
        
        //coeff_luma_h<->mul_9_6
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_h_mul_9_6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_h_c1.fifo),
        .read_port(rd_mul_9_6_opB.fifo)
        );        

        //coeff_luma_h<->mul_9_7
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_h_mul_9_7
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_h_c0.fifo),
        .read_port(rd_mul_9_7_opB.fifo)
        );
        
    //YELLOW: INPUT IN_PEL REMOVE H (x1)
    
        //add_18_6<->remove_h
        fifo_sr #(18,DEPTH,FLUX) fifo_add18_6_remove_h
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_18_6_sum.fifo),
        .read_port(rd_remove_h_in_pel.fifo)
        );    
    
    //LIME: INPUT EXTSIZE REMOVE H (x1)
    
        //extsize<->remove_h
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_remove_h
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_remove_h_ext_size.fifo),
        .read_port(rd_remove_h_ext_size.fifo)
        );
    
    //LIGHT BLUE: INPUT EXTSIZE DERIVE REAL SIZE (x1)
        
        //extsize<->derive_real_size
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_derive_real_size
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_derive_real_size_ext_size.fifo),
        .read_port(rd_derive_real_size_ext_size.fifo)
        );        

        
//ACTOR - FIRST HALF CIRCUIT

    //DELAY (x7); I: ORANGE - O: ORANGE / DARK YELLOW
     
        //delay0
        delay #(FLUX) delay_0 
        (
        .clk(clk),
        .rst(rst),
        .read_port_in_pel(rd_delay_0_in_pel.actor),
        .write_port_out_pel(wr_delay_0_out_pel.actor)        
        );
         
        //delay1 
        delay #(FLUX) delay_1 
        (
        .clk(clk),
        .rst(rst),
        .read_port_in_pel(rd_delay_1_in_pel.actor),
        .write_port_out_pel(wr_delay_1_out_pel.actor)        
        );    
        
        //delay2
        delay #(FLUX) delay_2 
        (
        .clk(clk),
        .rst(rst),
        .read_port_in_pel(rd_delay_2_in_pel.actor),
        .write_port_out_pel(wr_delay_2_out_pel.actor)        
        );
         
        //delay3 
        delay #(FLUX) delay_3 
        (
        .clk(clk),
        .rst(rst),
        .read_port_in_pel(rd_delay_3_in_pel.actor),
        .write_port_out_pel(wr_delay_3_out_pel.actor)        
        );    
    
        //delay4
        delay #(FLUX) delay_4 
        (
        .clk(clk),
        .rst(rst),
        .read_port_in_pel(rd_delay_4_in_pel.actor),
        .write_port_out_pel(wr_delay_4_out_pel.actor)        
        );
         
        //delay5 
        delay #(FLUX) delay_5 
        (
        .clk(clk),
        .rst(rst),
        .read_port_in_pel(rd_delay_5_in_pel.actor),
        .write_port_out_pel(wr_delay_5_out_pel.actor)        
        );    
    
        //delay6 
        delay #(FLUX) delay_6 
        (
        .clk(clk),
        .rst(rst),
        .read_port_in_pel(rd_delay_6_in_pel.actor),
        .write_port_out_pel(wr_delay_6_out_pel.actor)        
        );
    
    //COEFF_LUMA_H (x1); I: BLACK - O: BEIGE
    
        //coeff_luma_h
        coeff_luma #(FLUX) coeff_luma_h 
        (
        .read_port_alpha(rd_coeff_luma_h_alpha.actor),
        .write_port_c0(wr_coeff_luma_h_c0.actor),
        .write_port_c1(wr_coeff_luma_h_c1.actor),
        .write_port_c2(wr_coeff_luma_h_c2.actor),
        .write_port_c3(wr_coeff_luma_h_c3.actor),
        .write_port_c4(wr_coeff_luma_h_c4.actor),
        .write_port_c5(wr_coeff_luma_h_c5.actor),
        .write_port_c6(wr_coeff_luma_h_c6.actor),
        .write_port_c7(wr_coeff_luma_h_c7.actor)                               
        );    
    
        //COEFF_LUMA_V (x1); I: BLACK - O: GREEN (2°HALF)
        
        //coeff_luma_v
        coeff_luma #(FLUX) coeff_luma_v 
        (
        .read_port_alpha(rd_coeff_luma_v_alpha.actor),
        .write_port_c0(wr_coeff_luma_v_c0.actor),
        .write_port_c1(wr_coeff_luma_v_c1.actor),
        .write_port_c2(wr_coeff_luma_v_c2.actor),
        .write_port_c3(wr_coeff_luma_v_c3.actor),
        .write_port_c4(wr_coeff_luma_v_c4.actor),
        .write_port_c5(wr_coeff_luma_v_c5.actor),
        .write_port_c6(wr_coeff_luma_v_c6.actor),
        .write_port_c7(wr_coeff_luma_v_c7.actor)                               
        );

    //ADD18 (x7); I: BORDEAUX/GREEN - O: GREEN / YELLOW
    
        //add18_0
        add_18 #(FLUX) add18_0
        (
        .read_port_opA(rd_add_18_0_opA.actor),
        .read_port_opB(rd_add_18_0_opB.actor),    
        .write_port_sum(wr_add_18_0_sum.actor)        
        );
    
        //add18_1 
        add_18 #(FLUX) add18_1 
        (
        .read_port_opA(rd_add_18_1_opA.actor),
        .read_port_opB(rd_add_18_1_opB.actor),    
        .write_port_sum(wr_add_18_1_sum.actor)        
        );
    
        //add18_2
        add_18 #(FLUX) add18_2 
        (
        .read_port_opA(rd_add_18_2_opA.actor),
        .read_port_opB(rd_add_18_2_opB.actor),    
        .write_port_sum(wr_add_18_2_sum.actor)        
        );
    
        //add18_3
        add_18 #(FLUX) add18_3
        (
        .read_port_opA(rd_add_18_3_opA.actor),
        .read_port_opB(rd_add_18_3_opB.actor),    
        .write_port_sum(wr_add_18_3_sum.actor)        
        );
        
        //add18_4 
        add_18 #(FLUX) add18_4 
        (
        .read_port_opA(rd_add_18_4_opA.actor),
        .read_port_opB(rd_add_18_4_opB.actor),    
        .write_port_sum(wr_add_18_4_sum.actor)        
        );
    
        //add18_5 
        add_18 #(FLUX) add18_5 
        (
        .read_port_opA(rd_add_18_5_opA.actor),
        .read_port_opB(rd_add_18_5_opB.actor),    
        .write_port_sum(wr_add_18_5_sum.actor)        
        );
        
        //add18_6
        add_18 #(FLUX) add18_6
        (
        .read_port_opA(rd_add_18_6_opA.actor),
        .read_port_opB(rd_add_18_6_opB.actor),    
        .write_port_sum(wr_add_18_6_sum.actor)        
        );
        
    //MUL9 (x8); I: DARK YELLOW/RED/BEIGE - O: BORDEAUX / GREEN
    
        //mul9_0
        mul_9 #(FLUX) mul9_0
        (
        .clk(clk),
        .rst(rst),
        .read_port_ext_size(rd_mul_9_0_ext_size.actor),
        .read_port_opA(rd_mul_9_0_opA.actor),
        .read_port_opB(rd_mul_9_0_opB.actor),        
        .write_port_prod(wr_mul_9_0_prod.actor)        
        );
    
        //mul9_1
        mul_9 #(FLUX) mul9_1
        (
        .clk(clk),
        .rst(rst),
        .read_port_ext_size(rd_mul_9_1_ext_size.actor),
        .read_port_opA(rd_mul_9_1_opA.actor),
        .read_port_opB(rd_mul_9_1_opB.actor),        
        .write_port_prod(wr_mul_9_1_prod.actor)        
        );
    
        //mul9_2
        mul_9 #(FLUX) mul9_2
        (
        .clk(clk),
        .rst(rst),
        .read_port_ext_size(rd_mul_9_2_ext_size.actor),
        .read_port_opA(rd_mul_9_2_opA.actor),
        .read_port_opB(rd_mul_9_2_opB.actor),        
        .write_port_prod(wr_mul_9_2_prod.actor)        
        );
    
        //mul9_3
        mul_9 #(FLUX) mul9_3
        (
        .clk(clk),
        .rst(rst),
        .read_port_ext_size(rd_mul_9_3_ext_size.actor),
        .read_port_opA(rd_mul_9_3_opA.actor),
        .read_port_opB(rd_mul_9_3_opB.actor),        
        .write_port_prod(wr_mul_9_3_prod.actor)        
        );
    
        //mul9_4
        mul_9 #(FLUX) mul9_4
        (
        .clk(clk),
        .rst(rst),
        .read_port_ext_size(rd_mul_9_4_ext_size.actor),
        .read_port_opA(rd_mul_9_4_opA.actor),
        .read_port_opB(rd_mul_9_4_opB.actor),        
        .write_port_prod(wr_mul_9_4_prod.actor)        
        );
    
        //mul9_5
        mul_9 #(FLUX) mul9_5
        (
        .clk(clk),
        .rst(rst),
        .read_port_ext_size(rd_mul_9_5_ext_size.actor),
        .read_port_opA(rd_mul_9_5_opA.actor),
        .read_port_opB(rd_mul_9_5_opB.actor),        
        .write_port_prod(wr_mul_9_5_prod.actor)        
        );
    
        //mul9_6
        mul_9 #(FLUX) mul9_6
        (
        .clk(clk),
        .rst(rst),
        .read_port_ext_size(rd_mul_9_6_ext_size.actor),
        .read_port_opA(rd_mul_9_6_opA.actor),
        .read_port_opB(rd_mul_9_6_opB.actor),        
        .write_port_prod(wr_mul_9_6_prod.actor)        
        );
    
        //mul9_7
        mul_9 #(FLUX) mul9_7
        (
        .clk(clk),
        .rst(rst),
        .read_port_ext_size(rd_mul_9_7_ext_size.actor),
        .read_port_opA(rd_mul_9_7_opA.actor),
        .read_port_opB(rd_mul_9_7_opB.actor),        
        .write_port_prod(wr_mul_9_7_prod.actor)        
        );
    
    //REMOVE_H (x1); I: LIME/YELLOW - O: DARK GREY (2°HALF) / RED (2°HALF)

        //remove_h
        remove_h #(FLUX) remove_h
        (
        .clk(clk),
        .rst(rst),
        .read_port_ext_size(rd_remove_h_ext_size.actor),
        .read_port_in_pel(rd_remove_h_in_pel.actor),        
        .write_port_out_pel(wr_remove_h_out_pel.actor)        
        );        
               
    //DERIVE (x1); I: LIGHT BLUE - O: LIME (2°HALF) / BROWN (2°HALF) / ORANGE (2°HALF)

        //derive_real_size
        derive_real_size #(FLUX) derive_real_size
        (
        .read_port_ext_size(rd_derive_real_size_ext_size.actor),       
        .write_port_real_size(wr_derive_real_size_real_size.actor)        
        );


//FIFO - SECOND HALF CIRCUIT
    
    //ORANGE: INPUT REALSIZE MUL18 (x8)
        
        //derive_real_size<->mul18_0
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_mul18_0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_0_real_size.fifo),
        .read_port(rd_mul_18_0_real_size.fifo)
        );

        //derive_real_size<->mul18_1
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_mul18_1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_1_real_size.fifo),
        .read_port(rd_mul_18_1_real_size.fifo)
        );
        
        //derive_real_size<->mul18_2
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_mul18_2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_2_real_size.fifo),
        .read_port(rd_mul_18_2_real_size.fifo)
        );

        //derive_real_size<->mul18_3
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_mul18_3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_3_real_size.fifo),
        .read_port(rd_mul_18_3_real_size.fifo)
        );  
        //derive_real_size<->mul18_4
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_mul18_4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_4_real_size.fifo),
        .read_port(rd_mul_18_4_real_size.fifo)
        );

        //derive_real_size<->mul18_5
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_mul18_5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_5_real_size.fifo),
        .read_port(rd_mul_18_5_real_size.fifo)
        );
        
        //derive_real_size<->mul18_6
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_mul18_6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_6_real_size.fifo),
        .read_port(rd_mul_18_6_real_size.fifo)
        );

        //derive_real_size<->mul18_7
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_mul18_7
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_7_real_size.fifo),
        .read_port(rd_mul_18_7_real_size.fifo)
        );              
            
    //LIGHT GREY: INPUT EXTSIZE MUL18 (x8)

        //extsize<->mul_18_0        
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul18_0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_0_ext_size.fifo),
        .read_port(rd_mul_18_0_ext_size.fifo)
        );        
                
        //extsize<->mul_18_1
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul18_1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_1_ext_size.fifo),
        .read_port(rd_mul_18_1_ext_size.fifo)
        );
                
        //extsize<->mul_18_2
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul18_2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_2_ext_size.fifo),
        .read_port(rd_mul_18_2_ext_size.fifo)
        );
        
        //extsize<->mul_18_3
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul18_3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_3_ext_size.fifo),
        .read_port(rd_mul_18_3_ext_size.fifo)
        );
                
        //extsize<->mul_18_4
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul18_4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_4_ext_size.fifo),
        .read_port(rd_mul_18_4_ext_size.fifo)
        );
        
        //extsize<->mul_18_5
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul18_5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_5_ext_size.fifo),
        .read_port(rd_mul_18_5_ext_size.fifo)
        );        
        
        //extsize<->mul_18_6
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul18_6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_6_ext_size.fifo),
        .read_port(rd_mul_18_6_ext_size.fifo)
        );
                
        //extsize<->mul_18_7
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_mul18_7
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_7_ext_size.fifo),
        .read_port(rd_mul_18_7_ext_size.fifo)
        );    
        
    //DARK GREY: INPUT OPA MUL18 (x8)

        //remove_h<->mul_18_0
        fifo_sr #(18,DEPTH,FLUX) fifo_remove_h_mul18_0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_0_opA.fifo),
        .read_port(rd_mul_18_0_opA.fifo)
        );    

        //line_buffer_0<->mul_18_1
        fifo_sr #(18,DEPTH,FLUX) fifo_line_buffer_0_mul18_1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_1_opA.fifo),
        .read_port(rd_mul_18_1_opA.fifo)
        );

        //line_buffer_1<->mul_18_2
        fifo_sr #(18,DEPTH,FLUX) fifo_line_buffer_1_mul18_2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_2_opA.fifo),
        .read_port(rd_mul_18_2_opA.fifo)
        );
        
        //line_buffer_2<->mul_18_3
        fifo_sr #(18,DEPTH,FLUX) fifo_line_buffer_2_mul18_3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_3_opA.fifo),
        .read_port(rd_mul_18_3_opA.fifo)
        );
        
        //line_buffer_3<->mul_18_4
        fifo_sr #(18,DEPTH,FLUX) fifo_line_buffer_3_mul18_4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_4_opA.fifo),
        .read_port(rd_mul_18_4_opA.fifo)
        );    

        //line_buffer_4<->mul_18_5
        fifo_sr #(18,DEPTH,FLUX) fifo_line_buffer_4_mul18_5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_5_opA.fifo),
        .read_port(rd_mul_18_5_opA.fifo)
        );

        //line_buffer_5<->mul_18_6
        fifo_sr #(18,DEPTH,FLUX) fifo_line_buffer_5_mul18_6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_mul_18_6_opA.fifo),
        .read_port(rd_mul_18_6_opA.fifo)
        );
        
        //line_buffer_6<->mul_18_7
        fifo_sr #(18,DEPTH,FLUX) fifo_line_buffer_6_mul18_7
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_line_buffer_6_out_pel.fifo),
        .read_port(rd_mul_18_7_opA.fifo)
        );
        
    //GREEN: INPUT OPB MUL18 (x8)

        //coeff_luma_v<->mul_18_0
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_v_mul18_0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_v_c7.fifo),
        .read_port(rd_mul_18_0_opB.fifo)
        );        

        //coeff_luma_v<->mul_18_1
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_v_mul18_1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_v_c6.fifo),
        .read_port(rd_mul_18_1_opB.fifo)
        );

        //coeff_luma_v<->mul_18_2
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_v_mul18_2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_v_c5.fifo),
        .read_port(rd_mul_18_2_opB.fifo)
        );        

        //coeff_luma_v<->mul_18_3
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_v_mul18_3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_v_c4.fifo),
        .read_port(rd_mul_18_3_opB.fifo)
        );
        
        //coeff_luma_v<->mul_18_4
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_v_mul18_4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_v_c3.fifo),
        .read_port(rd_mul_18_4_opB.fifo)
        );        

        //coeff_luma_v<->mul_18_5
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_v_mul18_5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_v_c2.fifo),
        .read_port(rd_mul_18_5_opB.fifo)
        );

        //coeff_luma_v<->mul_18_6
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_v_mul18_6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_v_c1.fifo),
        .read_port(rd_mul_18_6_opB.fifo)
        );        

        //coeff_luma_v<->mul_18_7
        fifo_sr #(9,DEPTH,FLUX) fifo_coeff_luma_v_mul18_7
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_coeff_luma_v_c0.fifo),
        .read_port(rd_mul_18_7_opB.fifo)
        );
            
    //BORDEAUX: INPUT OPA ADD 27 (x7)

        //mul_18_1<->add_27_0
        fifo_sr #(27,DEPTH,FLUX) fifo_mul18_1_add27_0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_18_1_prod.fifo),
        .read_port(rd_add_27_0_opA.fifo)
        );        

        //mul_18_2<->add_27_1
        fifo_sr #(27,DEPTH,FLUX) fifo_mul18_2_add27_1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_18_2_prod.fifo),
        .read_port(rd_add_27_1_opA.fifo)
        );
        
        //mul_18_3<->add_27_2
        fifo_sr #(27,DEPTH,FLUX) fifo_mul18_3_add27_2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_18_3_prod.fifo),
        .read_port(rd_add_27_2_opA.fifo)
        );

        //mul_18_4<->add_27_3
        fifo_sr #(27,DEPTH,FLUX) fifo_mul18_4_add27_3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_18_4_prod.fifo),
        .read_port(rd_add_27_3_opA.fifo)
        );
        
        //mul_18_5<->add_27_4
        fifo_sr #(27,DEPTH,FLUX) fifo_mul18_5_add27_4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_18_5_prod.fifo),
        .read_port(rd_add_27_4_opA.fifo)
        );

        //mul_18_6<->add_27_5
        fifo_sr #(27,DEPTH,FLUX) fifo_mul18_6_add27_5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_18_6_prod.fifo),
        .read_port(rd_add_27_5_opA.fifo)
        );
        
        //mul_18_7<->add_27_6
        fifo_sr #(27,DEPTH,FLUX) fifo_mul18_7_add27_6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_18_7_prod.fifo),
        .read_port(rd_add_27_6_opA.fifo)
        );
                               
    //DARK YELLOW: INPUT OPB ADD 27 (x7)
        
        //mul_18_0<->add_27_0
        fifo_sr #(27,DEPTH,FLUX) fifo_mul18_0_add27_0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_mul_18_0_prod.fifo),
        .read_port(rd_add_27_0_opB.fifo)
        );        
     
        //add_27_0<->add_27_1
        fifo_sr #(27,DEPTH,FLUX) fifo_add27_0_add27_1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_27_0_sum.fifo),
        .read_port(rd_add_27_1_opB.fifo)
        );

        //add_27_1<->add_27_2
        fifo_sr #(27,DEPTH,FLUX) fifo_add27_1_add27_2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_27_1_sum.fifo),
        .read_port(rd_add_27_2_opB.fifo)
        );
     
        //add_27_2<->add_27_3
        fifo_sr #(27,DEPTH,FLUX) fifo_add27_2_add27_3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_27_2_sum.fifo),
        .read_port(rd_add_27_3_opB.fifo)
        );

        //add_27_3<->add_27_4
        fifo_sr #(27,DEPTH,FLUX) fifo_add27_3_add27_4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_27_3_sum.fifo),
        .read_port(rd_add_27_4_opB.fifo)
        );        
       
        //add_27_4<->add_27_5
        fifo_sr #(27,DEPTH,FLUX) fifo_add27_4_add27_5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_27_4_sum.fifo),
        .read_port(rd_add_27_5_opB.fifo)
        );       

        //add_27_5<->add_27_6
        fifo_sr #(27,DEPTH,FLUX) fifo_add27_5_add27_6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_27_5_sum.fifo),
        .read_port(rd_add_27_6_opB.fifo)
        );
        
    //LIME: INPUT REALSIZE LINE BUFFER (x7)
        
        //derive_real_size<->line_buffer_0
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_line_buffer_0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_0_real_size.fifo),
        .read_port(rd_line_buffer_0_real_size.fifo)
        );

        //derive_real_size<->line_buffer_1
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_line_buffer_1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_1_real_size.fifo),
        .read_port(rd_line_buffer_1_real_size.fifo)
        );
        
        //derive_real_size<->line_buffer_2
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_line_buffer_2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_2_real_size.fifo),
        .read_port(rd_line_buffer_2_real_size.fifo)
        );

        //derive_real_size<->line_buffer_3
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_line_buffer_3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_3_real_size.fifo),
        .read_port(rd_line_buffer_3_real_size.fifo)
        );  
        //derive_real_size<->line_buffer_4
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_line_buffer_4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_4_real_size.fifo),
        .read_port(rd_line_buffer_4_real_size.fifo)
        );

        //derive_real_size<->line_buffer_5
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_line_buffer_5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_5_real_size.fifo),
        .read_port(rd_line_buffer_5_real_size.fifo)
        );
        
        //derive_real_size<->line_buffer_6
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_line_buffer_6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_6_real_size.fifo),
        .read_port(rd_line_buffer_6_real_size.fifo)
        );        
                
    //LIGHT BLUE: INPUT EXTSIZE LINE BUFFER (x7)
        
        //extsize<->line_buffer_0
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_linebuffer0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_0_ext_size.fifo),
        .read_port(rd_line_buffer_0_ext_size.fifo)
        );    

        //extsize<->line_buffer_1
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_linebuffer1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_1_ext_size.fifo),
        .read_port(rd_line_buffer_1_ext_size.fifo)
        );

        //extsize<->line_buffer_2
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_linebuffer2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_2_ext_size.fifo),
        .read_port(rd_line_buffer_2_ext_size.fifo)
        );

        //extsize<->line_buffer_3
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_linebuffer3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_3_ext_size.fifo),
        .read_port(rd_line_buffer_3_ext_size.fifo)
        );

        //extsize<->line_buffer_4
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_linebuffer4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_4_ext_size.fifo),
        .read_port(rd_line_buffer_4_ext_size.fifo)
        );

        //extsize<->line_buffer_5
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_linebuffer5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_5_ext_size.fifo),
        .read_port(rd_line_buffer_5_ext_size.fifo)
        );

        //extsize<->line_buffer_6
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_linebuffer6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_6_ext_size.fifo),
        .read_port(rd_line_buffer_6_ext_size.fifo)
        );
    
    //RED: INPUT INPEL LINE BUFFER (x7)

       //remove_h<->line_buffer_0
        fifo_sr #(18,DEPTH,FLUX) fifo_remove_h_line_buffer_0
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_0_in_pel.fifo),
        .read_port(rd_line_buffer_0_in_pel.fifo)
        );    

        //line_buffer_0<->line_buffer_1
        fifo_sr #(18,DEPTH,FLUX) fifo_line_buffer_0_line_buffer_1
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_1_in_pel.fifo),
        .read_port(rd_line_buffer_1_in_pel.fifo)
        );

        //line_buffer_1<->line_buffer_2
        fifo_sr #(18,DEPTH,FLUX) fifo_line_buffer_1_line_buffer_2
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_2_in_pel.fifo),
        .read_port(rd_line_buffer_2_in_pel.fifo)
        );
        
        //line_buffer_2<->line_buffer_3
        fifo_sr #(18,DEPTH,FLUX) fifo_line_buffer_2_line_buffer_3
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_3_in_pel.fifo),
        .read_port(rd_line_buffer_3_in_pel.fifo)
        );
        
        //line_buffer_3<->line_buffer_4
        fifo_sr #(18,DEPTH,FLUX) fifo_line_buffer_3_line_buffer_4
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_4_in_pel.fifo),
        .read_port(rd_line_buffer_4_in_pel.fifo)
        );    
        
        //line_buffer_4<->line_buffer_5
        fifo_sr #(18,DEPTH,FLUX) fifo_line_buffer_4_line_buffer_5
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_5_in_pel.fifo),
        .read_port(rd_line_buffer_5_in_pel.fifo)
        );

        //line_buffer_5<->line_buffer_6
        fifo_sr #(18,DEPTH,FLUX) fifo_line_buffer_5_line_buffer_6
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_line_buffer_6_in_pel.fifo),
        .read_port(rd_line_buffer_6_in_pel.fifo)
        );
    
    //VIOLET: INPUT INPEL SHIFT (x1)
        
        //add_27_6<->shift
        fifo_sr #(27,DEPTH,FLUX) fifo_add27_6_shift
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_add_27_6_sum.fifo),
        .read_port(rd_shift_in_pel.fifo)
        );        
    
    //FUCSIA: INPUT INPEL CLIP (x1)    
    
        //shift<->clip
        fifo_sr #(16,DEPTH,FLUX) fifo_shift_clip
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_shift_out_pel.fifo),
        .read_port(rd_clip_in_pel.fifo)
        );
    
    //BROWN: INPUT REALSIZE REMOVE V
    
        //derive_real_size<->remove_v
        fifo_sr #(7,DEPTH,FLUX) fifo_derive_real_size_remove_v
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_remove_v_real_size.fifo),
        .read_port(rd_remove_v_real_size.fifo)
        );
    
    //BLUE: INPUT EXTSIZE REMOVE V
    
        //extsize<->remove_v
        fifo_sr #(7,DEPTH,FLUX) fifo_extsize_remove_v
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_fifo_remove_v_ext_size.fifo),
        .read_port(rd_remove_v_ext_size.fifo)
        );       
        
    //PINK: INPUT INPEL REMOVE V

        //clip<->remove_v
        fifo_sr #(8,DEPTH,FLUX) fifo_clip_remove_v
        (
        .clk(clk),
        .rst(rst),
        .write_port(wr_clip_out_pel.fifo),
        .read_port(rd_remove_v_in_pel.fifo)
        );


//ACTORS - SECOND HALF CIRCUIT

    //MUL18 (x8); I: ORANGE (1°HALF) / LIGHT GREY (1°HALF) / GREEN (1°HALF) / DARK GREY (1°-2° HALF) - O: BORDEAUX / DARK YELLOW

        //mul18_0
        mul_18 #(FLUX) mul18_0
        (
        .clk(clk),
        .rst(rst),
        .read_port_real_size(rd_mul_18_0_real_size.actor),        
        .read_port_ext_size(rd_mul_18_0_ext_size.actor),        
        .read_port_opA(rd_mul_18_0_opA.actor),
        .read_port_opB(rd_mul_18_0_opB.actor),        
        .write_port_prod(wr_mul_18_0_prod.actor)        
        );
        
        //mul18_1
        mul_18 #(FLUX) mul18_1
        (
        .clk(clk),
        .rst(rst),
        .read_port_real_size(rd_mul_18_1_real_size.actor),        
        .read_port_ext_size(rd_mul_18_1_ext_size.actor),        
        .read_port_opA(rd_mul_18_1_opA.actor),
        .read_port_opB(rd_mul_18_1_opB.actor),        
        .write_port_prod(wr_mul_18_1_prod.actor)        
        );
        
        //mul18_2
        mul_18 #(FLUX) mul18_2
        (
        .clk(clk),
        .rst(rst),
        .read_port_real_size(rd_mul_18_2_real_size.actor),        
        .read_port_ext_size(rd_mul_18_2_ext_size.actor),        
        .read_port_opA(rd_mul_18_2_opA.actor),
        .read_port_opB(rd_mul_18_2_opB.actor),        
        .write_port_prod(wr_mul_18_2_prod.actor)        
        );
        
        //mul18_3
        mul_18 #(FLUX) mul18_3
        (
        .clk(clk),
        .rst(rst),
        .read_port_real_size(rd_mul_18_3_real_size.actor),        
        .read_port_ext_size(rd_mul_18_3_ext_size.actor),        
        .read_port_opA(rd_mul_18_3_opA.actor),
        .read_port_opB(rd_mul_18_3_opB.actor),        
        .write_port_prod(wr_mul_18_3_prod.actor)        
        );
        
        //mul18_4
        mul_18 #(FLUX) mul18_4
        (
        .clk(clk),
        .rst(rst),
        .read_port_real_size(rd_mul_18_4_real_size.actor),        
        .read_port_ext_size(rd_mul_18_4_ext_size.actor),        
        .read_port_opA(rd_mul_18_4_opA.actor),
        .read_port_opB(rd_mul_18_4_opB.actor),        
        .write_port_prod(wr_mul_18_4_prod.actor)        
        );
        
        //mul18_5
        mul_18 #(FLUX) mul18_5
        (
        .clk(clk),
        .rst(rst),
        .read_port_real_size(rd_mul_18_5_real_size.actor),        
        .read_port_ext_size(rd_mul_18_5_ext_size.actor),        
        .read_port_opA(rd_mul_18_5_opA.actor),
        .read_port_opB(rd_mul_18_5_opB.actor),        
        .write_port_prod(wr_mul_18_5_prod.actor)        
        );
        
        //mul18_6
        mul_18 #(FLUX) mul18_6
        (
        .clk(clk),
        .rst(rst),
        .read_port_real_size(rd_mul_18_6_real_size.actor),        
        .read_port_ext_size(rd_mul_18_6_ext_size.actor),        
        .read_port_opA(rd_mul_18_6_opA.actor),
        .read_port_opB(rd_mul_18_6_opB.actor),        
        .write_port_prod(wr_mul_18_6_prod.actor)        
        );
        
        //mul18_7
        mul_18 #(FLUX) mul18_7
        (
        .clk(clk),
        .rst(rst),
        .read_port_real_size(rd_mul_18_7_real_size.actor),        
        .read_port_ext_size(rd_mul_18_7_ext_size.actor),        
        .read_port_opA(rd_mul_18_7_opA.actor),
        .read_port_opB(rd_mul_18_7_opB.actor),        
        .write_port_prod(wr_mul_18_7_prod.actor)        
        );                        
        
    //ADD27 (x7); I: BORDEAUX / DARK YELLOW - O: DARK YELLOW / VIOLET

        //add27_0
        add_27 #(FLUX) add27_0
        (
        .read_port_opA(rd_add_27_0_opA.actor),
        .read_port_opB(rd_add_27_0_opB.actor),    
        .write_port_sum(wr_add_27_0_sum.actor)        
        );
    
        //add27_1 
        add_27 #(FLUX) add27_1 
        (
        .read_port_opA(rd_add_27_1_opA.actor),
        .read_port_opB(rd_add_27_1_opB.actor),    
        .write_port_sum(wr_add_27_1_sum.actor)        
        );
    
        //add27_2
        add_27 #(FLUX) add27_2 
        (
        .read_port_opA(rd_add_27_2_opA.actor),
        .read_port_opB(rd_add_27_2_opB.actor),    
        .write_port_sum(wr_add_27_2_sum.actor)        
        );
    
        //add27_3
        add_27 #(FLUX) add27_3
        (
        .read_port_opA(rd_add_27_3_opA.actor),
        .read_port_opB(rd_add_27_3_opB.actor),    
        .write_port_sum(wr_add_27_3_sum.actor)        
        );
        
        //add27_4 
        add_27 #(FLUX) add27_4 
        (
        .read_port_opA(rd_add_27_4_opA.actor),
        .read_port_opB(rd_add_27_4_opB.actor),    
        .write_port_sum(wr_add_27_4_sum.actor)        
        );
    
        //add27_5 
        add_27 #(FLUX) add27_5 
        (
        .read_port_opA(rd_add_27_5_opA.actor),
        .read_port_opB(rd_add_27_5_opB.actor),    
        .write_port_sum(wr_add_27_5_sum.actor)        
        );
        
        //add27_6
        add_27 #(FLUX) add27_6
        (
        .read_port_opA(rd_add_27_6_opA.actor),
        .read_port_opB(rd_add_27_6_opB.actor),    
        .write_port_sum(wr_add_27_6_sum.actor)        
        );        
        
    //LINE BUFFER (x7); I: LIME (1°HALF) / LIGHT BLUE (1°HALF) / RED (1°-2°HALF) - O: DARK GREY / RED

        //line_buffer_0
        line_buffer #(FLUX) line_buffer0
        (
        .clk(clk),
        .rst(rst),        
        .read_port_real_size(rd_line_buffer_0_real_size.actor),
        .read_port_ext_size(rd_line_buffer_0_ext_size.actor),
        .read_port_in_pel(rd_line_buffer_0_in_pel.actor),            
        .write_port_out_pel(wr_line_buffer_0_out_pel.actor)        
        );

        //line_buffer_1
        line_buffer #(FLUX) line_buffer1
        (
        .clk(clk),
        .rst(rst),        
        .read_port_real_size(rd_line_buffer_1_real_size.actor),
        .read_port_ext_size(rd_line_buffer_1_ext_size.actor),
        .read_port_in_pel(rd_line_buffer_1_in_pel.actor),            
        .write_port_out_pel(wr_line_buffer_1_out_pel.actor)        
        );        
        
        //line_buffer_2
        line_buffer #(FLUX) line_buffer2
        (
        .clk(clk),
        .rst(rst),        
        .read_port_real_size(rd_line_buffer_2_real_size.actor),
        .read_port_ext_size(rd_line_buffer_2_ext_size.actor),
        .read_port_in_pel(rd_line_buffer_2_in_pel.actor),            
        .write_port_out_pel(wr_line_buffer_2_out_pel.actor)        
        );

        //line_buffer_3
        line_buffer #(FLUX) line_buffer3
        (
        .clk(clk),
        .rst(rst),        
        .read_port_real_size(rd_line_buffer_3_real_size.actor),
        .read_port_ext_size(rd_line_buffer_3_ext_size.actor),
        .read_port_in_pel(rd_line_buffer_3_in_pel.actor),            
        .write_port_out_pel(wr_line_buffer_3_out_pel.actor)        
        );        
        
        //line_buffer_4
        line_buffer #(FLUX) line_buffer4
        (
        .clk(clk),
        .rst(rst),        
        .read_port_real_size(rd_line_buffer_4_real_size.actor),
        .read_port_ext_size(rd_line_buffer_4_ext_size.actor),
        .read_port_in_pel(rd_line_buffer_4_in_pel.actor),            
        .write_port_out_pel(wr_line_buffer_4_out_pel.actor)        
        );
        
        //line_buffer_5
        line_buffer #(FLUX) line_buffer5
        (
        .clk(clk),
        .rst(rst),        
        .read_port_real_size(rd_line_buffer_5_real_size.actor),
        .read_port_ext_size(rd_line_buffer_5_ext_size.actor),
        .read_port_in_pel(rd_line_buffer_5_in_pel.actor),            
        .write_port_out_pel(wr_line_buffer_5_out_pel.actor)        
        );        
        
        //line_buffer_6
        line_buffer #(FLUX) line_buffer6
        (
        .clk(clk),
        .rst(rst),        
        .read_port_real_size(rd_line_buffer_6_real_size.actor),
        .read_port_ext_size(rd_line_buffer_6_ext_size.actor),
        .read_port_in_pel(rd_line_buffer_6_in_pel.actor),            
        .write_port_out_pel(wr_line_buffer_6_out_pel.actor)        
        ); 
        
    //SHIFT (x1); I: VIOLET - O: FUCSIA
    
        //shift 
        shift #(FLUX) shift
        (
        .read_port_in_pel(rd_shift_in_pel.actor),    
        .write_port_out_pel(wr_shift_out_pel.actor)        
        );
        
    //CLIP (x1); I: FUCSIA - O: PINK

        //clip 
        clip #(FLUX) clip
        (
        .read_port_in_pel(rd_clip_in_pel.actor),    
        .write_port_out_pel(wr_clip_out_pel.actor)        
        );
    
    //REMOVE_V (x1); I: PINK / BLUE / BROWN - O: NULL
    
        //remove_v
        remove_v #(FLUX) remove_v
        (
        .clk(clk),
        .rst(rst),
        .read_port_real_size(rd_remove_v_real_size.actor),
        .read_port_ext_size(rd_remove_v_ext_size.actor),
        .read_port_in_pel(rd_remove_v_in_pel.actor),    
        .write_port_out_pel(wr_remove_v_out_pel.actor)        
        ); 
    
    
endmodule

