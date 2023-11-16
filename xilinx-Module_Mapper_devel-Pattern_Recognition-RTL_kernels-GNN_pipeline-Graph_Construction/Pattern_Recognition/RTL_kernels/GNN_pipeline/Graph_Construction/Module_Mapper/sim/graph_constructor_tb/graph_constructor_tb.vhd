----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Create Date: 01/31/2022 01:38:55 PM
-- Design Name: Graph Constructor Testbench
-- Module Name: graph_constructor_tb - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: Testbench for graph construction using module maps.
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
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.all;

library work;
use work.graph_constructor_package.all;

----------------------------------------------------------------------------------
-- Entity
----------------------------------------------------------------------------------
entity graph_constructor_tb is
    GENERIC(
      -- Testbench Parameters
      DEBUG_ON		: boolean := false		-- Enable for debug messages
      );
end graph_constructor_tb;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture graph_constructor_tb_architecture of graph_constructor_tb is

    -- General Clocks and Resets
    signal clk                 : std_logic := '0';  --50M
    signal reset               : std_logic := '0';
    signal ready               : std_logic;

    -- Data
    signal data_in             : std_logic_vector(DataInputWidth-1 downto 0);
    signal valid_data_in       : std_logic;
    signal meta_data_flag      : std_logic;

    signal inference_data      : std_logic_vector(DataOutputWidth-1 downto 0);
    signal inference_addr      : std_logic_vector(RawAddrWidth-1 downto 0);
    signal inference_start     : std_logic;
    signal inference_done      : std_logic;

    signal edge_data_out       : std_logic_vector(ModuleDataOutputWidth-1 downto 0);
    signal adj_id_out          : std_logic_vector(RawAddrWidth*2-1 downto 0);

    signal debug               : std_logic_vector(DebugWidth-1 downto 0);

    -- State definitions for file reader process
    TYPE fr_state_type is (
        s_idle,
        s_read_1,
        s_done);
    signal fr_state : fr_state_type;

     -- State definitions for read process
    TYPE inf_state_type is (
        inf_idle,
        inf_read_0,
        inf_read_1,
        inf_done,
        inf_wait);
    signal inf_state : inf_state_type;
    signal inf_rtn_state : inf_state_type;
    signal inf_addr_count : integer;
    signal inf_wait_count : integer;

    -- Utility function to convert unsigned to hexadecimal string
    function to_hex (SLV : std_logic_vector) return string is
        variable L : LINE;
      begin
        hwrite(L,SLV);
        return L.all;
      end function to_hex;

    component graph_constructor_top is
        port ( 
            CLK                 : in  std_logic;
            RESET               : in  std_logic;
            READY               : out std_logic;

            DATA_IN             : in std_logic_vector(DataInputWidth-1 downto 0);
            VALID_DATA_IN       : in  std_logic;
            META_DATA_FLAG      : in  std_logic;

            INFERENCE_DATA      : out std_logic_vector(DataInputWidth-1 downto 0);
            INFERENCE_ADDR      : in std_logic_vector(RawAddrWidth-1 downto 0);
            INFERENCE_START     : out std_logic;
            INFERENCE_DONE      : in std_logic;

            EDGE_DATA_OUT       : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            ADJ_ID_OUT          : out std_logic_vector(RawAddrWidth*2-1 downto 0)
        );
    end component;

