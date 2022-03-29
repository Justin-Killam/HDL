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
(
input [5:0]opcode,
output control_sigs_t control_sigs,
output logic [1:0]alu_op)
);

always_comb begin
    case(opcode)
        R_Type_Opcode:{control_sigs,alu_op}= R_Type_Signals;//r-type
        LW_Opcode:{control_sigs,alu_op}= LW_Signals;
        SW_Opcode:{control_sigs,alu_op}= SW_Signals;
        BEQ_Opcode:{control_sigs,alu_op}= BEQ_Signals;
        ADDI_Opcode:{control_sigs,alu_op}= ADDI_Signals;
        J_Opcode :{control_sigs,alu_op}= J_Signals;
    endcase
end
endmodule