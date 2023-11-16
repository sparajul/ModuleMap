----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Create Date: 01/31/2022 01:38:55 PM
-- Design Name: Edge Calculator Testbench
-- Module Name: edge_calc_tb - Behavioral
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
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_MISC.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.all;

library work;
use work.graph_constructor_package.all;

----------------------------------------------------------------------------------
-- Entity
----------------------------------------------------------------------------------
entity edge_calc_tb is
    GENERIC(
      -- Testbench Parameters
      DEBUG_ON		: boolean := false		-- Enable for debug messages
      );
end edge_calc_tb;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture edge_calc_tb_architecture of edge_calc_tb is
    -- Signal Nameing Convention - <signal-name>_<source>

    -- General Clocks and Resets
    signal clk                 : std_logic := '0';  --50M
    signal reset               : std_logic := '0';
    signal ready               : std_logic;
    signal wr_en      : std_logic;

    -- Data from output manager
    signal module_data_out     : std_logic_vector(ModuleDataOutputWidth-1 downto 0);
    signal module_data_addr    : std_logic_vector(RawAddrWidth-1 downto 0);
    signal module_data_info    : std_logic_vector(ModuleDataInfoWidth-1 downto 0);
    signal module_data_we      : std_logic;

    -- File Reader
    signal data_in             : std_logic_vector(DataInputWidth-1 downto 0);
    signal data_addr           : std_logic_vector(RawAddrWidth-1 downto 0);
    signal data_info           : std_logic_vector(ModuleDataInfoWidth-1 downto 0);
    signal data_info_reg       : std_logic_vector(ModuleDataInfoWidth-1 downto 0);
    signal valid_data_in       : std_logic;
    signal meta_data_flag      : std_logic;
    signal wait_count          : std_logic_vector(3 downto 0);

    -- Data from edge calc
    signal edge_data_ready     : std_logic := '0';
    signal edge_data_count     : std_logic_vector(EdgeParamAddrWidth-1 downto 0);
    signal edge_data_out       : std_logic_vector(ModuleDataOutputWidth-1 downto 0);
    signal adj_id_out          : std_logic_vector(RawAddrWidth*2-1 downto 0);
    signal edge_re             : std_logic := '0';

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

    component edge_calc is
        port ( 
            CLK                 : in  std_logic;
            RESET               : in  std_logic;
            READY               : out std_logic;

            WREN                : in std_logic;

            MODULE_DATA_OUT     : in std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            MODULE_DATA_ADDR    : in std_logic_vector(RawAddrWidth-1 downto 0);
            MODULE_DATA_INFO    : in std_logic_vector(ModuleDataInfoWidth-1 downto 0);
            MODULE_DATA_WE      : in std_logic;

            EDGE_DATA_READY     : out std_logic;
            EDGE_DATA_COUNT     : out std_logic_vector(EdgeParamAddrWidth-1 downto 0);
            EDGE_DATA_OUT       : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            ADJ_ID_OUT          : out std_logic_vector(RawAddrWidth*2-1 downto 0);
            EDGE_RE             : in  std_logic
        );
    end component;

