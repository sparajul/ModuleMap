----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Create Date: 01/31/2022 01:38:55 PM
-- Design Name: Graph Constructor
-- Module Name: decoder - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: Parses incoming data stream and writes to intermediate memories. 
-- 
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
entity decoder is
    port ( 
        CLK                 : in  std_logic;
        RESET               : in  std_logic;
        READY               : out std_logic;

        EVENT_START         : out std_logic;
        EVENT_END           : out std_logic;
        
        W_START_CNTRL       : in  std_logic;
        W_DONE_DCDR         : out std_logic;

        META_DATA_FLAG      : in  std_logic;
        EVENT_DATA          : out std_logic_vector(EventInputWidth-1 downto 0);
        EVENT_WE            : out std_logic;

        DATA_IN             : in  std_logic_vector(DataInputWidth-1 downto 0);
        VALID_DATA_IN       : in  std_logic;

        RAW_DATA            : out std_logic_vector(DataInputWidth-1 downto 0);
        RAW_ADDR            : out std_logic_vector(RawAddrWidth-1 downto 0);
        RAW_WE              : out std_logic;

        DEBUG               : inout std_logic_vector(DebugWidth-1 downto 0)
    );
end decoder;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture decoder_arch of decoder is

    --Input Flag
    signal mw_flag_in      : std_logic;

    -- Module Word
    signal layer_id        : std_logic_vector(MWLayerIDWidth-1 downto 0);
    signal module_id       : std_logic_vector(MWModuleIDWidth-1 downto 0);
    signal module_word_raw_addr : std_logic_vector(RawAddrWidth-1 downto 0);
    
    -- Hit Word
    signal r_coordinate    : std_logic_vector(HWRCoordWidth-1 downto 0);
    signal phi_coordinate  : std_logic_vector(HWPhiCoordWidth-1 downto 0);
    signal z_coordinate    : std_logic_vector(HWZCoordWidth-1 downto 0);

    signal raw_addr_count  : std_logic_vector(RawAddrWidth-1 downto 0);
    signal raw_write       : std_logic;

    --Event
    signal event_word_count : std_logic_vector(3 downto 0);
    signal event_write      : std_logic;

    -- State definitions for decode process
    TYPE decode_state_type is (
        s_idle,
        s_raw_write_0,
        s_event_header_0,
        s_event_footer_0,
        s_wait_0,
        s_error_0, 
        s_done);
    signal decode_state : decode_state_type;
    signal decode_rtn_state : decode_state_type;

    -- Events

