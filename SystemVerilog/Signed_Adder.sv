`timescale 1ns/10ps

module Signed_Adder #(
    parameter DW=32
)(
    input signed [DW-1:0]in_1,
    input signed [DW-1:0]in_2,
    output signed [DW:0]data_out
);
    always_comb begin
        data_out=in_1+in_2;
    end
endmodule