`timescale 1ns/10ps

/*
Sign_Extension_Unit Inst_Name #(
    .In_DW(),
    .Out_DW()
)(
    .data_in(),
    .data_out()
);
*/


module Sign_Extension_Unit #(
    parameter In_DW=16,
    parameter Out_DW=32
)(
    input [In_DW-1:0]data_in,
    output [Out_DW-1:0]data_out
);

    assign data_out={{(Out_DW-In_DW){data_in[In_DW-1]}},data_in};

endmodule