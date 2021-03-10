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

module DDF_1P_2F#(
parameter WIDTH=33,
parameter WIDTH_NDA=5,
parameter ATTESA=0,
parameter AZIONE=1,
parameter CHOICE=2,
parameter PICK=3
)(
input [WIDTH_NDA-1:0] nda_data,
input [WIDTH-1:0] in_data,

input ck,
input rst,
input full,
//NDA
input nda0_empty,
input nda1_empty,
//PORTA 0
input in0_empty,
input in1_empty,
//NDA
output reg nda0_read,
output reg nda1_read,
//PORTA 0
output reg in0_read,
output reg in1_read,

output reg wr,
output reg [WIDTH-1:0] out_data);

//PRIORITA'
reg tag;

//EQUIVALENTI
reg [1:0] eqv_state;
reg [1:0] eqv_statenxt;
reg eqv_read;
reg eqv_ndaread;
reg eqv_ndaempty;
reg eqv_empty;
reg [WIDTH_NDA-2:0] eqv_cnt;
reg [WIDTH_NDA-2:0] eqv_cntnxt;
reg [WIDTH-2:0] eqv_acc;
reg [WIDTH-2:0] eqv_accnxt;

//FLUSSO 0
reg [1:0] c0_state;
reg [WIDTH_NDA-2:0] c0_cnt;
reg [WIDTH-2:0] c0_acc;

//FLUSSO 1
reg [1:0] c1_state;
reg [WIDTH_NDA-2:0] c1_cnt;
reg [WIDTH-2:0] c1_acc;

//COMBINATORIA 
always@(*)

begin

//CONDIZIONE DI DECISIONE SUL TAG
if((in1_empty==0 & c1_state!=PICK) | (nda1_empty==0 & c1_state==PICK) | c1_state==CHOICE) //senza tre condizioni rischio di bloccarmi su un solo flusso mentre gli altri flussi sono disponibili
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
		eqv_ndaempty=nda1_empty;
	end
else
	begin
		eqv_empty=in0_empty;	
		eqv_state=c0_state;
		eqv_cnt=c0_cnt;
		eqv_acc=c0_acc;
		eqv_ndaempty=nda0_empty;
	end

if(eqv_state==PICK) 
	begin

		//0 GESTIONE NDA
		if(eqv_ndaempty==1) 
			eqv_ndaread=0; 
		else 
			eqv_ndaread=1;

		//1 GESTIONE READ
		eqv_read=0;
 
		//2 GESTIONE WRITE
		wr=0;

		//3 GESTIONE ACC E CNT 
		eqv_accnxt=0; 
		eqv_cntnxt=0;
 
		//4 GESTIONE USCITA
		out_data={tag,eqv_acc};

		//5 GESTIONE PASSAGGIO DI STATO
		if(eqv_ndaempty==0) 
			eqv_statenxt=CHOICE;
		else 
			eqv_statenxt=PICK;
	end

else 
if(eqv_state==CHOICE)
	begin

		//0 GESTIONE NDA
		eqv_ndaread=0;

		//1 GESTIONE READ
		eqv_read=0;

		//2 GESTIONE WRITE
		wr=0;

		//3 GESTIONE ACC E CNT
		eqv_accnxt=0; 
		if(nda_data[WIDTH_NDA-2:0]==0) 
			eqv_cntnxt=0;  
		else 
			eqv_cntnxt=nda_data[WIDTH_NDA-2:0]-1;

		//4 GESTIONE USCITA
		out_data={tag,eqv_acc};

		//5 GESTIONE PASSAGGIO DI STATO
		if(nda_data[WIDTH_NDA-2:0]==0) 
			eqv_statenxt=PICK;
		else 
			eqv_statenxt=ATTESA;
	end
 
else
if(eqv_state==ATTESA) //->DEVO ASPETTARE CHE POSSA INIZIARE A CHIAMARE
	begin

		//0 GESTIONE NDA
		eqv_ndaread=0;

		//1 GESTIONE READ
		if(eqv_empty==1) 
			eqv_read=0; 
		else 
			eqv_read=1;

		//2 GESTIONE WRITE
		wr=0;

		//3 GESTIONE ACC E CNT 
		eqv_accnxt=eqv_acc; 
		eqv_cntnxt=eqv_cnt;

		//4 GESTIONE USCITA 
		out_data={tag,eqv_acc};

		//5 GESTIONE PASSAGGIO DI STATO
		if(eqv_empty==0) 
			eqv_statenxt=AZIONE;
		else 
			eqv_statenxt=ATTESA;  
	end

//->STO ACCUMULANDO; SE READ SI FERMA TORNO IN IDLE ALTRIMENTI CONTINUO FINO A MANDARE IL DATO. MANDATO IL DATO RITORNO IN ATTESA E RIPARTE COSI' IL CICLO
else
	begin

		//0 GESTIONE NDA
		eqv_ndaread=0;

		//1 GESTIONE READ
		if(eqv_empty==1 | eqv_cnt==0) 
			eqv_read=0; 
		else 
			eqv_read=1; 

		//2 GESTIONE WRITE //3 GESTIONE ACC E CNT //4 GESTIONE USCITA 
		if(eqv_cnt==0 & full==0) 
			begin 
				out_data={tag,(eqv_acc+in_data[WIDTH-2:0])}; 
				wr=1; 
				eqv_cntnxt=0;
				eqv_accnxt=0;
			end 
		else if(eqv_cnt==0 & full==1)
			begin 
				out_data={tag,eqv_acc}; 
				wr=0;
				eqv_cntnxt=eqv_cnt; 
				eqv_accnxt=eqv_acc; 
			end 
		else
			begin 
			out_data={tag,eqv_acc}; 
			wr=0; 
			eqv_cntnxt=eqv_cnt-1; 
			eqv_accnxt=eqv_acc+in_data[WIDTH-2:0];
			end

		//5 GESTIONE PASSAGGIO DI STATO
		if((eqv_cnt==0 & full==0)) 
			eqv_statenxt=PICK; 
		else if(eqv_empty==1 & ~(eqv_cnt==0)) 
			eqv_statenxt=ATTESA;    
		else 
			eqv_statenxt=AZIONE; 
	end

//ASSEGNAMENTI IN BASE AL TAG (FINE)

if(tag==1)
	begin
		nda1_read=eqv_ndaread;
		in1_read=eqv_read;
		nda0_read=0;
		in0_read=0;
	end
else
	begin
		nda1_read=0;
		in1_read=0;
		nda0_read=eqv_ndaread;
		in0_read=eqv_read;
	end

end 

//SEQUENZIALE 
always@(posedge ck or posedge rst)
if(rst==1) 
	begin
		c0_state<=ATTESA;
		c0_cnt<=0;
		c0_acc<=0;
		c1_state<=ATTESA;
		c1_cnt<=0;
		c1_acc<=0;
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