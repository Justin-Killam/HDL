`timescale 1ns/10ps

module Register #(
    parameter DW=32
)(
    input clk,
    input rst,
    input wen,
    input [DW-1:0]data_in,
    output logic [DW-1:0]data_out
);
    always_ff @(posedge clk)begin
        if(rst)data_out<='0;
        else if(wen)data_out<=data_in;
    end
endmodule