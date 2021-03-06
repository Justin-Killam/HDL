`timescale 1ns/10ps

/*
MIPS_Instruction_Rom Inst_Name(
    .r_addr(),
    .data_out() 
);
*/

`include "MIPS_Proc_File_Paths.svh"
`include `Generic_Pkg

module MIPS_Instruction_Rom (
    input [Instruction_Mem_Addr_Width-1:0] r_addr,
    output logic [Instruction_Width-1:0]data_out 
);
    
    logic [Instruction_Width-1:0] instruction_rom [0:Instruction_Mem_Depth-1];
    initial $readmemb(`Inst_Init,instruction_rom);

    always_comb begin
        data_out=instruction_rom[r_addr];
    end
endmodule