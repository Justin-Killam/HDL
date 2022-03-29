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
`include "MIPS_SC_Definitions.pkg"
module MIPS_Control_Unit (
    input [5:0]opcode,
    input [5:0]funct,
    output control_sigs_t control_sigs,
    output [3:0]alu_sel
    );

    wire [1:0]alu_op;

    MIPS_Opcode_Decoder Op_Dec (
        .opcode(opcode),
        .control_sigs(control_sigs),
        .alu_op(alu_op)
    );
    MIPS_ALU_Decoder ALU_Dec (
        .alu_op(alu_op),
        .funct(funct),
        .alu_sel(alu_sel)
    );


endmodule