`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2020 20:25:51
// Design Name: 
// Module Name: Accumulatore DDF
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
// DDF PARAMETRIZZATO

module DDF_1P_1F#(
parameter WIDTH=32,
parameter WIDTH_NDA=4,
parameter c0_ATTESA=0,
parameter c0_AZIONE=1,
parameter c0_CHOICE=2,
parameter c0_PICK=3
)(
input nda_empty,
input [WIDTH_NDA-1:0] nda_data,//per ora 4 bit
input [WIDTH-1:0] in0_data,
input ck,
input rst,
input out0_full,
input in0_empty,
output reg nda_rd,
output reg in0_rd,
output reg out0_wr,
output reg [WIDTH-1:0] out0_data);

//CONTROLLO
reg [1:0] c0_state;
reg [1:0] c0_statenxt;

//DATAPATH
reg [WIDTH_NDA-1:0] c0_cnt;
reg [WIDTH_NDA-1:0] c0_cntnxt;
reg [WIDTH-1:0] c0_acc;
reg [WIDTH-1:0] c0_accnxt;


//COMBINATORIA 
always@(*)

if(c0_state==c0_PICK) //QUI PRENDO L'NDA (APPENA POSSIBILE)
	begin

		//0 GESTIONE NDA
		if(nda_empty==1) 
			nda_rd=0; //DEVO BLOCCARE NEL CASO NON POSSA CHIAMARE L'NDA
		else 
			nda_rd=1;

		//1 GESTIONE READ
		in0_rd=0;
 
		//2 GESTIONE WRITE
		out0_wr=0;

		//3 GESTIONE ACC E CNT 
		c0_accnxt=0; //DURANTE QUESTO STATO NON DEVO CHIAMARE/SCRIVERE DATI PERCHE' NON SO QUANTE ACCUMULAZIONI DEVO FARE
		c0_cntnxt=0;
 
		//4 GESTIONE USCITA
		out0_data=c0_acc;

		//5 GESTIONE PASSAGGIO DI STATO
		if(nda_empty==0) 
			c0_statenxt=c0_CHOICE;
		else 
			c0_statenxt=c0_PICK;
	end

// DA QUI E' UGUALE AL MODULO CSDF SALVO LA CONDIZIONE DI USCITA NELLO STATO AZIONE

else 
if(c0_state==c0_CHOICE) //QUI PRENDO L'NDA E VEDO SE E' VALIDO; SE E' ZERO TORNO IN PICK, ALTRIMENTI INIZIO IL CICLO DI ACCUMULAZIONE
	begin

		//0 GESTIONE NDA
		nda_rd=0;

		//1 GESTIONE READ
		in0_rd=0;

		//2 GESTIONE WRITE
		out0_wr=0;

		//3 GESTIONE ACC E CNT
		c0_accnxt=0; //L'ACCUMULAZIONE OVVIAMENTE RIMANE A ZERO PERCHE' NON HO INIZIATO AD ACCUMULARE
		if(nda_data==0) 
			c0_cntnxt=0; //DATO CHE STO USANDO UNA LOGICA A DECREMENTO E CON CONTEGGIO 0,1,2... ANZICHE' 1,2... DEVO DIMINUIRE DI UNO IL NUMERO IN INGRESSO 
		else 
			c0_cntnxt=nda_data-1;

		//4 GESTIONE USCITA
		out0_data=c0_acc;

		//5 GESTIONE PASSAGGIO DI STATO
		if(nda_data==0) 
			c0_statenxt=c0_PICK; //SE L'NDA E' ZERO TORNO IN PICK, ALTRIMENTI INIZIO L'ACCUMULAZIONE
		else 
			c0_statenxt=c0_ATTESA;
	end
 
else
if(c0_state==c0_ATTESA) //->DEVO ASPETTARE CHE POSSA INIZIARE A CHIAMARE
	begin

		//0 GESTIONE NDA
		nda_rd=0;

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

		//0 GESTIONE NDA
		nda_rd=0;

		//1 GESTIONE READ
		if(in0_empty==1 | c0_cnt==0) 
			in0_rd=0; 
		else 
			in0_rd=1; //READ PUO' BLOCCARSI SOLO SE NELLA FIFO A MONTE NON CI SONO DATI (c0_empty==1) O SE HO IL DATO PRONTO DA MANDARE (c0_cnt==3)

		//2 GESTIONE WRITE //3 GESTIONE ACC E CNT //4 GESTIONE USCITA 
		if(c0_cnt==0 & out0_full==0)   //(c0_cnt==3 & out0_full==0) E' LA CONDIZIONE PER IL QUALE L'ACCUMULATORE MANDA IL DATO IN USCITA, SE E' VERA MANDO IL DATO IN USCITA 
			begin 
				out0_data=c0_acc+in0_data; 
				out0_wr=1; 
				c0_cntnxt=0;
				c0_accnxt=0;
			end 
		else if(c0_cnt==0 & out0_full==1) //SE HO PRONTO IL DATO DA MANDARE (c0_cnt==3) MA LA FIFO A VALLE E' PIENA (out0_full==1) ALLORA RIMANGO FERMO, CONSERVANDO DATI E CONTEGGIO E OVVIAMENTE NON TORNANDO IN ATTESA
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
			c0_cntnxt=c0_cnt-1; 
			c0_accnxt=c0_acc+in0_data;
			end

		//5 GESTIONE PASSAGGIO DI STATO
		if((c0_cnt==0 & out0_full==0)) 
			c0_statenxt=c0_PICK; //SE HO FINITO L'ACCUMULAZIONE TORNO IN PICK PER PRENDERE UN NUOVO NDA, ALTRIMENTI CONTINUO AD ACCUMULARE FINO A CHE NON FINISCO
		else if(in0_empty==1 & ~(c0_cnt==0)) 
			c0_statenxt=c0_ATTESA; //DEVO TORNARE IN ATTESA SOLO SE HO LA FIFO A MONTE VUOTA E NON HO I DATI PRONTI (in0_empty==1 & ~(c0_cnt==3)) OPPURE SE HO APPENA MANDATO UN DATO (c0_cnt==3 & out0_full==0)   
		else 
			c0_statenxt=c0_AZIONE; 
	end


//SEQUENZIALE 
always@(posedge ck or posedge rst)
if(rst==1) 
	begin
		c0_state<=c0_PICK;
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