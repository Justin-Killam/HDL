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
MIPS_Control_Unit Inst_Name(
    .opcode(),
    .funct(),
    .control_sigs()
    );
*/
`include "MIPS_SC_Definitions.pkg"
module MIPS_Control_Unit (
    input opcode_t opcode,
    input function_t funct,
    output control_signals_t control_sigs,
    output alu_sel_t alu_sel
    );

    alu_op_t alu_op;

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