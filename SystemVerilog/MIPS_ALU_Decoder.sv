`timescale 1ns/1ps
/*

Module Instantiation Skeleton:
    MIPS_ALU_Decoder Inst_Name (
        .alu_op(),
        .funct(),
        .alu_sel()
    );

*/
`include "MIPS_SC_Definitions.pkg"

module MIPS_ALU_Decoder (
input alu_op_t alu_op,
input function_t funct,
output alu_sel_t alu_sel
);
    always_comb begin
        case(alu_op)
            ADD_Op:alu_sel=ADD_ALU_Sel;
            SUB_Op:alu_sel=SUB_ALU_Sel;
            R_Type_Op:case(funct)
                ADD_Funct:alu_sel=ADD_ALU_Sel;
                SUB_Funct:alu_sel=SUB_ALU_Sel;
                SLL_Funct:alu_sel=SLL_ALU_Sel;
                SLLV_Funct:alu_sel=SLLV_ALU_Sel;
                SRAV_Funct:alu_sel=SRAV_ALU_Sel;
                default:alu_sel=ERR_ALU_Sel;
            endcase
            default:alu_sel=ERR_ALU_Sel;
        endcase
    end
endmodule