`timescale 1ns/1ps
`include "MIPS_SC_Definitions.pkg"

module MIPS_ALU(
    input alu_sel_t alu_sel,
    input signed [Data_Width-1:0] data_in1,
    input signed [Data_Width-1:0] data_in2,
    input [4:0] shamt,
    output logic zero,
    output logic ovf,
    output logic signed [Data_Width-1:0] data_out
);
    always_comb begin
        case(alu_sel)
            ADD_ALU_Sel:data_out=data_in1+data_in2;
            SUB_ALU_Sel:data_out=data_in1-data_in2;
            SLL_ALU_Sel:data_out=data_in2<<shamt;
            SRL_ALU_Sel:data_out=data_in2>>shamt;
            SLLV_ALU_Sel:data_out=data_in2<<data_in1[4:0];
            SRLV_ALU_Sel:data_out=data_in2>>data_in1[4:0];
            SRAV_ALU_Sel:data_out=data_in2>>>data_in1[4:0];
            AND_ALU_Sel:data_out=data_in1&data_in2;
            OR_ALU_Sel:data_out=data_in1|data_in2;
            XOR_ALU_Sel:data_out=data_in1^data_in2;
            XNOR_ALU_Sel:data_out=data_in1~^data_in2;
            default:data_out='x;
        endcase
    end
    

endmodule

/*

module ALU #(parameter WL=32)(input [3:0]OP,
                                    input signed [WL-1:0]in1,in2,
                                    input [4:0]shamt,
                                    output reg zero,
                                    output reg signed [WL-1:0]out);
                                    
    //multiplexing operations based on OP
    always@* begin
        case(OP)
            0:out= in1+in2;//addition
            1:out= in1-in2;//subtraction
            2:out= in2<<shamt;//lsl
            3:out= in2>>shamt;//lsr  //need to add asr
            4:out= in2<<in1[4:0];//lvsl
            5:out= in2>>in1[4:0];//lvsr
            6:out= in2>>>in1[4:0];//avsr
            7:out= in1&in2;//bitwise and
            8:out= in1|in2;//bitwise or
            9:out= in1^in2;//bitwise xor
            10:out= in1~^in2;//bitwise xnor
        endcase
        if(out==0)zero=1;
        else zero=0;
    end                                   
endmodule
*/