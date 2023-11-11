module CTRL (
    input  wire [5:0]opcode,
    input wire[5:0]func,
    input  [4:0]C0part,
    output RegWrite,
    output RegDst,
    output Alusrc,
    output MemReg,
    output Beqsign ,
    output Bnesign,
    output Extop ,
    output Jump ,
    output Jr, 
    output link, 
    output wire [3:0]Aluop ,
    output [2:0] Tnew_D,
    output [2:0] Tuse_RS,
    output [2:0] Tuse_RT,
    output [1:0] byte_cho,
    output [2:0]load_op,
    output select,
    output start,
    output RI_sign,
    output Syscall_sign,
    output Eret_D,
    output BD_F,
    output [2:0]type_ins,
    output Mtc0_D,
    output Mfc0_D,
    output [3:0]mdu_ctrl//this can mean the instr is mdu
);//

parameter RIop=6'b000000;
parameter add=6'b100000;
parameter sub=6'b100010;
parameter ori=6'b001101;
parameter lui=6'b001111;
parameter lw=6'b100011;
parameter sw=6'b101011;
parameter beq=6'b000100;
parameter jal=6'b000011;
parameter jr=6'b001000;
parameter lb=6'b100000;
parameter lh=6'b100001;
parameter sb=6'b101000;
parameter sh=6'b101001;
parameter andR=6'b100100;//plus x to diff  R
parameter orR=6'b100101;//R
parameter slt=6'b101010;//R
parameter sltu=6'b101011;//R
parameter addi=6'b001000;//I
parameter andi=6'b001100;//I
parameter bne=6'b000101;
parameter mult=6'b011000;//R
parameter multu=6'b011001;//R
parameter div=6'b011010;//R
parameter divu=6'b011011;//R
parameter mfhi=6'b010000;//R
parameter mflo=6'b010010;//R
parameter mthi=6'b010001;//R
parameter mtlo=6'b010011;//R

parameter COP0=6'b010000;//opcode
parameter eret=6'b011000;//func
parameter mfc0=5'b00000;//c0code
parameter mtc0=5'b00100;//c0code
parameter syscall=6'b001100;//R+func
//100是load，110是store,001是add,010是sub
assign type_ins=(opcode==lh||opcode==lb||opcode==lw)?3'b100:
                (opcode==addi||(opcode==RIop&&func==add))?3'b001:
                (opcode==RIop&&func==sub)?3'b010:
                (opcode==sw||opcode==sh||opcode==sb)?3'b110:2'b000;

assign Eret_D=(opcode==COP0&&func==eret)?1'b1:1'b0;

assign BD_F=(opcode==beq||opcode==bne||opcode==jal||(RIop==opcode&&func==jr))?1'b1:1'b0;

assign Mtc0_D=(opcode==COP0&&C0part==mtc0)?1'b1:1'b0;

assign Mfc0_D=(opcode==COP0&&C0part==mfc0)?1'b1:1'b0;

assign RI_sign=((opcode==RIop&&
(func==add
||func==sub
||func==jr
||func==andR
||func==orR
||func==slt
||func==sltu
||func==mult
||func==multu
||func==div
||func==divu
||func==mfhi
||func==mflo
||func==mthi
||func==mtlo
||func==syscall
))||(opcode==ori
||opcode==lui
||opcode==lw
||opcode==sw
||opcode==beq
||opcode==jal
||opcode==lb
||opcode==lh
||opcode==sb
||opcode==sh
||opcode==addi
||opcode==andi
||opcode==bne
)
||(opcode==COP0&&(func==eret||mfc0==C0part||mtc0==C0part))||(opcode==6'b0&&func==6'b0)
)?1'b0:1'b1;
//这里是小写，cp0里面是大写
assign Syscall_sign=(RIop==opcode&&func==syscall)?1'b1:1'b0;


assign byte_cho=(opcode==sw)?2'b11:
                (opcode==sh)?2'b01:
                (opcode==sb)?2'b10:2'b00;
