module mips(
    input clk,                    // 时钟信号
    input reset,                  // 同步复位信号
    input interrupt,              // 外部中断信号
    output [31:0] macroscopic_pc, // 宏观 PC

    output [31:0] i_inst_addr,    // IM 读取地址（取�PC�
    input  [31:0] i_inst_rdata,   // IM 读取数据

    output [31:0] m_data_addr,    // DM 读写地址
    input  [31:0] m_data_rdata,   // DM 读取数据
    output [31:0] m_data_wdata,   // DM 待写入数�
    output [3 :0] m_data_byteen,  // DM 字节使能信号

    output [31:0] m_int_addr,     // 中断发生器待写入地址
    output [3 :0] m_int_byteen,   // 中断发生器字节使能信�

    output [31:0] m_inst_addr,    // M �PC

    output w_grf_we,              // GRF 写使能信�
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,    // GRF 待写入数�

    output [31:0] w_inst_addr     // W �PC
);
wire [31:0] m_data_addr_cpu;
wire [31:0] m_data_rdata_cpu;
wire [31:0] m_data_wdata_cpu;
wire [3:0] m_data_byteen_cpu;
wire [5:0]HWInt;
wire IRQ0;
wire IRQ1;
assign HWInt={3'b0,interrupt,IRQ1,IRQ0};
CPU CPU(
        .clk(clk),
        .reset(reset),

        .i_inst_addr(i_inst_addr),
        .i_inst_rdata(i_inst_rdata),

        .m_data_addr(m_data_addr_cpu),
        .m_data_rdata(m_data_rdata_cpu),
        .m_data_wdata(m_data_wdata_cpu),
        .m_data_byteen(m_data_byteen_cpu),

        .m_inst_addr(m_inst_addr),

        .w_grf_we(w_grf_we),
        .w_grf_addr(w_grf_addr),
        .w_grf_wdata(w_grf_wdata),

        .w_inst_addr(w_inst_addr),
        .HWInt(HWInt)
    );
assign macroscopic_pc=m_inst_addr;

assign m_int_addr=m_data_addr_cpu;

assign m_int_byteen=m_data_byteen_cpu;

wire [31:0]TC0_out;
wire [31:0]TC1_out;
wire [31:0]TC0_in;
wire [31:0]TC1_in;
wire [31:0]TC0_addr;
wire [31:0]TC1_addr;
wire TC0_WE;
wire TC1_WE;
BRIDGE BRIDGE(
    .m_data_addr(m_data_addr),
    .m_data_wdata(m_data_wdata),
    .m_data_byteen(m_data_byteen),
    .m_data_rdata(m_data_rdata),

    .te_m_data_addr(m_data_addr_cpu),
    .te_m_data_wdata(m_data_wdata_cpu),
    .te_m_data_byteen(m_data_byteen_cpu),
    .te_m_data_rdata(m_data_rdata_cpu),

    .TC0_addr(TC0_addr),
    .TC0_out(TC0_out),
    .TC0_WE(TC0_WE),
    .TC0_in(TC0_in),

    .TC1_addr(TC1_addr),
    .TC1_out(TC1_out),
    .TC1_WE(TC1_WE),
    .TC1_in(TC1_in)
);

TC Timer0(
.clk(clk),
.reset(reset),
.Addr(TC0_addr[31:2]),
.WE(TC0_WE),
.Din(TC0_in),
.Dout(TC0_out),
.IRQ(IRQ0)
);
TC Timer1(
.clk(clk),
.reset(reset),
.Addr(TC1_addr[31:2]),
.WE(TC1_WE),
.Din(TC1_in),
.Dout(TC1_out),
.IRQ(IRQ1)
);
endmodule //mips