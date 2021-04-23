`timescale 1ns / 1ps
`include "fifo_interface.sv"

module delayer#
(
    DATA_WIDTH=8,
    FLUX=2                   
)(
    input clk,
    input rst,        
    write_interface.actor write_port,
    read_interface.actor read_port    
);
 
    //local parameters
    parameter TAG_WIDTH = $clog2(FLUX);
    parameter WIDTH=DATA_WIDTH+TAG_WIDTH;    

    //common combinatory elements
    logic eqv_read;                                     //read signal
    logic [WIDTH-1:0] data_nxt;                         //next data to be stored
    logic [WIDTH-1:0] data [0:FLUX-1];                  //data stored
    logic en_data;                                      //enable for storing data
    
    //external combinatory elements
    logic [TAG_WIDTH-1:0] tag;                          //priority data

    //loops
    integer i,j;
    
    //combinatory logic/elaboration of data 
    always_comb
        
        begin
                 
            //choice about which data flux will be elaborated by the actor             
            i=FLUX-1;
            while(i>=1)
                begin
                    if(read_port.empty[i]==0 & write_port.full==0) 
                        begin
                            tag=i; 
                            i=0;
                        end
                    else
                        begin
                            tag=i-1; 
                            i=i-1;
                        end
                end                      
                                                     
            //write, output data, data memory, data operation and read authorizations
                
                //the last operation is available  
                if(write_port.full==0 & read_port.empty[tag]==0)    
                    begin
                        eqv_read=1;
                        write_port.write=1;
                        data_nxt=read_port.dout;
                        write_port.din=data[tag];
                        en_data=1;
                    end                  
                else  
                    begin
                        eqv_read=0;
                        write_port.write=0;
                        data_nxt=data[tag];
                        write_port.din='x;
                        en_data=0; 
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


    always_ff@(posedge clk)
        if(rst)
            begin
                for(i=0;i<=FLUX-1;i=i+1)                
                    data[i] <= '0;
            end
        else if(en_data)
                    data[tag] <= data_nxt;    
    
endmodule

