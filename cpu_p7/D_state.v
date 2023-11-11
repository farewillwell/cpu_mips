module D_state (
    input clk,
    input reset,
    input [31:0]instr_F,
    output [31:0] pc_8_D,
    output [31:0] instr_D,
    output[4:0]RS_D,
    output[4:0]RT_D,
    output[4:0]RD_D,
    input En,//这个en代表的不是使能，而是是否停止，是1的话则就阻塞
    input [31:0]WPC_F,
    output [31:0]WPC_D,
    output [15:0] NoneImm,
    output [4:0]shamt_D,
    output [25:0]JPC_D,
    input Req,
    input BD_F,
    output BD_D,
    input AdEL_sign_pc,
    output [4:0] ExcCode_D
);
reg[31:0]instr;
reg[31:0]WPC;
reg[31:0]pc_8;
reg BD;
reg [4:0]ExcCode;
assign WPC_D=WPC;
assign pc_8_D=WPC+8;
assign instr_D=instr;
assign RS_D=instr[25:21];
assign RT_D=instr[20:16];
assign RD_D=instr[15:11];
assign NoneImm=instr[15:0];
assign JPC_D=instr[25:0];
assign shamt_D=instr[10:6];
assign BD_D=BD;
assign ExcCode_D=ExcCode;
always @(posedge clk) begin
    if(reset==1||Req==1)
    begin
        instr<=0;
        WPC<=(Req==1)?32'h0000_4180:0;
          BD<=0;
          ExcCode<=0;
    end
    else if(En==0)
    begin
        instr<=instr_F;
        WPC<=WPC_F;
          BD<=BD_F;
          ExcCode<=(AdEL_sign_pc==1'b1)?5'd4:5'd0;
    end
    else
    begin
        instr<=instr;
        WPC<=WPC;
          BD<=BD;
          ExcCode<=ExcCode;
    end
end
initial
begin
    instr=0;
    WPC=0;
     BD=0;
     ExcCode=0;
end
endmodule //D_state