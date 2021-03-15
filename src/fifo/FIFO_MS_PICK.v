`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2020 13:36:11
// Design Name: 
// Module Name: FIFO_MF
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

//RICONTROLLARE IL MECCANISMO DI EXIT, SITUAZIONE IN CUI NON HO LETTURE (STATUS DIVENTA PRATICAMENTE INUTILE)

module FIFO_MS_PICK#(
    parameter WIDTH = 8,
    parameter DEPTH = 4, //PROFONDITA' DI OGNI FLUSSO 
    parameter FLUX = 2
)(
input ck,
input rst,
input wr,
input [WIDTH-1:0] datain,
input [FLUX-1:0] rd,
output reg [FLUX-1:0] full,
output reg [FLUX-1:0] empty,
output reg [WIDTH-1:0] dataout
);

parameter TAG_WIDTH = $clog2(FLUX);
parameter ADDR_WIDTH = ($clog2(DEPTH));
 
//ORGANIZZAZIONE FLUSSI
reg [WIDTH-1:0] mem_ram [0:DEPTH-1][0:FLUX-1];
reg [WIDTH-1:0] exits [0:FLUX-1];

//PUNTATORI
reg [ADDR_WIDTH-1:0] Wp [0:FLUX-1];
reg [ADDR_WIDTH-1:0] Wpnxt [0:FLUX-1];
reg [ADDR_WIDTH-1:0] Rp [0:FLUX-1];
reg [ADDR_WIDTH-1:0] Rpnxt [0:FLUX-1];
reg WnR [0:FLUX-1];
reg WnRnxt [0:FLUX-1];

//VARIABILI DI CONTROLLO
integer i;
reg status_ext;
reg [FLUX-1:0] caller;

//LETTURA/SCRITTURA
////////////////////////////////////////////////////////////////////////////////
always@(posedge ck or posedge rst) //assegnati Wp0,Rp0,WnR
if(rst) 
	for(i=0;i<=FLUX-1;i=i+1)
	begin
		Wp[i]<=0;
		Rp[i]<=0;
		WnR[i]<=0;
	end
else
    for(i=0;i<=FLUX-1;i=i+1)
	begin
		Rp[i]<=Rpnxt[i]; 
		Wp[i]<=Wpnxt[i]; 
		WnR[i]<=WnRnxt[i]; 
	end
	
//FULL
always@(posedge ck) 
if(wr==1)
    for(i=0;i<=FLUX-1;i=i+1)
	if(full[i]==0 & datain[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)]==i)
			mem_ram[Wp[i]][i] = datain;
			
//EMPTY
always@(posedge ck)
    begin
        for(i=FLUX-1;i>=0;i=i-1) //PROBLEMA: SE UNO SCRIVESSE PER LA PRIMA VOLTA NON HA MICA BISOGNO DI AVERE UNA LETTURA
        if(rd[i]==1 & empty[i]==0 | (empty[i]==1 & wr==1 & datain[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)]==i)) //in questo modo trovo il mitico che vuole leggere dati già presenti nella FIFO e gli metto il dato in uscita           
                begin
                    exits[i] = mem_ram[Rpnxt[i]][i];
                end
		else 
                begin
                    exits[i] = mem_ram[Rp[i]][i]; 
                end                               
    end

////////////////////////////////////////////////////////////////////////////////

//SELETTORE DELL'USCITA
////////////////////////////////////////////////////////////////////////////////
always@(*)
//cerca se qualcuno ha fatto una richiesta di lettura
if(|rd==1)
    status_ext=1;
else
    status_ext=0;

always@(*)
if(status_ext==1) //se qualcuno ha chiesto una lettura
    begin
        for(i=FLUX-1;i>=0;i=i-1)
            if(rd[i]==1) //prima trovo il richiedente
                begin
                    caller=i; //secondo lui qui c'è un latch 
                end
            else
                begin
                    caller=caller;
                end
        dataout=exits[caller]; //poi metto l'uscita in base al richiedente
    end
else //se invece nessuno ha richiesto la lettura
    begin
        dataout=exits[FLUX-1]; //metto di default quella del flusso più importante
        caller=FLUX-1;
    end
////////////////////////////////////////////////////////////////////////////////

//PROSSIMA SCRITTURA/LETTURA E STATUS
////////////////////////////////////////////////////////////////////////////////

//PROSSIMA SCRITTURA
always@(*) //wr,full[i],Wp[i],datain[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)],i
for(i=0;i<=FLUX-1;i=i+1)
if(full[i]) 
	Wpnxt[i]=Wp[i];
else if(wr==1 & datain[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)]==i) 
	Wpnxt[i]=Wp[i]+1;
else 
	Wpnxt[i]=Wp[i];
	
//PROSSIMA LETTURA
always@(*) //rd[i],empty[i],Rp[i],i
for(i=0;i<=FLUX-1;i=i+1)
if(empty[i]) 
	Rpnxt[i]=Rp[i];
else if(rd[i]==1) 
	Rpnxt[i]=Rp[i]+1;
else  
	Rpnxt[i]=Rp[i];
	
//STATUS
always@(*) //wr,rd[i],WnR[i],datain[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)],i, full[i], empty[i]
for(i=0;i<=FLUX-1;i=i+1)
if((wr==1 & full[i]==0 & datain[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)]==i) & rd[i]==0) 
	WnRnxt[i]=1;
else if((wr==0 | wr==1 & datain[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)]!=i) & rd[i]==1 & empty[i]==0) 
	WnRnxt[i]=0;
else 
	WnRnxt[i]=WnR[i];
	
always@ (*) //Wp[i],Rp[i],WnR[i],i
for(i=0;i<=FLUX-1;i=i+1)
if(Wp[i]==Rp[i])
	if(WnR[i]) 
		begin 
			full[i]=1; 
			empty[i]=0; 
		end
	else
		begin
			full[i]=0;
			empty[i]=1; 
		end
else
	begin
		empty[i]=0; 
		full[i]=0; 
	end
////////////////////////////////////////////////////////////////////////////////

endmodule