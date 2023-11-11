`timescale 1ns / 1ps
`define IDLE 2'b00   //方式0
`define LOAD 2'b01   //方式1
`define CNT  2'b10
`define INT  2'b11
//俩寄存器每个占12B的空间，所以地址的时候可以根据这个判断选择的地址
//
`define ctrl   mem[0]//控制寄存器
`define preset mem[1]//初值寄存器
`define count  mem[2]//计数寄存器
//ctrl【3】是IM中断允许使能，1则允许中断否则不能中断
//ctrl[2:!]是模式选择
//ctrl【0】是是否计时器计数
//控制寄存器前几位是保存的，所以在load的时候看到要动这几位就是要位拼接成0的

//重要bug!!!这个addr是一个31:2的寄存器，假如输入一个31:0的就会炸掉！！根本做不对！！
module TC(
    input clk,//时钟
    input reset,//复位信号
    input [31:2] Addr,//地址，需要系统桥沟通
    input WE,//写使能
    input [31:0] Din,//输入值
    output [31:0] Dout,//输出值
    output IRQ//中断逻辑请求
    );

	reg [1:0] state;//状态
	reg [31:0] mem [2:0];//三个寄存器
	
	reg _IRQ;//中断请求的信号
	assign IRQ = `ctrl[3] & _IRQ;//
	
	assign Dout = mem[Addr[3:2]];
	
	wire [31:0] load = Addr[3:2] == 0 ? {28'h0, Din[3:0]} : Din;
	
	integer i;
	always @(posedge clk) begin
		if(reset) begin
			state <= 0; 
			for(i = 0; i < 3; i = i+1) mem[i] <= 0;
			_IRQ <= 0;
		end
		else if(WE) begin
			// $display("%d@: *%h <= %h", $time, {Addr, 2'b00}, load);
			mem[Addr[3:2]] <= load;
		end
		else begin
			case(state)
				`IDLE : if(`ctrl[0]) begin
					state <= `LOAD;
					_IRQ <= 1'b0;
				end
				`LOAD : begin
					`count <= `preset;
					state <= `CNT;
				end
				`CNT  : 
					if(`ctrl[0]) begin
						if(`count > 1) `count <= `count-1;
						else begin
							`count <= 0;
							state <= `INT;
							_IRQ <= 1'b1;
						end
					end
					else state <= `IDLE;
				default : begin//INT
					if(`ctrl[2:1] == 2'b00) `ctrl[0] <= 1'b0;
					else _IRQ <= 1'b0;
					state <= `IDLE;
				end
			endcase
		end
	end

endmodule
