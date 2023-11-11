module RF (
    input clk ,
    input RegWrite,
    input reset,
    input [4:0]A1,
    input [4:0]A2,
    input [4:0]A3,
    input [31:0]WPC,
    input [31:0]WriteData,
    output[31:0]RD1,
    output[31:0]RD2,
	 input [31:0]instr_W
);
reg [31:0]mem[0:31] ;
integer i;
// important fault :if RegWrite =1&&A3=A1=0&&WriteData!=0
assign RD1=(A1==0)?32'b0:
(A3==A1&&RegWrite==1'b1)? WriteData: mem[A1];
assign RD2=(A2==0)?32'b0:
(A3==A2&&RegWrite==1'b1)? WriteData: mem[A2];
always @(posedge clk ) begin
if(reset==1)
begin
    for(i=0;i<=31;i=i+1)
    begin
    mem[i]<=0;
    end
end
else
  begin
    if(RegWrite==1)
    begin
        //$display("@%h: $%d <= %h",WPC, A3, WriteData);
         if(A3!=0) mem[A3]<=WriteData;
         else mem[A3]<=0;
    end
   end
end
initial
begin

    for(i=0;i<=31;i=i+1)
    begin
    mem[i]=0;
    end
end
endmodule //Regs