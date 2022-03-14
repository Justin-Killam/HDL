`timescale 1ns/1ps

/*

MIPS_Opcode_Decoder Inst_Name (
.Opcode(),
.RFWE(),
.RFDSel(),
.ALUInSel(),
.Branch(),
.DMWE(),
.MroRFSel(),
.Jump(),
.ALUOp()
);

*/

module MIPS_Opcode_Decoder(
(
input [5:0]Opcode,
output logic RFWE,
output logic RFDSel,
output logic ALUInSel,
output logic Branch,
output logic DMWE,
output logic MtoRFSel,
output logic Jump,
output logic [1:0]ALUOp)
);
localparam R_Type_Inst =6'b000000;
localparam LW_Inst =6'b100011;
localparam SW_Inst =6'b101011;
localparam BEQ_Inst =6'b000100;
localparam ADDI_Inst =6'b001000;
localparam J_Inst =6'b000010;
always_comb begin
    case(Opcode)
        R_Type_Inst:{RFWE,RFDSel,ALUInSel,Branch,DMWE,MtoRFSel,ALUOp,Jump}= 9'b110000100;//r-type
        LW_Inst:{RFWE,RFDSel,ALUInSel,Branch,DMWE,MtoRFSel,ALUOp,Jump}= 9'b101001000;//lw
        SW_Inst:{RFWE,RFDSel,ALUInSel,Branch,DMWE,MtoRFSel,ALUOp,Jump}= 9'b001010000;//sw
        BEQ_Inst:{RFWE,RFDSel,ALUInSel,Branch,DMWE,MtoRFSel,ALUOp,Jump}= 9'b000100010;//beq
        ADDI_Inst :{RFWE,RFDSel,ALUInSel,Branch,DMWE,MtoRFSel,ALUOp,Jump}= 9'b101000000;//addi
        J_Inst :{RFWE,RFDSel,ALUInSel,Branch,DMWE,MtoRFSel,ALUOp,Jump}= 9'b000000001;//jump
    endcase
end
endmodule