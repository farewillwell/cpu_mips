module E_state (
    input RegWrite_D,
    input MemtoReg_D,
    input [3:0]Aluop_D,
    input Alusrc_D,
    input link_D,
    //6 signs of ctrl
    input [31:0]RFD1_D,
    input [31:0]RFD2_D,
    // read data 1/2
    input [31:0]signImm_D,
    //sign to use
    input [31:0]pc_8_D,
    //pc to carry and write in
    input [4:0]RS_D,
    input [4:0]RT_D,
    //rs rt rd to compare
    input clr,
    input reset,
    input clk,
    //time signs
    output RegWrite_E,
    output MemtoReg_E,
    output [3:0]Aluop_E,
    output link_E,
    output Alusrc_E,
    //6 signs out
    output [31:0]RFD1_E,
    output [31:0]RFD2_E,
    output [31:0]signImm_E,
    output [31:0]pc_8_E,
    output [4:0]RS_E,
    output [4:0]RT_E,
    input [4:0]A3_D,
    output [4:0]A3_E,
    input [31:0] WPC_D,
    output [31:0] WPC_E,
    input [2:0]Tnew_D,
    output[2:0]Tnew_E,
    input [4:0]shamt_D,
    output [4:0]shamt_E,//
	input [31:0]instr_D,
	output[31:0]instr_E,
    input [1:0]byte_cho_D,
    output [1:0]byte_cho_E,
    input start_D,
    output start_E,
    input select_D,
    output select_E,
    input [3:0] mdu_ctrl_D,
    output [3:0]mdu_ctrl_E,
	input [2:0]load_op_D,
    output [2:0]load_op_E,
    input Req,
    input BD_D,
    output BD_E,
    input [2:0]type_ins_D,
    output [2:0]type_ins_E,
    input Syscall_sign,
    input RI_sign,
    input [4:0]ExcCode_D,
    output [4:0]ExcCode_E,
    input Mtc0_D,
    output Mtc0_E,
    input Mfc0_D,
    output Mfc0_E,
    input Eret_D,
    output Eret_E,
    input [4:0]RegRd_D,
    output [4:0]RegRd_E
);
    reg RegWrite;
    reg  MemtoReg;
    reg  [3:0]Aluop;
    reg  Alusrc;
    reg  link;
    reg  [31:0]RFD1;
    reg  [31:0]RFD2;
    reg [31:0]signImm;
    reg [4:0]shamt;
    reg  [31:0]pc_8;
    reg  [4:0]RS;
    reg  [4:0]RT;
    reg [4:0]A3;
    reg  [31:0] WPC;
    reg [2:0]Tnew;//
	 reg [31:0]instr;
     reg [1:0]byte_cho;
	 reg [2:0]load_op;
     reg start;
     reg select;
     reg [3:0]mdu_ctrl;
     reg BD;
     reg [2:0]type_ins;
     reg [4:0]ExcCode;
     reg Eret;
     reg Mtc0;
     reg Mfc0;
     reg[4:0]RegRd;
assign RegWrite_E=RegWrite;
assign MemtoReg_E=MemtoReg;
assign Aluop_E=Aluop;
assign link_E=link;
assign Alusrc_E=Alusrc;
assign RFD1_E=RFD1;
assign RFD2_E=RFD2;
assign signImm_E=signImm;
assign pc_8_E=pc_8;
assign RS_E=RS;
assign RT_E=RT;
assign WPC_E=WPC;
assign A3_E=A3;
assign Tnew_E=Tnew;
assign shamt_E=shamt;
assign instr_E=instr;
assign byte_cho_E=byte_cho;
assign load_op_E=load_op;
assign start_E=start;
assign select_E=select;
assign mdu_ctrl_E=mdu_ctrl;
assign BD_E=BD;
assign type_ins_E=type_ins;
assign ExcCode_E=ExcCode;
assign Eret_E=Eret;
assign Mtc0_E=Mtc0;
assign Mfc0_E=Mfc0;
assign RegRd_E=RegRd;
    always @(posedge clk) begin
        if(reset==1||Req==1)
        begin
            RegWrite<=0;
            MemtoReg<=0;
            Aluop<=0;
            link<=0;
            RFD1<=0;
            RFD2<=0;
            signImm<=0;
            RS<=0;
            RT<=0;
            A3<=0;
            Tnew<=0;
            Alusrc<=0;
            shamt<=0;
            ExcCode<=0;
        WPC<=(Req==1)?32'h0000_4180:0;
				instr<=0;
                byte_cho<=0;
				load_op<=0;
                mdu_ctrl<=0;
                start<=0;
                select<=0;
                BD<=0;
                type_ins<=0;
                RegRd<=0;
                Eret<=0;
                Mtc0<=0;
                Mfc0<=0;
		end
        else if(clr==1) begin
            RegWrite<=0;
            MemtoReg<=0;
            Aluop<=0;
            link<=0;
            RFD1<=0;
            RFD2<=0;
            signImm<=0;
            RS<=0;
            RT<=0;
            A3<=0;
            Tnew<=0;
            Alusrc<=0;
            shamt<=0;
				WPC<=WPC_D;
				instr<=0;
                byte_cho<=0;
				load_op<=0;
                mdu_ctrl<=0;
                start<=0;
                select<=0;
                BD<=BD_D;
                type_ins<=0;
                ExcCode<=0;
                RegRd<=0;
                Eret<=0;
                Mtc0<=0;
                Mfc0<=0;
        end
        else
        begin
            RegWrite<=RegWrite_D;
            MemtoReg<=MemtoReg_D;
            Aluop<=Aluop_D;
            link<=link_D;
            RFD1<=RFD1_D;
            RFD2<=RFD2_D;
            signImm<=signImm_D;
            RS<=RS_D;
            RT<=RT_D;
            A3<=A3_D;
            Tnew<=Tnew_D;
            Alusrc<=Alusrc_D;
            shamt<=shamt_D;
				WPC<=WPC_D;
				instr<=instr_D;
                byte_cho<=byte_cho_D;
				load_op<=load_op_D;
                start<=start_D;
                select<=select_D;
                mdu_ctrl<=mdu_ctrl_D;
                BD<=BD_D;
                type_ins<=type_ins_D;
                ExcCode<=(ExcCode_D!=0)?ExcCode_D:
                         (RI_sign==1)?5'd10:
                         (Syscall_sign==1)?5'd8:5'd0;
                RegRd<=RegRd_D;
                Eret<=Eret_D;
                Mtc0<=Mtc0_D;
                Mfc0<=Mfc0_D;
        end
    end
initial
    begin
	         RegWrite=0;
            MemtoReg=0;
            Aluop=0;
            link=0;
            RFD1=0;
            RFD2=0;
            signImm=0;
            pc_8=0;
            RS=0;
            RT=0;
            A3=0;
            Tnew=0;
            Alusrc=0;
            shamt=0;
				WPC=0;
				instr=0;
                byte_cho=0;
                select=0;
                mdu_ctrl=0;
                start=0;
				load_op=0;
                BD=0;
                type_ins=0;
                ExcCode=0;
                RegRd=0;
                Eret=0;
                Mtc0=0;
                Mfc0=0;
	 end
endmodule //E_state