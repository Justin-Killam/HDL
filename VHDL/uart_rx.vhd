


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_rx is
    generic(
        SYS_FREQ: natural:=1E8;
        BAUD_FREQ: natural:=9600;
        DATA_WIDTH: natural:=8;
        STOP_BITS: natural:=1    
    );
    Port ( 
        clk_i: in std_logic;
        rst_i: in std_logic;
        en_i: in std_logic;
        rx_i: in std_logic;
        akn_i: in std_logic;
        rdy_o: out std_logic;
        data_o: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
    constant DIV: natural := natural(round(real(SYS_FREQ/BAUD_FREQ)));
    constant HALF_DIV: natural := natural(round(real(DIV/2)));
    constant CNT_WIDTH: natural :=natural(ceil(log2(real(DIV))));
    type state_t is (IDLE,START,DATA,STOP);
end uart_rx;

architecture Behavioral of uart_rx is
    signal state:state_t := IDLE;
    signal data_cnt: unsigned(3 downto 0):=(others=>'0');
    signal clk_cnt:unsigned(CNT_WIDTH-1 downto 0):=(others=>'0');
    signal temp_data:std_logic_vector(DATA_WIDTH-1 downto 0):=(others=>'0');
begin
    main_process: process(clk_i,rst_i)
        begin
           --Asynchronus reset logic
           main_if:if(rst_i='1') then
                state<=IDLE;
                data_cnt<=(others=>'0');
                clk_cnt<=(others=>'0');
                rdy_o<='0';
                data_o<=(others=>'0');
                temp_data<=(others=>'0');
            --Edge sensitive clock logic
            elsif(en_i='1') then
                    clock_if: if rising_edge(clk_i)then
                        state_machine:case state is
                            when IDLE => --Idle state logic
                                data_cnt<=(others=>'0');
                                clk_cnt<=(others=>'0');
                                temp_data<=(others=>'0');
                                if rx_i='0' then state<=START;
                                else state<=IDLE;
                                end if;
                            when START=> --Start state logic
                                --confirm valid start bit at mid point of baud period
                                start_if:if clk_cnt=HALF_DIV-1 and rx_i='1' then
                                    state<=IDLE;
                                    clk_cnt<=(others=>'0');
                                elsif clk_cnt=DIV-1 then
                                    state<=DATA;
                                    clk_cnt<=(others=>'0');
                                else
                                    clk_cnt<=clk_cnt+1;
                                    state<=START;
                                end if;
                            when DATA=> --Data reading state
                                if clk_cnt=HALF_DIV-1 then
                                    temp_data(to_integer(data_cnt))<=rx_i;
                                    clk_cnt<=clk_cnt+1;
                                elsif clk_cnt=DIV-1 then
                                    if data_cnt=DATA_WIDTH-1 then
                                        state<=STOP;
                                        clk_cnt<=(others=>'0');
                                    else 
                                        state<=DATA;
                                        clk_cnt<=(others=>'0');
                                        data_cnt<=data_cnt+1;
                                    end if;
                                else
                                    clk_cnt<=clk_cnt+1;
                                    state<=DATA;
                                end if;
                            when STOP=> --Stop Reception state
                                data_o<=temp_data;
                                rdy_o<='1';
                                state<=IDLE;
                        end case state_machine;
                       akn_if: if akn_i ='1' then rdy_o<='0';end if akn_if; 
                    end if clock_if;
            end if main_if;
    end process main_process;
end Behavioral;
