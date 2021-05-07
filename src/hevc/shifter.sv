`timescale 1ns / 1ps
`include "../fifo/fifo_interface.sv"

//TESTBENCHED; EVERYTHING'S OK
//NAME OF PORTS AS SCHEMATIC

module shift#
(
    FLUX=2                  
)(       
    write_interface.actor write_port_out_pel,
    read_interface.actor read_port_in_pel    
);
 
    //local parameters
    parameter TAG_WIDTH = $clog2(FLUX);   
    parameter SHIFT_NUM = 11; 
    
    //common combinatory elements
    logic eqv_read;                                     //read signal                        

    //external combinatory elements
    logic [TAG_WIDTH-1:0] tag;                          //priority data

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
                    tag=0;
                                                                         
            //operations
                
                //operation is available  
                if(write_port_out_pel.full[tag]==0 & read_port_in_pel.empty[tag]==0)    
                    begin
                        eqv_read=1;
                        write_port_out_pel.write=1;
                        write_port_out_pel.din=read_port_in_pel.dout>>(SHIFT_NUM);
                    end
                //operation is not available                      
                else  
                    begin
                        eqv_read=0;
                        write_port_out_pel.write=0;
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
