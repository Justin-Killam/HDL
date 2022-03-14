`timescale 1ns/1ps

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