//MODIFICA FATTA

`timescale 1ns / 1ps
`include "fifo_interface.sv"

//TESTBENCHED; EVERYTHING'S OK
//NAME OF PORTS AS SCHEMATIC
//`define MONO 1

module clip#
(
    FLUX=2                  
)(        
    write_interface.actor write_port_out_pel,
    read_interface.actor read_port_in_pel    
);
 
    `ifdef MONO  
    parameter TAG_WIDTH = 0;        
    `else
    parameter TAG_WIDTH = $clog2(FLUX);			
 	`endif
 	
    //local parameters
    parameter DATA_WIDTH_CLIP=16;
    parameter DATA_WIDTH=8;   
    parameter WIDTH=DATA_WIDTH+TAG_WIDTH;
    parameter WIDTH_CLIP=DATA_WIDTH_CLIP+TAG_WIDTH;     
    
    //common combinatory elements
    logic eqv_read;                                     //read signal                        
    logic signed [WIDTH_CLIP-(TAG_WIDTH)-1:0] op_A;     //operator for data evaluation
	logic signed [DATA_WIDTH-1:0] clipped;				//clipped signal
    
    //external combinatory elements
    logic [TAG_WIDTH:0] tag;                          //priority data

    //loops
    integer i;                                          //needed for loops
    
    //combinatory logic/elaboration of data 
    always_comb
        
        begin
                 
            //choice about which data flux will be elaborated by the actor                            
            for(i=0;i<=FLUX-1;i=i+1)
                if(read_port_in_pel.empty[i]==0 & write_port_out_pel.full[i]==0) 
                    begin
                        tag=i; 
                        break;
                    end
                else
                    tag='1;                      
                                                     
            //operations
                
                //operation is available  
                if(!tag[TAG_WIDTH])    
                    begin
                        eqv_read=1;
                        write_port_out_pel.write=1;
                        op_A=read_port_in_pel.dout[WIDTH_CLIP-(TAG_WIDTH)-1:0];
                            if(op_A>255)
                                clipped = '1;
                            else if(op_A<0)
                                clipped = '0;
                            else
                                clipped = op_A;
						write_port_out_pel.din = {tag,clipped};
								
                    end
                //operation is not available                      
                else  
                    begin
                        eqv_read=0;
                        write_port_out_pel.write=0;
                        op_A='x; 
                        write_port_out_pel.din='x; 
                    end

            //actual read assignments
            for(i=0;i<=FLUX-1;i=i+1)
                begin
                    if(i==tag)
                        read_port_in_pel.read[i] = eqv_read;
                    else
                        read_port_in_pel.read[i] = 0;
                end 	 
    
        end 
    
endmodule