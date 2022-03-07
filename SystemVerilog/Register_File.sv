`timescale 1ns/1ps
/*
Module Name: Register_File.sv
Language: System Verilog
Author: Justin Killam
Description: 

Parameters:
	AWL: Address word length
	DWL: Data word length
	MODE: Register file mode
		0:Asynchronous Read
		1:Write First
		2:Read First
Inputs:


Outputs:


Module Instantiation Skeleton:

*/

module Register_File #(
parameter AWL=8,
parameter DWL=32,
parameter MODE=0
)(
    input clk,
    input wen,
    input [AWL-1:0]RA1,
    input [AWL-1:0]RA2,
    input [AWL-1:0]WA,
    input [DWL-1:0]WD,
    output logic [DWL-1:0]RD1,
    output logic [DWL-1:0]RD2
);

	logic [DWL-1:0]rf_ram[0:2**AWL-1];
	assign rf_ram[0]=0;
	
	generate
		if(MODE==2)begin
			always_ff @(posedge clk)begin
				if(wen)rf_ram[WA]<=WD;
				RD1<=rf_ram[RA1];
				RD2<=rf_ram[RA2];
			end
		end
		else if(MODE==1)begin
			logic [AWL-1:0]RA1Q,RA2Q;
			always @(posedge clk)begin
				if(wen)rf_ram[WA]<=WD;
				RA1Q<=RA1;
				RA2Q<=RA2;
			end
			always_comb begin
				RD1=rf_ram[RA1Q];
				RD2=rf_ram[RA2Q];
			end
		end
		else begin
			always @(posedge clk)begin
				if(wen)rf_ram[WA]<=WD;
			end
			always_comb begin
				RD1=rf_ram[RA1];
				RD2=rf_ram[RA2];
			end
		end
	endgenerate
endmodule