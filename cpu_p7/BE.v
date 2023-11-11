module BE (
    input [1:0]byte_cho,//选择的模�
    input [31:0]addr,//地址
    output [3:0]byte_en,//字节使能
    input [2:0]type_ins_M,
    output AdES_sign_dm
//BE专供使能，所以仅仅需要考虑store类的指令
);
parameter dm_start=32'h0000_0000;
parameter dm_end=32'h0000_2fff;
parameter t0_start=32'h0000_7f00;
parameter t0_end=32'h0000_7f0b;
parameter t1_start=32'h0000_7f10;
parameter t1_end=32'h0000_7f1b;
parameter int_start=32'h0000_7F20;
parameter int_end=32'h0000_7F23;
wire [1:0]order;
assign order=addr[1:0];
assign byte_en=(byte_cho==2'b11)?4'b1111:
               (byte_cho==2'b01)?(
                    (order==2'b00)?4'b0011:
                    (order==2'b10)?4'b1100:4'bxxxx
               ):
               (byte_cho==2'b10)?(
                    (order==2'b00)?4'b0001:
                    (order==2'b01)?4'b0010:
                    (order==2'b10)?4'b0100:
                    (order==2'b11)?4'b1000:4'bxxxx
               ):4'b0000;
wire byte_wrong;
assign byte_wrong=(byte_cho==2'b11&&order!=2'b0)?1'b1:
                 (byte_cho==2'b01&&order[0]!=1'b0)?1'b1:1'b0;
wire range_wrong;
assign range_wrong=(addr>=dm_start&&addr<=dm_end)||
                   (addr>=t0_start&&addr<=t0_end)||
                   (addr>=t1_start&&addr<=t1_end)||
                   (addr>=int_start&&addr<=int_end)?1'b0:1'b1;
wire store_count;
assign store_count=(addr>=(t0_start+8)&&addr<=t0_end)||(addr>=(t1_start+8)&&addr<=t1_end)?1'b1:1'b0;
wire BorHforTime;
assign BorHforTime=(byte_cho==2'b01||byte_cho==2'b10)&&
((addr>=t0_start&&addr<=t0_end)||(addr>=t1_start&&addr<=t1_end))?1'b1:1'b0;

assign AdES_sign_dm=(type_ins_M==3'b110)?(byte_wrong||range_wrong||store_count||BorHforTime):1'b0;


endmodule //BE，这个模块是用来控制字节xie使能的。仅仅用来输出字节的使能