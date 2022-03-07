`timescale 1ns/1ps
/*
Module Name: Byte2Word
Language: System Verilog
Author: Justin Killam
Description: A module that converts a parameterized
number of bytes into a single word by reading them
one out at a time until the number is filled, and
registering the output. It is intended to be used with
a Uart reciever to conver N bytes into one word.

Parameters:
	BPW: Number of bytes per word

Inputs:
	clk: system clock
	rst: syncronus reset
	in_data_ready: Signal indicating the current byte is ready
	to be read.
	in_akn: Input acknowlegement signal from the module reading
	this module's data output.
	byte_in: A byte wide input number that will be read and included
	in the final output word.

Outputs:
	out_akn: An acknowlegement signal intended to let
	any module know it has read that modules present data
	out_data_ready: A ready signal to let any connected module
	that the completed word is present and ready to be read.
	word_out: The N byte output word.

Module Instantiation Skeleton:
	Byte2Word #(.BPW())
	name(
		.clk(),
		.rst(),
		.in_data_ready(),
		.in_akn(),
		.byte_in(),
		.out_akn(),
		.out_data_ready(),
		.word_out()
	);

*/
module Byte2Word #(parameter BPW=4)
(
input clk,
input rst,
input in_data_ready,
input in_akn,
input [7:0] byte_in,
output logic out_akn,
output logic out_data_ready,
output logic [BPW*8-1:0] word_out
);
    
    localparam CNT_DW=$clog2(BPW-1);
    logic prev_data_rdy;
    logic [CNT_DW-1:0]d_cnt;
    logic [BPW-1:0][7:0]cur_word;
    enum logic {DATA,FINISH}state;
    
    always_ff @(posedge clk)begin
        if(rst)prev_data_rdy<=0;
        else prev_data_rdy<=in_data_ready; 
    end
    
    always_ff @(posedge clk)begin
        if(rst)begin
            out_akn<=0;
            word_out<=0;
            cur_word<=0;
            d_cnt<=0;
            state<=DATA;
        end
        case(state)
            DATA:begin
                if(in_data_ready & !prev_data_rdy)begin
                    out_akn<=1;
                    cur_word[d_cnt]<=byte_in;
                    if(d_cnt==BPW-1)begin
                        d_cnt<=0;
                        state<=FINISH;
                    end
                    else d_cnt<=d_cnt+1;
                end
                else out_akn<=0;
            end
            FINISH:begin
                out_data_ready<=1;
                word_out<=cur_word;
                state<=DATA;
                out_akn<=0;
            end
        endcase
    end
endmodule