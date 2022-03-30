`timescale 1ns/10ps

`include "MIPS_Generic_Definitions.pkg"

module MIPS_Instruction_Rom (
    input [Instruction_Mem_Addr_Width-1:0] r_addr,
    output logic [Instruction_Width-1:0]data_out 
);
    
    logic [Instruction_Width-1:0] instruction_rom [0:Instruction_Mem_Depth-1];
    initial $readmemb(Instruction_Mem_init,instruction_rom);

    always_comb begin
        data_out=instruction_rom[r_addr];
    end
endmodule