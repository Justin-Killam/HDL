`timescale 1ns/1ps
/*
Module Name: MIPS_Register_File.sv
Language: System Verilog
Author: Justin Killam
Description: A register file intended to be used with a MIPS or
MIPS based system. The module has the ability to be used in 3
Register_File_Modes either asynchronous read, write first, or read first using
a Register_File_Mode parameter.

Parameters:
	AWL: Address word length
	DWL: Data word length
	Register_File_Mode: Register file Register_File_Mode
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
	MIPS_Register_File Inst_Name(
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
`include "MIPS_Proc_File_Paths.svh"
`include `Generic_Pkg

module MIPS_Register_File(
    input clk,
    input wen,
    input rfa_t RA1,
    input rfa_t RA2,
    input rfa_t WA,
    input [Data_Width-1:0]WD,
    output logic [Data_Width-1:0]RD1,
    output logic [Data_Width-1:0]RD2
);

	logic [Data_Width-1:0]rf_ram[0:31];
	
	generate
		//Mode that reads data present before write operation
		if(Register_File_Mode==2)begin
			always_ff @(posedge clk)begin
				if(wen)rf_ram[WA]<=WD;
				//Setting position 0 to 0
				else rf_ram[0]<=0;
				RD1<=rf_ram[RA1];
				RD2<=rf_ram[RA2];
			end
		end
		//Mode that reads data present after write operation
		else if(Register_File_Mode==1)begin
			rfa_t RA1Q,RA2Q;
			always_ff @(posedge clk)begin
				if(wen)rf_ram[WA]<=WD;
				//Setting position 0 to 0
				else rf_ram[0]<=0;
				//registering the address
				RA1Q<=RA1;
				RA2Q<=RA2;
			end
			//reading a synchronously from the updated address
			always_comb begin
				RD1=rf_ram[RA1Q];
				RD2=rf_ram[RA2Q];
			end
		end
		//Mode for simple asynchronous reading
		else begin
			always_ff @(posedge clk)begin
				if(wen)rf_ram[WA]<=WD;
				//Setting position 0 to 0
				else rf_ram[0]<=0;
			end
			always_comb begin
				RD1=rf_ram[RA1];
				RD2=rf_ram[RA2];
			end
		end
	endgenerate
endmodule