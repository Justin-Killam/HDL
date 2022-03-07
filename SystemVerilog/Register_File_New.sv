`timescale 1ns/1ps

module Register_File_New #( 
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
.INIT_A(64'd0), // Initial contents of A Port
.INIT_B(64'd0), // Initial contents of B Port
.INIT_C(64'd0), // Initial contents of C Port
.INIT_D(64'd0), // Initial contents of D Port
.IS_WCLK_INVERTED(1'b0) // Specifies active high/low WCLK
) RAM32M_inst (
.DOA(RD1[i+1:i]), // Read port A 2-bit output
.DOB(RD2[i+1:i]), // Read port B 2-bit output
.DOC(), // Read port C 2-bit output
.DOD(), // Read/write port D 2-bit output
.ADDRA(RA1), // Read port A 5-bit address input
.ADDRB(RA2), // Read port B 5-bit address input
.ADDRC(), // Read port C 5-bit address input
.ADDRD(WA), // Read/write port D 5-bit address input
.DIA(WD[i+1:i]), // RAM 2-bit data write input addressed by ADDRD,
// read addressed by ADDRA
.DIB(WD[i+1:i]), // RAM 2-bit data write input addressed by ADDRD,
// read addressed by ADDRB
.DIC(WD[i+1:i]), // RAM 2-bit data write input addressed by ADDRD,
// read addressed by ADDRC
.DID(WD[i+1:i]), // RAM 2-bit data write input addressed by ADDRD,
// read addressed by ADDRD
.WCLK(clk), // Write clock input
.WE(wen) // Write enable input
);

end
endgenerate
endmodule