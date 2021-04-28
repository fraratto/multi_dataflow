`timescale 1ns / 1ps
`include "fifo_interface.sv"

//TESTBENCHED; EVERYTHING'S OK

module delayer#
(
    FLUX=2                   
)(
    input clk,
    input rst,        
    write_interface.actor write_port,
    read_interface.actor read_port    
);
 
    //local parameters
    parameter DATA_WIDTH=8;
    parameter TAG_WIDTH = $clog2(FLUX);
    parameter WIDTH=DATA_WIDTH+TAG_WIDTH;    

    //common combinatory elements
    logic eqv_read;                                     //read signal
    logic [WIDTH-(TAG_WIDTH)-1:0] data_nxt;                         //next data to be stored
    logic [WIDTH-(TAG_WIDTH)-1:0] data [0:FLUX-1];                  //data stored
    logic en_data;                                      //enable for storing data
    
    //external combinatory elements
    logic [TAG_WIDTH-1:0] tag;                          //priority data

    //loops
    integer i,k;                                        //needed for loops
    
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
                                                     
            //operations
                
                //operation is available  
                if(write_port.full==0 & read_port.empty[tag]==0)    
                    begin
                        eqv_read=1;
                        write_port.write=1;
                        data_nxt=read_port.dout[WIDTH-(TAG_WIDTH)-1:0];
                        write_port.din={tag,data[tag]};
                        en_data=1;
                    end
                //operation is not available                      
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

    //data update
    always_ff@(posedge clk)
        if(rst)
            begin
                for(k=0;k<=FLUX-1;k=k+1)                
                    data[k] <= '0;
            end
        else if(en_data)
                    data[tag] <= data_nxt;    
    
endmodule

