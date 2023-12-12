----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Design Name: Edge Calculator
-- Module Name: edge_calc - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: Compute edge features of all hits between a single output module and 
-- modules it is an input too.
-- 
-- 
-- Dependencies: 
-- 
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
use ieee.float_pkg.all;
use STD.TEXTIO.all;

library work;
use work.graph_constructor_package.all;

----------------------------------------------------------------------------------
-- Entity
----------------------------------------------------------------------------------
entity edge_calc is
    port ( 
        CLK                 : in  std_logic;
        RESET               : in  std_logic;
        READY               : out std_logic;

        WREN                : in std_logic;
        LAST                : in std_logic;

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
end edge_calc;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture edge_calc_arch of edge_calc is

    -- State definitions for edge calc process
    TYPE ec_state_type is (
        ec_idle,
        ec_input_0,
        ec_pipeline_0,
        ec_output_0,
        ec_wait_0,
        ec_done);
    signal ec_state : ec_state_type;
    signal ec_rtn_state : ec_state_type;
    signal wait_count   :   integer;

    signal start_ec     :  std_logic;
    signal done_ecin    :  std_logic;
    signal done_ecpipe    :  std_logic;
    signal done_ecout    :  std_logic;

    signal ready_ecin    :  std_logic;
    signal ready_ecpl    :  std_logic;
    signal ready_ecout    :  std_logic;
    
    signal module_info_addr_ecpl    : std_logic_vector(ModInfoAddrWidth-1 downto 0); 
    signal module_info_ecin         : std_logic_vector(ModInfoWidth-1 downto 0); 
    signal output_hit_addr_ecpl     : std_logic_vector(OutHitAddrWidth-1 downto 0);
    signal output_hit_ecin          : std_logic_vector(ModuleDataOutputWidth-1 downto 0);
    signal output_id_ecin           : std_logic_vector(RawAddrWidth-1 downto 0);
    signal input_hit_addr_ecpl      : std_logic_vector(InHitAddrWidth-1 downto 0);
    signal input_hit_ecin           : std_logic_vector(ModuleDataOutputWidth-1 downto 0);
    signal input_id_ecin            : std_logic_vector(RawAddrWidth-1 downto 0);

    signal edge_data_ecpl           : std_logic_vector(ModuleDataOutputWidth-1 downto 0);
    signal adj_id_ecpl              : std_logic_vector(RawAddrWidth*2-1 downto 0);
    signal edge_we_ecpl             : std_logic;



    component ec_input
        port ( 
            CLK                 : in  std_logic;
            RESET               : in  std_logic;
            READY               : out std_logic;

            MODULE_DATA_OUT     : in std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            MODULE_DATA_ADDR    : in std_logic_vector(RawAddrWidth-1 downto 0);
            MODULE_DATA_INFO    : in std_logic_vector(ModuleDataInfoWidth-1 downto 0);
            MODULE_DATA_WE      : in std_logic;
    
            START               : in std_logic;
            DONE                : out std_logic;

            LAST                : in std_logic;
    
            MODULE_INFO_ADDR    : in std_logic_vector(ModInfoAddrWidth-1 downto 0); 
            MODULE_INFO         : out std_logic_vector(ModInfoWidth-1 downto 0); 
            OUTPUT_HIT_ADDR     : in std_logic_vector(OutHitAddrWidth-1 downto 0);
            OUTPUT_HIT          : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            OUTPUT_ID           : out std_logic_vector(RawAddrWidth-1 downto 0);
            INPUT_HIT_ADDR      : in std_logic_vector(InHitAddrWidth-1 downto 0);
            INPUT_HIT           : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            INPUT_ID            : out std_logic_vector(RawAddrWidth-1 downto 0)
        );
    end component ec_input;

    component ec_pipeline
        port ( 
            CLK                 : in  std_logic;
            RESET               : in  std_logic;
            READY               : out std_logic;
    
            START               : in std_logic;
            DONE                : out std_logic;
    
            MODULE_INFO_ADDR    : out std_logic_vector(ModInfoAddrWidth-1 downto 0); 
            MODULE_INFO         : in std_logic_vector(ModInfoWidth-1 downto 0); 
            OUTPUT_HIT_ADDR     : out std_logic_vector(OutHitAddrWidth-1 downto 0);
            OUTPUT_HIT          : in std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            OUTPUT_ID           : in std_logic_vector(RawAddrWidth-1 downto 0);
            INPUT_HIT_ADDR      : out std_logic_vector(InHitAddrWidth-1 downto 0);
            INPUT_HIT           : in std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            INPUT_ID            : in std_logic_vector(RawAddrWidth-1 downto 0);

            EDGE_DATA_OUT       : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            ADJ_ID_OUT          : out std_logic_vector(RawAddrWidth*2-1 downto 0);
            EDGE_WE             : out std_logic
        );
    end component ec_pipeline;

    component ec_output
        port ( 
            CLK                 : in  std_logic;
            RESET               : in  std_logic;
            READY               : out std_logic;
    
            START               : in std_logic;
            DONE                : out std_logic;
    
            -- Pipeline Interface
            EDGE_DATA_IN        : in std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            ADJ_ID_IN           : in std_logic_vector(RawAddrWidth*2-1 downto 0);
            EDGE_WE             : in std_logic;
    
            -- Edge Calc Output
            EDGE_DATA_READY     : out std_logic;
            EDGE_DATA_COUNT     : out std_logic_vector(EdgeParamAddrWidth-1 downto 0);
            EDGE_DATA_OUT       : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            ADJ_ID_OUT          : out std_logic_vector(RawAddrWidth*2-1 downto 0);
            EDGE_RE             : in  std_logic
        );
    end component ec_output;

begin

    --Signal Mapping

    input_0 : ec_input
    port map( 
        CLK                 => CLK,
        RESET               => RESET,
        READY               => ready_ecin,

        MODULE_DATA_OUT     => MODULE_DATA_OUT,
        MODULE_DATA_ADDR    => MODULE_DATA_ADDR,
        MODULE_DATA_INFO    => MODULE_DATA_INFO,
        MODULE_DATA_WE      => MODULE_DATA_WE,

        START               => start_ec,
        DONE                => done_ecin, 

        LAST                => LAST,

        MODULE_INFO_ADDR    => module_info_addr_ecpl,
        MODULE_INFO         => module_info_ecin,
        OUTPUT_HIT_ADDR     => output_hit_addr_ecpl,
        OUTPUT_HIT          => output_hit_ecin,
        OUTPUT_ID           => output_id_ecin,
        INPUT_HIT_ADDR      => input_hit_addr_ecpl,
        INPUT_HIT           => input_hit_ecin,
        INPUT_ID            => input_id_ecin
    );

    pipeline_0 : ec_pipeline
    port map( 
        CLK                 => CLK,
        RESET               => RESET,
        READY               => ready_ecpl,

        START               => done_ecin,
        DONE                => done_ecpipe, 

        MODULE_INFO_ADDR    => module_info_addr_ecpl,
        MODULE_INFO         => module_info_ecin,
        OUTPUT_HIT_ADDR     => output_hit_addr_ecpl,
        OUTPUT_HIT          => output_hit_ecin,
        OUTPUT_ID           => output_id_ecin,
        INPUT_HIT_ADDR      => input_hit_addr_ecpl,
        INPUT_HIT           => input_hit_ecin,
        INPUT_ID            => input_id_ecin,

        EDGE_DATA_OUT       => edge_data_ecpl,
        ADJ_ID_OUT          => adj_id_ecpl,
        EDGE_WE             => edge_we_ecpl
    );

    output_0 : ec_output
    port map( 
        CLK                 => CLK,
        RESET               => RESET,
        READY               => ready_ecout,

        START               => done_ecpipe,
        DONE                => done_ecout, 
    
        EDGE_DATA_IN        => edge_data_ecpl,      
        ADJ_ID_IN           => adj_id_ecpl, 
        EDGE_WE             => edge_we_ecpl,
    
        EDGE_DATA_READY     => EDGE_DATA_READY,  
        EDGE_DATA_COUNT     => EDGE_DATA_COUNT,   
        EDGE_DATA_OUT       => EDGE_DATA_OUT,     
        ADJ_ID_OUT          => ADJ_ID_OUT,     
        EDGE_RE             => EDGE_RE       
    );


    ------------------------------
    -- Edge Calculator Control Process
    ------------------------------
    edge_calc_process : process(CLK)
    begin
        if ( rising_edge(CLK) ) then
            if (RESET = '1') then
                start_ec <= '0';
                wait_count <= 0;
                READY <= '1';
                ec_state <= ec_idle;
            else
                -- Data pipeline
                
                --Default Assignments
                start_ec <= '0';

                case(ec_state) is

                    when ec_idle =>
                        if (WREN = '1') then
                            start_ec <= '1';
                            READY <= '0';
                            ec_state <= ec_input_0; 
                        else 
                            ec_state <= ec_idle;
                        end if;
                    
                    when ec_input_0 =>
                        if (done_ecin = '1' and WREN = '0') then
                            -- Pipeline started
                            ec_state <= ec_pipeline_0; 
                        else 
                            ec_state <= ec_input_0;
                        end if;

                    when ec_pipeline_0 =>
                        if (done_ecpipe = '1') then
                            -- Output started
                            ec_state <= ec_output_0; 
                        else 
                            ec_state <= ec_pipeline_0;
                        end if;


                    when ec_output_0 =>
                        if (done_ecout = '1') then
                            -- Output Complete
                            ec_state <= ec_done; 
                        else 
                            ec_state <= ec_output_0;
                        end if;
                       
                    when ec_wait_0 =>
                        if (wait_count = 0) then
                            ec_state <= ec_rtn_state;
                        else
                            wait_count <= wait_count - 1; 
                            ec_state <= ec_wait_0;
                        end if;
                        
                    when ec_done =>
                        READY <= '1';
                        ec_state <= ec_idle;
                    
                    when others =>
                        ec_state <= ec_idle;

                end case;
            end if;
        end if;
    end process edge_calc_process;
                
end edge_calc_arch;