begin

    ----------------------------------------
    -- Unit Under Test: Graph Constructor
    ----------------------------------------
    UUT : graph_constructor_top
        PORT MAP(
            CLK                 => clk,
            RESET               => reset,
            READY               => ready,

            DATA_IN             => data_in,
            VALID_DATA_IN       => valid_data_in,
            META_DATA_FLAG      => meta_data_flag, 

            INFERENCE_DATA      => inference_data,
            INFERENCE_ADDR      => inference_addr,
            INFERENCE_START     => inference_start,
            INFERENCE_DONE      => inference_done,

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

    ----------------------------------------
    -- File Reader Process for Input Data
    ----------------------------------------
    file_reader_process : process(clk)

    --C:/work/neubauer-group/EFTracking-Xilinx/Pattern_Recognition/RTL_kernels/GNN_pipeline/Graph_Construction/Module_Mapper/sim/graph_constructor_tb/data
        file data_input_file	   : text open read_mode is "./data/multiple_event_data.txt";
        variable file_line         : line;
        variable input_data_word   : std_logic_vector(SimDataInputWidth-1 downto 0);
        variable read_count        : integer := 0;

        variable msg_line          : line;
        
    
    begin

        if ( rising_edge(clk) ) then
            if (reset ='1') then
                read_count := 0;
                data_in <= (others => '0');
                input_data_word := (others => '0');
                valid_data_in <= '0';
                meta_data_flag <= '0';
                fr_state <= s_idle;
            else

                case (fr_state) is
                    when s_idle =>
                        report "---- Reading Data Input File ----";
                        valid_data_in <= '0';
                        fr_state <= s_read_1;	

                    when s_read_1 =>
                        if (ready = '1') then
                            --If the constructor is ready to received data
                            if(not endfile(data_input_file)) then  
                                --Read lines of data until the end of the file
                                readline(data_input_file, file_line);
                                read_count := read_count + 1;
                                
                                -- Parse lines for event boundries
                                if(file_line'length = 0) then
                                    write(msg_line, STRING'("----- Skip Blank Line"));
                                    valid_data_in <= '0';
                                elsif(file_line(1 to 4) = "ABCD") then
                                    write(msg_line, STRING'("----- Event Start : "));
                                    write(msg_line, file_line(14 to 17));
                                    valid_data_in <= '0';    
                                elsif(file_line(1 to 4) = "FFFF") then
                                    write(msg_line, STRING'("----- Event End : "));
                                    write(msg_line, file_line(14 to 17));  
                                    valid_data_in <= '0';
                                else
                                    -- Feed sim data to top level module
                                    hread(file_line, input_data_word);
                                    data_in <= input_data_word(DataInputWidth-1 downto 0);
                                    meta_data_flag <= input_data_word(DataInputWidth);
                                    valid_data_in <= '1';
                                    write(msg_line, STRING'("----- Data : "));
                                    write(msg_line, to_hex(input_data_word));
                                end if;

                                writeline(output, msg_line);
                                fr_state <= s_read_1;

                            else
                                write(msg_line, STRING'("---- File Lines Read : "));
                                write(msg_line, read_count);
                                writeline(output, msg_line);
                                valid_data_in <= '0';
                                fr_state <= s_done;
                            end if;
                        else
                            fr_state <= s_read_1;
                        end if;

                    when s_done =>
                        fr_state <= s_done;

                    when others =>
                        fr_state <= s_idle;
                        
                end case;
            end if;
        end if;

    end process file_reader_process;

    ----------------------------------------
    -- Dummy Inference Process 
    ----------------------------------------

    inference_addr <= std_logic_vector(to_unsigned(inf_addr_count,RawAddrWidth));

    dummy_inference_process : process(clk)
    begin

        if ( rising_edge(clk) ) then
            if (reset ='1') then
                inf_wait_count <= 0;
                inf_addr_count <= 0;
                inference_done <= '0';
                inf_state <= inf_idle;
            else
                inference_done <= '0';

                case (inf_state) is

                    when inf_idle =>
                        if (inference_start = '1') then
                            report "---- Start Inferencing ----";
                            inf_addr_count <= 16;
                            inf_state <= inf_read_0;
                        else
                            inf_state <= inf_idle;
                        end if;

                    when inf_read_0 =>
                        if (inf_addr_count = 0) then
                            inf_state <= inf_done;
                        else
                            inf_addr_count <= inf_addr_count - 1; 
                            inf_state <= inf_read_0;
                        end if;   
                    
                    when inf_wait =>
                        if (inf_wait_count = 0) then
                            inf_state <= inf_rtn_state;
                        else
                            inf_wait_count <= inf_wait_count - 1; 
                            inf_state <= inf_wait;
                        end if;

                    when inf_done =>
                        inference_done <= '1';
                        inf_state <= inf_idle;

                    when others =>
                        inf_state <= inf_idle;
                end case;
            end if;
        end if;
    end process dummy_inference_process;	




end graph_constructor_tb_architecture;

  