`timescale 1ns/1ps

/*
Module Name: MIPS_Register_File.sv
Language: System Verilog
Author: Justin Killam
Description: A register file intended to be used with a MIPS or
MIPS based system. This register file reads asynchronously, and
is resource optimized using the RAM32M Ultrascale primitive.

Parameters:
	AWL: Address word length

	DWL: Data word length

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
	MIPS_Register_File_Opt #(
		.AWL(),
		.DWL()
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

module MIPS_Register_File_Opt #( 
parameter AWL=5,
parameter DWL=32
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

	generate
	genvar i;
		for(i=0;i<DWL;i=i+2)begin
			RAM32M #(
				.INIT_A(64'd0),//Initializing contents of A-D
				.INIT_B(64'd0),
				.INIT_C(64'd0),
				.INIT_D(64'd0), 
				.IS_WCLK_INVERTED(1'b0)
				) RAM32M_inst (
				.DOA(RD1[i+1:i]), // Read port 1
				.DOB(RD2[i+1:i]), // Read port 2
				.ADDRA(RA1), // Address Port 1
				.ADDRB(RA2), // Address Port 2
				.ADDRD(WA), // Write Address
				.DIA(WD[i+1:i]), // Same Data Tied to all input ports
				.DIB(WD[i+1:i]),
				.DIC(WD[i+1:i]),
				.DID(WD[i+1:i]),
				.WCLK(clk), // Write clock input
				.WE(wen) // Write enable input
			);
		end
	endgenerate
endmodule