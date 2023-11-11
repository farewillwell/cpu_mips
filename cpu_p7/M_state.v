module M_state (
    input clk,
    input reset,
    // time signs
    input RegWrite_E,
    input MemtoReg_E,
    input link_E,
    // 4 ctrl signs
    output RegWrite_M,
    output MemtoReg_M,
    output link_M,
    // 4 ctrl signs out
    output [31:0] pc_8_M,
    input [4:0]A3_E,
    output [4:0]A3_M,
    input [31:0]WPC_E,
    output [31:0]WPC_M,
    input [31:0]AO_E,
    output [31:0]AO_M,
    input [31:0]RFD2_E,
    output [31:0]RFD2_M,
    input [2:0]Tnew_E,
    output [2:0]Tnew_M,
    input [4:0]RT_E,
    output [4:0]RT_M,
	 input[31:0]instr_E,
	 output [31:0]instr_M,
    input [1:0]byte_cho_E,
    output [1:0]byte_cho_M,
    input [2:0]load_op_E,
    output [2:0]load_op_M,
    input Req,
    input BD_E,
    output BD_M,
    input [2:0]type_ins_E,
    output[2:0]type_ins_M,
    input AdEL_sign_alu,
    input AdES_sign_alu,
    input OV_sign,
    input [4:0]ExcCode_E,
    output [4:0]ExcCode_M,
    input Eret_E,
    output Eret_M,
    input Mtc0_E,
    output Mtc0_M,
    input Mfc0_E,
    output Mfc0_M,
    input [4:0]RegRd_E,
    output [4:0]RegRd_M
);
reg RegWrite;
reg MemtoReg;
reg [31:0]WPC;
reg link;
reg [31:0]AO;
reg [4:0]A3;
reg [31:0]RFD2;
reg [2:0]Tnew;
reg [4:0]RT;
reg [31:0]instr;
reg [1:0]byte_cho;
reg [2:0]load_op;
reg BD;
reg [2:0]type_ins;
reg [4:0]ExcCode;
reg Mtc0;
reg Mfc0;
reg [4:0] RegRd;
reg Eret;
assign RegWrite_M=RegWrite;
assign MemtoReg_M=MemtoReg;
assign link_M=link;
assign WPC_M=WPC;
assign A3_M=A3;
assign AO_M=AO;
assign RFD2_M=RFD2;
assign pc_8_M=WPC+8;
assign Tnew_M=Tnew;
assign RT_M=RT;
assign instr_M=instr;
assign byte_cho_M=byte_cho;
assign load_op_M=load_op;
assign BD_M=BD;
assign type_ins_M=type_ins;
assign ExcCode_M=ExcCode;
assign RegRd_M=RegRd;
assign Mtc0_M=Mtc0;
assign Mfc0_M=Mfc0;
assign Eret_M=Eret;
always @(posedge clk) begin
    if(reset==1||Req==1)
    begin
    RegWrite<=0;
    MemtoReg<=0;
    link<=0;
    WPC<=(Req==1)?32'h0000_4180:0;
    A3<=0;
    AO<=0;
    RFD2<=0;
    Tnew<=0;
    RT<=0;
	instr<=0;
    byte_cho<=0;
    load_op<=0;
    BD<=0;
    type_ins<=0;
    ExcCode<=0;
    RegRd<=0;
    Mtc0<=0;
    Mfc0<=0;
    Eret<=0;
    end
	 
    else
    begin
    RegWrite<=RegWrite_E;
    MemtoReg<=MemtoReg_E;
    link<=link_E;
    WPC<=WPC_E;
    A3<=A3_E;
    AO<=AO_E;
    RFD2<=RFD2_E;
    Tnew<=Tnew_E;
    RT<=RT_E;
	instr<=instr_E;
    byte_cho<=byte_cho_E;
    load_op<=load_op_E;
    BD<=BD_E;
    type_ins<=type_ins_E;
    ExcCode<=(ExcCode_E!=0)?ExcCode_E:
             (AdEL_sign_alu==1'b1)?5'd4:
             (AdES_sign_alu==1'b1)?5'd5:
             (OV_sign==1'b1)?5'd12:5'd0;
    RegRd<=RegRd_E;
    Mtc0<=Mtc0_E;
    Mfc0<=Mfc0_E;
    Eret<=Eret_E;
    end
end
initial
begin
    RegWrite=0;
    MemtoReg=0;
    link=0;
    WPC=0;
    A3=0;
    AO=0;
    RFD2=0;
    Tnew=0;
    RT=0;
    byte_cho=0;
	instr=0;
    load_op=0;
    BD=0;
    type_ins=0;
    ExcCode=0;
    RegRd=0;
    Mtc0=0;
    Mfc0=0;
    Eret=0;
end
endmodule //M_state