assign RegWrite=(
(RIop==opcode&&(func==add||func==sub||func==orR||func==andR||func==slt||func==sltu))
||opcode==lui
||opcode==ori
||opcode==lw
||opcode==lb
||opcode==lh
||opcode==jal
||opcode==addi
||opcode==andi
||(opcode==COP0&&C0part==mfc0)
||(opcode==RIop&&(func==mfhi||func==mflo))
)?1'b1:1'b0;
assign select=(opcode==RIop&&(func==mfhi||func==mflo))?1'b1:1'b0;

assign start=(opcode==RIop&&(func==mult||func==multu||func==div||func==divu))?1'b1:1'b0;

assign RegDst=((RIop==opcode)&&(func==add||func==sub||func==andR||func==orR
||func==slt
||func==sltu
||func==mfhi
||func==mflo))?1'b1:1'b0;

assign Alusrc=(opcode==lui
||opcode==ori
||opcode==lw
||opcode==sw
||opcode==lb
||opcode==lh
||opcode==sh
||opcode==addi
||opcode==andi
||opcode==sb)?1'b1:1'b0;

assign MemReg=(opcode==lw||opcode==lb||opcode==lh)?1'b1:1'b0;

assign Beqsign=(opcode==beq)?1'b1:1'b0;

assign Bnesign=(opcode==bne)?1'b1:1'b0;

assign Extop=(opcode==ori||opcode==andi)?1'b1:1'b0;

assign Jr=(RIop==opcode&&func==jr)?1'b1:1'b0;

assign Jump=(jal==opcode||(RIop==opcode&&func==jr))?1'b1:1'b0;

assign Aluop=((RIop==opcode&&func==add)
||opcode==lw
||opcode==sw
||opcode==lb
||opcode==lh
||opcode==sh
||opcode==addi
||opcode==sb)?4'd2:
             (RIop==opcode&&func==sub)?4'd6:
             (opcode==lui)?4'd4:
             (opcode==ori||(RIop==opcode&&func==orR))?4'd1:
             (opcode==andi||(RIop==opcode&&func==andR))?4'd0:
             (opcode==RIop&&func==slt)?4'd7:
             (opcode==RIop&&func==sltu)?4'd8:4'b0;
assign link=(jal==opcode)?1'b1:1'b0;

assign Tnew_D=(opcode==lw||opcode==lh||opcode==lb||(opcode==COP0&&C0part==mfc0))?3'b010:
((RIop==opcode&&
(func==add
||func==sub
||func==mfhi
||func==mflo
||func==andR
||func==orR
||func==slt
||func==sltu))
            ||opcode==lui
            ||opcode==addi
            ||opcode==andi
            ||opcode==ori)?3'b01:3'b0;

assign Tuse_RS=((RIop==opcode&&(func==add
||func==sub
||func==mthi
||func==mtlo
||func==mult
||func==multu
||func==div
||func==divu
||func==andR
||func==orR
||func==slt
||func==sltu))
                ||opcode==ori
                ||opcode==lb
                ||opcode==lh
                ||opcode==andi
                ||opcode==addi
                ||opcode==lw
                ||opcode==sw
                ||opcode==sb
                ||opcode==sh)?3'b001:
               ((RIop==opcode&&func==jr)
               ||opcode==beq
               ||opcode==bne)?3'b000:3'b011;
assign Tuse_RT=(RIop==opcode&&
(func==add
||func==sub
||func==andR
||func==orR
||func==slt
||func==sltu
||func==mult
||func==multu
||func==div
||func==divu))?3'b001:
               (opcode==sw||opcode==sb||opcode==sh||(opcode==COP0&&C0part==mtc0))?3'b010:
			   (opcode==beq||opcode==bne)?3'b000:3'b011;
					
assign load_op=(opcode==lb)?3'b010:
               (opcode==lh)?3'b100:3'b000;
assign mdu_ctrl=(RIop==opcode&&func==mfhi)?4'b0001:
                (RIop==opcode&&func==mflo)?4'b0010:
                (RIop==opcode&&func==mthi)?4'b0011:
                (RIop==opcode&&func==mtlo)?4'b0100:
                (RIop==opcode&&func==mult)?4'b0101:
                (RIop==opcode&&func==multu)?4'b0110:
                (RIop==opcode&&func==div)?4'b0111:
                (RIop==opcode&&func==divu)?4'b1000:4'b0000;
endmodule 