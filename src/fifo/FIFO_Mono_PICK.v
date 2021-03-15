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
//FIFO PARAMETRIZZATA
//FIFO CON PICK

module FIFO_Mono_PICK#(
    parameter WIDTH = 8,
    parameter DEPTH = 8
)(
input ck,
input reset,
input read,
input write,
input [WIDTH-1:0] datain,
output reg full,
output reg empty,
output reg [WIDTH-1:0] dataout
);

parameter ADDR_WIDTH=$clog2(DEPTH);

reg [WIDTH-1:0] mem_ram [0:DEPTH-1];
reg [ADDR_WIDTH-1:0] Wp;
reg [ADDR_WIDTH-1:0] Wpnxt;
reg [ADDR_WIDTH-1:0] Rp;
reg [ADDR_WIDTH-1:0] Rpnxt;
reg WnR;
reg WnRnxt;

always@(posedge ck or posedge reset) //assegnati Wp,Rp,WnR
if(reset)
	begin 
		Wp<=0;
		Rp<=0;
		WnR<=0;
	end
else
	begin
		Rp<=Rpnxt; 
		Wp<=Wpnxt; 
		WnR<=WnRnxt; 
	end

always@(posedge ck) //assegnato mem
if(full==0)
	if(write)
		mem_ram[Wp] = datain;

always@(posedge ck) //assegnato mem
if((empty==1 & write==1) | (empty==0 & read==1))
        dataout = mem_ram[Rpnxt];
else
        dataout = mem_ram[Rp];

always@(write,full,Wp) //assegnato Wp_nxt
	if(full) 
		Wpnxt=Wp;
	else if(write) 
		Wpnxt=Wp+1;
	else 
		Wpnxt=Wp;

always@(read,empty,Rp) //assegnato Rp_nxt
	if(empty) 
		Rpnxt=Rp;
	else if(read) 
		Rpnxt=Rp+1;
	else  
		Rpnxt=Rp;

always@(write,read,WnR, full, empty) //assegnato WnR_nxt
	if(write==1 & read==0 & full==0) 
		WnRnxt=1;
	else if(write==0 & read==1 & empty==0)
		WnRnxt=0;
	else 
		WnRnxt=WnR;

always@ (Wp,Rp,WnR) //assegnati full ed empty (possibili richiamate con gli always di assegnazione di Wp_nxt ed Rp_nxt)
if(Wp==Rp)
	if(WnR) 
		begin 
			full=1; 
			empty=0; 
		end
	else
		begin
			empty=1; 
			full=0; 
		end
else
	begin
		empty=0; 
		full=0; 
	end

endmodule