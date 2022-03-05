`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2022 04:31:45 PM
// Design Name: 
// Module Name: Uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Uart_Rx #(
        parameter DW=8,
        parameter SYS_FREQ=100000000,
        parameter BAUD_FREQ=9600
    )(
        input clk,
        input rst,
        input rx_ser,
        input rx_akn,
        output logic rx_data_ready,
        output logic [DW-1:0]rx_par
    );
	
	typedef enum logic[1:0] {IDLE,START,DATA,END} t_state;
    localparam CLK_DIVISOR = SYS_FREQ/BAUD_FREQ;
    localparam HALF_DIVISOR = CLK_DIVISOR/2;
    localparam CNT_DW = $clog2(CLK_DIVISOR-1);
    localparam DATA_CNT_DW = $clog2(DW-1);
	
	t_state state;
    
    logic [DW-1:0]rx_par_pre;
    logic [CNT_DW-1:0]clk_counter;
    logic [DATA_CNT_DW-1:0]data_counter;
    
    
    always_ff @(posedge clk)begin
        if(rst)begin
            state <= IDLE;
            clk_counter <= 0;
            rx_data_ready <= 0;
            rx_par <= 0;
            data_counter<=0;
            rx_par_pre<=0;
        end
        else begin
            case(state)
                IDLE:begin
                    if(!rx_ser)begin
                        clk_counter <= 0;
                        state <= START;
                    end
                end
                START:begin
                    if((clk_counter==HALF_DIVISOR-1) & rx_ser)begin
                        clk_counter <= 0;
                        state <= IDLE;
                    end
                    else if(clk_counter==CLK_DIVISOR-1)begin
                        clk_counter <= 0;
                        state <= DATA;
                        data_counter<=0;
                    end
                    else clk_counter <= clk_counter +1;
                end
                DATA:begin
                    if(clk_counter==HALF_DIVISOR-1)begin
                        rx_par_pre[data_counter]<=rx_ser;
                        clk_counter <= clk_counter +1;
                    end
                    else if(clk_counter==CLK_DIVISOR-1)begin
                        if(data_counter==DW-1)state<=END;
                        else data_counter<=data_counter+1;
                        clk_counter <= 0;    
                    end
                    else clk_counter <= clk_counter +1;
                end
                END:begin
                    if(clk_counter==CLK_DIVISOR-1)begin
                        clk_counter <= 0;
                        state <= IDLE;
                        rx_par<=rx_par_pre;
                        rx_data_ready<=1; 
                    end
                    else clk_counter <= clk_counter +1;
                end
            endcase
        end
        if(rx_data_ready & rx_akn)rx_data_ready<=0;
    end
endmodule
