`timescale 1ns/1ps

/*

MIPS_Opcode_Decoder Inst_Name (
.opcode(),
.control_sigs(),
.alu_op()
);

*/

`include "MIPS_SC_Definitions.pkg"

module MIPS_Opcode_Decoder(
input opcode_t opcode,
output opcode_decoder_signal_t control_sigs,
output alu_op_t alu_op
);

always_comb begin
    case(opcode)
        R_Type_Opcode:{control_sigs,alu_op}= {R_Type_Signals,R_Type_Op};//r-type
        LW_Opcode:{control_sigs,alu_op}= {LW_Signals,ADD_Op};
        SW_Opcode:{control_sigs,alu_op}= {SW_Signals,ADD_Op};
        BEQ_Opcode:{control_sigs,alu_op}= {BEQ_Signals,SUB_Op};
        ADDI_Opcode:{control_sigs,alu_op}= {ADDI_Signals,ADD_Op};
        J_Opcode :{control_sigs,alu_op}= {J_Signals,ERR_Op};
        default:{control_sigs,alu_op}={ERR_Signals,ERR_Op};
    endcase
end
endmodule