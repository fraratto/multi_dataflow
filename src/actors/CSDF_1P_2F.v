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
// CSDF PARAMETRIZZATO

module CSDF_1P_2F#
(
parameter WIDTH=33, 
parameter ATTESA=0,
parameter AZIONE=1
)(
input [WIDTH-1:0] in0_data,
input ck,
input rst,
input in0_full,
input in0_empty,
input in1_empty,
output reg in0_read,
output reg in1_read,
output reg out0_wr,
output reg [WIDTH-1:0] out0_data);

//PRIORITA'
reg tag;

//EQUIVALENTI
reg eqv_state;
reg eqv_statenxt;
reg eqv_read;
reg eqv_empty;
reg [1:0] eqv_cnt;
reg [1:0] eqv_cntnxt;
reg [WIDTH-2:0] eqv_acc;
reg [WIDTH-2:0] eqv_accnxt;

//FLUSSO 0
reg [1:0] c0_cnt;
reg [WIDTH-2:0] c0_acc;
reg c0_state;

//FLUSSO 1
reg [1:0] c1_cnt;
reg [WIDTH-2:0] c1_acc;
reg c1_state;

//COMBINATORIA 
always@(*)

begin

//CONDIZIONE DI DECISIONE SUL TAG
if((in1_empty==0 & c1_cnt<3) | (in0_full==0 & c1_cnt==3)) 
	tag=1;
else 
	tag=0;

//ASSEGNAMENTI IN BASE AL TAG (INIZIO)

if(tag==1)
	begin
		eqv_empty=in1_empty;	
		eqv_state=c1_state;
		eqv_cnt=c1_cnt;
		eqv_acc=c1_acc;
	end
else
	begin
		eqv_empty=in0_empty;	
		eqv_state=c0_state;
		eqv_cnt=c0_cnt;
		eqv_acc=c0_acc;		
	end

//->DEVO ASPETTARE CHE POSSA INIZIARE A CHIAMARE
if(eqv_state==ATTESA)
	begin
	
		//1 GESTIONE READ
		if(eqv_empty==1) 
			eqv_read=0; 
		else 
			eqv_read=1;
	
		//2 GESTIONE WRITE
		out0_wr=0;
	
		//3 GESTIONE ACC E CNT 
		eqv_accnxt=eqv_acc; 
		eqv_cntnxt=eqv_cnt;
	
		//4 GESTIONE USCITA 
		out0_data={tag,eqv_acc};
	
		//5 GESTIONE PASSAGGIO DI STATO
		if(eqv_empty==0) 
			eqv_statenxt=AZIONE; 
		else 
			eqv_statenxt=ATTESA;  
	end

//->STO ACCUMULANDO; SE READ SI FERMA TORNO IN IDLE ALTRIMENTI CONTINUO FINO A MANDARE IL DATO. MANDATO IL DATO RITORNO IN ATTESA E RIPARTE COSI' IL CICLO
else
	begin
	
		//1 GESTIONE READ
		if(eqv_empty==1 | eqv_cnt==3) 
			eqv_read=0; 
		else
			eqv_read=1; 
	
		//2 GESTIONE WRITE //3 GESTIONE ACC E CNT //4 GESTIONE USCITA 
		if(eqv_cnt==3 & in0_full==0)
			begin 
				out0_data={tag,(eqv_acc+in0_data[WIDTH-2:0])}; 
				out0_wr=1; 
				eqv_cntnxt=eqv_cnt+1;
				eqv_accnxt=0;
			end
		else if(eqv_cnt==3 & in0_full==1) 
			begin 
				out0_data={tag,eqv_acc}; 
				out0_wr=0;
				eqv_cntnxt=eqv_cnt; 
				eqv_accnxt=eqv_acc; 
			end 
		else 
			begin 
				out0_data={tag,eqv_acc}; 
				out0_wr=0; 
				eqv_cntnxt=eqv_cnt+1; 
				eqv_accnxt=eqv_acc+in0_data[WIDTH-2:0];
			end
	
		//5 GESTIONE PASSAGGIO DI STATO
		if((eqv_empty==1 & ~(eqv_cnt==3)) | (eqv_cnt==3 & in0_full==0)) 
			eqv_statenxt=ATTESA;    
		else 
			eqv_statenxt=AZIONE; 
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
		c1_state<=ATTESA;
		c1_cnt<=0;
		c1_acc<=0;
		c0_state<=ATTESA;
		c0_cnt<=0;
		c0_acc<=0;
	end
else 
	begin
		if(tag==1)
			begin
				c1_state<=eqv_statenxt;
				c1_cnt<=eqv_cntnxt;
				c1_acc<=eqv_accnxt;
			end
		else
			begin
				c0_state<=eqv_statenxt;
				c0_cnt<=eqv_cntnxt;
				c0_acc<=eqv_accnxt;
		end
	end

endmodule