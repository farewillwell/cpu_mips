
`define IM SR[15:10]//分别对应若干外设中断，可以通过设置0,1来屏蔽中断类�
`define EXL SR[1]//发生异常时置位，强制进入异常处理状�
`define IE SR[0]//全局中断使能�时允许中断�时不�
`define BD Cause[31]//是否是延迟槽中的指令
`define IP Cause[15:10]//6个位，每个位�代表当前有中断�
`define ExcCode Cause[6:2]//异常的类�


module CP0 (
input clk,
input reset,
input en, 	//写使能信号�
input[4:0] CP0Add,//寄存器地址。必然是rd，所以针对rd要单独传并且连接
input[31:0] CP0In,// 	CP0 写入数据。rt，直接连rt即可
output[31:0] CP0Out ,//	CP0 读出数据。，要伸到W级内部转发那个几个里面，
input[31:0] VPC ,//受害 PC�
input BDIn ,//是否是延迟槽指令�
input[4:0] ExcCodeIn,//	记录异常类型�
input[5:0] HWInt,//	输入中断信号�
input EXLClr,//用来复位 EXL�
output [31:0] EPCOut, //32 	EPC 的值�
output Req  //进入处理程序请求�

);
assign EPCOut=tempEpc; //直接暴露EPC的�

parameter Int = 5'd0;
parameter AdEL= 5'd4;
parameter AdES= 5'd5;
parameter Syscall=5'd8;
parameter RI=5'd10;
parameter OV=5'd12;

initial
begin
    SR=0;
    Cause=0;
    EPC=0;
end

wire Expreq;//出现异常,而不是中断，异常和中断分开�
//中断
wire Intreq;

assign Intreq=(|(HWInt&`IM))&(!`EXL)&`IE;

assign Expreq=(ExcCodeIn!=0&&(!`EXL))?1'b1:1'b0;//注意这个当Exl置为�的时候已经在中断态了，是不能再生成异常的.

assign Req=(Intreq|Expreq);

reg [31:0]SR;//12
reg [31:0]Cause;//13
reg [31:0]EPC;//14



assign CP0Out=(CP0Add==12)?SR:
              (CP0Add==13)?Cause:
              (CP0Add==14)?EPC:32'b0;
wire [31:0] tempEpc;
assign tempEpc=(Req==1)?((BDIn==1)?(VPC-4):VPC)://一个小小转�
                        EPC;
always @(posedge clk) begin
    if(reset==1)
    begin
        SR=0;
        Cause=0;
        EPC=0;
    end
    else 
    begin
    `IP<=HWInt;
    if(Req==1) begin
        `ExcCode<=(Intreq)?5'b0:ExcCodeIn;
        `EXL<=1'b1;
        EPC<=tempEpc;
        `BD<=BDIn;
               end
    else if(EXLClr==1) begin
        `EXL<=1'b0;

    end
    else
    begin 
        if(en==1)begin
          if(CP0Add==12)SR<=CP0In;
          else if(CP0Add==13) begin
          Cause<=CP0In  ;
          end
          else if(CP0Add==14) begin
          EPC<=CP0In;  
          end
        end
    end
        end
end
endmodule //cp0