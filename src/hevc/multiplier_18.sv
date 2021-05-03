`timescale 1ns / 1ps
`include "fifo_interface.sv"

//TESTBENCHED; EVERYTHING'S OK
//NAME OF PORTS AS SCHEMATIC

module multiplier_18#
(
    FLUX=2                   
)(
    input clk,
    input rst,        
    write_interface.actor write_port_prod,                               
    read_interface.actor read_port_opA,                               
    read_interface.actor read_port_opB,                               
    read_interface.actor read_port_ext_size,                        
    read_interface.actor read_port_real_size                        
);

    //local parameters                                        
    parameter DATA_WIDTH_EXT_SIZE=7;
    parameter DATA_WIDTH_REAL_SIZE=7;                                    
    parameter DATA_WIDTH=27;
    parameter DATA_WIDTH_OP_A=18;                                    
    parameter DATA_WIDTH_OP_B=9;
    parameter TAG_WIDTH = $clog2(FLUX);       
    parameter WIDTH_EXT_SIZE=DATA_WIDTH_EXT_SIZE+TAG_WIDTH;
    parameter WIDTH_REAL_SIZE=DATA_WIDTH_REAL_SIZE+TAG_WIDTH;    
    parameter WIDTH=DATA_WIDTH+TAG_WIDTH;
    parameter WIDTH_OP_B=DATA_WIDTH_OP_B+TAG_WIDTH;
    parameter WIDTH_OP_A=DATA_WIDTH_OP_A+TAG_WIDTH;    
    
    //state parameters
    parameter IDLE=0;
    parameter WORK=1;
        
    //cnt h
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] cnt_h [0:FLUX-1];        //operation count_h for each flux
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] eqv_cnt_h;               //operation count signal
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] eqv_cnt_h_nxt;           //next operation count signal
    logic en_cnt_h;                                                 //enable signal
    
    //cnt v    
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] cnt_v [0:FLUX-1];        //operation count_v for each flux
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] eqv_cnt_v;               //operation count signal    
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] eqv_cnt_v_nxt;           //next operation count signal
    logic en_cnt_v;                                                 //enable signal
        
    //state
    logic [FLUX-1:0] state;                                         //state for each flux
    logic eqv_state;                                                //state signal
    logic eqv_state_nxt;                                            //next state signal    
    logic en_state;                                                 //enable signal
    
    //coeff
    logic signed [WIDTH_OP_B-(TAG_WIDTH)-1:0] coeff [0:FLUX-1];     //coeff for each flux
    logic signed [WIDTH_OP_B-(TAG_WIDTH)-1:0] eqv_coeff;            //coeff signal
    logic signed [WIDTH_OP_B-(TAG_WIDTH)-1:0] eqv_coeff_nxt;        //next coeff signal
    logic en_coeff;                                                 //enable signal
            
    //max_v
    logic [WIDTH_REAL_SIZE-(TAG_WIDTH)-1:0] max_v [0:FLUX-1];        //max_v for each flux    
    logic [WIDTH_REAL_SIZE-(TAG_WIDTH)-1:0] eqv_max_v;               //max_v signal
    logic [WIDTH_REAL_SIZE-(TAG_WIDTH)-1:0] eqv_max_v_nxt;           //next max_v signal
    logic en_max_v;                                                  //enable signal

    //max_h
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] max_h [0:FLUX-1];        //max_h for each flux    
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] eqv_max_h;               //max_h signal
    logic [WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0] eqv_max_h_nxt;           //next max_h signal
    logic en_max_h;                                                 //enable signal
    
    //operators
    logic signed [WIDTH_OP_A-(TAG_WIDTH)-1:0] adapter;              //needed for adapting input for operation
    logic signed [WIDTH-(TAG_WIDTH)-1:0] op_A;                      //needed for operation
    
    //external combinatory elements
    logic [TAG_WIDTH-1:0] tag;                                      //priority data
    logic eqv_read_A;                                               //read port A
    logic eqv_read_B;                                               //read port B
    logic eqv_read_ext_size;                                        //read port ext_size
    logic eqv_read_real_size;                                       //read port real_size
    
    //loops
    integer i,j;                                                    //needed for loops
    
    //combinatory logic/elaboration of data 
    always_comb
    
        begin
           
            //choice about which data flux will be elaborated by the actor 
            for(i=0;i<=FLUX-1;i=i+1)
                if(
                  (read_port_opB.empty[i]==0 & read_port_ext_size.empty[i]==0 & read_port_ext_size.empty[i]==0 & state[i]==IDLE)                //condizione 1
                | (read_port_opA.empty[i]==0 & state[i]==WORK & (cnt_h[i]<max_h[i] & cnt_v[i]<max_v[i]) & write_port_prod.full[i]==0)           //condizione 2
                | (read_port_opA.empty[i]==0 & state[i]==WORK & cnt_v[i]<max_v[i] & write_port_prod.full[i]==0)                                 //condizione 3
                | (read_port_opA.empty[i]==0 & state[i]==WORK & write_port_prod.full[i]==0)                                                     //condizione 4
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
            eqv_max_v=max_v[tag];
            eqv_max_h=max_h[tag];            
            eqv_coeff=coeff[tag];
            eqv_state=state[tag];
                                   

            //condizione 1 
            if(read_port_opB.empty[tag]==0 & read_port_ext_size.empty[tag]==0 & read_port_ext_size.empty[tag]==0 & eqv_state==IDLE)
                begin
                    //read
                        eqv_read_A = 0;
                        eqv_read_B = 1;
                        eqv_read_ext_size = 1;
                        eqv_read_real_size = 1;
                    //write
                        adapter='x;
                        op_A='x;                           
                        write_port_prod.din = 'x; 
                        write_port_prod.write = 0;                                    
                    //state
                        eqv_state_nxt = WORK;
                        en_state = 1;
                    //max_h
                        eqv_max_h_nxt = read_port_real_size.dout[WIDTH_REAL_SIZE-(TAG_WIDTH)-1:0];
                        en_max_h = 1;
                    //max_v
                        eqv_max_v_nxt = read_port_ext_size.dout[WIDTH_EXT_SIZE-(TAG_WIDTH)-1:0];
                        en_max_v = 1;                        
                    //coeff
                        eqv_coeff_nxt = read_port_opB.dout[WIDTH_OP_B-(TAG_WIDTH)-1:0];
                        en_coeff = 1;
                    //cnt v    
                        eqv_cnt_v_nxt = eqv_cnt_v;
                        en_cnt_v = 0;
                    //cnt h
                        eqv_cnt_h_nxt = eqv_cnt_h;    
                        en_cnt_h = 0;
                end
            //condizione 2     
            else if(read_port_opA.empty[tag]==0 & eqv_state==WORK & (eqv_cnt_h<eqv_max_h & eqv_cnt_v<eqv_max_v) & write_port_prod.full[tag]==0)
                begin
                    //read
                        eqv_read_A = 1;
                        eqv_read_B = 0;
                        eqv_read_ext_size = 0;
                        eqv_read_real_size = 0;
                    //write
                        adapter=read_port_opA.dout[WIDTH_OP_A-(TAG_WIDTH)-1:0];
                        op_A=adapter*eqv_coeff;                                                   
                        write_port_prod.din = {tag,op_A}; 
                        write_port_prod.write = 1;                                    
                    //state
                        eqv_state_nxt = WORK;
                        en_state = 1;
                    //max_h
                        eqv_max_h_nxt = eqv_max_h;
                        en_max_h = 0;
                    //max_v
                        eqv_max_v_nxt = eqv_max_v;
                        en_max_v = 0;                        
                    //coeff
                        eqv_coeff_nxt = eqv_coeff;
                        en_coeff = 0;
                    //cnt v    
                        eqv_cnt_v_nxt = eqv_cnt_v;
                        en_cnt_v = 0;
                    //cnt h
                        eqv_cnt_h_nxt = eqv_cnt_h + 1;    
                        en_cnt_h = 1;
                end                    
            //condizione 3    
            else if(read_port_opA.empty[tag]==0 & eqv_state==WORK & eqv_cnt_v<eqv_max_v & write_port_prod.full[tag]==0)
                begin
                    //read
                        eqv_read_A = 1;
                        eqv_read_B = 0;
                        eqv_read_ext_size = 0;
                        eqv_read_real_size = 0;
                    //write
                        adapter=read_port_opA.dout[WIDTH_OP_A-(TAG_WIDTH)-1:0];
                        op_A=adapter*eqv_coeff;                                                   
                        write_port_prod.din = {tag,op_A}; 
                        write_port_prod.write = 1;                                    
                    //state
                        eqv_state_nxt = WORK;
                        en_state = 1;
                    //max_h
                        eqv_max_h_nxt = eqv_max_h;
                        en_max_h = 0;
                    //max_v
                        eqv_max_v_nxt = eqv_max_v;
                        en_max_v = 0;                        
                    //coeff
                        eqv_coeff_nxt = eqv_coeff;
                        en_coeff = 0;
                    //cnt v    
                        eqv_cnt_v_nxt = eqv_cnt_v + 1;
                        en_cnt_v = 1;
                    //cnt h
                        eqv_cnt_h_nxt = 0;    
                        en_cnt_h = 1;
                end              
            //condizione 4
            else if(read_port_opA.empty[tag]==0 & eqv_state==WORK & write_port_prod.full[tag]==0)
                begin
                    //read
                        eqv_read_A = 1;
                        eqv_read_B = 0;
                        eqv_read_ext_size = 0;
                        eqv_read_real_size = 0;
                    //write
                        adapter=read_port_opA.dout[WIDTH_OP_A-(TAG_WIDTH)-1:0];
                        op_A=adapter*eqv_coeff;                                                   
                        write_port_prod.din = {tag,op_A}; 
                        write_port_prod.write = 1;                                    
                    //state
                        eqv_state_nxt = WORK;
                        en_state = 1;
                    //max_h
                        eqv_max_h_nxt = eqv_max_h;
                        en_max_h = 0;
                    //max_v
                        eqv_max_v_nxt = eqv_max_v;
                        en_max_v = 0;                        
                    //coeff
                        eqv_coeff_nxt = eqv_coeff;
                        en_coeff = 0;
                    //cnt v    
                        eqv_cnt_v_nxt = 0;
                        en_cnt_v = 1;
                    //cnt h
                        eqv_cnt_h_nxt = 0;    
                        en_cnt_h = 1;
                end 
            //default
            else 
                begin //da modificare
                    //read
                        eqv_read_A = 0;
                        eqv_read_B = 0;
                        eqv_read_ext_size = 0;
                        eqv_read_real_size = 0;
                    //write
                        adapter='x;                    
                        op_A='x;                                                   
                        write_port_prod.din = 'x; 
                        write_port_prod.write = 0;                                    
                    //state
                        eqv_state_nxt = eqv_state;
                        en_state = 0;
                    //max_h
                        eqv_max_h_nxt = eqv_max_h;
                        en_max_h = 0;
                    //max_v
                        eqv_max_v_nxt = eqv_max_v;
                        en_max_v = 0;                        
                    //coeff
                        eqv_coeff_nxt = eqv_coeff;
                        en_coeff = 0;
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
                                read_port_opA.read[i]=eqv_read_A;
                                read_port_opB.read[i]=eqv_read_B;
                                read_port_ext_size.read[i]=eqv_read_ext_size;
                                read_port_real_size.read[i]=eqv_read_real_size;
                            end
                        else    
                            begin
                                read_port_opA.read[i]=0;
                                read_port_opB.read[i]=0;
                                read_port_ext_size.read[i]=0;
                                read_port_real_size.read[i]=0;                                
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
                        coeff[j]<=0;
                        max_v[j]<=0;
                        max_h[j]<=0;                        
                        state[j]<=IDLE;
                    end
            end
        else 
            begin
                if(en_cnt_h)
                    cnt_h[tag]<=eqv_cnt_h_nxt;
                if(en_cnt_v)
                    cnt_v[tag]<=eqv_cnt_v_nxt;
                if(en_max_v)
                    max_v[tag]<=eqv_max_v_nxt;
                if(en_max_h)
                    max_h[tag]<=eqv_max_h_nxt;                    
                if(en_coeff)
                    coeff[tag]<=eqv_coeff_nxt;
                if(en_state)
                    state[tag]<=eqv_state_nxt;
            end
	
endmodule
