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

module CSDF_1P_1F#
(
parameter WIDTH=32, 
parameter c0_ATTESA=0,
parameter c0_AZIONE=1
)(
input [WIDTH-1:0] in0_data,
input ck,
input rst,
input out0_full,
input in0_empty,
output reg in0_rd,
output reg out0_wr,
output reg [WIDTH-1:0] out0_data);

//CONTROLLO
reg c0_state;
reg c0_statenxt;

//DATAPATH
reg [1:0] c0_cnt;
reg [1:0] c0_cntnxt;
reg [WIDTH-1:0] c0_acc;
reg [WIDTH-1:0] c0_accnxt;

//COMBINATORIA 
always@(*)

//->DEVO ASPETTARE CHE POSSA INIZIARE A CHIAMARE
if(c0_state==c0_ATTESA)
	begin
	
		//1 GESTIONE READ
		if(in0_empty==1) 
			in0_rd=0; 
		else 
			in0_rd=1;
	
		//2 GESTIONE WRITE
		out0_wr=0;
	
		//3 GESTIONE ACC E CNT 
		c0_accnxt=c0_acc; 
		c0_cntnxt=c0_cnt;
	
		//4 GESTIONE USCITA 
		out0_data=c0_acc;
	
		//5 GESTIONE PASSAGGIO DI STATO
		if(in0_empty==0) 
			c0_statenxt=c0_AZIONE; 
		else 
			c0_statenxt=c0_ATTESA;  
	end

//->STO ACCUMULANDO; SE READ SI FERMA TORNO IN IDLE ALTRIMENTI CONTINUO FINO A MANDARE IL DATO. MANDATO IL DATO RITORNO IN ATTESA E RIPARTE COSI' IL CICLO
else
	begin
	
		//1 GESTIONE READ
		if(in0_empty==1 | c0_cnt==3) 
			in0_rd=0; 
		else
			in0_rd=1; 
			//READ PUO' BLOCCARSI SOLO SE NELLA FIFO A MONTE NON CI SONO DATI (c0_empty==1) O SE HO IL DATO PRONTO DA MANDARE (c0_cnt==3)
	
		//2 GESTIONE WRITE //3 GESTIONE ACC E CNT //4 GESTIONE USCITA 
		if(c0_cnt==3 & out0_full==0)   //(c0_cnt==3 & out0_full==0) E' LA CONDIZIONE PER IL QUALE L'ACCUMULATORE MANDA IL DATO IN USCITA, SE E' VERA MANDO IL DATO IN USCITA 
			begin 
				out0_data=c0_acc+in0_data; 
				out0_wr=1; 
				c0_cntnxt=c0_cnt+1;
				c0_accnxt=0;
			end
		else if(c0_cnt==3 & out0_full==1) //SE HO PRONTO IL DATO DA MANDARE (c0_cnt==3) MA LA FIFO A VALLE E' PIENA (out0_full==1) ALLORA RIMANGO FERMO, CONSERVANDO DATI E CONTEGGIO E OVVIAMENTE NON TORNANDO IN ATTESA
			begin 
				out0_data=c0_acc; 
				out0_wr=0;
				c0_cntnxt=c0_cnt; 
				c0_accnxt=c0_acc; 
			end 
		else 
			begin //SE NON HO PRONTI I DATI (c0_cnt!=3) ALLORA CONTINUO COME SE NIENTE FOSSE
				out0_data=c0_acc; 
				out0_wr=0; 
				c0_cntnxt=c0_cnt+1; 
				c0_accnxt=c0_acc+in0_data;
			end
	
		//5 GESTIONE PASSAGGIO DI STATO
		if((in0_empty==1 & ~(c0_cnt==3)) | (c0_cnt==3 & out0_full==0)) 
			c0_statenxt=c0_ATTESA; 
		//DEVO TORNARE IN ATTESA SOLO SE HO LA FIFO A MONTE VUOTA E NON HO I DATI PRONTI (in0_empty==1 & ~(c0_cnt==3)) OPPURE SE HO APPENA MANDATO UN DATO (c0_cnt==3 & out0_full==0)   
		else 
			c0_statenxt=c0_AZIONE; 
	end


//SEQUENZIALE 
always@(posedge ck or posedge rst)
if(rst==1) 
	begin
		c0_state<=c0_ATTESA;
		c0_cnt<=0;
		c0_acc<=0;
	end
else 
	begin
		c0_state<=c0_statenxt;
		c0_cnt<=c0_cntnxt;
		c0_acc<=c0_accnxt;
	end

endmodule