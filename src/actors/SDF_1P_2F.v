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
// SDF PARAMETRIZZATO

module SDF_1P_2F#(
parameter WIDTH=33,
parameter ATTESA=0,
parameter AZIONE=1
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
if(in1_empty==0 & full==0) 
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

//-> SONO STATO BLOCCATO NELLA LETTURA E SCRITTURA DEI DATI; LE ACCUMULAZIONI SONO SALVATE SU ACC E VENGONO MANDATE APPENA POSSO TORNARE IN AZIONE
if(eqv_state==ATTESA)
	begin
	
		//1 GESTIONE READ
		if(eqv_empty==1 | full==1) 
			eqv_read=0; 
		else 
			eqv_read=1;

		//2 GESTIONE WRITE
		if(eqv_empty==1 | full==1) 
			wr=0; 
		else 
			wr=1;

		//3 GESTIONE ACC E CNT 
		if(eqv_cnt==0 & ~(eqv_empty==1 | full==1))  
			begin
				eqv_accnxt=0;
				eqv_cntnxt=eqv_cnt; 
			end
		else
			begin
				eqv_accnxt=eqv_acc;
				eqv_cntnxt=eqv_cnt;
			end

		//4 GESTIONE USCITA 
		out_data={tag,eqv_acc}; 
  
		//5 GESTIONE PASSAGGIO DI STATO
		if(eqv_empty==1 | full==1)
			eqv_statenxt=ATTESA; 
		else 
			eqv_statenxt=AZIONE;  
	end

else
//-> CHIAMO E CONTINUO A CHIAMARE FINO A CHE POSSO
	begin
	
		//1 GESTIONE READ
		if(eqv_empty==1 | full==1) 
			eqv_read=0; 
		else 
			eqv_read=1; 
 
		//2 GESTIONE WRITE //3 GESTIONE ACC E CNT //4 GESTIONE USCITA 
		if(eqv_cnt==3 & ~(full==1 | eqv_empty==1))    
			begin
				wr=1;
				out_data={tag,(eqv_acc+in_data[WIDTH-2:0])};
				eqv_accnxt=0;
				eqv_cntnxt=eqv_cnt+1;
			end

		else
		if(full==1 | eqv_empty==1)   
			begin
				wr=0;
				out_data={tag,(eqv_acc+in_data[WIDTH-2:0])};
				eqv_accnxt=eqv_acc+in_data[WIDTH-2:0];
				eqv_cntnxt=eqv_cnt+1;
			end

		else  
			begin
				wr=1;
				out_data={tag,(eqv_acc+in_data[WIDTH-2:0])}; 
				eqv_accnxt=eqv_acc+in_data[WIDTH-2:0];
				eqv_cntnxt=eqv_cnt+1;
			end
		//5 GESTIONE PASSAGGIO DI STATO
		if(full==1 | eqv_empty==1)
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