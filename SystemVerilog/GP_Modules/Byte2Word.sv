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
    
    //Parameter for size of the counter keeping track of byte entry
    localparam CNT_DW=$clog2(BPW-1);

    //Value for registering the input data ready signal to check for level change
    logic prev_in_data_rdy;

    //Counter for keeping track of the # of input bytes recieved
    logic [CNT_DW-1:0]d_cnt;

    //intermediate storage for holding the current word until all bytes are ready
    logic [BPW-1:0][7:0]cur_word;

    //Enemurated variable for the state
    enum logic {DATA,FINISH}state;
    
    //Sequential block for registering the in data ready signal
    always_ff @(posedge clk)begin
        if(rst)prev_in_data_rdy<=0;
        else prev_in_data_rdy<=in_data_ready; 
    end
    
    //Main functional state machine logic
    always_ff @(posedge clk)begin
        //clear the output ready signal if it high and a aknowlege signal is recieved
        if(out_data_ready&in_akn)out_data_ready<=0;
        //Syncronous reset
        if(rst)begin
            //Reseting all stored values to 0 or the starting state
            out_akn<=0;
            word_out<=0;
            cur_word<=0;
            d_cnt<=0;
            state<=DATA;
        end
        case(state)
            //State for recieving the bytes that makeup the word
            DATA:begin
                //Essential checking for the positive edge of the ready signal
                if(in_data_ready & !prev_in_data_rdy)begin
                    //acknowlege the recieved data
                    out_akn<=1;
                    //set the current byte location to the input byte
                    cur_word[d_cnt]<=byte_in;
                    //If completed go to the finish state and reset the count
                    if(d_cnt==BPW-1)begin
                        d_cnt<=0;
                        state<=FINISH;
                    end
                    //otherwise increment the data recieved count
                    else d_cnt<=d_cnt+1;
                end
                //any other clock lower the acknowlege bit
                else out_akn<=0;
            end
            //in the finish stage register the output data, trigger the ready bit, and return to data
            FINISH:begin
                out_data_ready<=1;
                word_out<=cur_word;
                state<=DATA;
                out_akn<=0;
            end
        endcase
    end
endmodule