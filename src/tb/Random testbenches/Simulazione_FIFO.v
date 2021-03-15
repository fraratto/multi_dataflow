`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.02.2021 14:14:51
// Design Name: 
// Module Name: Simulazione_FIFO
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


module Simulazione_FIFO;
reg [7:0] datain;
reg write;
reg ck;
reg reset;
wire [1:0] full;
wire [1:0] empty;
wire [7:0] dataout;

reg [1:0] read;
//FIFO dut(.ck(ck),.rst(reset),.rd(read),.wr(write),.datain(datain),.full(pieno),.empty(vuoto),.dataout(dataout));

//FIFO_MF dut(.ck(ck),.rst(reset),.rd_0(read),.rd_1(read_1),.wr(write),.datain(datain),.full_0(pieno),.full_1(pieno),.empty_0(vuoto),.empty_1(vuoto_1),.dataout(dataout));

//FIFO_PNT dut1(.ck(ck),.rst(reset),.rd0(read),.rd1(read_1),.wr(write),.datain(datain),.full(pieno),.empty0(vuoto),.empty1(vuoto_1),.dataout(dataout));

//FIFO_SR_PAR dut2(.ck(ck),.rst(reset),.rd(read),.wr(write),.datain(datain),.full(full),.empty(empty),.dataout(dataout));

//FIFO_MS_PAR dut2(.ck(ck),.rst(reset),.rd(read),.wr(write),.datain(datain),.full(full),.empty(empty),.dataout(dataout));

//FIFO_MS_PAR_PICK dut2(.ck(ck),.rst(reset),.rd(read),.wr(write),.datain(datain),.full(full),.empty(empty),.dataout(dataout));

//FIFO_SR_PAR_PICK dut2(.ck(ck),.rst(reset),.rd(read),.wr(write),.datain(datain),.full(full),.empty(empty),.dataout(dataout));

//OTTIMIZZATO PER 8 LOCAZIONI, 8 DATI

initial
begin
ck=0;
reset=0;
read=0;
write=0;
#6 reset=1;
#5 reset=0;datain={1'b1,7'd1};
#5 write=1;datain={1'b1,7'd2};
#10 datain={1'b0,7'd1};
#10 datain={1'b1,7'd3};
#10 datain={1'b1,7'd4};
#10 datain={1'b0,7'd2};
#10 datain={1'b0,7'd3}; write=0;
#10 datain={1'b0,7'd2};
#10 datain={1'b1,7'd7};//FULL
#10 datain={1'b0,7'd2};
#10 datain={1'b1,7'd7};
#10 datain={1'b0,7'd5};write=0;
#20 datain={1'b0,7'd4};read=1;
#10 datain={1'b0,7'd5};read=2;
#10 datain={1'b1,7'd5};read=0;
#10 datain={1'b1,7'd6};
#10 datain={1'b1,7'd7};write=1;
#10 datain={1'b0,7'd8};
#10 datain={1'b0,7'd6};write=0;
#10 datain={1'b0,7'd7};
#10 datain={1'b0,7'd8};read=1;
#10 datain={1'b0,7'd9};
#10 datain={1'b0,7'd10};
#10 datain={1'b1,7'd9};
#10 datain={1'b1,7'd10};
#10 datain={1'b1,7'd10};
#10 datain={1'b1,7'd11};read=2;
#10 datain={1'b0,7'd11};
#10 datain={1'b0,7'd12};
#10 datain={1'b0,7'd13};
#10 datain={1'b0,7'd14};
#10 datain={1'b0,7'd15};read=0;
#10 datain={1'b1,7'd12};
#10 datain={1'b1,7'd13};
#10 datain={1'b1,7'd14};read=1;write=1;
#10 datain={1'b0,7'd15};
#10 datain={1'b1,7'd14};read=2;
#10 datain={1'b0,7'd15};
#10 datain={1'b1,7'd14};
#10 datain={1'b0,7'd16};
#10 datain={1'b1,7'd14};read=0;
#10 datain={1'b0,7'd17};
#10 datain={1'b1,7'd14};
#10 datain={1'b0,7'd18};
#10 datain={1'b1,7'd14};
#10 datain={1'b0,7'd19};
#10 datain={1'b1,7'd14};
#10 datain={1'b0,7'd13};
#10 datain={1'b1,7'd14};
#10 datain={1'b0,7'd16};
#10 datain={1'b1,7'd14};
#10 datain={1'b0,7'd19};write=0;
#50 read=2;
#90 read=1;
#90 read=0;
#20 $stop;
end

always
#5 ck=~ck;

endmodule

