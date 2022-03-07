`timescale 1ns/1ps

/*
Module Name: Ram.sv
Language: System Verilog
Description:


*/

module Ram #(
parameter DWL=32
)(
input clk,
input wen,
input [7:0]waddr,
input [DWL-1:0] data_in,
output logic [DWL-1:0] data_out
);
	generate
		genvar i;
		for(i=0;i<DWL;i=i+1)begin
			RAM256X1S #(
                .INIT(256'd0),
                .IS_WCLK_INVERTED(1'b0) // Specifies active high/low WCLK
			) Ram (
                .O(data_out[i]), // Read/write port 1-bit output
                .A(waddr), // Read/write port 8-bit address input
                .WE(wen), // Write enable input
                .WCLK(clk), // Write clock input
                .D(data_in[i]) // RAM data input
			);
		end
	endgenerate
endmodule