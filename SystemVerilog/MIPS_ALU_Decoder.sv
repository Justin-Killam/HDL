`timescale 1ns/1ps
/*

Module Instantiation Skeleton:
    MIPS_ALU_Decoder Inst_Name (
        .ALU_Op(),
        .funct(),
        .ALU_Sel()
    );

*/
`include "MIPS_SC_Definitions.pkg"

module MIPS_ALU_Decoder (
input [1:0]alu_op,
input [5:0]funct,
output logic [3:0]alu_sel
);

    always_comb begin
        case(alu_op)
            ADD_Op:ADD_ALU_Sel;
            SUB_Op:SUB_ALU_Sel;
            R_Type_Op:case(funct)
                ADD_Funct:alu_sel=ADD_ALU_Sel;
                SUB_Funct:alu_sel=SUB_ALU_Sel;
                SLL_Funct:alu_sel=SLL_ALU_Sel;
                SLLV_Funct:alu_sel=SLLV_ALU_Sel;
                SRAV_Funct:alu_sel=SRAV_ALU_Sel;
            endcase
        endcase
    end
endmodule