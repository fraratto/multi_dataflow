`timescale 1ns / 1ps
`include "fifo_interface.sv"

//TESTBENCHED; EVERYTHING'S OK

module derive_real_size_8tap#
( 
    FLUX=2                  
)(        
    write_interface.actor write_port,                   //real size
    read_interface.actor read_port                      //ext size
);
    //local parameters
    parameter DATA_WIDTH=7;
    parameter TAG_WIDTH = $clog2(FLUX);   
    parameter WIDTH=DATA_WIDTH+TAG_WIDTH;
    parameter DIFF=7;
    
    //common combinatory elements
    logic eqv_read;                                     //read signal                        

    //external combinatory elements
    logic [TAG_WIDTH-1:0] tag;                          //priority data
    logic [WIDTH-(TAG_WIDTH)-1:0] part;                  //operator for signal
    
    //loops
    integer i;                                          //needed for loops
    
    //combinatory logic/elaboration of data 
    always_comb
        
        begin
                 
            //choice about which data flux will be elaborated by the actor                            
            for(i=0;i<=FLUX-1;i=i+1)
                if(read_port.empty[i]==0 & write_port.full==0) 
                    begin
                        tag=i; 
                        break;
                    end
                else
                    tag=0;                      
                                                     
            //write, output data, data memory, data operation and read authorizations
                
                //the last operation is available  
                if(write_port.full==0 & read_port.empty[tag]==0)    
                    begin
                        eqv_read=1;
                        write_port.write=1;
                        part=read_port.dout[WIDTH-(TAG_WIDTH)-1:0];
                        part=part-DIFF;
                        write_port.din={tag,part};
                    end                  
                else  
                    begin
                        eqv_read=0;
                        write_port.write=0;
                        part='x;
                        write_port.din='x; 
                    end

            //actual read assignments
            for(i=0;i<=FLUX-1;i=i+1)
                begin
                    if(i==tag)
                        read_port.read[i] = eqv_read;
                    else
                        read_port.read[i] = 0;
                end 	 
    
        end 
    
endmodule

