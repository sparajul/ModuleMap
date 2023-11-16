----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Create Date: 01/31/2022 01:38:55 PM
-- Design Name: Graph Constructor
-- Module Name: graph_constructor_top - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: Top level for graph construction using module maps.
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.all;

library work;
use work.graph_constructor_package.all;

----------------------------------------------------------------------------------
-- Entity
----------------------------------------------------------------------------------
entity graph_constructor_top is
    port ( 
        CLK                 : in  std_logic;
        RESET               : in  std_logic;
        READY               : out std_logic;

        -- Serial Data Input Interface
        DATA_IN             : in std_logic_vector(DataInputWidth-1 downto 0);
        VALID_DATA_IN       : in  std_logic;
        META_DATA_FLAG      : in  std_logic;

        -- Inferencing Data Interface
        INFERENCE_DATA      : out std_logic_vector(DataInputWidth-1 downto 0);
        INFERENCE_ADDR      : in std_logic_vector(RawAddrWidth-1 downto 0);
        INFERENCE_START     : out std_logic;
        INFERENCE_DONE      : in std_logic;

        EDGE_DATA_OUT       : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
        ADJ_ID_OUT          : out std_logic_vector(RawAddrWidth*2-1 downto 0)
    );
end graph_constructor_top;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture graph_constructor_arch of graph_constructor_top is

    -- Clocks and Resets

    -- Control
    signal start                    : std_logic;
    signal done                     : std_logic;

    -- Debug Signlals
    signal debug_count              : std_logic_vector(DebugWidth-1 downto 0);

    -- Module Mapper Outputs
    signal edge_calc_wren_mmap      : std_logic_vector(NumEdgeCalc-1 downto 0);
    signal module_data_out_mmap     : std_logic_vector(ModuleDataOutputWidth-1 downto 0);
    signal module_data_addr_mmap    : std_logic_vector(RawAddrWidth-1 downto 0);
    signal module_data_we_mmap      : std_logic;
    signal module_data_info_mmap    : std_logic_vector(ModuleDataInfoWidth-1 downto 0);

    -- Edge Calculator Outputs 
    signal edge_calc_ready_eclc     : std_logic_vector(NumEdgeCalc-1 downto 0);
    signal edge_data_ready_eclc     : std_logic_vector(NumEdgeCalc-1 downto 0);
    signal edge_data_count_eclc     : EdgeDataCount_t;
    signal edge_data_out_eclc       : EdgeDataIn_t;
    signal adj_id_out_eclc          : AdjIDIn_t;

    -- Concatenator Output Data
    signal edge_re_cnct             : std_logic_vector(NumEdgeCalculators-1 downto 0);
    signal edge_data_out_cnct       : std_logic_vector(ModuleDataOutputWidth-1 downto 0);
    signal adj_id_out_cnct          : std_logic_vector(RawAddrWidth*2-1 downto 0);
    signal edge_data_ready_cnct     : std_logic;

    -- State definitions for graph constructor process
    TYPE gc_state_type is (
        gc_idle,
        gc_running_0,
        gc_wait_0,
        gc_done);
    signal gc_state : gc_state_type;
    signal gc_rtn_state : gc_state_type;
    signal wait_count   :   integer;

    -- Module Mapper Block
    component module_mapper is
        port (
            CLK                 : in  std_logic;
            RESET               : in  std_logic;
            READY               : out std_logic;
    
            DATA_IN             : in  std_logic_vector(DataInputWidth-1 downto 0);
            VALID_DATA_IN       : in  std_logic;
            META_DATA_FLAG      : in  std_logic;
    
            EDGE_CALC_READY     : in std_logic_vector(NumEdgeCalc-1 downto 0);
            EDGE_CALC_WREN      : out std_logic_vector(NumEdgeCalc-1 downto 0);
            MODULE_DATA_OUT     : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            MODULE_DATA_ADDR    : out std_logic_vector(RawAddrWidth-1 downto 0);
            MODULE_DATA_INFO    : out std_logic_vector(ModuleDataInfoWidth-1 downto 0);
            MODULE_DATA_WE      : out std_logic;

            INFERENCE_DATA      : out std_logic_vector(DataInputWidth-1 downto 0);
            INFERENCE_ADDR      : in std_logic_vector(RawAddrWidth-1 downto 0);
            INFERENCE_START     : out std_logic;
            INFERENCE_DONE      : in std_logic
        );
    end component module_mapper;

    -- Edge Calculator Block
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

    -- Concatenator Block
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

    -- Signal Mapping

    ------------------------------
    -- Module Mapper
    ------------------------------
    module_mapper_0 : module_mapper
        port map (
            CLK                 => CLK,
            RESET               => RESET,
            READY               => READY,

            DATA_IN             => DATA_IN,
            VALID_DATA_IN       => VALID_DATA_IN,
            META_DATA_FLAG      => META_DATA_FLAG,

            EDGE_CALC_READY     => edge_calc_ready_eclc,
            EDGE_CALC_WREN      => edge_calc_wren_mmap,
            MODULE_DATA_OUT     => module_data_out_mmap,
            MODULE_DATA_ADDR    => module_data_addr_mmap,
            MODULE_DATA_INFO    => module_data_info_mmap,
            MODULE_DATA_WE      => module_data_we_mmap,

            INFERENCE_DATA      => INFERENCE_DATA,
            INFERENCE_ADDR      => INFERENCE_ADDR,
            INFERENCE_START     => INFERENCE_START,
            INFERENCE_DONE      => INFERENCE_DONE
        );

    ------------------------------
    -- Edge Calculators
    ------------------------------
    GEN_EDGE_CALC : for i in NumEdgeCalculators-1 downto 0 generate
    edge_calc_gen : edge_calc
        PORT MAP(
            CLK                 => CLK,
            RESET               => RESET,
            READY               => edge_calc_ready_eclc(i),

            WREN             => edge_calc_wren_mmap(i),

            MODULE_DATA_OUT     => module_data_out_mmap,
            MODULE_DATA_ADDR    => module_data_addr_mmap,
            MODULE_DATA_INFO    => module_data_info_mmap,
            MODULE_DATA_WE   => module_data_we_mmap,
            
            EDGE_DATA_READY     => edge_data_ready_eclc(i),
            EDGE_DATA_COUNT     => edge_data_count_eclc(i),
            EDGE_DATA_OUT       => edge_data_out_eclc(i),
            ADJ_ID_OUT          => adj_id_out_eclc(i),
            EDGE_RE             => edge_re_cnct(i)
        );
    end generate GEN_EDGE_CALC;

    ------------------------------
    -- Concatenator
    ------------------------------
    concatenator_0 : concatenator
        PORT MAP(
            CLK                 => CLK,
            RESET               => RESET,
            READY               => edge_data_ready_cnct,

            START               => start,
            DONE                => done,
            
            EDGE_DATA_READY     => edge_data_ready_eclc,
            EDGE_DATA_COUNT     => edge_data_count_eclc,
            EDGE_DATA_IN        => edge_data_out_eclc,
            ADJ_ID_IN           => adj_id_out_eclc,
            EDGE_RE             => edge_re_cnct,

            EDGE_DATA_OUT       => EDGE_DATA_OUT, --edge_data_out_cnct,
            ADJ_ID_OUT          => ADJ_ID_OUT --adj_id_out_cnct
        );

    ------------------------------
    -- Graph Constructor Control Process
    ------------------------------
    gc_control_process : process(CLK)
    begin
        if ( rising_edge(CLK) ) then
            if (RESET = '1') then
                start <= '0';
                done <= '0';
                gc_state <= gc_idle;
            else
                -- Data pipeline
                
                --Default Assignments

                case(gc_state) is

                    when gc_idle =>
                        if (module_data_we_mmap = '1') then
                            gc_state <= gc_running_0; 
                        else 
                            gc_state <= gc_idle;
                        end if;
                    
                    when gc_running_0 =>
                        start <= '1';
                        gc_state <= gc_running_0;
                       
                    when gc_wait_0 =>
                        if (wait_count = 0) then
                            gc_state <= gc_rtn_state;
                        else
                            wait_count <= wait_count - 1; 
                            gc_state <= gc_wait_0;
                        end if;                   

                    when gc_done =>
                        gc_state <= gc_idle;
                    
                    when others =>
                        gc_state <= gc_idle;

                end case;
            end if;
        end if;
    end process gc_control_process;


end graph_constructor_arch;
