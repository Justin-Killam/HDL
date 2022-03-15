`timescale 1ns/1ps
/*
Module Name: 
Language: System Verilog
Author: Justin Killam
Description:

Parameters:


Inputs:


Outputs:


Module Instantiation Skeleton:

*/

module MIPS_Control_Unit (
    input [5:0]opcode,
    input [5:0]funct,
    output RFWE,
    output RFDSel,
    output ALUInSel,
    output Branch,
    output DMWE,
    output MtoRFSel,
    output Jump,
    output [3:0]ALUsel
    );

    wire [1:0]ALU_Op;

    MIPS_Opcode_Decoder Op_Dec (
        .Opcode(opcode),
        .RFWE(RFWE),
        .RFDSel(RFDSel),
        .ALUInSel(ALUInSel),
        .Branch(Branch),
        .DMWE(DMWE),
        .MroRFSel(MtoRFSel),
        .Jump(Jump),
        .ALUOp(ALU_Op)
    );


endmodule