module MDU (
    input clk,
    input reset,
    input [3:0]mdu_ctrl,
    input [31:0]inA,
    input [31:0]inB,
    input start,
    output busy,
    output [31:0]HIorLO,
    input Req
);
reg [31:0]HI;
reg [31:0]LO;
reg [3:0]status;
wire [63:0]zero_inA;
wire [63:0]zero_inB;
wire [63:0]sign_inA;
wire [63:0]sign_inB;
assign zero_inA={32'b0,inA};
assign zero_inB={32'b0,inB};
assign sign_inA={{32{inA[31]}},inA};
assign sign_inB={{32{inB[31]}},inB};
assign HIorLO=(mdu_ctrl==mfhi)?HI:
              (mdu_ctrl==mflo)?LO:32'bx;
parameter mfhi=4'b0001;
parameter mflo=4'b0010;
parameter mthi=4'b0011;
parameter mtlo=4'b0100;
parameter mult=4'b0101;
parameter multu=4'b0110;
parameter div= 4'b0111;
parameter divu=4'b1000;
assign busy=(status==0)?1'b0:1'b1;
initial
begin
    HI=0;
    LO=0;
    status=0;
end
always @(posedge clk) begin
    if(reset==1)
    begin
        HI<=0;
        LO<=0;
        status<=0;
    end
    else if(Req!=1'b1)
    begin
        if(status>0)status<=status-1;
        if(start==1'b1)
        begin
            if(mdu_ctrl==div||mdu_ctrl==divu)status<=10;
            else if(mdu_ctrl==mult||mdu_ctrl==multu)status<=5;
        end
        if(mdu_ctrl==mthi)HI<=inA;
        else if(mdu_ctrl==mtlo)LO<=inA;
        else if(mdu_ctrl==multu)begin{HI,LO}<=zero_inA*zero_inB;
		  end
        else if(mdu_ctrl==divu) begin
            HI<=inA%inB;
            LO<=inA/inB;
        end 
        else if(mdu_ctrl==mult) begin
            {HI,LO}<=$signed($signed(sign_inA)*$signed(sign_inB));
        end
        else if(mdu_ctrl==div) begin
            HI<=$signed($signed(inA)%$signed(inB));
            LO<=$signed($signed(inA)/$signed(inB));
        end
    end
end

endmodule //MDU