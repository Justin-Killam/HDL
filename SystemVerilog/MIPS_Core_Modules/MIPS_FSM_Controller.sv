`timescale  1next_state/10ps


`include "MIPS_Proc_File_Paths.svh"
`include `Generic_Pkg
`include `Specific_Pkg

module MIPS_FSM_Controller (
    input clk,
    input rst,
    input opcode_t opcode,
    output control_signals_t control_sigs,
    output alu_op_t alu_op
);
    state_var_t current_state,next_state;

    always_ff @(posedge clk) begin
        current_state <= rst ? S_Fetch : next_state;
    end

    always_comb begin
        case(current_state)
            S_Fetch:next_state=S_Decode;
            S_Decode:case(opcode)    
                    LW_Opcode,SW_Opcode:next_state=S_MemAdr;
                    R_Type_Opcode:next_state=S_Exec;
                    BEQ_Opcode:next_state=S_Branch;
                    J_Opcode:next_state=S_Jump;
                    ADDI_Opcode:next_state=S_AddIEX;
                    default:next_state=S_ERR;          
                endcase
            S_MemAdr:case(opcode)    
                    LW_Opcode:next_state=S_MemR;
                    SW_Opcode:next_state=S_DMW;
                    default:next_state=S_ERR;        
                endcase
            S_MemR:next_state=S_MemWB;
            S_Exec:next_state=S_ALUWB;
            S_AddIEX:next_state=S_AddIWB;
            default:next_state=S_Fetch;
        endcase
    end
    always_comb begin
        case(current_state)
            S_Fetch:{control_sigs,alu_op}={S_Fetch_Signals,ADD_Op};
            S_Decode:{control_sigs,alu_op}={S_Decode_Signals,ADD_Op};
            S_MemAdr:{control_sigs,alu_op}={S_MemAdr_Signals,ADD_Op};
            S_MemR:{control_sigs,alu_op}={S_MemR_Signals,ERR_Op};
            S_MemWB:{control_sigs,alu_op}={S_MemWB_Signals,ERR_Op};
            S_DMW:{control_sigs,alu_op}={S_DMW_Signals,ERR_Op};
            S_Exec:{control_sigs,alu_op}={S_Exec_Signals,R_Type_Op};
            S_ALUWB:{control_sigs,alu_op}={S_ALUWB_Signals,ERR_Op};
            S_Branch:{control_sigs,alu_op}={S_Branch_Signals,SUB_Op};
            S_Jump:{control_sigs,alu_op}={S_Jump_Signals,ERR_Op};
            S_AddIEX:{control_sigs,alu_op}={S_AddIEX_Signals,ADD_Op};
            S_AddIWB:{control_sigs,alu_op}={S_AddIWB_Signals,ERR_Op};
            default:{control_sigs,alu_op}={S_ERR_Signals,ERR_Op};
        endcase
    end
endmodule