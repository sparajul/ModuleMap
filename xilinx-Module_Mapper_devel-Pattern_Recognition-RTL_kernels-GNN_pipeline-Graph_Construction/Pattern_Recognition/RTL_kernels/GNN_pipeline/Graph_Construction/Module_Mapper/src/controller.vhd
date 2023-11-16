----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Create Date: 01/31/2022 01:38:55 PM
-- Design Name: Graph Constructor
-- Module Name: controller - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: Handles ping-pomg state control. 
-- 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--  Buffer  : 0   1   2
--  State 1 : W   R   I
--  State 2 : R   I   W
--  State 3 : I   W   R
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
entity controller is
    port ( 
        CLK                 : in  std_logic;
        RESET               : in  std_logic;
        READY               : out std_logic;

        RW_MODE             : out RWMode_t;
        R_INDEX             : out integer;
        I_INDEX             : out integer := 0;
        WBUF_EMPTY          : in std_logic_vector(NumHitBuffer-1 downto 0);
        RBUF_READY          : in std_logic_vector(NumHitBuffer-1 downto 0);
        IBUF_READY          : in std_logic_vector(NumHitBuffer-1 downto 0);
        FLAG_RESET          : out std_logic_vector(NumHitBuffer-1 downto 0);
        FLAG_RESET_DONE     : in std_logic_vector(NumHitBuffer-1 downto 0);

        EVENT_START         : in std_logic;
        EVENT_END           : in std_logic;

        W_START_CNTRL       : out std_logic;
        W_DONE_DCDR         : in std_logic;
        
        R_START_CNTRL       : out std_logic;
        R_DONE_OMGR         : in std_logic;

        I_START_CNTRL       : out std_logic;
        I_DONE_INFR         : in std_logic;

        DEBUG               : inout std_logic_vector(DebugWidth-1 downto 0)
    );
end controller;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture controller_arch of controller is

    -- Control Process
    signal write_nread : RWMode_t;

    -- State definitions for control process
    TYPE control_state_type is (
        s_buf0_writing,
        s_buf1_writing,
        s_buf2_writing
        );
    signal control_state : control_state_type;
    signal control_rtn_state : control_state_type;

    signal buf_data_flag : std_logic_vector(NumHitBuffer-1 downto 0);
    signal r_start_cntrl_int : std_logic;
   
