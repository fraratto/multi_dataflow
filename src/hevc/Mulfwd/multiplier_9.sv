//COMPLETED AND TESTED

`timescale 1ns / 1ps
`include "fifo_interface.sv"
`include "ram_interface.sv"

//TESTBENCHED; EVERYTHING'S OK
//NAME OF PORTS AS SCHEMATIC
//`define MONO 1

module mul_9#
(
    FLUX=2                   
)(
    input clk,
    input rst,        
    write_interface.actor write_port_prod,                               
    read_interface.actor read_port_opA,                               
    read_interface.actor read_port_opB,                               
    read_interface.actor read_port_ext_size                         
);

    `ifdef MONO  
    parameter TAG_WIDTH = 0;        
    `else
    parameter TAG_WIDTH = $clog2(FLUX);			
 	`endif

    //local parameters
    parameter DATA_WIDTH_EXT=7;                                
    parameter DATA_WIDTH_OP_A=8;                                        
    parameter DATA_WIDTH_OP_B=9;                                    
    parameter DATA_WIDTH=18;        
    parameter WIDTH_EXT_SIZE=DATA_WIDTH_EXT+TAG_WIDTH;
    parameter WIDTH=DATA_WIDTH+TAG_WIDTH;
    parameter WIDTH_OP_B=DATA_WIDTH_OP_B+TAG_WIDTH;
    parameter WIDTH_OP_A=DATA_WIDTH_OP_A+TAG_WIDTH;    
    
    //state parameters
    parameter IDLE=0;
    parameter WORK=1;
        
    //cnt h
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] cnt_h_out;               //operation count signal
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] cnt_h_in;           //next operation count signal
    logic [TAG_WIDTH-1:0] cnt_h_read_addr;
    logic [TAG_WIDTH-1:0] cnt_h_write_addr;    
    logic en_cnt_h;                                                 //enable signal
    
    //cnt_h memory     
	ram_interface #(DATA_WIDTH_EXT, FLUX) cnt_h_port (clk);
	assign cnt_h_port.din = cnt_h_in;
	assign cnt_h_port.write_address = cnt_h_write_addr;
	assign cnt_h_port.read_address = cnt_h_read_addr; 
	assign cnt_h_port.write_en = en_cnt_h;
	assign cnt_h_out= cnt_h_port.dout;

	ram_dual_ported #(
		.DEPTH(FLUX),
		.WIDTH(DATA_WIDTH_EXT)
		) cnt_h_mem (
		.port(cnt_h_port.slave)
		);
    
    //cnt v    
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] cnt_v_out;               //operation count signal    
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] cnt_v_in;           //next operation count signal
    logic [TAG_WIDTH-1:0] cnt_v_read_addr;
    logic [TAG_WIDTH-1:0] cnt_v_write_addr;     
    logic en_cnt_v;                                                 //enable signal
    
    //cnt_v memory     
	ram_interface #(DATA_WIDTH_EXT, FLUX) cnt_v_port (clk);
	assign cnt_v_port.din = cnt_v_in;
	assign cnt_v_port.write_address = cnt_v_write_addr;
	assign cnt_v_port.read_address = cnt_v_read_addr; 
	assign cnt_v_port.write_en = en_cnt_v;
	assign cnt_v_out = cnt_v_port.dout;

	ram_dual_ported #(
		.DEPTH(FLUX),
		.WIDTH(DATA_WIDTH_EXT)
		) cnt_v_mem (
		.port(cnt_v_port.slave)
		);    
        
    //state
    logic [FLUX-1:0] state_out;                                                //state signal
    logic state_in;                                            //next state signal        
    logic en_state;                                                 //enable signal
    
    //coeff
    logic signed [WIDTH_OP_B-(TAG_WIDTH)-1:0] coeff_out;            //coeff signal
    logic signed [WIDTH_OP_B-(TAG_WIDTH)-1:0] coeff_in;        //next coeff signal
    logic [TAG_WIDTH-1:0] coeff_read_addr;
    logic [TAG_WIDTH-1:0] coeff_write_addr;    
    logic en_coeff;                                                 //enable signal
    
    //coeff memory     
	ram_interface #(DATA_WIDTH_OP_B, FLUX) coeff_port (clk);
	assign coeff_port.din = coeff_in;
	assign coeff_port.write_address = coeff_write_addr;
	assign coeff_port.read_address = coeff_read_addr; 
	assign coeff_port.write_en = en_coeff;
	assign coeff_out = coeff_port.dout;

	ram_dual_ported #(
		.DEPTH(FLUX),
		.WIDTH(DATA_WIDTH_OP_B)
		) coeff_mem (
		.port(coeff_port.slave)
		);    
            
    //max    
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] max_out;                 //max signal
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] max_in;             //next max signal
    logic [TAG_WIDTH-1:0] max_read_addr;
    logic [TAG_WIDTH-1:0] max_write_addr; 
    logic en_max;                                                   //enable signal
    
    //max memory    
	ram_interface #(DATA_WIDTH_EXT, FLUX) max_port (clk);
	assign max_port.din = max_in;
	assign max_port.write_address = max_write_addr;
	assign max_port.read_address = max_read_addr; 
	assign max_port.write_en = en_max;
	assign max_out = max_port.dout;

	ram_dual_ported #(
		.DEPTH(FLUX),
		.WIDTH(DATA_WIDTH_EXT)
		) max_mem (
		.port(max_port.slave)
		);    
    
    //operators
    logic signed [WIDTH_OP_A-(TAG_WIDTH):0] adapter;              //needed for adapting input for operation    
    logic signed [WIDTH-(TAG_WIDTH)-1:0] op_A;                      //needed for operation
    
    //external combinatory elements
    logic [TAG_WIDTH:0] tag;                                      //priority data
    logic eqv_read_A;                                               //read port A
    logic eqv_read_B;                                               //read port B
    logic eqv_read_ext_size;                                        //read port ext_size
    
    //loops
    integer i,j;                                                    //needed for loops
    
    //combinatory logic/elaboration of data 
    always_comb
    
        begin
           
            //choice about which data flux will be elaborated by the actor 
            for(i=0;i<=FLUX-1;i=i+1)
                begin                    
                    if(
                      (read_port_opB.empty[i]==0 & read_port_ext_size.empty[i]==0 & state_out[i]==IDLE)
                    | (read_port_opA.empty[i]==0 & state_out[i]==WORK & write_port_prod.full[i]==0)
                        )
                        begin
                            tag=i; 
                            break;
                        end
                    else
                        tag='1;
                end     
           
            
            if(!tag[TAG_WIDTH])
                begin    
                
                    //initial common element assignments	   
                    //read addr	   
                    cnt_h_read_addr=tag;
                    cnt_v_read_addr=tag;                    
                    max_read_addr=tag;
                    coeff_read_addr=tag;
                                        
                    //write addr
                    cnt_h_write_addr=tag;
                    cnt_v_write_addr=tag;
                    max_write_addr=tag;
                    coeff_write_addr=tag;
                                                                    
                    //condizione 1 
                    if(state_out[tag]==IDLE)
                        begin
                            //read
                                eqv_read_A = 0;
                                eqv_read_B = 1;
                                eqv_read_ext_size = 1;
                            //write
                                op_A='x;                           
                                write_port_prod.din = 'x; 
                                write_port_prod.write = 0;                                    
                            //state
                                state_in = WORK;
                                en_state = 1;
                            //max
                                max_in = read_port_ext_size.dout[WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0];
                                en_max = 1;
                            //coeff
                                coeff_in = read_port_opB.dout[WIDTH_OP_B-(TAG_WIDTH)-1:0];
                                en_coeff = 1;
                            //cnt v    
                                cnt_v_in = cnt_v_out;
                                en_cnt_v = 0;
                            //cnt h
                                cnt_h_in = cnt_h_out;    
                                en_cnt_h = 0;
                        end
                    //condizione 2     
                    else if(state_out[tag]==WORK & cnt_h_out<max_out-1 & cnt_v_out<max_out)
                        begin
                            //read
                                eqv_read_A = 1;
                                eqv_read_B = 0;
                                eqv_read_ext_size = 0;
                            //write                        
                                adapter={1'b0,read_port_opA.dout[WIDTH_OP_A-(TAG_WIDTH)-1:0]};  
                                op_A=adapter*coeff_out;                                                                   
                                write_port_prod.din ={tag, op_A}; 
                                write_port_prod.write = 1;                                    
                            //state
                                state_in = WORK;
                                en_state = 1;
                            //max
                                max_in = max_out;
                                en_max = 0;
                            //coeff
                                coeff_in = coeff_out;
                                en_coeff = 0;
                            //cnt v    
                                cnt_v_in = cnt_v_out;
                                en_cnt_v = 0;
                            //cnt h
                                cnt_h_in = cnt_h_out + 1;    
                                en_cnt_h = 1;
                        end                    
                    //condizione 3    
                    else if(state_out[tag]==WORK & cnt_v_out<max_out-1)
                        begin
                            //read
                                eqv_read_A = 1;
                                eqv_read_B = 0;
                                eqv_read_ext_size = 0;
                            //write
                                adapter={1'b0,read_port_opA.dout[WIDTH_OP_A-(TAG_WIDTH)-1:0]};  
                                op_A=adapter*coeff_out;                                                                     
                                write_port_prod.din ={tag, op_A}; 
                                write_port_prod.write = 1;                                    
                            //state
                                state_in = WORK;
                                en_state = 1;
                            //max
                                max_in = max_out;
                                en_max = 0;
                            //coeff
                                coeff_in = coeff_out;
                                en_coeff = 0;
                            //cnt v    
                                cnt_v_in = cnt_v_out + 1;
                                en_cnt_v = 1;
                            //cnt h
                                cnt_h_in = 0;    
                                en_cnt_h = 1;
                        end             
                    //condizione 4
                    else
                        begin                                                                        
                            //read
                                eqv_read_A = 1;
                                eqv_read_B = 0;
                                eqv_read_ext_size = 0;
                            //write
                                adapter={1'b0,read_port_opA.dout[WIDTH_OP_A-(TAG_WIDTH)-1:0]};  
                                op_A=adapter*coeff_out;                                                                     
                                write_port_prod.din ={tag, op_A}; 
                                write_port_prod.write = 1;                                    
                            //state
                                state_in = IDLE;
                                en_state = 1;
                            //max
                                max_in = max_out;
                                en_max = 0;
                            //coeff
                                coeff_in = coeff_out;
                                en_coeff = 0;
                            //cnt v    
                                cnt_v_in = 0;
                                en_cnt_v = 1;
                            //cnt h
                                cnt_h_in = 0;    
                                en_cnt_h = 1;
                        end
                end
            //default
            else 
                begin
                    //initial common element assignments
                    	   
                    //read addr	   
                    cnt_h_read_addr='x;
                    cnt_v_read_addr='x;                    
                    max_read_addr='x;
                    coeff_read_addr='x;
                                        
                    //write addr
                    cnt_h_write_addr='x;
                    cnt_v_write_addr='x;
                    max_write_addr='x;
                    coeff_write_addr='x;                                
                
                    //read
                        eqv_read_A = 0;
                        eqv_read_B = 0;
                        eqv_read_ext_size = 0;
                    //write
                        op_A='x;                                  
                        write_port_prod.din = 'x; 
                        write_port_prod.write = 0;                                    
                    //state
                        state_in = state_out[tag];
                        en_state = 0;
                    //max
                        max_in = max_out;
                        en_max = 0;
                    //coeff
                        coeff_in = coeff_out;
                        en_coeff=0;
                    //cnt v    
                        cnt_v_in = cnt_v_out;
                        en_cnt_v = 0;
                    //cnt h
                        cnt_h_in = cnt_h_out;    
                        en_cnt_h = 0;
                end
                
                //actual read assignments
                for(i=0;i<=FLUX-1;i=i+1)
                    begin
                        if(i==tag)
                            begin
                                read_port_opA.read[i]=eqv_read_A;
                                read_port_opB.read[i]=eqv_read_B;
                                read_port_ext_size.read[i]=eqv_read_ext_size;
                            end
                        else    
                            begin
                                read_port_opA.read[i]=0;
                                read_port_opB.read[i]=0;
                                read_port_ext_size.read[i]=0;
                            end                    
                    end
                                                                   
        end                                             

    always_ff @(posedge clk)
        if(rst)
            for(j=0;j<=FLUX-1;j=j+1)
                begin                        
                    state_out[j]<=IDLE;
                end
        else
            begin
                if(en_state)
                    state_out[tag]<=state_in;
            end    
                        	
endmodule