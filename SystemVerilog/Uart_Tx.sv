/*
Module Name: Uart_Tx
Language: System Verilog
Description: Uart Transmitter with parameterized
data width, and baud rate. Format 1 start, DW data,
1 stop, and no parity.

Parameters:
	DW: The data width
	SYS_FREQ: The system clock frequency
	BAUD_FREQ: The desired baud rate frequency

Inputs:
	clk: system clock
	rst: syncronus reset
	tx_par: parallel data that will be transmited
	tx_start: signal to start the transmition process

Outputs:
	tx_akn: a signal to acknowlege the transmitter has recieved data
	tx_ser: serial transmiter output signal

Module Instantiation Skeleton:
	Uart_Tx #(
			.DW(8),
			.SYS_FREQ(100000000),
			.BAUD_FREQ(9600)
		)Name(
			.clk(),
			.rst(),
			.tx_par(),
			.tx_start(),
			.tx_akn(),
			.tx_ser()
		);
*/

module Uart_Tx #(
        parameter DW=8,
        parameter SYS_FREQ=100000000,
        parameter BAUD_FREQ=9600
    )(
        input clk,
        input rst,
        input [DW-1:0]tx_par,
        input tx_start,
        output logic tx_akn,
        output logic tx_ser
    );
	
	//enumerated 2 bit state variable
	typedef enum logic[1:0] {IDLE,START,DATA,END} t_state;
	
	//local parameter values for the clock division and data counting variables
    localparam CLK_DIVISOR = SYS_FREQ/BAUD_FREQ;
    localparam CNT_DW = $clog2(CLK_DIVISOR-1);
    localparam DATA_CNT_DW = $clog2(DW-1);
	
	//initializing state variable
	t_state state;
    
	//registered data variable and counter variables
    logic [DW-1:0]tx_par_cur;
    logic [CNT_DW-1:0]clk_counter;
    logic [DATA_CNT_DW-1:0]data_counter;
    
    //finite state machine
    always_ff @(posedge clk)begin
		//reset
        if(rst)begin
            state <= IDLE;
            clk_counter <= 0;
            tx_akn <= 0;
            tx_ser <= 1;
            data_counter<=DW-1;
        end
        else begin
            case(state)
				//do nothing in the idle state but check for start signal
                IDLE:begin
                    if(tx_start)begin
                        state <= START;
                        clk_counter <= 0;
                        tx_ser <= 0;
                        tx_akn <= 1;
                        tx_par_cur<=tx_par;
                    end
                end
				//the start signal has been recieved and the baud rate begins
                START:begin
                    if(clk_counter==CLK_DIVISOR-1)begin
                        state<=DATA;
                        clk_counter<=0;
                        data_counter<=DW-1;
                        tx_ser<=tx_par_cur[0];
                        tx_par_cur<=tx_par_cur>>1;                         
                    end
                    else begin
                        clk_counter<=clk_counter+1;
                        tx_ser<=0;
                        tx_akn<=0;
                    end
                end
				//transimts the data 
                DATA:begin
                    if(clk_counter==CLK_DIVISOR-1)begin
                        clk_counter<=0;
                        if(data_counter==0)begin
                            state<=END;
                            tx_ser<=1;
                        end
                        else begin
                            tx_ser<=tx_par_cur[0]; 
                            tx_par_cur<=tx_par_cur>>1;
                            data_counter<=data_counter-1;  
                        end                      
                    end
                    else clk_counter<=clk_counter+1;
                end
				//ends the transmit with the stop bit
                END:begin
                    if(clk_counter==CLK_DIVISOR-1)begin
                        state<=IDLE;
                        clk_counter<=0;
                        tx_ser<=1; 
                    end
                    else clk_counter<=clk_counter+1;
                end
            endcase
        end
    end
endmodule