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

module FIFO_MS#(
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

//PUNTATORI
reg [ADDR_WIDTH-1:0] Wp [0:FLUX-1];
reg [ADDR_WIDTH-1:0] Wpnxt [0:FLUX-1];
reg [ADDR_WIDTH-1:0] Rp [0:FLUX-1];
reg [ADDR_WIDTH-1:0] Rpnxt [0:FLUX-1];
reg WnR [0:FLUX-1];
reg WnRnxt [0:FLUX-1];

//VARIABILI DI CONTROLLO
integer i;

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
for(i=0;i<=FLUX-1;i=i+1)
	if(empty[i]==0)
		if(rd[i]) 
			dataout = mem_ram[Rp[i]][i];
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