begin

    -- Signal Mappings
    RAW_ADDR <= raw_addr_count;
    RAW_WE <= raw_write;
    EVENT_WE <= event_write;
    DEBUG <= x"BBBB";
    
    -- Input Parsing
    mw_flag_in <= DATA_IN(MWInFlag);
    layer_id <= DATA_IN(MWLayerIDMSB downto MWLayerIDLSB);
    module_id <= DATA_IN(MWModuleIDMSB downto MWModuleIDLSB);
    r_coordinate <= DATA_IN(HWRCoordMSB downto HWRCoordLSB);
    phi_coordinate <= DATA_IN(HWPhiCoordMSB downto HWPhiCoordLSB);
    z_coordinate <= DATA_IN(HWZCoordMSB downto HWZCoordLSB);


    ------------------------------
    -- Raw Data Parsing Process
    ------------------------------
    decode_process : process(CLK)
    begin
        if ( rising_edge(CLK) ) then
            if (RESET = '1') then
                EVENT_START <= '0';
                EVENT_END <= '0';
                EVENT_DATA <= (others => '0');
                RAW_DATA <= (others => '0');
                W_DONE_DCDR <= '0';
                READY <= '1';
                raw_addr_count <= (others => '0');
                raw_write <= '0';
                event_word_count <= (others => '0');
                event_write <= '0';
                
                module_word_raw_addr <= (others => '0'); 
                decode_state <= s_idle;
            else

                --Default Assignments
                EVENT_START <= '0';
                EVENT_END <= '0';
                W_DONE_DCDR <= '0';
                
                case(decode_state) is

                    when s_idle =>
                        if(W_START_CNTRL = '1') then
                            READY <= '1';
                        end if;
                        
                        if (META_DATA_FLAG = '1') then
                            -- Event Header Encountered
                            if(W_START_CNTRL = '1') then
                                EVENT_DATA <= DATA_IN;
                                event_write <= '1';
                                event_word_count <= event_word_count + 1;
                                -- Event Write Started / Decoder Busy
                                EVENT_START <= '1';
                                W_DONE_DCDR <= '0';
                                decode_state <= s_event_header_0;
                            else
                                decode_state <= s_error_0;
                            end if;
                        else
                            decode_state <= s_idle;
                        end if;

                    when s_event_header_0 =>
                        if (event_word_count < EventHeaderLength) then
                            EVENT_DATA <= DATA_IN;
                            event_write <= '1';
                            event_word_count <= event_word_count + 1;
                            decode_state <= s_event_header_0;
                        else
                            EVENT_DATA <= (others => '0');
                            event_write <= '0';
                            event_word_count <= (others => '0');

                            RAW_DATA <= ModuleWordOut & layer_id & x"000000000" & module_id;
                            raw_addr_count <= raw_addr_count + 1;
                            raw_write <= '1';

                            --Catch Empty Event
                            if(DATA_IN(DataOutputWidth-1 downto DataOutputWidth-EventFlagLength) =  EventFooterFlag) then
                                EVENT_DATA <= DATA_IN;
                                event_write <= '1';
                                event_word_count <= "0001";
                                RAW_DATA <= (others => '0');
                                raw_write <= '0';
                                EVENT_END <= '1';
                                decode_state <= s_event_footer_0;
                            else
                                decode_state <= s_raw_write_0;
                            end if;

                        end if;

                    when s_raw_write_0 =>
                        if (META_DATA_FLAG = '1') then
                            --Event Footer Encountered
                            EVENT_DATA <= DATA_IN;
                            event_write <= '1';
                            event_word_count <= event_word_count + 1;
                            RAW_DATA <= (others => '0');
                            raw_write <= '0';
                            EVENT_END <= '1';
                            decode_state <= s_event_footer_0;

                        elsif (mw_flag_in = ModuleWordIn) then
                            RAW_DATA <= ModuleWordOut & layer_id & x"000000000" & module_id;
                            raw_addr_count <= raw_addr_count + 1;
                            raw_write <= '1';
                            module_word_raw_addr <= raw_addr_count;
                            decode_state <= s_raw_write_0;

                        elsif (mw_flag_in = HitWordIn) then
                            RAW_DATA <= HitWordOut & x"000" & r_coordinate & phi_coordinate & z_coordinate;
                            raw_addr_count <= raw_addr_count + 1;
                            raw_write <= '1';
                            decode_state <= s_raw_write_0;
                        else 
                            RAW_DATA <= (others => '0');
                            raw_write <= '0';
                            decode_state <= s_raw_write_0;
                        end if;

                    when s_event_footer_0 =>
                        if (event_word_count < EventFooterLength) then
                            EVENT_DATA <= DATA_IN;
                            event_write <= '1';
                            event_word_count <= event_word_count + 1;
                            decode_state <= s_event_footer_0;
                        else
                            EVENT_DATA <= (others => '0');
                            event_write <= '0';
                            event_word_count <= (others => '0');
                            -- Event Finished
                            W_DONE_DCDR <= '1';
                            READY <= '0';
                            raw_addr_count <= (others => '0');
                            decode_state <= s_idle;
                        end if;

                    when s_error_0 =>
                        -- Do some error handling here eventually
                        decode_state <= s_idle;

                    when others =>
                        decode_state <= s_idle;

                end case;
            end if;
        end if;
    end process decode_process;
                

end decoder_arch;
