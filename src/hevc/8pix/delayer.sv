//COMPLETED

`timescale 1ns / 1ps
`include "../../fifo/fifo_interface.sv"
`include "../../fifo/ram_interface.sv"

module delay#
(
    FLUX=2                   
)(
    input clk,
    input rst,        
    write_interface.actor write_port_out_pel,
    read_interface.actor read_port_in_pel    
);
 
    //local parameters
    parameter DATA_WIDTH=8;
    parameter TAG_WIDTH = $clog2(FLUX);
    parameter WIDTH=DATA_WIDTH+TAG_WIDTH;    
	
	//stae parameters
	parameter IDLE = 0;
	parameter WORK = 1;
	
	// state
	logic state [0 : FLUX-1];	// added a state in which data is initialized to 0 after reset

    //common combinatory elements
    logic eqv_read;                                     //read signal
	
	//data
	logic [TAG_WIDTH-1: 0] data_read_addr;
	logic [TAG_WIDTH-1: 0] data_write_addr;
	logic [DATA_WIDTH-1: 0] data_exit;
	logic en_data;
    
    //external combinatory elements
    logic [TAG_WIDTH:0] tag;                          //priority data

    //loops
    integer i,j,k;                                        //needed for loops
	
	
	//data memory instantiation
	ram_interface #(DATA_WIDTH, FLUX) data_port (clk);
	assign data_port.din = read_port_in_pel.dout[DATA_WIDTH-1 : 0];
	assign data_port.write_address = data_write_addr;
	assign data_port.read_address = data_read_addr; 
	assign data_port.write_en = en_data;
	assign data_exit = data_port.dout;

	ram_dual_ported #(
		.DEPTH(FLUX),
		.WIDTH(DATA_WIDTH)
		) data_mem (
		.port(data_port.slave)
		);
    
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
                        data_write_addr = tag;
						data_read_addr = tag;
                        write_port_out_pel.din={tag,data_exit};
                        en_data=1;
                    end
                //operation is not available                      
                else  
                    begin
                        eqv_read=0;
                        write_port_out_pel.write=0;
						data_write_addr = 'x;
						data_read_addr = 'x;
                        write_port_out_pel.din='x; 
                        en_data=0; 
                    end

            //actual read assignments
            for(j=0;j<=FLUX-1;j=j+1)
                begin
                    if(j==tag)
                        read_port_in_pel.read[j] = eqv_read;
                    else
                        read_port_in_pel.read[j] = 0;
                end 	 
    
        end 

    
endmodule