begin

    -- Signal Mappings
    RW_MODE <= write_nread;
    R_START_CNTRL <= r_start_cntrl_int;
    DEBUG <= x"CCCC";
    
    ------------------------------
    -- Controller Process
    ------------------------------
    controller_process : process(CLK)
    begin
        if ( rising_edge(CLK) ) then
            if (RESET = '1') then
                -- Reset Mode: Buffer 0 Writting / Buffer 1 Reading/Constructing / Buffer 2 Reading/Inferencing
                write_nread(0) <= writing;
                write_nread(1) <= constructing;
                write_nread(2) <= inferencing;
                R_INDEX <= 1;
                I_INDEX <= 2;

                buf_data_flag <= (others => '0');
                W_START_CNTRL <= '0';
                r_start_cntrl_int <= '0'; 
                I_START_CNTRL <= '0'; 
                FLAG_RESET <= (others => '0');
                READY <= '1'; 
                control_state <= s_buf0_writing;
            else
                -- Data pipeline

                --Default Assignments
               
                case(control_state) is

                    ----------------------------------------------------------------------------------------
                    -- Buf 0 Writting
                    ----------------------------------------------------------------------------------------
                    when s_buf0_writing =>
                        write_nread(0) <= writing;
                        write_nread(1) <= constructing;
                        write_nread(2) <= inferencing;
                        R_INDEX <= 1;
                        I_INDEX <= 2;

                        ------------------
                        -- Buf 0 Writing
                        ------------------
                        if (WBUF_EMPTY(0) = '1') then 
                            -- Hit buffer 0 is avavilbe for writing     
                            W_START_CNTRL <= '1';
                        else 
                            W_START_CNTRL <= '0';
                        end if;

                        if (W_DONE_DCDR= '1') then                            
                            -- Decoder is done writing data set buf 0 flag as full
                            buf_data_flag(0) <= '1';  
                            W_START_CNTRL <= '0';   
                        end if;

                        ------------------
                        -- Buf 1 Reading / Constructing
                        ------------------
                        if (RBUF_READY(1)= '1') then 
                            -- Hit buffer 1 is avavilbe for reading/constructing     
                            r_start_cntrl_int <= '1';     
                        else   
                            r_start_cntrl_int <= '0';
                        end if;

                        if (R_DONE_OMGR = '1') then
                            -- Output manager done reading 
                            r_start_cntrl_int <= '0';
                        end if;

                        ------------------
                        -- Buf 2 Reading / Inferencing
                        ------------------
                        if (IBUF_READY(2)= '1') then 
                            -- Hit buffer 2 is avavilbe for reading/inferencing     
                            I_START_CNTRL <= '1';     
                        else   
                            I_START_CNTRL <= '0';
                        end if;

                        if (I_DONE_INFR = '1') then
                            -- Inferencing stage done reading so reset hit buffer 2 write flags
                            FLAG_RESET(2) <= '1';
                            I_START_CNTRL <= '0';
                        end if;

                        if(FLAG_RESET_DONE(2) = '1') then
                            -- Hit buffer 2 is done reseting write flags set buf 2 flag as clear
                            buf_data_flag(2) <= '0';
                            FLAG_RESET(2) <= '0';
                        end if; 

                        ------------------
                        -- State Control
                        ------------------
                        if(buf_data_flag(0) = '1' and buf_data_flag(2) = '0' ) then
                            --Buffer 0 has data ready to read and Buffer 2 inferencing is complete and its flags reset
                            control_state <= s_buf2_writing;
                        else
                            control_state <= s_buf0_writing;
                        end if; 

                    ----------------------------------------------------------------------------------------
                    -- Buf 2 Writting
                    ----------------------------------------------------------------------------------------
                    when s_buf2_writing =>
                        write_nread(0) <= constructing;
                        write_nread(1) <= inferencing;
                        write_nread(2) <= writing;
                        R_INDEX <= 0;
                        I_INDEX <= 1;

                        ------------------
                        -- Buf 0 Reading / Constructing
                        ------------------
                        if (RBUF_READY(0)= '1') then 
                            -- Hit buffer 0 is avavilbe for reading/constructing     
                            r_start_cntrl_int <= '1';     
                        --else   
                        --    r_start_cntrl_int <= '0';
                        end if;

                        if (R_DONE_OMGR = '1') then
                            -- Output manager done reading 
                            r_start_cntrl_int <= '0';
                        end if;

                        ------------------
                        -- Buf 1 Reading / Inferencing
                        ------------------
                        if (IBUF_READY(1)= '1') then 
                            -- Hit buffer 1 is avavilbe for reading/inferencing     
                            I_START_CNTRL <= '1';     
                        else   
                            I_START_CNTRL <= '0';
                        end if;

                        if (I_DONE_INFR = '1') then
                            -- Inferencing stage done reading so reset hit buffer 1 write flags
                            FLAG_RESET(1) <= '1';
                            I_START_CNTRL <= '0';
                        end if;

                        if(FLAG_RESET_DONE(1) = '1') then
                            -- Hit buffer 1 is done reseting write flags set buf 1 flag as clear
                            buf_data_flag(1) <= '0';
                            FLAG_RESET(1) <= '0';
                        end if; 

                        ------------------
                        -- Buf 2 Writing
                        ------------------
                        if (WBUF_EMPTY(2) = '1') then 
                            -- Hit buffer 2 is avavilbe for writing     
                            W_START_CNTRL <= '1';
                        else 
                            W_START_CNTRL <= '0';
                        end if;

                        if (W_DONE_DCDR= '1') then                            
                            -- Decoder is done writing data set buf 2 flag as full
                            buf_data_flag(2) <= '1';  
                            W_START_CNTRL <= '0';   
                        end if;

                        ------------------
                        -- State Control
                        ------------------
                        if(buf_data_flag(2) = '1' and buf_data_flag(1) = '0' and r_start_cntrl_int = '0') then
                            --Buffer 2 has data ready to read
                            --Buffer 1 inferencing is complete and its flags reset
                            --Buffer 0 read/construction is complete
                            control_state <= s_buf1_writing;
                        else
                            control_state <= s_buf2_writing;
                        end if; 

                    ----------------------------------------------------------------------------------------
                    -- Buf 1 Writting
                    ----------------------------------------------------------------------------------------
                    when s_buf1_writing =>
                        write_nread(0) <= inferencing;
                        write_nread(1) <= writing;
                        write_nread(2) <= constructing;
                        R_INDEX <= 2;
                        I_INDEX <= 0;

                        ------------------
                        -- Buf 0 Reading / Inferencing
                        ------------------
                        if (IBUF_READY(0)= '1') then 
                            -- Hit buffer 0 is avavilbe for reading/inferencing     
                            I_START_CNTRL <= '1';     
                        else   
                            I_START_CNTRL <= '0';
                        end if;

                        if (I_DONE_INFR = '1') then
                            -- Inferencing stage done reading so reset hit buffer 0 write flags
                            FLAG_RESET(0) <= '1';
                            I_START_CNTRL <= '0';
                        end if;

                        if(FLAG_RESET_DONE(0) = '1') then
                            -- Hit buffer 0 is done reseting write flags set buf 0 flag as clear
                            buf_data_flag(0) <= '0';
                            FLAG_RESET(0) <= '0';
                        end if; 

                        ------------------
                        -- Buf 1 Writing
                        ------------------
                        if (WBUF_EMPTY(1) = '1') then 
                            -- Hit buffer 1 is avavilbe for writing     
                            W_START_CNTRL <= '1';
                        else 
                            W_START_CNTRL <= '0';
                        end if;

                        if (W_DONE_DCDR= '1') then                            
                            -- Decoder is done writing data set buf 1 flag as full
                            buf_data_flag(1) <= '1';  
                            W_START_CNTRL <= '0';   
                        end if;

                        ------------------
                        -- Buf 2 Reading / Constructing
                        ------------------
                        if (RBUF_READY(2)= '1') then 
                            -- Hit buffer 2 is avavilbe for reading/constructing     
                            r_start_cntrl_int <= '1';     
                        else   
                            r_start_cntrl_int <= '0';
                        end if;

                        if (R_DONE_OMGR = '1') then
                            -- Output manager done reading 
                            r_start_cntrl_int <= '0';
                        end if;


                        ------------------
                        -- State Control
                        ------------------
                        if(buf_data_flag(1) = '1' and buf_data_flag(0) = '0' ) then
                            --Buffer 1 has data ready to read and Buffer 0 inferencing is complete and its flags reset
                            control_state <= s_buf0_writing;
                        else
                            control_state <= s_buf1_writing;
                        end if; 

                    
                    when others =>
                        control_state <= s_buf0_writing;

                end case;
            end if;
        end if;
    end process controller_process;

     

end controller_arch;
