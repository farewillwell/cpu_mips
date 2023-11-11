module DBS (
    input [31:0]addr,
    input [31:0]Din,
    input [2:0]load_op,
    output[31:0]Dout,
    input [2:0]type_ins_M,
    output AdEL_sign_dm
);
//这个�
parameter dm_start=32'h0000_0000;
parameter dm_end=32'h0000_2fff;
parameter t0_start=32'h0000_7f00;
parameter t0_end=32'h0000_7f0b;
parameter t1_start=32'h0000_7f10;
parameter t1_end=32'h0000_7f1b;
parameter none=3'b000;
parameter zeroByte=3'b001;
parameter signByte=3'b010;
parameter zeroHalf=3'b011;
parameter signHalf=3'b100;
wire [1:0]order;
assign order=addr[1:0];
assign Dout=(load_op==none)?Din:
            (load_op==zeroByte)?(
                (order==2'b00)?{{24'b0},Din[7:0]}:
                (order==2'b01)?{{24'b0},Din[15:8]}:
                (order==2'b10)?{{24'b0},Din[23:16]}:
                (order==2'b11)?{{24'b0},Din[31:24]}:32'bx
            ):
            (load_op==signByte)?(
                (order==2'b00)?{{24{Din[7]}},Din[7:0]}:
                (order==2'b01)?{{24{Din[15]}},Din[15:8]}:
                (order==2'b10)?{{24{Din[23]}},Din[23:16]}:
                (order==2'b11)?{{24{Din[31]}},Din[31:24]}:32'bx
            ):
            (load_op==zeroHalf)?(
                (order==2'b00)?{{16'b0},Din[15:0]}:
                (order==2'b10)?{{16'b0},Din[31:16]}:32'bx
            ):
            (load_op==signHalf)?(
                (order==2'b00)?{{16{Din[15]}},Din[15:0]}:
                (order==2'b10)?{{16{Din[31]}},Din[31:16]}:32'bx
            ):32'bx;
wire byte_wrong;
assign  byte_wrong =(load_op==none&&order!=2'b0)?1'b1:
                    (load_op==signHalf&&order[0]!=1'b0)?1'b1:
                    (load_op==zeroHalf&&order[0]!=1'b0)?1'b1:1'b0;
wire range_wrong;
assign range_wrong=(addr>=dm_start&&addr<=dm_end)||
                   (addr>=t0_start&&addr<=t0_end)||
                   (addr>=t1_start&&addr<=t1_end)?1'b0:1'b1;

wire BorHforTime;
assign BorHforTime=(load_op==zeroByte||load_op==signByte||load_op==zeroHalf||load_op==signHalf)&&
((addr>=t0_start&&addr<=t0_end)||(addr>=t1_start&&addr<=t1_end))?1'b1:1'b0;

assign AdEL_sign_dm=(type_ins_M==3'b100)?(byte_wrong||range_wrong||BorHforTime):1'b0;
endmodule //DBS