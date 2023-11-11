module W_state (
    input clk,
    input reset,
    // time signs
    input RegWrite_M,
    input MemtoReg_M,
    output RegWrite_W,
    output MemtoReg_W,
    input link_M,
    output link_W,
    //3 signs for Io
    input [31:0]Med_M,
    output [31:0]Med_W,
    output [31:0] pc_8_W,
    input [4:0]A3_M,
    output [4:0]A3_W,
    input [31:0]WPC_M,
    output [31:0]WPC_W,
    input [31:0]AO_M,
    output [31:0]AO_W,
    input [2:0]Tnew_M,
    output [2:0]Tnew_W,
	 input [31:0]instr_M,
	 output [31:0]instr_W,
     input Req,
     input Mfc0_M,
     output Mfc0_W,
     input [31:0] CP0Out_M,
     output [31:0] CP0Out_W
);
reg RegWrite;
reg MemtoReg;
reg [31:0]WPC;
reg link;
reg [31:0]Med;
reg [31:0]AO;
reg [4:0]A3;
reg [2:0]Tnew;
reg [31:0]instr;
reg Mfc0;
reg [31:0]CP0Out;
assign RegWrite_W=RegWrite;
assign MemtoReg_W=MemtoReg;
assign link_W=link;
assign WPC_W=WPC;
assign Med_W=Med;
assign A3_W=A3;
assign AO_W=AO;
assign pc_8_W=WPC+8;
assign Tnew_W=Tnew;
assign instr_W=instr;
assign Mfc0_W=Mfc0;
assign CP0Out_W=CP0Out;
always @(posedge clk) begin
    if(reset==1||Req==1)
    begin
        RegWrite<=0;
        MemtoReg<=0;
        link<=0;
        WPC<=0;
        Med<=0;
        A3<=0;
        AO<=0;
        Tnew<=0;
		  instr<=0;
          Mfc0<=0;
          CP0Out<=0;
    end
    else
    begin
        RegWrite<=RegWrite_M;
        MemtoReg<=MemtoReg_M;
        link<=link_M;
        WPC<=WPC_M;
        Med<=Med_M;
        A3<=A3_M;
        AO<=AO_M;
        Tnew<=Tnew_M;
		  instr<=instr_M;
          Mfc0<=Mfc0_M;
          CP0Out<=CP0Out_M;
    end
end
initial
begin
    RegWrite=0;
    MemtoReg=0;
    link=0;
    WPC=0;
    Med=0;
    A3=0;
    AO=0;
    Tnew=0; 
instr=0;	 
   Mfc0=0;
   CP0Out=0;
end
endmodule //W_state