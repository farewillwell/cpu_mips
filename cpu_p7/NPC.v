module NPC (
    input [31:0]signImm_D,//imm after extend
    input [25:0]JPC_D,//j
    input [31:0]Jrdata_D,//data in reg
    input beqsrc,//beq
    input [31:0]WPC,//pc now,for next pc
    input Jr,//jr of not
    input Jump,// j class or not
    output [31:0]newPc,// the new pc
    input [31:0]EPC,
    input Req,
    input Eret_D
);
wire [31:0]JPCS;//get jpc
wire [31:0]out1;//
wire [31:0]out2;
wire [31:0]BeqImm;//the imm for beq
wire [31:0]nextPc;

assign nextPc=WPC+4;
//nextPc

assign BeqImm=WPC+{signImm_D[29:0],2'b00};// 
//**excuse! the order to be jump is pc in D,but Wpc is in pc,so no need to plus 4
//
//

assign JPCS={WPC[31:28],JPC_D,2'b00};
//
assign out1=(beqsrc==1'b1)?BeqImm:nextPc;
//nextpc or beqimm
assign out2=(Jr==1'b1)?Jrdata_D:JPCS;
//
assign newPc=(Req==1'b1)?32'h0000_4180:
             (Eret_D==1'b1)?(EPC+4):
             (Jump==1'b1)?out2:out1;
endmodule //NPC