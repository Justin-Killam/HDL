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
    rfa_t rs,rt,rd,rtd;
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

    //Control signals
    control_signals_t control_sigs;
    wire zero;

    wire [Data_Width-1:0]regfile_out1;
    wire [Data_Width-1:0]regfile_out2;
    wire [Data_Width-1:0]alu_in2;
    wire [Data_Width-1:0]alu_out;
    wire [Data_Width-1:0]data_mem_out;
    wire [Data_Width-1:0]write_back_data;

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
        .sel(control_sigs.signals.branch & zero),//add zero flag
        .in_0(incremented_pc),
        .in_1(branch_addr),
        .data_out(branch_mux_out)
    );
    Mux2 #(
        .DW(Data_Width)
    )Jump_Mux(
        .sel(control_sigs.signals.jump),
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

    MIPS_Control_Unit CU(
        .opcode(opcode),
        .funct(funct),
        .control_sigs(control_sigs)
    );

    Mux2  #(
        .DW(5)
    )RFD_Mux(
        .sel(control_sigs.signals.rfd_sel),
        .in_0(rt),
        .in_1(rd),
        .data_out(rtd)
    );

    MIPS_Register_File RF(
		.clk(clk),
		.wen(control_sigs.signals.rfwe),
		.RA1(rs),
		.RA2(rt),
		.WA(rtd),
		.WD(write_back_data),
		.RD1(regfile_out1),
		.RD2(regfile_out2)
	);

    Mux2  #(
        .DW(Data_Width)
    )ALU_In_Mux(
        .sel(control_sigs.signals.alu_in_sel),
        .in_0(regfile_out2),
        .in_1(se_imm),
        .data_out(alu_in2)
    );

    MIPS_ALU ALU(
        .alu_sel(control_sigs.alu_sel),
        .data_in1(regfile_out1),
        .data_in2(alu_in2),
        .shamt(shamt),
        .zero(zero),
        .data_out(alu_out)
    );

    MIPS_Data_Rom DM(
        .clk(clk),
        .we(control_sigs.signals.dmwe),
        .addr(alu_out),
        .data_in(regfile_out2), 
        .data_out(data_mem_out) 
    );

    Mux2  #(
        .DW(Data_Width)
    )WB_Mux(
        .sel(mem_to_rf_sel),
        .in_0(alu_out),
        .in_1(data_mem_out),
        .data_out(write_back_data)
    );
endmodule