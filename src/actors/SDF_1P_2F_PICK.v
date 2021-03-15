`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2020 13:54:27
// Design Name: 
// Module Name: Accumulatore
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//ACCUMULAZIONE FISSATA A 4 ELEMENTI; IN CASO DI PARAMETRIZZAZIONE DEL NUMERO DI ELEMENTI BISOGNA MODIFICARE CNT

module SDF_1P_2F_PICK#(
parameter WIDTH=8
)(
input [WIDTH-1:0] in_data,
input ck,
input rst,
input full,
input in0_empty,
input in1_empty,
output reg in0_read,
output reg in1_read,
output reg wr,
output reg [WIDTH-1:0] out_data);

//PRIORITA'
reg tag;

//EQUIVALENTI 
reg eqv_read;
reg eqv_empty;
reg [1:0] eqv_cnt;
reg [1:0] eqv_cntnxt;
reg [WIDTH-2:0] eqv_acc;
reg [WIDTH-2:0] eqv_accnxt;

//FLUSSO 0
reg [1:0] c0_cnt;
reg [WIDTH-2:0] c0_acc;

//FLUSSO 1
reg [1:0] c1_cnt;
reg [WIDTH-2:0] c1_acc;

//COMBINATORIA 
always@(*)

begin

    //CONDIZIONE DI DECISIONE SUL TAG
    if(in1_empty==0 & full==0) 
	   tag=1;
    else
	   tag=0;

    //ASSEGNAMENTI IN BASE AL TAG (INIZIO)
	
    if(tag==1)
	   begin
		  eqv_empty=in1_empty;	
		  eqv_cnt=c1_cnt;
		  eqv_acc=c1_acc;
	   end
    else
    	begin
	      eqv_empty=in0_empty;	
		  eqv_cnt=c0_cnt;
		  eqv_acc=c0_acc;		
	   end


	begin
	
		//1 GESTIONE READ
		if(eqv_empty==0 & full==0) 
			eqv_read=1; 
		else 
			eqv_read=0; 
 
		//2 GESTIONE WRITE //3 GESTIONE ACC E CNT //4 GESTIONE USCITA 
		if(eqv_cnt==3 & full==0 & eqv_empty==0)    
			begin
				wr=1;
				out_data={tag,(eqv_acc+in_data[WIDTH-2:0])};
				eqv_accnxt=0;
				eqv_cntnxt=0;
			end

		else
		if(eqv_cnt<3 & full==0 & eqv_empty==0)   
			begin
				wr=1;
				out_data={tag,(eqv_acc+in_data[WIDTH-2:0])};
				eqv_accnxt=eqv_acc+in_data[WIDTH-2:0];
				eqv_cntnxt=eqv_cnt+1;
			end
		else  
			begin
				wr=0;
				out_data={tag,eqv_acc}; 
				eqv_accnxt=eqv_acc;
				eqv_cntnxt=eqv_cnt;
			end

	end

    //ASSEGNAMENTI IN BASE AL TAG (FINE)
	
    if(tag==1)
	   begin
            in1_read=eqv_read;
		    in0_read=0;
	   end
    else
	   begin
            in1_read=0;
		    in0_read=eqv_read;
	   end

end 

    //SEQUENZIALE 
always@(posedge ck or posedge rst)
if(rst==1) 
    begin
        c0_cnt<=0;
        c0_acc<=0;
        c1_cnt<=0;
        c1_acc<=0;
    end
else 
    begin
        if(tag==1)
            begin
                c1_cnt<=eqv_cntnxt;
                c1_acc<=eqv_accnxt;
            end
        else
            begin
                c0_cnt<=eqv_cntnxt;
                c0_acc<=eqv_accnxt;
            end
    end

endmodule