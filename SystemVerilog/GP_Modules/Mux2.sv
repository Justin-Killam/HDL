`timescale 1ns/10ps
/*
Mux2 Inst_Name #(
    .DW()
)(
    .sel(),
    .in_0(),
    .in_1(),
    .data_out()
);

*/


module Mux2 #(
    parameter DW=32
)(
    input sel,
    input [DW-1:0]in_0,
    input [DW-1:0]in_1,
    output logic [DW-1:0] data_out
);
    always_comb begin
        data_out = sel?in_1:in_0;
    end
endmodule