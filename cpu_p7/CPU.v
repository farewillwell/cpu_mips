module CPU(
    input clk,                    // 时钟信号
    input reset,                  // 同步复位信号

    output [31:0] i_inst_addr,    // IM 读取地址（取�PC�
    input  [31:0] i_inst_rdata,   // IM 读取数据

    output [31:0] m_data_addr,    // DM 读写地址
    input  [31:0] m_data_rdata,   // DM 读取数据
    output [31:0] m_data_wdata,   // DM 待写入数�
    output [3 :0] m_data_byteen,  // DM 字节使能信号


    output [31:0] m_inst_addr,    // M �PC

    output w_grf_we,              // GRF 写使能信�
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,    // GRF 待写入数�

    input [5:0]HWInt,
    output [31:0] w_inst_addr     // W �PC,

);
//UNI
    wire STALL_PC;
    wire STALL_D;
    wire [1:0]FORWARD_S_D;
    wire [1:0]FORWARD_S_E;
    wire [1:0]FORWARD_T_D;
    wire [1:0]FORWARD_T_E;
    wire [1:0]FORWARD_T_M;
    wire Flush_E;
    wire[4:0]RS_D;
    wire[4:0]RT_D;
    wire [4:0]RS_E;
    wire [4:0]RT_E;
    wire[4:0]RT_M;
    wire[4:0]A3_E;
    wire [4:0]A3_M;
    wire [4:0]A3_W;
    wire [2:0]Tnew_E;
    wire [2:0]Tnew_M;
    wire [2:0]Tnew_W;
    wire [2:0]Tuse_RS;
    wire[2:0]Tuse_RT;
    wire RegWrite_E;
    wire RegWrite_M;
    wire RegWrite_W;
    wire [3:0]mdu_ctrl_D;
    wire busy;
    wire start_E;
    wire busy_start_E;
    wire Eret_D;
    wire Mtc0_E;
    wire [4:0]RegRd_E;
    wire Mtc0_M;
    wire [4:0]RegRd_M;
    assign busy_start_E=busy|start_E;
UNIT UNIT
(
    .STALL_PC(STALL_PC),
    .STALL_D(STALL_D),
    .FORWARD_S_D(FORWARD_S_D),
    .FORWARD_S_E(FORWARD_S_E),
    .FORWARD_T_D(FORWARD_T_D),
    .FORWARD_T_E(FORWARD_T_E),
    .FORWARD_T_M(FORWARD_T_M),
    .Flush_E(Flush_E),
    .RS_D(RS_D),
    .RS_E(RS_E),
    .RT_D(RT_D),
    .RT_E(RT_E),
    .RT_M(RT_M),
    .A3_E(A3_E),
    .A3_M(A3_M),
    .A3_W(A3_W),
    .Tnew_E(Tnew_E),
    .Tnew_M(Tnew_M),
    .Tnew_W(Tnew_W),
    .Tuse_RS(Tuse_RS),
    .Tuse_RT(Tuse_RT),
    .RegWrite_E(RegWrite_E),
    .RegWrite_M(RegWrite_M),
    .RegWrite_W(RegWrite_W),
    .busy_start_E(busy_start_E),
    .mdu_ctrl_D(mdu_ctrl_D),
    .Eret_D(Eret_D),
    .Mtc0_E(Mtc0_E),
    .RegRd_E(RegRd_E),
    .RegRd_M(RegRd_M),
    .Mtc0_M(Mtc0_M)
);
//unexpected
    wire Req;

//F state
    wire[31:0]EPCOut_M;
//NPC
    wire beqsrc;
    wire Jr;
    wire Jump;
    wire [31:0]WPC_F;
    wire [31:0]signImm_D;
    wire [25:0]JPC_D;
    wire [31:0]newPc;
	wire [31:0]RSDATA_D;
NPC NPC
(
    .signImm_D(signImm_D),
    .JPC_D(JPC_D),
    .Jrdata_D(RSDATA_D),
    .beqsrc(beqsrc),
    .WPC(WPC_F),
    .Jr(Jr),
    .Jump(Jump),
    .newPc(newPc),
    .EPC(EPCOut_M),
    .Req(Req),
    .Eret_D(Eret_D)
);
//pc
   wire AdEL_sign_pc;
