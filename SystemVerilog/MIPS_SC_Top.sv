`timescale 1ns/10ps

`include "MIPS_SC_Definitions.pkg"

module MIPS_SC_Top (
    input clk,
    input rst
);
    //Program Counter Address Wires
    wire [Data_Width-1:0] branch_mux_out;
    wire [Data_Width-1:0] jump_mux_out;
    wire [Data_Width-1:0] current_pc;
    wire [Data_Width-1:0] incremented_pc;
    wire [Data_Width-1:0] branch_addr;

    
    //Decoding the instruction
    mips_instruction_t mips_instruction;
    opcode_t opcode;
    function_t funct;
    rfa_t rs,rt,rd;
    wire [4:0]shamt;
    wire [15:0]imm;
    wire [25:0]jump_target;
    wire [Data_Width-1:0] se_imm;

    alias mips_instruction.r_type_instruction.opcode=opcode;
    alias mips_instruction.r_type_instruction.funct=funct;
    alias mips_instruction.r_type_instruction.rs=rs;
    alias mips_instruction.r_type_instruction.rt=rt;
    alias mips_instruction.r_type_instruction.rd=rd;
    alias mips_instruction.r_type_instruction.shamt=shamt;
    alias mips_instruction.i_type_instruction.imm=imm;
    alias mips_instruction.j_type_instruction.jump_target=jump_target;

    //Sign extending the 16 bit immediate
    Sign_Extension_Unit #(
        .In_DW(16),
        .Out_DW(Data_Width)
    )SE_Unit(
        .data_in(imm),
        .data_out(se_imm)
    );


    //Program Counter Update Modules
    Mux2 #(
        .DW(Data_Width)
    )Branch_Mux(
        .sel(),
        .in_0(incremented_pc),
        .in_1(branch_addr),
        .data_out(branch_mux_out)
    );
    Mux2 #(
        .DW(Data_Width)
    )Jump_Mux(
        .sel(),
        .in_0(branch_mux_out),
        .in_1({incremented_pc[31:26],jump_target}),
        .data_out(jump_mux_out)
    );

    Register #(
        .DW(Data_Width)
    )PC_Reg(
        .clk(clk),
        .rst(rst),
        .wen(1'b1),
        .data_in(jump_mux_out),
        .data_out(current_pc)
    );

    Signed_Adder #(
        .DW(Data_Width)
    )PC_Inc(
        .in_1(current_pc),
        .in_2(Data_Width'd1),
        .data_out(incremented_pc)
    );

    Signed_Adder #(
        .DW(Data_Width)
    )Branch_Calc(
        .in_1(se_imm),
        .in_2(incremented_pc),
        .data_out(branch_addr)
    );

    MIPS_Instruction_Rom IM(
        .r_addr(current_pc),
        .data_out(mips_instruction) 
    );

endmodule