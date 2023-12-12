 ----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Create Date: 01/31/2022 01:38:55 PM
-- Design Name: Concatenator Testbench
-- Module Name: concatenator_tb - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
--use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_MISC.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.all;

library work;
use work.graph_constructor_package.all;

----------------------------------------------------------------------------------
-- Entity
----------------------------------------------------------------------------------
entity concatenator_tb is
    GENERIC(
      -- Testbench Parameters
      DEBUG_ON		: boolean := false		-- Enable for debug messages
      );
end concatenator_tb;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture concatenator_tb_architecture of concatenator_tb is
    -- Signal Nameing Convention - <signal-name>_<source>

    -- General Clocks and Resets
    signal clk                 : std_logic := '0';  --50M
    signal reset               : std_logic := '0';
    signal ready               : std_logic;
    signal start               : std_logic;
    signal done                : std_logic;

    -- File Reader
    signal edge_calc_num       : std_logic_vector(15 downto 0);
    signal edge_calc_index     : integer := 0; 
    signal edge_word_count     : std_logic_vector(EdgeParamAddrWidth-1 downto 0);
    signal tb_edge_count       : std_logic_vector(EdgeParamAddrWidth-1 downto 0);
    signal tb_wait             : std_logic;

    signal wait_count          : std_logic_vector(3 downto 0);

    -- Data from edge calc
    signal edge_data_ready     : std_logic_vector(NumEdgeCalculators-1 downto 0) := (others => '0');
    signal edge_data_count     : EdgeDataCount_t;
    signal edge_data_in        : EdgeDataIn_t;
    signal adj_id_in           : AdjIDIn_t;
    signal edge_re             : std_logic_vector(NumEdgeCalculators-1 downto 0);

    -- Concatenator Output Data
    signal edge_data_out       : std_logic_vector(ModuleDataOutputWidth-1 downto 0);
    signal adj_id_out          : std_logic_vector(RawAddrWidth*2-1 downto 0);

    -- State definitions for file reader process
    TYPE fr_state_type is (
        s_idle,
        s_read_1,
        s_wait_0,
        s_done);

    signal fr_state : fr_state_type;
    signal fr_rtn_state : fr_state_type;

    -- File Writter
    signal fw_wait_count          : integer;

    -- State definitions for file writter process
    TYPE fw_state_type is (
        s_idle,
        s_write_0,
        s_wait_0,
        s_done);

    signal fw_state : fw_state_type;
    signal fw_rtn_state : fw_state_type;

    type t_ec_output is array (0 to 3) of std_logic_vector(63 downto 0);
    signal ec_output_array : t_ec_output := (others => (others => '0'));

    -- Utility function to convert unsigned to hexadecimal string
    function to_hex (SLV : std_logic_vector) return string is
        variable L : LINE;
      begin
        hwrite(L,SLV);
        return L.all;
      end function to_hex;

    component concatenator is
        port ( 
            CLK                 : in  std_logic;
            RESET               : in  std_logic;
            READY               : out std_logic;

            START               : in std_logic;
            DONE                : out std_logic;

            EDGE_DATA_READY     : in std_logic_vector(NumEdgeCalculators-1 downto 0);
            EDGE_DATA_COUNT     : in EdgeDataCount_t;
            EDGE_DATA_IN        : in EdgeDataIn_t;
            ADJ_ID_IN           : in AdjIDIn_t;
            EDGE_RE             : out std_logic_vector(NumEdgeCalculators-1 downto 0);

            EDGE_DATA_OUT       : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            ADJ_ID_OUT          : out std_logic_vector(RawAddrWidth*2-1 downto 0)
        );
    end component;

