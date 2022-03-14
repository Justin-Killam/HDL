`timescale 1ns/1ps
/*

Module Instantiation Skeleton:
    MIPS_ALU_Decoder Inst_Name (
        .ALU_Op(),
        .funct(),
        .ALU_Sel()
    );

*/
module MIPS_ALU_Decoder (
input [1:0]ALU_Op,
input [5:0]funct,
output logic [3:0]ALU_Sel
);

//Parameters for readability
    //ALU Op parameters
    localparam ADDI=2'b00;
    localparam SUBI=2'b01;
    localparam R_Type=2'b10;

    //Output select signal parameters
    localparam ADD_Sel=4'd0;
    localparam SUB_Sel=4'd1;
    localparam SLL_Sel=4'd2;
    localparam SLLV_Sel=4'd4;
    localparam SRAV_Sel=4'd6;

    //Input function parameters
    localparam ADD_Funct=6'b100000;
    localparam SUB_Funct=6'b100010;
    localparam SLL_Funct=6'b000000;
    localparam SLLV_Funct=6'b000100;
    localparam SRAV_Funct=6'b000111;

    always_comb begin
        case(ALU_Op)
            ADDI:
            SUBI:
            R_Type:case(funct)
                ADD_Funct:ALU_Sel=ADD_Sel;
                SUB_Funct:ALU_Sel=SUB_Sel;
                SLL_Funct:ALU_Sel=SLL_Sel;
                SLLV_Funct:ALU_Sel=SLLV_Sel;
                SRAV_Funct:ALU_Sel=SRAV_Sel;
            endcase
        endcase
    end
endmodule