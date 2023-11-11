`timescale 1ns / 1ps
module ALU (
    input [3:0]Aluop,
    input [31:0]inA,
    input [31:0]inB,
    input [4:0]shamt,
    output [31:0]AluAns ,
    output OV_sign,
    output AdEL_sign_alu,
    output AdES_sign_alu,
    input [2:0]type_ins_E
);
//，01是addaddi 010是sub，100是load，110是store类型指令。
wire [31:0]signB;
assign signB=$signed (inB)<<<shamt ;
wire [31:0]slt_ans;
wire [31:0]sltu_ans;
assign AluAns=(Aluop==0)?inA&inB:
              (Aluop==1)?inA|inB:
              (Aluop==2)?inA+inB:
              (Aluop==4)?inB<<16:
              (Aluop==5)?inA^inB:
              (Aluop==6)?inA-inB:
				  (Aluop==7)?slt_ans:
				  (Aluop==8)?sltu_ans:
              (Aluop==11)?inB<<shamt:
              (Aluop==12)?inB>>shamt:
              (Aluop==13)? signB:0;
assign slt_ans=($signed(inA)<$signed(inB))?32'b1:32'b0;
assign sltu_ans=(inA<inB)?32'b1:32'b0;

wire [32:0] over_inA;
wire [32:0] over_inB;
wire [32:0] over_ans_add;
wire [32:0] over_ans_sub;
assign over_inA={inA[31],inA};
assign over_inB={inB[31],inB};
assign over_ans_add=over_inA+over_inB;
assign over_ans_sub=over_inA-over_inB;
wire over_add_sign;//
wire over_sub_sign;
//注意这里，加减法应该分开算！假如是加法不溢出，然后减法溢出或者减法不溢出加法溢出都可能出事情！！！
assign over_add_sign=(over_ans_add[32]!=over_ans_add[31])?1'b1:1'b0;
assign over_sub_sign=(over_ans_sub[32]!=over_ans_sub[31])?1'b1:1'b0;
assign AdEL_sign_alu=(type_ins_E==3'b100)?over_add_sign:1'b0;
assign AdES_sign_alu=(type_ins_E==3'b110)?over_add_sign:1'b0;
assign OV_sign=((type_ins_E==3'b001&&over_add_sign==1)||(type_ins_E==3'b010&&over_sub_sign==1))?1'b1:1'b0;
endmodule //ALU