PC PC(
    .newPc(newPc),
    .clk(clk),
    .reset(reset),
    .WPC(WPC_F),
    .En(STALL_PC),
    .AdEL_sign_pc(AdEL_sign_pc),
    .EPC(EPCOut_M),
    .Req(Req),
    .Eret_D(Eret_D)
);
//IM
    wire [31:0]instr_F;
    assign instr_F=(AdEL_sign_pc==1'b1)?32'b0:i_inst_rdata;
    assign i_inst_addr=WPC_F;
// D STATE
    wire [31:0]pc_8_D;
    wire [31:0]instr_D;
    wire [31:0]WPC_D;
    wire [4:0]RD_D;
    wire [15:0]NoneImm;
    wire [4:0]shamt_D;
    wire BD_F;
    wire BD_D;
    wire [4:0]ExcCode_D;
D_state D_state
(
    .clk(clk),
    .reset(reset),
    .instr_F(instr_F),
    .pc_8_D(pc_8_D),
    .instr_D(instr_D),
    .RS_D(RS_D),
    .RT_D(RT_D),
    .RD_D(RD_D),
    .En(STALL_D),
    .WPC_F(WPC_F),
    .WPC_D(WPC_D),
    .NoneImm(NoneImm),
    .shamt_D(shamt_D),
    .JPC_D(JPC_D),
    .Req(Req),
    .BD_F(BD_F),
    .BD_D(BD_D),
    .AdEL_sign_pc(AdEL_sign_pc),
    .ExcCode_D(ExcCode_D)
);
//CTRL
    wire [5:0]opcode;
    wire [5:0]func;
    wire [4:0]C0part;
    assign opcode=instr_D[31:26];
    assign func=instr_D[5:0];
    assign C0part=instr_D[25:21];
    wire RegWrite_D;
    wire RegDst;
    wire Alusrc_D;
    wire MemReg_D;
    wire Beqsign ;
    wire Bnesign;
    wire Extop ;
    wire link_D; 
    wire [3:0]Aluop_D ;
    wire [2:0] Tnew_D;
    wire [1:0]byte_cho_D;
    wire [2:0]load_op_D;
    wire select_D;
    wire start_D;
    wire RI_sign;
    wire Syscall_sign;
    wire [2:0]type_ins_D;
    wire Mtc0_D;
    wire Mfc0_D;
CTRL CTRL(
    .opcode(opcode),
    .func(func),
    .C0part(C0part),
    .RegWrite(RegWrite_D),
    .RegDst(RegDst),
    .Alusrc(Alusrc_D),
    .MemReg(MemReg_D),
    .Beqsign(Beqsign),
    .Bnesign(Bnesign),
    .Extop(Extop),
    .Jump(Jump),
    .Jr(Jr),
    .link(link_D),
    .Aluop(Aluop_D),
    .Tnew_D(Tnew_D),
    .Tuse_RS(Tuse_RS),
    .Tuse_RT(Tuse_RT),
    .byte_cho(byte_cho_D),
    .load_op(load_op_D),
    .start(start_D),
    .select(select_D),
    .mdu_ctrl(mdu_ctrl_D),
    .RI_sign(RI_sign),
    .Syscall_sign(Syscall_sign),
    .Eret_D(Eret_D),
    .BD_F(BD_F),
    .type_ins(type_ins_D),
    .Mtc0_D(Mtc0_D),
    .Mfc0_D(Mfc0_D)
);
//RF
    wire [4:0]A3_D;
    wire [31:0]WriteData;//data to be write into RF
	wire [31:0]RFD1_D;
    wire [31:0]RFD2_D;
	wire [31:0]WPC_W;
	wire [31:0]instr_W;
RF RF(
    .clk(clk),
    .RegWrite(RegWrite_W),
    .reset(reset),
    .A1(RS_D),
    .A2(RT_D),
    .A3(A3_W),
    .WPC(WPC_W),
	.instr_W(instr_W),
    .WriteData(WriteData),
    .RD1(RFD1_D),
    .RD2(RFD2_D)
);
//mux of A3_D
    assign A3_D=(link_D==1'b1)?5'd31:
                (RegDst==1'b1)?RD_D:RT_D;
//MUXRS_D
    wire [31:0]pc_8_E;
    wire [31:0]AOorPC_M;
  assign RSDATA_D=(FORWARD_S_D==2'b10)?pc_8_E:
                  (FORWARD_S_D==2'b01)?AOorPC_M:RFD1_D;
//MUXRT_D
    wire [31:0]RTDATA_D;
  assign RTDATA_D=(FORWARD_T_D==2'b10)?pc_8_E:
                  (FORWARD_T_D==2'b01)?AOorPC_M:RFD2_D;
//ExTop
ExTop ExTop(
    .Extop(Extop),
    .NoneImm(NoneImm),
    .signimm(signImm_D)
);
//equal
    wire equal;
    assign equal=(RSDATA_D==RTDATA_D)?1'b1:1'b0;
    assign beqsrc=(Beqsign&equal)||(Bnesign&(~equal));

//E state
    wire MemReg_E;
    wire [3:0]Aluop_E;
    wire link_E;
    wire Alusrc_E;
    wire [31:0]RFD1_E;
    wire [31:0]RFD2_E;
    wire [31:0]signImm_E;
    wire [31:0]WPC_E;
    wire [4:0]shamt_E;
	wire [31:0]instr_E;
	wire [31:0]instr_M;
    wire [1:0]byte_cho_E;
    wire[2:0]load_op_E;
    wire select_E;
    wire [3:0]mdu_ctrl_E;
    wire BD_E;
    wire [2:0]type_ins_E;
    wire [4:0]ExcCode_E;
    wire Mfc0_E;
    wire Eret_E;
    wire [4:0]RegRd_D;
    assign RegRd_D=RD_D;
E_state E_state
(
    .RegWrite_D(RegWrite_D),
    .MemtoReg_D(MemReg_D),
    .Aluop_D(Aluop_D),
	.Alusrc_D(Alusrc_D),
	.Alusrc_E(Alusrc_E),
    .link_D(link_D),
    .RFD1_D(RSDATA_D),
    .RFD2_D(RTDATA_D),
    .signImm_D(signImm_D),
    .RS_D(RS_D),
    .RT_D(RT_D),
    .clr(Flush_E),
    .reset(reset),
    .clk(clk),
    .RegWrite_E(RegWrite_E),
    .MemtoReg_E(MemReg_E),
    .Aluop_E(Aluop_E),
    .link_E(link_E),
    .RFD1_E(RFD1_E),
    .RFD2_E(RFD2_E),
    .signImm_E(signImm_E),
    .pc_8_E(pc_8_E),
    .RS_E(RS_E),
    .RT_E(RT_E),
    .A3_D(A3_D),
    .A3_E(A3_E),
    .WPC_D(WPC_D),
    .WPC_E(WPC_E),
    .Tnew_D(Tnew_D),
    .Tnew_E(Tnew_E),
    .shamt_D(shamt_D),
    .shamt_E(shamt_E),
	.instr_D(instr_D),
	.instr_E(instr_E),
    .byte_cho_D(byte_cho_D),
    .byte_cho_E(byte_cho_E),
    .load_op_D(load_op_D),
    .load_op_E(load_op_E),
    .start_D(start_D),
    .start_E(start_E),
    .select_D(select_D),
    .select_E(select_E),
    .mdu_ctrl_D(mdu_ctrl_D),
    .mdu_ctrl_E(mdu_ctrl_E),
    .Req(Req),
    .BD_D(BD_D),
    .BD_E(BD_E),
    .type_ins_D(type_ins_D),
    .type_ins_E(type_ins_E),
    .Syscall_sign(Syscall_sign),
    .RI_sign(RI_sign),
    .ExcCode_D(ExcCode_D),
    .ExcCode_E(ExcCode_E),
    .Mtc0_D(Mtc0_D),
    .Mfc0_D(Mfc0_D),
    .Mtc0_E(Mtc0_E),
    .Mfc0_E(Mfc0_E),
    .Eret_D(Eret_D),
    .Eret_E(Eret_E),
    .RegRd_D(RegRd_D),
    .RegRd_E(RegRd_E)
);      
//     
//MUXRS_E
    wire [31:0]RSDATA_E;
    assign RSDATA_E=(FORWARD_S_E==2'b10)?AOorPC_M:
                    (FORWARD_S_E==2'b01)?WriteData:RFD1_E;
//MUXRT_E
    wire [31:0]RTDATA_E;
    assign RTDATA_E=(FORWARD_T_E==2'b10)?AOorPC_M:
                    (FORWARD_T_E==2'b01)?WriteData:RFD2_E;
//inB select
    wire [31:0]RTorSignimm;
    assign RTorSignimm=(Alusrc_E==1'b0)?RTDATA_E:signImm_E;
//ALU
    wire [31:0] AO_E;
    wire [31:0]AluAns;
    wire OV_sign;
    wire AdEL_sign_alu;
    wire AdES_sign_alu;
ALU ALU(
    .Aluop(Aluop_E),
    .inA(RSDATA_E),
    .inB(RTorSignimm),
    .shamt(shamt_E),
    .AluAns(AluAns),
    .OV_sign(OV_sign),
    .AdEL_sign_alu(AdEL_sign_alu),
    .AdES_sign_alu(AdES_sign_alu),
    .type_ins_E(type_ins_E)
);
//MDU
    wire[31:0]HIorLO;
MDU MDU(
 .clk(clk),
 .reset(reset),
 .mdu_ctrl(mdu_ctrl_E),
 .start(start_E),
 .busy(busy),
 .inA(RSDATA_E),
 .inB(RTorSignimm),
 .HIorLO(HIorLO),
 .Req(Req)

);  
    assign AO_E=(select_E==1'b1)?HIorLO:AluAns;
    wire [2:0]Tnew_E_1;
    assign Tnew_E_1=(Tnew_E==0)?Tnew_E:(Tnew_E-1);
//M state
    wire MemReg_M;
    wire link_M;
    wire [31:0]AO_M;
    wire [31:0]pc_8_M;
    wire [31:0]WPC_M;
    wire [31:0]RFD2_M;
    wire [1:0]byte_cho_M;
    wire [2:0]load_op_M;
    wire BD_M;
    wire [2:0] type_ins_M;
    wire [4:0] ExcCode_M;
    wire Eret_M;
    wire Mfc0_M;
M_state M_state(
    .clk(clk),
    .reset(reset),
    .RegWrite_E(RegWrite_E),
	.RegWrite_M(RegWrite_M),
    .MemtoReg_E(MemReg_E),
    .link_E(link_E),
    .MemtoReg_M(MemReg_M),
    .link_M(link_M),
    .pc_8_M(pc_8_M),
    .A3_E(A3_E),
    .A3_M(A3_M),
    .WPC_E(WPC_E),
    .WPC_M(WPC_M),
    .AO_E(AO_E),
    .AO_M(AO_M),
    .RFD2_E(RTDATA_E),
    .RFD2_M(RFD2_M),
    .Tnew_E(Tnew_E_1),
    .Tnew_M(Tnew_M),
    .RT_E(RT_E),
    .RT_M(RT_M),
	.instr_E(instr_E),
	.instr_M(instr_M),
    .byte_cho_E(byte_cho_E),
    .byte_cho_M(byte_cho_M),
    .load_op_E(load_op_E),
    .load_op_M(load_op_M),
    .Req(Req),
    .BD_E(BD_E),
    .BD_M(BD_M),
    .type_ins_E(type_ins_E),
    .type_ins_M(type_ins_M),
    .AdEL_sign_alu(AdEL_sign_alu),
    .AdES_sign_alu(AdES_sign_alu),
    .OV_sign(OV_sign),
    .ExcCode_E(ExcCode_E),
    .ExcCode_M(ExcCode_M),
    .Eret_E(Eret_E),
    .Eret_M(Eret_M),
    .Mtc0_E(Mtc0_E),
    .Mtc0_M(Mtc0_M),
    .Mfc0_E(Mfc0_E),
    .Mfc0_M(Mfc0_M),
    .RegRd_E(RegRd_E),
    .RegRd_M(RegRd_M)
);
    wire [31:0]WMD;
    wire [2:0] Tnew_M_1;
    assign Tnew_M_1=(Tnew_M==0)?Tnew_M:(Tnew_M-1);
//MUXRT_M
    assign WMD=(FORWARD_T_M==2'b00)?RFD2_M:WriteData;//写进DM的�
    assign AOorPC_M=(link_M==1'b1)?pc_8_M:AO_M;

//BE，用来搞sw类型的存数使能�
    wire[3:0]byte_en;
    wire AdES_sign_dm;
BE BE(
.byte_cho(byte_cho_M),
.addr(AO_M),
.byte_en(byte_en),
.AdES_sign_dm(AdES_sign_dm),
.type_ins_M(type_ins_M)
);


//DM
    wire [31:0]MemRead;//这里MemRead为DM读出的数据？指的应该是整个字�
    wire [31:0]WriteMem;
    assign m_inst_addr=WPC_M;
    assign m_data_addr=AO_M;
    assign MemRead=m_data_rdata;
    assign m_data_wdata=(byte_en==4'b1111)?WMD:
                        (byte_en==4'b0011)?{MemRead[31:16],WMD[15:0]}:
                        (byte_en==4'b1100)?{WMD[15:0],MemRead[15:0]}:
                        (byte_en==4'b0001)?{MemRead[31:8],WMD[7:0]}:
                        (byte_en==4'b0010)?{MemRead[31:16],WMD[7:0],MemRead[7:0]}:
                        (byte_en==4'b0100)?{MemRead[31:24],WMD[7:0],MemRead[15:0]}:
                        (byte_en==4'b1000)?{WMD[7:0],MemRead[23:0]}:MemRead;
    assign m_data_byteen=(Req==1'b0)?byte_en:4'b0000;//发生异常或者中断的时候不允许往外设写东西
    

wire [31:0] Med_M;
wire AdEL_sign_dm;
wire [31:0]CP0Out_M;
wire [4:0]ExcCodeIn;
      assign ExcCodeIn=(ExcCode_M!=0)?ExcCode_M:
                       (AdEL_sign_dm==1'b1)?5'd4:
                       (AdES_sign_dm==1'b1)?5'd5:5'd0;
//DBS，用来搞取数load的指�
DBS DBS(
    .addr(AO_M),
    .Din(MemRead),
    .load_op(load_op_M),
    .Dout(Med_M),
    .AdEL_sign_dm(AdEL_sign_dm),
    .type_ins_M(type_ins_M)
);
//CP0出现了！�
CP0 CP0(
    .clk(clk),
    .reset(reset),
    .en(Mtc0_M),
    .CP0Add(RegRd_M),
    .CP0In(WMD),
    .CP0Out(CP0Out_M),
    .VPC(WPC_M),
    .BDIn(BD_M),
    .ExcCodeIn(ExcCodeIn),
    .HWInt(HWInt),
    .EXLClr(Eret_M),
    .EPCOut(EPCOut_M),
    .Req(Req)
);


//W state
    wire [31:0]Med_W;
    wire MemReg_W;
    wire [31:0]pc_8_W;
    wire [31:0]AO_W;
    wire Mfc0_W;
    wire [31:0]CP0Out_W;
W_state W_state(
    .clk(clk),
    .reset(reset),
    .RegWrite_M(RegWrite_M),
    .MemtoReg_M(MemReg_M),
    .RegWrite_W(RegWrite_W),
    .MemtoReg_W(MemReg_W),
    .link_M(link_M),
    .link_W(link_W),
    .Med_M(Med_M),
    .Med_W(Med_W),
    .pc_8_W(pc_8_W),
    .A3_M(A3_M),
    .A3_W(A3_W),
    .WPC_M(WPC_M),
    .WPC_W(WPC_W),
    .AO_M(AO_M),
    .AO_W(AO_W),
    .Tnew_M(Tnew_M_1),
    .Tnew_W(Tnew_W),
	 .instr_M(instr_M),
	 .instr_W(instr_W),
     .Req(Req),
     .Mfc0_M(Mfc0_M),
     .Mfc0_W(Mfc0_W),
     .CP0Out_M(CP0Out_M),
     .CP0Out_W(CP0Out_W)
);

assign WriteData=(Mfc0_W==1'b1)?CP0Out_W:
                 (link_W==1'b1)?pc_8_W:
                 (MemReg_W==1'b1)?Med_W:AO_W;
	assign w_grf_we=RegWrite_W;
    assign w_grf_addr=A3_W;
    assign w_grf_wdata=WriteData;
    assign w_inst_addr=WPC_W;

endmodule //mips