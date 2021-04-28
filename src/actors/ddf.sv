`timescale 1ns / 1ps
`include "fifo_interface.sv"

module ddf#
(
    DATA_WIDTH=8,
    FLUX=2,
    PORTS=2    
)(
    input clk,
    input rst,        
    write_interface.actor write_port,
    read_interface.actor read_port,
    read_interface.actor nda_port            
);
    //SIGNALS ORGANIZATION
    //din organization: din includes many ports data and it is organised as follows:
    //e.g. 2 ports, 9 bit WIDTH each gate -> din[0->17] -> din [0->8] = port 0, din[9->17] = port 1
    //read and empty organization: both signals includes many read/empty signals and they are organised as follows:
    //e.g. 2 flux, 2 ports -> signal[0->3]: 
    //  -> signal[0->1] = flux 0 (signal[0] from port 0, signal[1] from port 1) 
    //  -> signal[2->3] = flux 1 (signal[2] from port 0, signal[3] from port 1) 

    //local parameters
    parameter TAG_WIDTH = $clog2(FLUX);
    parameter WIDTH=DATA_WIDTH+TAG_WIDTH;    
    
    //state parameters
    parameter PICK=0;
    parameter ACTION=1;
        
    //memories
    logic [WIDTH-(TAG_WIDTH)-1:0] cnt [0:FLUX-1];       //operation count for each flux
    logic [WIDTH-(TAG_WIDTH)-1:0] acc [0:FLUX-1];       //data memory for each flux
    logic [FLUX-1:0] ready;                             //signal of data operations completed
    logic [FLUX-1:0] state;                             //state for each flux
    
    //common combinatory elements
    logic [WIDTH-(TAG_WIDTH)-1:0] eqv_cnt;              //operation count signal
    logic [WIDTH-(TAG_WIDTH)-1:0] eqv_cntnxt;           //next operation count signal
    logic [WIDTH-(TAG_WIDTH)-1:0] eqv_acc;              //data memory signal
    logic [WIDTH-(TAG_WIDTH)-1:0] eqv_accnxt;           //next data memory signal
    logic [PORTS-1:0] eqv_read;                         //read signal
    logic [FLUX-1:0] eqv_empty;                         //empty signal
    logic eqv_ready;                                    //ready signal
    logic eqv_readynxt;                                 //next ready signal
    logic eqv_state;                                    //state signal
    logic eqv_statenxt;                                 //next state signal
    logic eqv_ndaread;                                  //nda read signal

    //external combinatory elements
    logic [TAG_WIDTH-1:0] tag;                          //priority data
    logic [WIDTH-(TAG_WIDTH)-1:0] total_data;           //support operation variable 
    logic [(WIDTH*PORTS)-1:0] carrier1;                 //support operation variable
    logic [WIDTH-(TAG_WIDTH)-1:0] carrier2;             //support operation variable

    //loops
    integer i,j,k;                                      //needed for loops
    
    //combinatory logic/elaboration of data 
    always_comb
    
        begin
        
            //eqv_empty of all empty signals of each flux
            for(j=FLUX-1;j>=0;j=j-1) 
                begin
                    eqv_empty[j]=0;
                    for(i=0;i<=PORTS-1;i=i+1) 
                        begin
                            eqv_empty[j] = eqv_empty[j] | read_port.empty[i+j*PORTS];
                        end
                end
    
            //choice about which data flux will be elaborated by the actor 
            for(i=0;i<=FLUX-1;i=i+1)
                if(
                  (nda_port.empty[i]==0 & state[i]==PICK)                                               //actor can request the number of operations
                | (cnt[i]==0 & write_port.full==0 & ready[i]==0 & eqv_empty[i]==0 & state[i]==ACTION)   //the last operation is available and data can be sended at the first try
                | (cnt[i]==0 & write_port.full==1 & ready[i]==0 & eqv_empty[i]==0 & state[i]==ACTION)   //the last operation is available but the data cannot be sended at the first try
                | (cnt[i]==0 & write_port.full==0 & ready[i]==1 & state[i]==ACTION)                     //the last operation has been done and data can be sended
                | (cnt[i]!=0 & eqv_empty[i]==0 & state[i]==ACTION)                                      //the ordinary operation is available
                    )
                    begin
                        tag=i; 
                        break;
                    end
                else
                    tag=0;
                
            //initial common element assignments	   
            eqv_cnt=cnt[tag];
            eqv_acc=acc[tag];	
            eqv_ready=ready[tag];
            eqv_state=state[tag];
                                   
            //PICK state: in this state the actor receives the number of operations it will do  
            if(eqv_state==PICK)
            
                begin
                
                    //initial external element assignments 	
                    carrier2 = 0;
                    carrier1 = 0;
                    total_data = 0;
                    
                    //write, output data, data memory, data operation, ready, state and read authorizations
                    
                        for(j=0;j<=PORTS-1;j=j+1)
                            begin
                                eqv_read[j]=0;
                            end                                            
                        write_port.write=0;
                        eqv_accnxt=0;
                        eqv_readynxt=0;
                        write_port.din={tag,eqv_acc};
                                                
                        if(nda_port.empty[tag]==0)
                            //actor can request the number of operations
                            begin
                                eqv_ndaread=1;
                                eqv_statenxt=ACTION;                                                        
                                if(nda_port.dout[WIDTH-(TAG_WIDTH)-1:0]==0)
