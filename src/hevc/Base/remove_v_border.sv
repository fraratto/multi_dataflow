//COMPLETED 

`timescale 1ns / 1ps
`include "fifo_interface.sv"
`include "ram_interface.sv"

//TESTBENCHED; EVERYTHING'S OK
//NAME OF PORTS AS SCHEMATIC 
//`define MONO 1

module remove_v#
(
    FLUX=2                   
)(
    input clk,
    input rst,        
    write_interface.actor write_port_out_pel,                               
    read_interface.actor read_port_in_pel,                               
    read_interface.actor read_port_ext_size,                        
    read_interface.actor read_port_real_size                        
);

    `ifdef MONO  
    parameter TAG_WIDTH = 0;        
    `else
    parameter TAG_WIDTH = $clog2(FLUX);			
 	`endif

    //local parameters
    parameter DATA_WIDTH_EXT=7;                                                                    
    parameter DATA_WIDTH_REAL=7;
    parameter DATA_WIDTH=8;        
    parameter WIDTH_EXT_SIZE=DATA_WIDTH_EXT+TAG_WIDTH;
    parameter WIDTH_REAL_SIZE=DATA_WIDTH_REAL+TAG_WIDTH;            
    parameter WIDTH=DATA_WIDTH+TAG_WIDTH;    
    
    //state parameters
    parameter IDLE=0;
    parameter DROP=1;
    parameter WORK=2;
        
    //cnt h
    logic [WIDTH_REAL_SIZE-(TAG_WIDTH)-1:0] cnt_h_out;              //operation count_h signal
    logic [WIDTH_REAL_SIZE-(TAG_WIDTH)-1:0] cnt_h_in;          //next operation count_h signal
    logic [TAG_WIDTH-1:0] cnt_h_read_addr;
    logic [TAG_WIDTH-1:0] cnt_h_write_addr;
    logic en_cnt_h;                                                 //enable signal
    
    //cnt_h memory     
	ram_interface #(DATA_WIDTH_REAL, FLUX) cnt_h_port (clk);
	assign cnt_h_port.din = cnt_h_in;
	assign cnt_h_port.write_address = cnt_h_write_addr;
	assign cnt_h_port.read_address = cnt_h_read_addr; 
	assign cnt_h_port.write_en = en_cnt_h;
	assign cnt_h_out= cnt_h_port.dout;

	ram_dual_ported #(
		.DEPTH(FLUX),
		.WIDTH(DATA_WIDTH_REAL)
		) cnt_h_mem (
		.port(cnt_h_port.slave)
		);    
    
    //cnt v    
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] cnt_v_out;               //operation count_v signal    
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] cnt_v_in;           //next operation count_v signal
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
    logic [1:0] state_out [FLUX-1:0];                                          //state signal
    logic [1:0] state_in;                                      //next state signal         
    logic en_state;                                                 //enable signal
                
    //max_h    
    logic [WIDTH_REAL_SIZE-(TAG_WIDTH)-1:0] max_h_out;              //max_h signal
    logic [WIDTH_REAL_SIZE-(TAG_WIDTH)-1:0] max_h_in;          //next max_h signal
    logic [TAG_WIDTH-1:0] max_h_read_addr;
    logic [TAG_WIDTH-1:0] max_h_write_addr;     
    logic en_max_h;                                                 //enable signal
    
    //max_h memory     
	ram_interface #(DATA_WIDTH_REAL, FLUX) max_h_port (clk);
	assign max_h_port.din = max_h_in;
	assign max_h_port.write_address = max_h_write_addr;
	assign max_h_port.read_address = max_h_read_addr; 
	assign max_h_port.write_en = en_max_h;
	assign max_h_out= max_h_port.dout;

	ram_dual_ported #(
		.DEPTH(FLUX),
		.WIDTH(DATA_WIDTH_REAL)
		) max_h_mem (
		.port(max_h_port.slave)
		);    
    
    //max_v    
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] max_v_out;               //max_v signal
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] max_v_in;           //next max_v signal
    logic [TAG_WIDTH-1:0] max_v_read_addr;
    logic [TAG_WIDTH-1:0] max_v_write_addr;    
    logic en_max_v;                                                 //enable signal    
    
    //max_v memory     
	ram_interface #(DATA_WIDTH_EXT, FLUX) max_v_port (clk);
	assign max_v_port.din = max_v_in;
	assign max_v_port.write_address = max_v_write_addr;
	assign max_v_port.read_address = max_v_read_addr; 
	assign max_v_port.write_en = en_max_v;
	assign max_v_out = max_v_port.dout;

	ram_dual_ported #(
		.DEPTH(FLUX),
		.WIDTH(DATA_WIDTH_EXT)
		) max_v_mem (
		.port(max_v_port.slave)
		);   
    
    //operators
    logic signed [WIDTH-(TAG_WIDTH)-1:0] op_A;                      //needed for operations
    
    //external combinatory elements
    logic [TAG_WIDTH:0] tag;                                      //priority data
    logic eqv_read_A;                                               //read port A 
    logic eqv_read_ext_size;                                        //read port ext_size
    logic eqv_read_real_size;                                       //read port real_size
    
    //loops
    integer i,j;                                                    //needed for loops
    
    //combinatory logic/elaboration of data 
    always_comb
    
        begin
           
            //choice about which data flux will be elaborated by the actor 
            for(i=0;i<=FLUX-1;i=i+1)
                begin                                                            
                    if(
                      (read_port_ext_size.empty[i]==0 & read_port_real_size.empty[i]==0 & state_out[i]==IDLE)                                           //condizione 1                                                                  //condizione 3
                    | (read_port_in_pel.empty[i]==0 & state_out[i]==DROP)                                               //condizione 4                       //condizione 6
                    | (read_port_in_pel.empty[i]==0 & state_out[i]==WORK & write_port_out_pel.full[i]==0)                                                               //condizione 7        
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
                    max_h_read_addr=tag;
                    max_v_read_addr=tag;
                                                            
                    //write addr
                    cnt_h_write_addr=tag;
                    cnt_v_write_addr=tag;
                    max_h_write_addr=tag;
                    max_v_write_addr=tag;                                           
                                                       
                    //condizione 1 
                    if(state_out[tag]==IDLE)
                        begin
                            //read
                                eqv_read_A = 0;
                                eqv_read_ext_size = 1;
                                eqv_read_real_size = 1;
                            //write
                                op_A='x;                                  
                                write_port_out_pel.din = 'x; 
                                write_port_out_pel.write = 0;                                    
                            //state
                                state_in = DROP;
                                en_state = 1;
                            //max_h
                                max_h_in = read_port_real_size.dout[WIDTH_REAL_SIZE-(TAG_WIDTH)-1:0];
                                en_max_h = 1;
                            //max_v
                                max_v_in = read_port_ext_size.dout[WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0];
                                en_max_v = 1;                        
                            //cnt v    
                                cnt_v_in = cnt_v_out;
                                en_cnt_v = 0;
                            //cnt h
                                cnt_h_in = cnt_h_out;    
                                en_cnt_h = 0;
                        end
                    //condizione 2     
                    else if(state_out[tag]==DROP & cnt_h_out<max_h_out-1 & cnt_v_out<7)
                        begin
                            //read
                                eqv_read_A = 1;
                                eqv_read_ext_size = 0;
                                eqv_read_real_size = 0;
                            //write
                                op_A='x;                                 
                                write_port_out_pel.din = 'x; 
                                write_port_out_pel.write = 0;                                    
                            //state
                                state_in = DROP;
                                en_state = 1;
                            //max_h
                                max_h_in = max_h_out;
                                en_max_h = 0;
                            //max_v
                                max_v_in = max_v_out;
                                en_max_v = 0;                        
                            //cnt v    
                                cnt_v_in = cnt_v_out;
                                en_cnt_v = 0;
                            //cnt h
                                cnt_h_in = cnt_h_out+1;    
                                en_cnt_h = 1;
                        end                   
                    //condizione 3    
                    else if(state_out[tag]==DROP & cnt_v_out<6)
                        begin
                            //read
                                eqv_read_A = 1;
                                eqv_read_ext_size = 0;
                                eqv_read_real_size = 0;
                            //write
                                op_A='x;                                  
                                write_port_out_pel.din = 'x; 
                                write_port_out_pel.write = 0;                                    
                            //state
                                state_in = DROP;
                                en_state = 1;
                            //max_h
                                max_h_in = max_h_out;
                                en_max_h = 0;
                            //max_v
                                max_v_in = max_v_out;
                                en_max_v = 0;                        
                            //cnt v    
                                cnt_v_in = cnt_v_out+1;
                                en_cnt_v = 1;
                            //cnt h
                                cnt_h_in = 0;    
                                en_cnt_h = 1;
                        end             
                    //condizione 4
                    else if(state_out[tag]==DROP)
                        begin
                            //read
                                eqv_read_A = 1;
                                eqv_read_ext_size = 0;
                                eqv_read_real_size = 0;
                            //write
                                op_A='x;                                  
                                write_port_out_pel.din = 'x; 
                                write_port_out_pel.write = 0;                                    
                            //state
                                state_in = WORK;
                                en_state = 1;
                            //max_h
                                max_h_in = max_h_out;
                                en_max_h = 0;
                            //max_v
                                max_v_in = max_v_out;
                                en_max_v = 0;                        
                            //cnt v    
                                cnt_v_in = cnt_v_out+1;
                                en_cnt_v = 1;
                            //cnt h
                                cnt_h_in = 0;    
                                en_cnt_h = 1;
                        end 
                    //condizione 5
                    else if(state_out[tag]==WORK & cnt_h_out<max_h_out-1 & cnt_v_out<max_v_out)
                        begin
                            //read
                                eqv_read_A = 1;
                                eqv_read_ext_size = 0;
                                eqv_read_real_size = 0;
                            //write
                                op_A=read_port_in_pel.dout[WIDTH-(TAG_WIDTH)-1:0];                                 
                                write_port_out_pel.din = {tag,op_A}; 
                                write_port_out_pel.write = 1;                                    
                            //state
                                state_in = WORK;
                                en_state = 1;
                            //max_h
                                max_h_in = max_h_out;
                                en_max_h = 0;
                            //max_v
                                max_v_in = max_v_out;
                                en_max_v = 0;                        
                            //cnt v    
                                cnt_v_in = cnt_v_out;
                                en_cnt_v = 0;
                            //cnt h
                                cnt_h_in = cnt_h_out+1;    
                                en_cnt_h = 1;
                        end
                    //condizione 6
                    else if(state_out[tag]==WORK & cnt_v_out<max_v_out-1)
                        begin
                            //read
                                eqv_read_A = 1;
                                eqv_read_ext_size = 0;
                                eqv_read_real_size = 0;
                            //write
                                op_A=read_port_in_pel.dout[WIDTH-(TAG_WIDTH)-1:0];                                 
                                write_port_out_pel.din = {tag,op_A}; 
                                write_port_out_pel.write = 1;                                    
                            //state
                                state_in = WORK;
                                en_state = 1;
                            //max_h
                                max_h_in = max_h_out;
                                en_max_h = 0;
                            //max_v
                                max_v_in = max_v_out;
                                en_max_v = 0;                        
                            //cnt v    
                                cnt_v_in = cnt_v_out+1;
                                en_cnt_v = 1;
                            //cnt h
                                cnt_h_in = 0;    
                                en_cnt_h = 1;
                        end
                    //condizione 7
                    else
                        begin
                            //read
                                eqv_read_A = 1;
                                eqv_read_ext_size = 0;
                                eqv_read_real_size = 0;
                            //write
                                op_A=read_port_in_pel.dout[WIDTH-(TAG_WIDTH)-1:0];                                 
                                write_port_out_pel.din = {tag,op_A}; 
                                write_port_out_pel.write = 1;                                     
                            //state
                                state_in = IDLE;
                                en_state = 1;
                            //max_h
                                max_h_in = max_h_out;
                                en_max_h = 0;
                            //max_v
                                max_v_in = max_v_out;
                                en_max_v = 0;                        
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
                    max_h_read_addr='x;
                    max_v_read_addr='x;  
                                      
                    //write addr
                    cnt_h_write_addr='x;
                    cnt_v_write_addr='x;
                    max_h_write_addr='x;
                    max_v_write_addr='x;
                                    
                    //read
                        eqv_read_A = 0;
                        eqv_read_ext_size = 0;
                        eqv_read_real_size = 0;
                    //write
                        op_A='x;                                 
                        write_port_out_pel.din = 'x; 
                        write_port_out_pel.write = 0;                                    
                    //state
                        state_in = state_out[tag];
                        en_state = 0;
                    //max_h
                        max_h_in = max_h_out;
                        en_max_h = 0;
                    //max_v
                        max_v_in = max_v_out;
                        en_max_v = 0;                        
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
                                read_port_in_pel.read[i]=eqv_read_A;
                                read_port_ext_size.read[i]=eqv_read_ext_size;
                                read_port_real_size.read[i]=eqv_read_real_size;                                
                            end
                        else    
                            begin
                                read_port_in_pel.read[i]=0;
                                read_port_ext_size.read[i]=0;
                                read_port_real_size.read[i]=0;                                
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