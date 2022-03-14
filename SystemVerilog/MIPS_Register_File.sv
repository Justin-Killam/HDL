`timescale 1ns/1ps
/*
Module Name: MIPS_Register_File.sv
Language: System Verilog
Author: Justin Killam
Description: A register file intended to be used with a MIPS or
MIPS based system. The module has the ability to be used in 3
modes either asynchronous read, write first, or read first using
a mode parameter.

Parameters:
	AWL: Address word length
	DWL: Data word length
	MODE: Register file mode
		0:Asynchronous Read
		1:Write First
		2:Read First
Inputs:
	clk: System clock frequency
	
	wen: Write enable signal. If enabled data on port WD is written 
	to location WA.

	RA1/RA2: Data read address locations for the RD1 and RD2 output ports.

	WA: The address at which WD will be written when wen is active.

	WD: The data to be written to address WA when wen is active.

Outputs:
	RD1: Read port 1 data output.

	RD2: Read port 2 Data output.

Module Instantiation Skeleton:
	MIPS_Register_File #(
		.AWL(),
		.DWL(),
		.MODE()
	)Inst_Name(
		.clk(),
		.wen(),
		.RA1(),
		.RA2(),
		.WA(),
		.WD(),
		.RD1(),
		.RD2()
	);
*/

module MIPS_Register_File #(
parameter AWL=5,
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
			always_ff @(posedge clk)begin
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
			always_ff @(posedge clk)begin
				if(wen)rf_ram[WA]<=WD;
			end
			always_comb begin
				RD1=rf_ram[RA1];
				RD2=rf_ram[RA2];
			end
		end
	endgenerate
endmodule