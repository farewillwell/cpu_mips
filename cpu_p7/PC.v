module PC (
    input [31:0] newPc,
    input [31:0]EPC,
    input Eret_D,
    input clk,
    input reset,
    input En, 
    input Req,
    output [31:0]WPC,
    output AdEL_sign_pc
);
parameter range_low =32'h00003000;
parameter range_high=32'h00006ffc;
reg [31:0]store ;
assign  WPC=(Eret_D==1'b1)?EPC:store;
always @(posedge clk ) begin
    if(reset==1)
    begin
        store<=32'h00003000;//reset
    end
    else if(Req==1'b1) begin
        store<=32'h0000_4180;
    end
    else if(En==1'b1) begin
        store<=store;//stop
    end
    else
        begin
            store<=newPc;//move
        end
end
initial
begin
store=32'h00003000;
end

assign AdEL_sign_pc=(WPC[1:0]!=2'b0)?1'b1:
                    (!(WPC<=range_high&&range_low<=WPC))?1'b1:1'b0;

endmodule //pc