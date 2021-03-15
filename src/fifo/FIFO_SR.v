`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2020 13:57:56
// Design Name: 
// Module Name: FIFO_PNTV2
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
 
module FIFO_SR#(
    parameter WIDTH = 8, //WIDTH E' LA DIMENSIONE COMPLESSIVA (DUNQUE NEL CONTEGGIO WIDTH BISOGNA CONTARE TOT BIT PER IL TAG)
    parameter DEPTH = 8,
    parameter FLUX = 2
)(
input ck,
input rst,
input [FLUX-1:0] rd,
input wr,
input [WIDTH-1:0] datain,
output reg full,
output reg [FLUX-1:0] empty,
output reg [WIDTH-1:0] dataout
);
 
parameter TAG_WIDTH = $clog2(FLUX);
parameter ADDR_WIDTH = $clog2(DEPTH);

//DATI E INDIRIZZI
reg [WIDTH-1:0] mem_ram [0:DEPTH-1];
reg [ADDR_WIDTH-1:0] ram_nxt [0:DEPTH-1];

//STATUS DELLA MEMORIA
reg [DEPTH-1:0] statusreg;

//LOCAZIONI LIBERE E STORIE DEI FLUSSI
reg [ADDR_WIDTH-1:0] Rpstory [0:FLUX-1]; 
reg [ADDR_WIDTH-1:0] lastloc; 
reg [ADDR_WIDTH-1:0] previous [0:FLUX-1];

//PUNTATORI
reg [ADDR_WIDTH-1:0] Wp;
reg [ADDR_WIDTH-1:0] Wpnxt;
reg [ADDR_WIDTH-1:0] Rp [0:FLUX-1];
reg [ADDR_WIDTH-1:0] Rpnxt [0:FLUX-1];
reg [ADDR_WIDTH:0] Rptot; //manca il -1 perché altrimenti non ci sta la somma di tutti i W_LOC. Alternative?

//VARIABILI DI CONTROLLO
integer i; //flusso
integer j;

//GESTIONE AGGIORNAMENTI/LETTURA/SCRITTURA
////////////////////////////////////////////////////////////////////////////////
always@(posedge ck or posedge rst)
begin

//RESET
	if(rst)
		begin 
		for(i=0;i<=FLUX-1;i=i+1)
            begin
                previous[i] = 0;
                Rpstory[i] = 0;
            end
		for(i=0;i<=DEPTH-1;i=i+1)
				statusreg[i]=0;
		end

//SCRITTURA
	if(full==0)
		if(wr)
		for(i=0;i<=FLUX-1;i=i+1)
			if(datain[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)]==i) 
				begin
					mem_ram[Wp]=datain;
					if(Rpstory[i]!=0) 
						begin
							ram_nxt[previous[i]]=Wp;
						end
					previous[i]=Wp;
					Rpstory[i]=Rpstory[i]+1;
					statusreg[Wp]=1; 
			    end

//LETTURA
for(i=0;i<=FLUX-1;i=i+1)
	if(empty[i]==0)
		if(rd[i])
			begin 
				Rpstory[i] = Rpstory[i]-1;
				dataout = mem_ram[Rp[i]];
				statusreg[Rp[i]]=0;
			end
////////////////////////////////////////////////////////////////////////////////

//AGGIORNAMENTI
////////////////////////////////////////////////////////////////////////////////
if(rst)
begin
	Wp<=0;
	for(i=0;i<=FLUX-1;i=i+1)
	    Rp[i]<=0;
end
else
begin
	Wp<=Wpnxt;
	for(i=0;i<=FLUX-1;i=i+1)
        Rp[i]<=Rpnxt[i];
end

end
////////////////////////////////////////////////////////////////////////////////

//RICERCA DI LOCAZIONI VUOTE
////////////////////////////////////////////////////////////////////////////////
always@(statusreg,Wp)   
        if(&statusreg)  
            lastloc = Wp;
        else
            for(j=DEPTH-1; j>=0; j=j-1)
                if(statusreg[j]==0 && Wp!=j)
                    lastloc = j;
                else 
                	lastloc = lastloc; 

////////////////////////////////////////////////////////////////////////////////

//GESTIONE DEL PUNTATORE DI SCRITTURA
////////////////////////////////////////////////////////////////////////////////
always@(*) //full,lastloc,wr,Wp,Rp[i],rd[i],i   
for(i=0;i<=FLUX-1;i=i+1)
    if((full & rd[i]==1) | (lastloc==Wp & rd[i]==1 & wr==1))   
	   Wpnxt=Rp[i];
	else if(wr==1 & lastloc!=Wp)
	   Wpnxt=lastloc;
    else 
	   Wpnxt=Wp;
////////////////////////////////////////////////////////////////////////////////

//AGGIORNAMENTO DI LETTURA FLUSSI
////////////////////////////////////////////////////////////////////////////////
always@(*) //wr,Rpstory[i],datain[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)],Wp,rd[i],ram_nxt[Rp[i]],Rp[i],i
for(i=0;i<=FLUX-1;i=i+1)
    if(wr==1 & Rpstory[i]==0 & datain[WIDTH-1:WIDTH-1-(TAG_WIDTH-1)]==i)
	   Rpnxt[i]=Wp;
    else if(Rpstory[i]>1 & rd[i]==1)
	   Rpnxt[i]=ram_nxt[Rp[i]];
    else 
	   Rpnxt[i]=Rp[i];
////////////////////////////////////////////////////////////////////////////////

//AGGIORNAMENTO FULL/EMPTY
////////////////////////////////////////////////////////////////////////////////
always@(*) //Rpstory[i], Rptot, i
begin
//FULL
Rptot=0;
for(i=0;i<=FLUX-1;i=i+1)
    Rptot=Rptot+Rpstory[i];
if(Rptot==DEPTH) //Overflow su Rptot, necessario mettere Rptot dimensionato a W_LOC anziché W_LOC-1. Alternative?
	full=1;
else 
	full=0;
//EMPTY
for(i=0;i<=FLUX-1;i=i+1)
    if(Rpstory[i]==0) 
	   empty[i]=1;
    else 
	   empty[i]=0;

end
////////////////////////////////////////////////////////////////////////////////

endmodule