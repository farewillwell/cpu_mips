module UNIT (
    output STALL_PC,
    output STALL_D,
    output [1:0]FORWARD_S_D,//for beq
    output [1:0]FORWARD_T_D,
    output [1:0]FORWARD_S_E,
    output [1:0]FORWARD_T_E,
    output [1:0]FORWARD_T_M,
    output Flush_E,
    input [4:0]RS_D,
    input [4:0]RT_D,
    input [4:0]RS_E,
    input [4:0]RT_E,
    input [4:0]RT_M,
    input [4:0]A3_E,
    input [4:0]A3_M,
    input [4:0]A3_W,
    input [2:0]Tnew_E,
    input [2:0]Tnew_M,
    input [2:0]Tnew_W,
    input [2:0]Tuse_RS,
    input [2:0]Tuse_RT,
    input RegWrite_E,
    input RegWrite_M,
    input RegWrite_W,
    input busy_start_E,
    input [3:0]mdu_ctrl_D,
    input Eret_D,
    input Mtc0_E,
    input [4:0]RegRd_E,
    input Mtc0_M,
    input [4:0]RegRd_M
);
wire STALL;
wire STALL_RS;
wire STALL_RT;
wire STALL_MDU;
wire STALL_ERET;
assign STALL_MDU=(busy_start_E==1&&mdu_ctrl_D!=0)?1'b1:1'b0;
assign STALL_ERET=(Eret_D==1'b1)&&((Mtc0_E==1'b1&&RegRd_E==5'd14)||(Mtc0_M==1'b1&&RegRd_M==5'd14));
assign STALL=STALL_RS|STALL_RT|STALL_MDU|STALL_ERET;
assign STALL_D=STALL;
assign STALL_PC=STALL;
assign Flush_E=STALL;
assign STALL_RS=(Tnew_E>Tuse_RS&&(A3_E!=5'b0&&A3_E==RS_D))||(Tnew_M>Tuse_RS&&(A3_M!=5'b0&&A3_M==RS_D))?1'b1:1'b0;
assign STALL_RT=(Tnew_E>Tuse_RT&&(A3_E!=5'b0&&A3_E==RT_D))||(Tnew_M>Tuse_RT&&(A3_M!=5'b0&&A3_M==RT_D))?1'b1:1'b0;
assign FORWARD_S_D=(A3_E!=5'b0&&A3_E==RS_D&&Tnew_E==2'b0&&RegWrite_E==1'b1)?2'b10://has a insert foward so only think about E and M without W
                   (A3_M!=5'b0&&A3_M==RS_D&&Tnew_M==2'b0&&RegWrite_M==1'b1)?2'b01:2'b0;
assign FORWARD_T_D=(A3_E!=5'b0&&A3_E==RT_D&&Tnew_E==2'b0&&RegWrite_E==1'b1)?2'b10:
                   (A3_M!=5'b0&&A3_M==RT_D&&Tnew_M==2'b0&&RegWrite_M==1'b1)?2'b01:2'b0;
assign FORWARD_S_E=(A3_M!=5'b0&&A3_M==RS_E&&Tnew_M==2'b0&&RegWrite_M==1'b1)?2'b10:
                   (A3_W!=5'b0&&A3_W==RS_E&&Tnew_W==2'b0&&RegWrite_W==1'b1)?2'b01:2'b0;
assign FORWARD_T_E=(A3_M!=5'b0&&A3_M==RT_E&&Tnew_M==2'b0&&RegWrite_M==1'b1)?2'b10:
                   (A3_W!=5'b0&&A3_W==RT_E&&Tnew_W==2'b0&&RegWrite_W==1'b1)?2'b01:2'b0;
assign FORWARD_T_M=(A3_W!=5'b0&&A3_W==RT_M&&Tnew_W==2'b0&&RegWrite_W==1'b1)?2'b01:2'b0;             


endmodule //UNIT