//SHOULD THIS PART BE IN THE ACTOR? //number of operations requested is 0 (in this case the actor will treat this 0 like a 1)                              
                                    begin  
                                        eqv_cntnxt=0;
                                    end  
                                else
                                    //number of operations requested is 1 or greater
                                    begin                                    
                                        eqv_cntnxt=nda_port.dout[WIDTH-(TAG_WIDTH)-1:0] - 1;
                                    end 
                            end 
                        else
                            //actor cannot request the number of operations
                            begin 
                                eqv_ndaread=0;
                                eqv_cntnxt=0;
                                eqv_statenxt=PICK;                            
                            end                            
                                                
                end
     
            //ACTION state: in this state the actor will do the operations requested
            else
        
                begin
    
                    //initial external element assignments   
                    total_data = 0;
                    carrier1 = read_port.dout;
                    carrier2 = 0;
                    
                    //input data adaptation for the operations
                    for(i=0;i<=PORTS-1;i=i+1)
                        begin
                            carrier2=carrier1[WIDTH-(TAG_WIDTH)-1:0];
                            carrier1=carrier1>>(WIDTH);
                            total_data=total_data+carrier2;
                        end	   
                                        
                    //write, output data, data memory, data operation, ready and read authorizations
                       
                        //the last operation is available and data can be sended at the first try 
                        if(eqv_cnt==0 & write_port.full==0 & eqv_ready==0 & eqv_empty[tag]==0)
                            begin
                                for(j=0;j<=PORTS-1;j=j+1)
                                    begin
                                        eqv_read[j]=1;
                                    end 
                                write_port.din={tag,eqv_acc+total_data}; 
                                write_port.write=1; 
                                eqv_cntnxt=0;
                                eqv_accnxt=0;
                                eqv_readynxt=0;
                                eqv_ndaread=0;                                 
                                eqv_statenxt=PICK;
                            end
                        //the last operation is available but the data cannot be sended at the first try     
                        else if(eqv_cnt==0 & write_port.full==1 & eqv_ready==0 & eqv_empty[tag]==0)
                            begin
                                for(j=0;j<=PORTS-1;j=j+1)
                                    begin
                                        eqv_read[j]=1;
                                    end 
                                write_port.din={tag,eqv_acc+total_data}; 
                                write_port.write=0; 
                                eqv_cntnxt=eqv_cnt;
                                eqv_accnxt=eqv_acc+total_data;
                                eqv_readynxt=1;
                                eqv_ndaread=0;                                
                                eqv_statenxt=ACTION;
                            end                    
                        //the last operation has been done and data can be sended    
                        else if(eqv_cnt==0 & write_port.full==0 & eqv_ready==1)
                            begin
                                for(j=0;j<=PORTS-1;j=j+1)
                                    begin
                                        eqv_read[j]=0;
                                    end         
                                write_port.din={tag,eqv_acc}; 
                                write_port.write=1; 
                                eqv_cntnxt=0;
                                eqv_accnxt=0;
                                eqv_readynxt=0;
                                eqv_ndaread=0;                                
                                eqv_statenxt=PICK;
                            end             
                        //the ordinary operation is available
                        else if(eqv_cnt!=0 & eqv_empty[tag]==0)
                            begin 
                                for(j=0;j<=PORTS-1;j=j+1)
                                    begin
                                        eqv_read[j]=1;
                                    end                     
                                write_port.din={tag,eqv_acc+total_data}; 
                                write_port.write=0;
                                eqv_cntnxt=eqv_cnt-1; 
                                eqv_accnxt=eqv_acc+total_data;
                                eqv_readynxt=0;
                                eqv_ndaread=0;                                
                                eqv_statenxt=ACTION;
                            end
                        //the operation is not available
                        else 
                            begin
                                for(j=0;j<=PORTS-1;j=j+1)
                                    begin
                                        eqv_read[j]=0;
                                    end                         
                                write_port.din={tag,eqv_acc}; 
                                write_port.write=0;
                                eqv_cntnxt=eqv_cnt; 
                                eqv_accnxt=eqv_acc;
                                eqv_readynxt=eqv_ready;
                                eqv_ndaread=0;                                
                                eqv_statenxt=ACTION;  
                            end
                                                                              
                end                                 
            
            //default read assignments
            for(i=0;i<=PORTS*FLUX-1;i=i+1)
                begin
                    read_port.read[i] = 0;
                end
                
            //actual read assignments
            for(i=0;i<=PORTS-1;i=i+1)
                begin
                    read_port.read[i+tag*PORTS] = eqv_read[i];
                end	                  
                               
            //nda_read assignments                                                
            for(i=0;i<=FLUX-1;i=i+1)
                begin
                    if(i==tag)
                        nda_port.read[i] = eqv_ndaread;                                
                    else
                        nda_port.read[i] = 0;
                end
                
        end
         
    //data memory and data operation update 
    always_ff @(posedge clk)
        if(rst==1) 
            begin
                for(k=0;k<=FLUX-1;k=k+1)
                    begin
                        ready[k]<=0;
                        cnt[k]<=0;
                        acc[k]<=0;
                        state[k]<=PICK;
                    end
            end
        else 
            begin
                ready[tag]<=eqv_readynxt;
                cnt[tag]<=eqv_cntnxt;
                acc[tag]<=eqv_accnxt;
                state[tag]<=eqv_statenxt;
            end
	
endmodule
