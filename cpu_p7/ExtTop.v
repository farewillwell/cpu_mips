module ExTop (
    input Extop,
    input [15:0]NoneImm,
    output wire [31:0]signimm
);
assign signimm = (Extop==1'b1)? {{16{1'b0}},NoneImm}: {{16{NoneImm[15]}},NoneImm};

endmodule //Extop