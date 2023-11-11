module BRIDGE (
    output[31:0]m_data_addr,//针对DM的地址
    output[31:0]m_data_wdata,//针对DM的写入数�
    output[3:0]m_data_byteen,//DM的字节使�
    input [31:0]m_data_rdata,//从DM读出的data

    input [31:0]te_m_data_addr,//cpu出来的addr
    input [31:0]te_m_data_wdata,//cpu出来的要写的东西
    input [3:0]te_m_data_byteen,//cpu字节使能
    output[31:0]te_m_data_rdata,//往CPU读入的数�

    output [31:0]TC0_addr,//针对Tc0的地址
    input  [31:0]TC0_out,//Tc0读出的数�
    output TC0_WE,//T0的写使能
    output [31:0]TC0_in,//

    output [31:0]TC1_addr,//
    input  [31:0]TC1_out,//
    output TC1_WE,//
    output [31:0]TC1_in//
    
);
parameter dm_start=32'h0000_0000;
parameter dm_end=32'h0000_2fff;
parameter t0_start=32'h0000_7f00;
parameter t0_end=32'h0000_7f0b;
parameter t1_start=32'h0000_7f10;
parameter t1_end=32'h0000_7f1b;

wire sel_tc0;
wire sel_tc1;
wire sel_dm;
assign sel_tc0=(te_m_data_addr>=t0_start&&te_m_data_addr<=t0_end)?1'b1:1'b0;

assign sel_tc1=(te_m_data_addr>=t1_start&&te_m_data_addr<=t1_end)?1'b1:1'b0;

assign sel_dm=(te_m_data_addr>=dm_start&&te_m_data_addr<=dm_end)?1'b1:1'b0;

assign m_data_byteen=(sel_dm==1)?te_m_data_byteen:4'b0000;

assign TC0_WE=(te_m_data_byteen!=0&&sel_tc0==1)?1'b1:1'b0;

assign TC1_WE=(te_m_data_byteen!=0&&sel_tc1==1)?1'b1:1'b0;

assign TC0_in=te_m_data_wdata;

assign TC1_in=te_m_data_wdata;

assign TC0_addr=te_m_data_addr;

assign TC1_addr=te_m_data_addr;

assign m_data_addr=te_m_data_addr;//

assign m_data_wdata=te_m_data_wdata;

assign te_m_data_rdata=(sel_tc0==1'b1)?TC0_out:
                       (sel_tc1==1'b1)?TC1_out:
                       (sel_dm==1'b1)?m_data_rdata:32'b0;

endmodule //BRIDGE