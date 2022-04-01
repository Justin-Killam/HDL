`timescale 1ns / 1ps
/*
Module Name: Uart_Rx
Language: System Verilog
Author: Justin Killam
Description: Uart Reciever with parameterized
data width, and baud rate. Format 1 start, DW data,
1 stop, and no parity.

Parameters:
	DW: The data width
	SYS_FREQ: The system clock frequency
	BAUD_FREQ: The desired baud rate frequency

Inputs:
	clk: system clock
	rst: syncronus reset
	rx_ser: serially recieved data
	rx_akn: aknowlegement the data being output has been recieved

Outputs:
	rx_data_ready: signal to let exterial modules know the data is ready
	rx_par: the parallel output data

Module Instantiation Skeleton:
	Uart_Rx #(
			.DW(8),
			.SYS_FREQ(100000000),
			.BAUD_FREQ(9600)
		)Name(
			.clk(),
			.rst(),
			.rx_ser(),
			.rx_akn(),
			.rx_data_ready(),
			.rx_par()
		);
*/

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
	
	//enumerated 2 bit state variable
	typedef enum logic[1:0] {IDLE,START,DATA,END} t_state;
	
	//local parameter values for the clock division and data counting variables
    localparam CLK_DIVISOR = SYS_FREQ/BAUD_FREQ;
    localparam HALF_DIVISOR = CLK_DIVISOR/2;
    localparam CNT_DW = $clog2(CLK_DIVISOR-1);
    localparam DATA_CNT_DW = $clog2(DW-1);
	
	//initializing state variable
	t_state state;
    
	//intermediate data variable and counter variables
    logic [DW-1:0]rx_par_pre;
    logic [CNT_DW-1:0]clk_counter;
    logic [DATA_CNT_DW-1:0]data_counter;
    
    //finite state machine
    always_ff @(posedge clk)begin
		//reset state
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
				// do nothing in the idle state but wait for the rx drop
                IDLE:begin
                    if(!rx_ser)begin
                        clk_counter <= 0;
                        state <= START;
                    end
                end
				// the start pules has been recieved and the start pulse must be validated
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
				//salmple each data bit at the center of the baud rate
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
				//end and register the recieved data
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
		//clear the ready signal if the data is acknowleged
        if(rx_data_ready & rx_akn)rx_data_ready<=0;
    end
endmodule