begin

    -- Mapping from file reader
    module_data_we <= valid_data_in;
    module_data_out <= data_in;
    module_data_addr <= data_addr;
    module_data_info <= data_info;

    -- Array to capture edge calculator output
   
    ec_output_array(0) <= x"0000_0000_0000_000" & "000" & edge_data_ready;
    ec_output_array(1) <= x"0000_0000_000" & "00" & edge_data_count;
    ec_output_array(2) <= edge_data_out;
    ec_output_array(3) <= x"0000_0000" & adj_id_out;


    ----------------------------------------
    -- Unit Under Test: Graph Constructor
    ----------------------------------------
    UUT : edge_calc
        PORT MAP(
            CLK                 => clk,
            RESET               => reset,
            READY               => ready,

            WREN      => wr_en,

            MODULE_DATA_OUT     => module_data_out,
            MODULE_DATA_ADDR    => module_data_addr,
            MODULE_DATA_INFO    => module_data_info,
            MODULE_DATA_WE      => module_data_we,
            
            EDGE_DATA_READY     => edge_data_ready,
            EDGE_DATA_COUNT     => edge_data_count,
            EDGE_DATA_OUT       => edge_data_out,
            ADJ_ID_OUT          => adj_id_out,
            EDGE_RE             => edge_re
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
    -- Read Enable Process
    ----------------------------------------
    edge_rd_process : process(CLK)
    begin
        if ( rising_edge(CLK) ) then
            if (edge_data_ready = '1') then
                edge_re <= '1';
            else
                edge_re <= '0';
            end if;
        end if;
    end process edge_rd_process;

    -------------------------------------------------------
    -- File Reader Process for Edge Calculator Input Data
    -------------------------------------------------------
    file_reader_process : process(clk)

        file data_input_file	   : text open read_mode is "./data/edge_calc_data.txt";
        variable file_line         : line;
        variable data_line         : line;
        variable input_data_word   : std_logic_vector(SimDataInputWidth-1 downto 0);
        variable input_addr_word   : std_logic_vector(SimDataInputWidth-1 downto 0);
        variable read_count        : integer := 0;

        variable msg_line          : line;
        
    
    begin

        if ( rising_edge(clk) ) then
            if (reset ='1') then
                read_count := 0;
                data_in <= (others => '0');
                data_addr <= (others => '0');
                data_info <= (others => '0');
                data_info_reg <= (others => '0');
                input_data_word := (others => '0');
                input_addr_word := (others => '0');
                wait_count <= (others => '0');
                valid_data_in <= '0';
                wr_en  <= '0';
                meta_data_flag <= '0';
                fr_state <= s_idle;
            else

                case (fr_state) is
                    when s_idle =>
                        report "---- Reading Edge Calc Data Input File ----";
                        valid_data_in <= '0';
                        if (ready = '1') then
                            fr_state <= s_read_1;
                        else
                            fr_state <= s_idle;
                        end if;

                    when s_read_1 =>
                        --if (ready = '1') then
                            --If the constructor is ready to received data
                            if(not endfile(data_input_file)) then  
                                --Read lines of data until the end of the file
                                readline(data_input_file, file_line);
                                read_count := read_count + 1;
                                
                                -- Parse lines for event boundries
                                if(file_line'length = 0) then
                                    write(msg_line, STRING'("----- Skip Blank Line"));
                                    valid_data_in <= '0';
                                    data_info <= (others => '0');
                                    writeline(output, msg_line);
                                    fr_state <= s_read_1;
                                elsif(file_line(1 to 4) = "ABCD") then
                                    write(msg_line, STRING'("----- Out Module Group Start : "));
                                    write(msg_line, file_line(14 to 17));
                                    valid_data_in <= '0';
                                    wr_en  <= '1';  
                                    writeline(output, msg_line);
                                    fr_state <= s_read_1;  
                                elsif(file_line(1 to 4) = "FFFF") then
                                    write(msg_line, STRING'("----- Module Group End : "));
                                    write(msg_line, file_line(14 to 17));  
                                    valid_data_in <= '0';
                                    wr_en  <= '0';
                                    writeline(output, msg_line);
                                    fr_state <= s_read_1;
                                elsif(file_line(1 to 2) = "EF") then
                                    write(msg_line, STRING'("----- Module Info : "));
                                    write(msg_line, file_line(14 to 17));  
                                    hread(file_line, input_data_word);
                                    data_info_reg <= input_data_word(ModuleDataInfoWidth-1 downto 0);
                                    writeline(output, msg_line);
                                    fr_state <= s_read_1;
                                elsif(file_line(1 to 4) = "EEEE") then
                                    hread(file_line, input_data_word);
                                    wait_count <= input_data_word(3 downto 0);
                                    data_info <= (others => '0');
                                    valid_data_in <= '0';
                                    fr_state <= s_wait_0;
                                    fr_rtn_state <= s_read_1;
                                else
                                    -- Feed sim data to top level module
                                    
                                    -- Data Word
                                    hread(file_line, input_data_word);
                                    data_in <= input_data_word(DataInputWidth-1 downto 0);
                                    
                                    -- Addr Word
                                    hread(file_line, input_addr_word);
                                    data_addr <= input_addr_word(RawAddrWidth-1 downto 0);
                                    
                                    -- Info Word 
                                    data_info <= data_info_reg;
                                    meta_data_flag <= input_data_word(DataInputWidth);
                                    valid_data_in <= '1';
                                    wr_en <= '1';
                                    
                                    write(msg_line, STRING'("----- Data : "));
                                    write(msg_line, to_hex(input_data_word));
                                    write(msg_line, LF);
                                    write(msg_line, STRING'("----- Addr : "));
                                    write(msg_line, to_hex(input_addr_word));

                                    writeline(output, msg_line);
                                    fr_state <= s_read_1;

                                end if;
                               

                            else
                                write(msg_line, STRING'("---- File Lines Read : "));
                                write(msg_line, read_count);
                                writeline(output, msg_line);
                                valid_data_in <= '0';
                                fr_state <= s_done;
                            end if;
                        --else
                        --    fr_state <= s_read_1;
                        --end if;

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
    -- File Writter Process for Edge Calculator Output Data
    -------------------------------------------------------
    file_writer_process : process(clk)

        file ec_output_file	     : text open write_mode is "./data/ec_out.txt";
        variable file_line       : line;
        variable write_count   : integer := 0;
        variable msg_line       : line;

    begin

        if ( rising_edge(clk) ) then
            if (reset ='1') then
                write_count := 0;
                fw_wait_count <= 0;
                fw_state <= s_idle;
            else
                --Default signal states

                case (fw_state) is
                    when s_idle =>
                        if (edge_re = '1') then
                            report "---- Writting Edge Calc Data ------------";
                            fw_wait_count <= 0;
                            fw_state <= s_wait_0;
                            fw_rtn_state <= s_write_0;
                        else
                            fw_state <= s_idle;
                        end if;

                    when s_write_0 =>
                        if (edge_re = '1')  then
                            -- Write array to files
                            for i in 0 to 3 loop
                                hwrite(file_line,ec_output_array(i), right, 17);
                            end loop;
                            writeline(ec_output_file, file_line);
                            write_count := write_count + 1;
                            fw_state <= s_write_0;
                        else
                            fw_state <= s_done;
                        end if;

                    when s_wait_0 =>
                        if (fw_wait_count = 0) then
                            fw_state <= fw_rtn_state;
                        else
                            fw_wait_count <= fw_wait_count - 1; 
                            fw_state <= s_wait_0;
                        end if;

                    when s_done =>
                        write(msg_line, STRING'("---- Number of ec outputs to file: "));
                        write(msg_line, write_count);
                        writeline(output, msg_line);  
                        fw_state <= s_idle; 

                    when others =>
                        fw_state <= s_idle;
                        
                end case;
            end if;
        end if;

    end process file_writer_process;
    ----------------------------------------------------------------------------------------

end edge_calc_tb_architecture;

  