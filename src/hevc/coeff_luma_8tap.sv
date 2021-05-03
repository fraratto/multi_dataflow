`timescale 1ns / 1ps
`include "fifo_interface.sv"

//TESTBENCHED; EVERYTHING'S OK
//NAME OF PORTS AS SCHEMATIC

module coeff_luma_8tap#
(
    FLUX=2                  
)(
    
    //alpha
        read_interface.actor read_port_alpha,
    
    //c0        
        write_interface.actor write_port_c0,
    //c1
        write_interface.actor write_port_c1,
    //c2
        write_interface.actor write_port_c2,
    //c3
        write_interface.actor write_port_c3,
    //c4
        write_interface.actor write_port_c4,
    //c5
        write_interface.actor write_port_c5,
    //c6
        write_interface.actor write_port_c6,
    //c7
        write_interface.actor write_port_c7
        
);
 
    //local parameters
    parameter DATA_WIDTH=3;    
    parameter TAG_WIDTH = $clog2(FLUX);   
    parameter WIDTH=DATA_WIDTH+TAG_WIDTH; 
    
    //common combinatory elements
    logic eqv_read;                                     //read signal                        
    
    //external combinatory elements
    logic [TAG_WIDTH-1:0] tag;                          //priority data

    //loops
    integer i,j;                                        //needed for loops
    
    //combinatory logic/elaboration of data 
    always_comb
        
        begin
                 
            //choice about which data flux will be elaborated by the actor             
            for(i=0;i<=FLUX-1;i=i+1)
                    if(
                      (read_port_alpha.empty[i]==0) 
                    & (write_port_c0.full[i]==0)
                    & (write_port_c1.full[i]==0)
                    & (write_port_c2.full[i]==0)
                    & (write_port_c3.full[i]==0)
                    & (write_port_c4.full[i]==0)
                    & (write_port_c5.full[i]==0)
                    & (write_port_c6.full[i]==0)
                    & (write_port_c7.full[i]==0)
                       ) 
                    begin
                        tag=i; 
                        break;
                    end
                else
                    tag=0;                      
                                                     
            //write, output data, data memory, data operation and read authorizations
                
                    //alpha=0 
                    if(
                      (read_port_alpha.empty[tag]==0) 
                    & (write_port_c0.full[tag]==0)
                    & (write_port_c1.full[tag]==0)
                    & (write_port_c2.full[tag]==0)
                    & (write_port_c3.full[tag]==0)
                    & (write_port_c4.full[tag]==0)
                    & (write_port_c5.full[tag]==0)
                    & (write_port_c6.full[tag]==0)
                    & (write_port_c7.full[tag]==0)
                    & (read_port_alpha.dout[WIDTH-(TAG_WIDTH)-1:0]==0)
                       )    
                        begin
                            eqv_read=1;
                            //scritture
                                write_port_c0.write=1;
                                write_port_c1.write=1;
                                write_port_c2.write=1;
                                write_port_c3.write=1;
                                write_port_c4.write=1;
                                write_port_c5.write=1;
                                write_port_c6.write=1;
                                write_port_c7.write=1;
                            //dati in output
                                write_port_c0.din={tag,9'd0};
                                write_port_c1.din={tag,9'd0};
                                write_port_c2.din={tag,9'd0};
                                write_port_c3.din={tag,9'd64};
                                write_port_c4.din={tag,9'd0};
                                write_port_c5.din={tag,9'd0};
                                write_port_c6.din={tag,9'd0};
                                write_port_c7.din={tag,9'd0};                        
                        end
                    //alpha=2                      
                    else                     
                    if(
                      (read_port_alpha.empty[tag]==0) 
                    & (write_port_c0.full[tag]==0)
                    & (write_port_c1.full[tag]==0)
                    & (write_port_c2.full[tag]==0)
                    & (write_port_c3.full[tag]==0)
                    & (write_port_c4.full[tag]==0)
                    & (write_port_c5.full[tag]==0)
                    & (write_port_c6.full[tag]==0)
                    & (write_port_c7.full[tag]==0)
                    & (read_port_alpha.dout[WIDTH-(TAG_WIDTH)-1:0]==2)
                      )
                        begin
                            eqv_read=1;
                            //scritture
                                write_port_c0.write=1;
                                write_port_c1.write=1;
                                write_port_c2.write=1;
                                write_port_c3.write=1;
                                write_port_c4.write=1;
                                write_port_c5.write=1;
                                write_port_c6.write=1;
                                write_port_c7.write=1;
                            //dati in output
                                write_port_c0.din= {tag,-9'd1};
                                write_port_c1.din= {tag,9'd4};
                                write_port_c2.din= {tag,-9'd10};
                                write_port_c3.din= {tag,9'd58};
                                write_port_c4.din= {tag,9'd17};
                                write_port_c5.din= {tag,-9'd5};
                                write_port_c6.din= {tag,9'd1};
                                write_port_c7.din= {tag,9'd0};                        
                        end
                    //alpha=4                      
                    else                     
                    if(
                      (read_port_alpha.empty[tag]==0) 
                    & (write_port_c0.full[tag]==0)
                    & (write_port_c1.full[tag]==0)
                    & (write_port_c2.full[tag]==0)
                    & (write_port_c3.full[tag]==0)
                    & (write_port_c4.full[tag]==0)
                    & (write_port_c5.full[tag]==0)
                    & (write_port_c6.full[tag]==0)
                    & (write_port_c7.full[tag]==0)
                    & (read_port_alpha.dout[WIDTH-(TAG_WIDTH)-1:0]==4)
                      )
                        begin
                            eqv_read=1;
                            //scritture
                                write_port_c0.write=1;
                                write_port_c1.write=1;
                                write_port_c2.write=1;
                                write_port_c3.write=1;
                                write_port_c4.write=1;
                                write_port_c5.write=1;
                                write_port_c6.write=1;
                                write_port_c7.write=1;
                            //dati in output
                                write_port_c0.din= {tag,-9'd1};
                                write_port_c1.din= {tag,9'd4};
                                write_port_c2.din= {tag,-9'd11};
                                write_port_c3.din= {tag,9'd40};
                                write_port_c4.din= {tag,9'd40};
                                write_port_c5.din= {tag,-9'd11};
                                write_port_c6.din= {tag,9'd4};
                                write_port_c7.din= {tag,-9'd1};                        
                        end
                    //alpha=6                      
                    else                     
                    if(
                      (read_port_alpha.empty[tag]==0) 
                    & (write_port_c0.full[tag]==0)
                    & (write_port_c1.full[tag]==0)
                    & (write_port_c2.full[tag]==0)
                    & (write_port_c3.full[tag]==0)
                    & (write_port_c4.full[tag]==0)
                    & (write_port_c5.full[tag]==0)
                    & (write_port_c6.full[tag]==0)
                    & (write_port_c7.full[tag]==0)
                    & (read_port_alpha.dout[WIDTH-(TAG_WIDTH)-1:0]==6)
                      )
                        begin
                            eqv_read=1;
                            //scritture
                                write_port_c0.write=1;
                                write_port_c1.write=1;
                                write_port_c2.write=1;
                                write_port_c3.write=1;
                                write_port_c4.write=1;
                                write_port_c5.write=1;
                                write_port_c6.write=1;
                                write_port_c7.write=1;
                            //dati in output
                                write_port_c0.din= {tag,9'd0};
                                write_port_c1.din= {tag,9'd1};
                                write_port_c2.din= {tag,-9'd5};
                                write_port_c3.din= {tag,9'd17};
                                write_port_c4.din= {tag,9'd58};
                                write_port_c5.din= {tag,-9'd10};
                                write_port_c6.din= {tag,9'd4};
                                write_port_c7.din= {tag, -9'd1};                        
                        end
                    //default                      
                    else                     
                        begin
                            eqv_read=0;
                            //scritture
                                write_port_c0.write=0;
                                write_port_c1.write=0;
                                write_port_c2.write=0;
                                write_port_c3.write=0;
                                write_port_c4.write=0;
                                write_port_c5.write=0;
                                write_port_c6.write=0;
                                write_port_c7.write=0;
                            //dati in output
                                write_port_c0.din=  'x; 
                                write_port_c1.din=  'x; 
                                write_port_c2.din=  'x; 
                                write_port_c3.din=  'x; 
                                write_port_c4.din=  'x; 
                                write_port_c5.din=  'x; 
                                write_port_c6.din=  'x; 
                                write_port_c7.din=  'x;                        
                        end
                                                                                                 
            //actual read assignments
            for(i=0;i<=FLUX-1;i=i+1)
                begin
                    if(i==tag)
                        read_port_alpha.read[i] = eqv_read;
                    else
                        read_port_alpha.read[i] = 0;
                end 	 
    
        end 
    
endmodule
