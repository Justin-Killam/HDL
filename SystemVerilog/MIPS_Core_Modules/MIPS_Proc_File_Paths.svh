//Leave this file within the directory where all sv files are contained
//Ensure the top module is compiled first
//`include "MIPS_Proc_File_Paths.svh"
//Change paths to match the absolute address of the respective file
`ifndef FPATHS
    `define FPATHS
    `define Inst_Init "C:/Users/Justin Killam/Documents/Git_Local/HDL/Init_Files/MIPS_Inst_E_Bin.txt"
    `define Data_Init "C:/Users/Justin Killam/Documents/Git_Local/HDL/Init_Files/MIPS_Data_Init.txt"
    `define Generic_Pkg "C:/Users/Justin Killam/Documents/Git_Local/HDL/SystemVerilog/Packages/MIPS_Generic_Definitions.pkg"
    `ifdef SC
        `define Specific_Pkg "C:/Users/Justin Killam/Documents/Git_Local/HDL/SystemVerilog/Packages/MIPS_SC_Definitions.pkg"
    `else
        `define Specific_Pkg "C:/Users/Justin Killam/Documents/Git_Local/HDL/SystemVerilog/Packages/MIPS_SC_Definitions.pkg"
    `endif
`endif