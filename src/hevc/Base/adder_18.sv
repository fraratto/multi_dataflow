//MODIFICA FATTA

`include "fifo_interface.sv"

//TESTBENCHED; EVERYTHING'S OK
//NAME OF PORTS AS SCHEMATIC
//`define MONO 1

module add_18#
(
    FLUX=2                   
)(        
    write_interface.actor write_port_sum,                
    read_interface.actor read_port_opA,                  
    read_interface.actor read_port_opB                   
);

    `ifdef MONO   
    parameter TAG_WIDTH = 0;        
    `else
    parameter TAG_WIDTH = $clog2(FLUX);			
 	`endif
 	 	
    //local parameters
    parameter DATA_WIDTH=18;    
    parameter WIDTH=DATA_WIDTH+TAG_WIDTH;    

    //common combinatory elements
    logic eqv_read;                                     //read signal
    logic signed [WIDTH-(TAG_WIDTH)-1:0] op_A;          //operator for port A
    logic signed [WIDTH-(TAG_WIDTH)-1:0] op_B;          //operator for port B
    logic signed [WIDTH-(TAG_WIDTH)-1:0] sum;           //operator for sum of op_A and op_B
    
    //external combinatory elements
    logic [TAG_WIDTH:0] tag;                          //priority data

    //loops
    integer i;                                          //needed for loops
    
    //combinatory logic/elaboration of data 
    always_comb
        
        begin
                 
            //choice about which data flux will be elaborated by the actor                            
            for(i=0;i<=FLUX-1;i=i+1)
                if(read_port_opA.empty[i]==0 & read_port_opB.empty[i]==0 & write_port_sum.full[i]==0) 
                    begin
                        tag=i; 
                        break;
                    end
                else
                    tag='1;                      
                                                     
            //write, output data, data memory, data operation and read authorizations
                
                //the last operation is available
                  
                if(!tag[TAG_WIDTH]) //!x[A] sarebbe "se il bit in posizione A è zero"    
                    begin
                        eqv_read=1;
                        write_port_sum.write=1;
                        op_A=read_port_opA.dout[WIDTH-(TAG_WIDTH)-1:0];
                        op_B=read_port_opB.dout[WIDTH-(TAG_WIDTH)-1:0];
                        sum=op_A+op_B;
                        write_port_sum.din={tag,sum};
                    end                  
                else  
                    begin
                        eqv_read=0;
                        op_A='x;
                        op_B='x;
                        write_port_sum.write=0;
                        sum='x;
                        write_port_sum.din='x; 
                    end

            //actual read assignments
            for(i=0;i<=FLUX-1;i=i+1)
                begin
                    if(i==tag)
                        begin
                            read_port_opA.read[i] = eqv_read;
                            read_port_opB.read[i] = eqv_read;
                        end
                    else
                        begin
                            read_port_opA.read[i] = 0;
                            read_port_opB.read[i] = 0;
                        end
                end 	 
    
        end 
     
endmodule