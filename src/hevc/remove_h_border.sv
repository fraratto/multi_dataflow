`timescale 1ns / 1ps
`include "fifo_interface.sv"

//TESTBENCHED; EVERYTHING'S OK
//NAME OF PORTS AS SCHEMATIC

module remove_h_border#
(    
    FLUX=2                   
)(
    input clk,
    input rst,        
    write_interface.actor write_port_out_pel,                           
    read_interface.actor read_port_in_pel,                           
    read_interface.actor read_port_ext_size                     
);

    //local parameters
    parameter DATA_WIDTH_IN_OUT=18;
    parameter DATA_WIDTH_EXT=7;    
    parameter TAG_WIDTH = $clog2(FLUX);
    parameter WIDTH=DATA_WIDTH_IN_OUT+TAG_WIDTH;
    parameter WIDTH_EXT=DATA_WIDTH_EXT+TAG_WIDTH;    
    
    
    //state parameters
    parameter IDLE=0;
    parameter DROP=1;
    parameter WORK=2;
        
    //cnt h
    logic [WIDTH_EXT-(TAG_WIDTH)-1:0] cnt_h [0:FLUX-1];         //operation count_h for each flux
    logic [WIDTH_EXT-(TAG_WIDTH)-1:0] eqv_cnt_h;                //operation count signal
    logic [WIDTH_EXT-(TAG_WIDTH)-1:0] eqv_cnt_h_nxt;            //next operation count signal
    logic en_cnt_h;                                             //enable signal
    
    //cnt v    
    logic [WIDTH_EXT-(TAG_WIDTH)-1:0] cnt_v [0:FLUX-1];         //operation count_v for each flux
    logic [WIDTH_EXT-(TAG_WIDTH)-1:0] eqv_cnt_v;                //operation count signal    
    logic [WIDTH_EXT-(TAG_WIDTH)-1:0] eqv_cnt_v_nxt;            //next operation count signal
    logic en_cnt_v;                                             //enable signal
                                                                
    //state                                                     
    logic [1:0] state [0:FLUX-1];                               //state for each flux
    logic [1:0] eqv_state;                                      //state signal
    logic [1:0] eqv_state_nxt;                                  //next state signal    
    logic en_state;                                             //enable signal 
                
    //max
    logic [WIDTH_EXT-(TAG_WIDTH)-1:0] max [0:FLUX-1];           //max for each flux    
    logic [WIDTH_EXT-(TAG_WIDTH)-1:0] eqv_max;                  //operation count signal
    logic [WIDTH_EXT-(TAG_WIDTH)-1:0] eqv_max_nxt;              //next state max signal
    logic en_max;                                               //enable signal
    
    //operators
    logic signed [WIDTH-(TAG_WIDTH)-1:0] op_A;                  //needed for data operations
    
    //external combinatory elements
    logic [TAG_WIDTH-1:0] tag;                                  //priority data
    logic eqv_read_A;                                           //read signal for op_A
    logic eqv_read_ext_size;                                    //read signal for ext_size
    
    //loops
    integer i,j;                                                //needed for loops
    
    //combinatory logic/elaboration of data 
    always_comb
    
        begin
           
            //choice about which data flux will be elaborated by the actor 
            for(i=0;i<=FLUX-1;i=i+1)
                if(
                  (read_port_ext_size.empty[i]==0 & state[i]==IDLE)                                                         //condizione 1
                | (read_port_in_pel.empty[i]==0 & state[i]==DROP & cnt_h[i]<6)                                                   //condizione 2
                | (read_port_in_pel.empty[i]==0 & state[i]==DROP)                                                                //condizione 3
                | (read_port_in_pel.empty[i]==0 & state[i]==WORK & cnt_h[i]<max[i]-1 & cnt_v[i]<max[i]+1 & write_port_out_pel.full==0)   //condizione 4
                | (read_port_in_pel.empty[i]==0 & state[i]==WORK & cnt_v[i]<max[i] & write_port_out_pel.full==0)                         //condizione 5
                | (read_port_in_pel.empty[i]==0 & state[i]==WORK & write_port_out_pel.full==0)                                           //condizione 6
                    )
                        begin
                            tag=i; 
                            break;
                        end
                    else
                            tag=0; 
                
            //initial common element assignments	   
            eqv_cnt_v=cnt_v[tag];
            eqv_cnt_h=cnt_h[tag];
            eqv_max=max[tag];
            eqv_state=state[tag];
                                   
                 
            //condizione 1 
            if(read_port_ext_size.empty[tag]==0 & eqv_state==IDLE)
                begin
                    //read
                        eqv_read_A = 0;
                        eqv_read_ext_size = 1;
                    //write
                        op_A='x; //VHDL?                                 
                        write_port_out_pel.din = 'x; 
                        write_port_out_pel.write = 0;                                    
                    //state
                        eqv_state_nxt = DROP;
                        en_state = 1;
                    //max
                        eqv_max_nxt = read_port_ext_size.dout[WIDTH_EXT-(TAG_WIDTH)-1:0];
                        eqv_max_nxt = eqv_max_nxt-1;
                        en_max = 1;
                    //cnt v    
                        eqv_cnt_v_nxt = eqv_cnt_v;
                        en_cnt_v = 0;
                    //cnt h
                        eqv_cnt_h_nxt = eqv_cnt_h;    
                        en_cnt_h = 0;                    
                end
            //condizione 2     
            else if(read_port_in_pel.empty[tag]==0 & eqv_state==DROP & eqv_cnt_h<6)
                begin
                    //read
                        eqv_read_A = 1;
                        eqv_read_ext_size = 0;
                    //write
                        op_A='x;                                                                      
                        write_port_out_pel.din ='x; 
                        write_port_out_pel.write = 0;                                    
                    //state
                        eqv_state_nxt = DROP;
                        en_state = 1;
                    //max
                        eqv_max_nxt = eqv_max;
                        en_max = 0;
                    //cnt v    
                        eqv_cnt_v_nxt = eqv_cnt_v;
                        en_cnt_v = 0;
                    //cnt h
                        eqv_cnt_h_nxt = eqv_cnt_h + 1;    
                        en_cnt_h = 1;
                end                    
            //condizione 3    
            else if(read_port_in_pel.empty[tag]==0 & eqv_state==DROP)
                begin
                    //read
                        eqv_read_A = 1;
                        eqv_read_ext_size = 0;
                    //write
                        op_A='x;                                                                     
                        write_port_out_pel.din ='x; 
                        write_port_out_pel.write = 0;                                    
                    //state
                        eqv_state_nxt = WORK;
                        en_state = 1;
                    //max
                        eqv_max_nxt = eqv_max;
                        en_max = 0;
                    //cnt v    
                        eqv_cnt_v_nxt = eqv_cnt_v;
                        en_cnt_v = 0;
                    //cnt h
                        eqv_cnt_h_nxt = eqv_cnt_h;    
                        en_cnt_h = 0;
                end             
            //condizione 4
            else if(read_port_in_pel.empty[tag]==0 & eqv_state==WORK & (eqv_cnt_h<eqv_max-1 & eqv_cnt_v<eqv_max+1) & write_port_out_pel.full==0)
                begin 
                    //read
                        eqv_read_A = 1;
                        eqv_read_ext_size = 0;
                    //write
                        op_A=read_port_in_pel.dout[WIDTH-(TAG_WIDTH)-1:0];                                                                  
                        write_port_out_pel.din ={tag, op_A}; 
                        write_port_out_pel.write = 1;                                    
                    //state
                        eqv_state_nxt = WORK;
                        en_state = 1;
                    //max
                        eqv_max_nxt = eqv_max;
                        en_max = 0;
                    //cnt v    
                        eqv_cnt_v_nxt = eqv_cnt_v;
                        en_cnt_v = 0;
                    //cnt h
                        eqv_cnt_h_nxt = eqv_cnt_h+1;    
                        en_cnt_h = 1;
                end
            //condizione 5
            else if(read_port_in_pel.empty[tag]==0 & eqv_state==WORK & eqv_cnt_v<eqv_max & write_port_out_pel.full==0)
                begin 
                    //read
                        eqv_read_A = 1;
                        eqv_read_ext_size = 0;
                    //write
                        op_A=read_port_in_pel.dout[WIDTH-(TAG_WIDTH)-1:0];                                                                  
                        write_port_out_pel.din ={tag, op_A}; 
                        write_port_out_pel.write = 1;                                    
                    //state
                        eqv_state_nxt = DROP;
                        en_state = 1;
                    //max
                        eqv_max_nxt = eqv_max;
                        en_max = 0;
                    //cnt v    
                        eqv_cnt_v_nxt = eqv_cnt_v+1;
                        en_cnt_v = 1;
                    //cnt h
                        eqv_cnt_h_nxt = 0;    
                        en_cnt_h = 1;
                end
            //condizione 6
            else if(read_port_in_pel.empty[tag]==0 & eqv_state==WORK & write_port_out_pel.full==0)
                begin 
                    //read
                        eqv_read_A = 1;
                        eqv_read_ext_size = 0;
                    //write
                        op_A=read_port_in_pel.dout[WIDTH-(TAG_WIDTH)-1:0];                                                                  
                        write_port_out_pel.din ={tag, op_A}; 
                        write_port_out_pel.write = 1;                                    
                    //state
                        eqv_state_nxt = IDLE;
                        en_state = 1;
                    //max
                        eqv_max_nxt = eqv_max;
                        en_max = 0;
                    //cnt v    
                        eqv_cnt_v_nxt = 0;
                        en_cnt_v = 1;
                    //cnt h
                        eqv_cnt_h_nxt = 0;    
                        en_cnt_h = 1;
                end                                
            //default
            else 
                begin
                    //read
                        eqv_read_A = 0;
                        eqv_read_ext_size = 0;
                    //write
                        op_A='x;                                 
                        write_port_out_pel.din = 'x; 
                        write_port_out_pel.write = 0;                                    
                    //state
                        eqv_state_nxt = eqv_state;
                        en_state = 0;
                    //max
                        eqv_max_nxt = eqv_max;
                        en_max = 0;
                    //cnt v    
                        eqv_cnt_v_nxt = eqv_cnt_v;
                        en_cnt_v = 0;
                    //cnt h
                        eqv_cnt_h_nxt = eqv_cnt_h;    
                        en_cnt_h = 0;
                end
                
                //actual read assignments
                for(i=0;i<=FLUX-1;i=i+1)
                    begin
                        if(i==tag)
                            begin
                                read_port_in_pel.read[i]=eqv_read_A;
                                read_port_ext_size.read[i]=eqv_read_ext_size;
                            end
                        else    
                            begin
                                read_port_in_pel.read[i]=0;
                                read_port_ext_size.read[i]=0;
                            end                    
                    end
                                                                  
        end                                             
                
         
    //data memory and data operation update 
    always_ff @(posedge clk)
        if(rst==1) 
            begin
                for(j=0;j<=FLUX-1;j=j+1)
                    begin
                        cnt_v[j]<=0;
                        cnt_h[j]<=0;
                        max[j]<=0;
                        state[j]<=IDLE;
                    end
            end
        else 
            begin
                if(en_cnt_h)
                    cnt_h[tag]<=eqv_cnt_h_nxt;
                if(en_cnt_v)
                    cnt_v[tag]<=eqv_cnt_v_nxt;
                if(en_max)
                    max[tag]<=eqv_max_nxt;
                if(en_state)
                    state[tag]<=eqv_state_nxt;
            end
	
endmodule

