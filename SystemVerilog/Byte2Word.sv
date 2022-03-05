

module Byte2Word #(parameter BPW=4)
(
input clk,
input rst,
input d_rdy,
input [7:0] byte_in,
output logic d_akn,
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
				if(d_cnt==BPW)begin
					d_cnt<=0;
					state<=FINISH;
				end
			end
		end
		FINISH:
	endcase

end