`timescale 1ns/1ps
`include "MIPS_Generic_Definitions.pkg"

module MIPS_ALU(
    input alu_sel_t alu_sel,
    input signed [Data_Width-1:0] data_in1,
    input signed [Data_Width-1:0] data_in2,
    input [4:0] shamt,
    output zero,
    output logic signed [Data_Width-1:0] data_out
);
    always_comb begin
        case(alu_sel)
            ADD_ALU_Sel:data_out=data_in1+data_in2;
            SUB_ALU_Sel:data_out=data_in1-data_in2;
            SLL_ALU_Sel:data_out=data_in2<<shamt;
            SRL_ALU_Sel:data_out=data_in2>>shamt;
            SLLV_ALU_Sel:data_out=data_in2<<data_in1[4:0];
            SRLV_ALU_Sel:data_out=data_in2>>data_in1[4:0];
            SRAV_ALU_Sel:data_out=data_in2>>>data_in1[4:0];
            AND_ALU_Sel:data_out=data_in1&data_in2;
            OR_ALU_Sel:data_out=data_in1|data_in2;
            XOR_ALU_Sel:data_out=data_in1^data_in2;
            XNOR_ALU_Sel:data_out=data_in1~^data_in2;
            default:data_out='x;
        endcase
    end
    assign zero=data_out==0;

endmodule

