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

module SDF_1P_1F#(
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

//-> SONO STATO BLOCCATO NELLA LETTURA E SCRITTURA DEI DATI; LE ACCUMULAZIONI SONO SALVATE SU ACC E VENGONO MANDATE APPENA POSSO TORNARE IN AZIONE
if(c0_state==c0_ATTESA)
	begin
	
		//1 GESTIONE READ
		if(in0_empty==1 | out0_full==1) 
			in0_rd=0;  // SE HO LA FIFO A MONTE NON VUOTA E LA FIFO A VALLE NON PIENA SCRIVO E LEGGO, ALTRIMENTI NO
		else 
			in0_rd=1;

		//2 GESTIONE WRITE
		if(in0_empty==1 | out0_full==1) 
			out0_wr=0; 
		else 
			out0_wr=1;

		//3 GESTIONE ACC E CNT 
		if(c0_cnt==0 & ~(in0_empty==1 | out0_full==1)) //SE MI E' ARRIVATO UN FULL O UN EMPTY NEL MOMENTO IN CUI HO MANDATO IL QUARTO READ (E QUINDI DEVO RESETTARE) LUI SI OCCUPA DI AZZERARE ACCNXT. IN TAL MODO NEL MOMENTO IN CUI INIZIO IL SUCCESSIVO CICLO DI ACCUMULAZIONE, DATAOUT E' LEGATO AD ACC CHE TIENE I 4 DATI ACCUMULATI MENTRE ACCNXT AZZERA ACC IN MODO CHE QUANDO ENTRO IN AZIONE ACCNXT E' PRONTO PER IMMAGAZZINARE I DATI 
			begin
				c0_accnxt=0;
				c0_cntnxt=c0_cnt; //ACC NON C'E' BISOGNO DI INCREMENTARLO PERCHE' VERRA' INCREMENTATO IN AZIONE
			end
		else
			begin
				c0_accnxt=c0_acc;
				c0_cntnxt=c0_cnt;
			end

		//4 GESTIONE USCITA 
		out0_data=c0_acc; //IN TAL MODO SE HO UNA INTERRUZIONE (E QUINDI PASSO DA AZIONE AD ATTESA) LE ACCUMULAZIONI SONO PRONTE E, APPENA c0_statenxt=c0_AZIONE, LE MANDO
  
		//5 GESTIONE PASSAGGIO DI STATO
		if(in0_empty==1 | out0_full==1)
			c0_statenxt=c0_ATTESA; 
		else 
			c0_statenxt=c0_AZIONE;  
	end

else
//-> CHIAMO E CONTINUO A CHIAMARE FINO A CHE POSSO
	begin
	
		//1 GESTIONE READ
		if(in0_empty==1 | out0_full==1) 
			in0_rd=0; 
		else 
			in0_rd=1; //READ PUO' BLOCCARSI SOLO SE HO LA FIFO A MONTE NON VUOTA E LA FIFO A VALLE NON PIENA
 
		//2 GESTIONE WRITE //3 GESTIONE ACC E CNT //4 GESTIONE USCITA 
		if(c0_cnt==3 & ~(out0_full==1 | in0_empty==1)) //SONO ARRIVATO A 4, HO MANDATO E DEVO AZZERARE 
//NOTA: CHE QUANDO ARRIVO A QUESTA CONDIZIONE STO SCRIVENDO L'ACCUMULAZIONE DI 4 DATI IN QUANTO READ e WRITE SONO IN ANTICIPO DI UN CICLO DI CLOCK RISPETTO AL CONTEGGIO (DI FATTO E' COME SE FOSSI AL PRIMO DATO DELL'ACCUMULAZIONE SUCCESSIVA PERCHE' STO LEGGENDO IL PRIMO DATO E MANDANDO I PRECEDENTI 4). ALLA PRIMA PAUSA (EMPTY O FULLO O ENTRAMBI AD 1) I READ E WRITE SI RI-SINCRONIZZANO CON IL CONTEGGIO  
			begin
				out0_wr=1;
				out0_data=c0_acc+in0_data;
				c0_accnxt=0;
				c0_cntnxt=c0_cnt+1;
			end

		else
		if(out0_full==1 | in0_empty==1) //NON SONO ARRIVATO A 4 MA NON POSSO FARE NULLA; DUNQUE FINISCO L'ACCUMULAZIONE DEL VECCHIO READ E PAREGGIO IL NUMERO DI READ CON IL CONTEGGIO MA OVVIAMENTE NON LEGGO E NON SCRIVO 
			//NOTA: QUANDO SONO STATO BLOCCATO DA UN FULL E/O UN EMPTY ED ERO A c0_cnt==3, IL CONTEGGIO VA A ZERO MA L'ACCUMULAZIONE CHE AVREI DOVUTO MANDARE (DI 4 DATI) E' TUTTA DENTRO c0_acc QUANDO SARO' IN c0_ATTESA. DA c0_ATTESA, APPENA POTRO' ANDARE IN c0_AZIONE, NELLA TRANSIZIONE c0_ATTESA->c0_AZIONE MANDO L'ACCUMULAZIONE DEI 4 DATI TRAMITE IL WRITE ATTIVATO IN ATTESA 
			begin
				out0_wr=0;
				out0_data=c0_acc+in0_data;
				c0_accnxt=c0_acc+in0_data;
				c0_cntnxt=c0_cnt+1;
			end

		else //NON SONO ARRIVATO A 4 MA NON CI SONO PROBLEMI, DUNQUE CONTINUO AD ACCUMULARE E A MANDARE. 
			begin
				out0_wr=1;
				out0_data=c0_acc+in0_data; 
				c0_accnxt=c0_acc+in0_data;
				c0_cntnxt=c0_cnt+1;
			end
		//5 GESTIONE PASSAGGIO DI STATO
		if(out0_full==1 | in0_empty==1)
			c0_statenxt=c0_ATTESA; //DEVO TORNARE IN ATTESA SOLO SE HO LA FIFO A MONTE VUOTA E NON HO I DATI PRONTI (in0_empty==1 & ~(c0_cnt==3)) OPPURE SE HO APPENA MANDATO UN DATO (c0_cnt==3 & out0_full==0)
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