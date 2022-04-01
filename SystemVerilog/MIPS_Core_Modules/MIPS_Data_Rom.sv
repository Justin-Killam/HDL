`timescale 1ns/10ps

/*
MIPS_Data_Rom Inst_Name(
    .clk(),
    .we(),
    .addr(),
    .data_in(), 
    .data_out() 
);

*/


`include "/../Packages/MIPS_Generic_Definitions.pkg"

module MIPS_Data_Rom (
    input clk,
    input we,
    input [Data_Mem_Addr_Width-1:0] addr,
    input [Data_Width-1:0]data_in, 
    output logic [Data_Width-1:0]data_out 
);

    logic [Data_Width-1:0] data_rom [0:Data_Mem_Depth-1];
    initial $readmemb(Data_Mem_init,data_rom);
    always_ff @(posedge clk)begin
        if(we)data_rom[addr]<=data_in;
    end
    always_comb begin
        data_out=data_rom[addr];
    end
endmodule