`timescale 1ns/1ps
/*

	Byte2Word #(.BPW())
	name(
		.clk(),
		.rst(),
		.d_rdy(),
		.out_akn(),
		.byte_in(),
		.d_akn(),
		.out_rdy(),
		.word_out()
	);

*/
module Byte2Word #(parameter BPW=4)
(
input clk,
input rst,
input d_rdy,
input out_akn,
input [7:0] byte_in,
output logic d_akn,
output logic out_rdy,
output logic [BPW*8-1:0] word_out
);
    
    localparam CNT_DW=$clog2(BPW-1);
    
    logic [CNT_DW-1:0]d_cnt;
    logic [BPW-1:0][7:0]cur_word;
    enum logic {DATA,FINISH}state;
    always_ff @(posedge clk)begin
        if(rst)begin
            d_akn<=0;
            word_out<=0;
            cur_word<=0;
            d_cnt<=0;
            state<=DATA;
        end
        case(state)
            DATA:begin
                if(d_rdy)begin
                    d_akn<=1;
                    cur_word[d_cnt]<=byte_in;
                    if(d_cnt==BPW-1)begin
                        d_cnt<=0;
                        state<=FINISH;
                    end
                    else d_cnt<=d_cnt+1;
                end
                else d_akn<=0;
            end
            FINISH:begin
                out_rdy<=1;
                word_out<=cur_word;
                state<=DATA;
                d_akn<=0;
            end
        endcase
    end
endmodule