begin

    -- Mapping from file reader
    --ec_output_array(0) <= x"0000_0000_0000_000" & "000" & edge_data_ready;
    --ec_output_array(1) <= x"0000_0000_000" & "00" & edge_data_count;
    --ec_output_array(2) <= edge_data_out;
    --ec_output_array(3) <= x"0000_0000" & adj_id_out;

    -- Array to capture edge calculator output

    ----------------------------------------
    -- Unit Under Test: Graph Constructor
    ----------------------------------------
    UUT : concatenator
        PORT MAP(
            CLK                 => clk,
            RESET               => reset,
            READY               => ready,

            START               => start,
            DONE                => done,
            
            EDGE_DATA_READY     => edge_data_ready,
            EDGE_DATA_COUNT     => edge_data_count,
            EDGE_DATA_IN        => edge_data_in,
            ADJ_ID_IN           => adj_id_in,
            EDGE_RE             => edge_re,

            EDGE_DATA_OUT       => edge_data_out,
            ADJ_ID_OUT          => adj_id_out
        );

    ----------------------------------------
    -- Reset Process
    ----------------------------------------
    reset_process : process
    begin
        reset  <= '0';
        wait for 5 ns;
        reset  <= '1';
        wait for 15 ns;
        reset  <= '0';
        wait for 35 us;
    end process reset_process;
    
    ----------------------------------------
    -- Clock Process
    ----------------------------------------
    clock_process : process
    begin
        clk  <= '0';
        wait for ClkPeriod/2;
        clk  <= '1';
        wait for ClkPeriod/2;
    end process clock_process;

    -------------------------------------------------------
    -- File Reader Process for Concatenator Input Data
    -------------------------------------------------------
    file_reader_process : process(clk)

        file data_input_file	   : text open read_mode is "./data/ec_out.txt";
        variable file_line         : line;
        variable data_line         : line;

        variable input_data_word_1 : std_logic_vector(ConcatSimDataInputWidth-1 downto 0);
        variable input_data_word_2 : std_logic_vector(ConcatSimDataInputWidth-1 downto 0);

        variable read_count        : integer := 0;
        variable msg_line          : line;
        
    
    begin

        --Signal Mapping
    


        if ( rising_edge(clk) ) then
            if (reset ='1') then
                read_count := 0;
                
                edge_calc_num <= (others => '0');
                edge_calc_index <= 0;
                edge_word_count <= (others => '0');
                tb_edge_count <= (others => '0');
                tb_wait  <= '0';

                input_data_word_1 := (others => '0');
                input_data_word_2 := (others => '0');
               
                wait_count <= (others => '0');
                
                start  <= '0';
                fr_state <= s_idle;
            else

                case (fr_state) is
                    when s_idle =>
                        
                        if (ready = '1') then
                            report "---- Reading Edge Calc Data Input File ----";
                            start  <= '1';
                            fr_state <= s_read_1;
                        else
                            fr_state <= s_idle;
                        end if;

                    when s_read_1 =>
                            if(not endfile(data_input_file)) then  
                                --Read lines of data until the end of the file
                                if (tb_wait = '0') then 
                                    readline(data_input_file, file_line);
                                    read_count := read_count + 1;
                                end if;
                                
                                -- Parse lines for event boundries
                                if(file_line'length = 0) then
                                    write(msg_line, STRING'("----- Skip Blank Line"));
                                    writeline(output, msg_line);
                                    fr_state <= s_read_1;
                                elsif(file_line(1 to 4) = "ABCD") then
                                    write(msg_line, STRING'("----- Event Start # : "));
                                    write(msg_line, file_line(14 to 17));
                                    writeline(output, msg_line);
                                    fr_state <= s_read_1;  
                                elsif(file_line(1 to 4) = "FFFF") then
                                    write(msg_line, STRING'("----- Event End # : "));
                                    write(msg_line, file_line(14 to 17));  
                                    writeline(output, msg_line);
                                    fr_state <= s_read_1;
                                elsif(file_line(1 to 2) = "EF") then
                                    write(msg_line, STRING'("----- Edge Calc # : "));
                                    write(msg_line, file_line(6 to 9)); 

                                    write(msg_line, STRING'(" Num Words # : "));
                                    write(msg_line, file_line(14 to 17));   
                                    
                                    hread(file_line, input_data_word_1);
                                    --Capture Edge Calc Instance Number
                                    edge_calc_index <= to_integer(unsigned(input_data_word_1(40 downto 32))) - 1;
                                    --Capture Expected Number of words
                                    edge_word_count <= input_data_word_1(EdgeParamAddrWidth-1 downto 0);
                                    tb_edge_count <= input_data_word_1(EdgeParamAddrWidth-1 downto 0);

                                    writeline(output, msg_line);
                                    fr_state <= s_read_1;
                                elsif(file_line(1 to 2) = "FF") then
                                        write(msg_line, STRING'("----- Edge Data: "));
    
                                        -- Edge Ready
                                        edge_data_ready(edge_calc_index) <= '1'; 
    
                                        -- Edge Data Count
                                        edge_data_count(edge_calc_index) <= input_data_word_1(EdgeParamAddrWidth-1 downto 0);
    
                                        writeline(output, msg_line);
                                        fr_state <= s_read_1;
                                elsif(file_line(1 to 4) = "EEEE") then
                                    hread(file_line, input_data_word_1);
                                    wait_count <= input_data_word_1(3 downto 0);
                                    edge_calc_index <= 0;
                                    edge_word_count <= (others => '0');
                                    -- De-assert Edge Ready
                                    edge_data_ready(edge_calc_index) <= '0'; 
                                    fr_state <= s_wait_0;
                                    fr_rtn_state <= s_read_1;
                                elsif (edge_re(edge_calc_index)= '1') then 
                                    -- Feed simulated edge calculator data to top level module
                                    
                                    tb_wait  <= '0';

                                    -- Edge Ready
                                    --edge_data_ready(edge_calc_index) <= '1'; 

                                    -- Edge Data Count
                                    --edge_data_count(edge_calc_index) <= edge_word_count(EdgeParamAddrWidth-1 downto 0);

                                    -- Edge Parameters Word
                                    hread(file_line, input_data_word_1);
                                    edge_data_in(edge_calc_index) <= input_data_word_1(ModuleDataOutputWidth-1 downto 0);
                                    
                                    -- Adjacency Matrix Word
                                    hread(file_line, input_data_word_2);
                                    adj_id_in(edge_calc_index) <= input_data_word_2(RawAddrWidth*2-1 downto 0);
                                    
                                    write(msg_line, STRING'("----- Data : "));
                                    write(msg_line, to_hex(input_data_word_1(ModuleDataOutputWidth-1 downto 0)));
                                    write(msg_line, LF);
                                    write(msg_line, STRING'("----- Adj : "));
                                    write(msg_line, to_hex(input_data_word_2(RawAddrWidth*2-1 downto 0)));

                                    writeline(output, msg_line);
                                    fr_state <= s_read_1;
                                else
                                    tb_wait  <= '1';
                                    fr_state <= s_read_1;

                                end if;
                               

                            else
                                write(msg_line, STRING'("---- File Lines Read : "));
                                write(msg_line, read_count);
                                writeline(output, msg_line);
                                fr_state <= s_done;
                            end if;
                

                    when s_wait_0 =>
                        if (wait_count = 0) then
                            fr_state <= fr_rtn_state;
                        else
                            wait_count <= wait_count - 1; 
                            fr_state <= s_wait_0;
                        end if;

                    when s_done =>
                        fr_state <= s_done;

                    when others =>
                        fr_state <= s_idle;
                        
                end case;
            end if;
        end if;

    end process file_reader_process;

    -------------------------------------------------------
    -- File Writter Process for Concatenator Output Data
    -------------------------------------------------------
    -- file_writer_process : process(clk)

    --     file ec_output_file	     : text open write_mode is "./data/ec_out.txt";
    --     variable file_line       : line;
    --     variable write_count   : integer := 0;
    --     variable msg_line       : line;

    -- begin

    --     if ( rising_edge(clk) ) then
    --         if (reset ='1') then
    --             write_count := 0;
    --             fw_wait_count <= 0;
    --             fw_state <= s_idle;
    --         else
    --             --Default signal states

    --             case (fw_state) is
    --                 when s_idle =>
    --                     if (edge_re = '1') then
    --                         report "---- Writting Edge Calc Data ------------";
    --                         fw_wait_count <= 0;
    --                         fw_state <= s_wait_0;
    --                         fw_rtn_state <= s_write_0;
    --                     else
    --                         fw_state <= s_idle;
    --                     end if;

    --                 when s_write_0 =>
    --                     if (edge_re = '1')  then
    --                         -- Write array to files
    --                         for i in 0 to 3 loop
    --                             hwrite(file_line,ec_output_array(i), right, 17);
    --                         end loop;
    --                         writeline(ec_output_file, file_line);
    --                         write_count := write_count + 1;
    --                         fw_state <= s_write_0;
    --                     else
    --                         fw_state <= s_done;
    --                     end if;

    --                 when s_wait_0 =>
    --                     if (fw_wait_count = 0) then
    --                         fw_state <= fw_rtn_state;
    --                     else
    --                         fw_wait_count <= fw_wait_count - 1; 
    --                         fw_state <= s_wait_0;
    --                     end if;

    --                 when s_done =>
    --                     write(msg_line, STRING'("---- Number of ec outputs to file: "));
    --                     write(msg_line, write_count);
    --                     writeline(output, msg_line);  
    --                     fw_state <= s_idle; 

    --                 when others =>
    --                     fw_state <= s_idle;
                        
    --             end case;
    --         end if;
    --     end if;

    -- end process file_writer_process;
    ----------------------------------------------------------------------------------------

end concatenator_tb_architecture;

 