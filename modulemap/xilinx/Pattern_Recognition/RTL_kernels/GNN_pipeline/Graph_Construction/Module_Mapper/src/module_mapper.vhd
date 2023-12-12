----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Create Date: 01/31/2022 01:38:55 PM
-- Design Name: Graph Constructor
-- Module Name: module_mapper - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: Segments data based on mudule map.
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
entity module_mapper is
    port ( 
        CLK                 : in  std_logic;
        RESET               : in  std_logic;
        READY               : out std_logic;

        DATA_IN             : in  std_logic_vector(DataInputWidth-1 downto 0);
        VALID_DATA_IN       : in  std_logic;
        META_DATA_FLAG      : in  std_logic;

        EDGE_CALC_RESET     : out std_logic_vector(NumEdgeCalc-1 downto 0);
        EDGE_CALC_READY     : in std_logic_vector(NumEdgeCalc-1 downto 0);
        EDGE_CALC_WREN      : out std_logic_vector(NumEdgeCalc-1 downto 0);
        EDGE_CALC_LAST      : out std_logic;
        MODULE_DATA_OUT     : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
        MODULE_DATA_ADDR    : out std_logic_vector(RawAddrWidth-1 downto 0);
        MODULE_DATA_INFO    : out std_logic_vector(ModuleDataInfoWidth-1 downto 0);
        MODULE_DATA_WE      : out std_logic;

        INFERENCE_DATA      : out std_logic_vector(DataInputWidth-1 downto 0);
        INFERENCE_ADDR      : in std_logic_vector(RawAddrWidth-1 downto 0);
        INFERENCE_START     : out std_logic;
        INFERENCE_DONE      : in std_logic
    );
end module_mapper;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture module_mapper_arch of module_mapper is

    -- Decoder
    signal event_start_dcdr    : std_logic;
    signal event_end_dcdr      : std_logic;
        
    
    signal event_data_dcdr     : std_logic_vector(EventInputWidth-1 downto 0);
    signal event_we_dcdr       : std_logic;

    signal raw_data_dcdr       : std_logic_vector(DataInputWidth-1 downto 0);
    signal raw_addr_dcdr       : std_logic_vector(RawAddrWidth-1 downto 0);
    signal raw_we_dcdr         : std_logic;

    signal flag_data_dcdr      : std_logic_vector(FlagDataWidth-1 downto 0);
    signal flag_addr_dcdr      : std_logic_vector(FlagAddrWidth-1 downto 0);
    signal flag_we_dcdr        : std_logic;

    signal debug_dcdr          : std_logic_vector(DebugWidth-1 downto 0);

    -- Hit Buffer
    signal module_id_omgr      : std_logic_vector(IndexAddrWidth-1 downto 0);
    signal module_re_omgr      : std_logic;
    signal hit_data_hbufr      : HitBufferOutput_t;
    signal hit_addr_hbufr      : HitAddrOutput_t;
    signal hit_count_hbufr     : HitCountOutput_t;
    signal valid_data_hbufr    : std_logic_vector(NumHitBuffer-1 downto 0);
    signal read_done_hbufr     : std_logic_vector(NumHitBuffer-1 downto 0);

    signal event_data_out_hbufr : EventOutput_t;
    signal event_re_omgr        : std_logic;

    -- Controller
    signal ready_cntrl          : std_logic; 
    signal debug_cntrl          : std_logic_vector(DebugWidth-1 downto 0);
    
    signal rw_mode_cntrl        : RWMode_t;
    signal r_index_cntrl        : integer;
    signal i_index_cntrl        : integer;
    signal wbuf_empty_hbufr     : std_logic_vector(NumHitBuffer-1 downto 0);
    signal rbuf_ready_hbufr     : std_logic_vector(NumHitBuffer-1 downto 0);
    signal ibuf_ready_hbufr     : std_logic_vector(NumHitBuffer-1 downto 0);
    signal flag_reset_cntrl       : std_logic_vector(NumHitBuffer-1 downto 0);
    signal flag_reset_done_hbufr  : std_logic_vector(NumHitBuffer-1 downto 0);

    signal w_start_cntrl  : std_logic; 
    signal w_done_dcdr    : std_logic;    
    
    signal r_start_cntrl   : std_logic;
    signal r_done_omgr     : std_logic;

    signal i_start_cntrl   : std_logic;
    signal i_done_infr     : std_logic;

    -- Output Manager
    signal ready_otptmgr          : std_logic; 
    signal debug_otptmgr          : std_logic_vector(DebugWidth-1 downto 0);

    -- GNN Inferencing Data Interface
    signal ibuf_raw_addr      : std_logic_vector(RawAddrWidth-1 downto 0);

    component decoder is
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
    end component decoder;

    component hit_buffer
        port (
            CLK         : in  std_logic;
            RESET       : in  std_logic;

            EVENT_DATA_IN  : in  std_logic_vector(EventInputWidth-1 downto 0);
            EVENT_WE       : in std_logic;

            RAW_DATA    : in  std_logic_vector(DataInputWidth-1 downto 0);
            RAW_ADDR    : in  std_logic_vector(RawAddrWidth-1 downto 0);
            RAW_WE      : in  std_logic;

            WBUF_EMPTY  : out std_logic;
            RBUF_READY  : out std_logic;
            IBUF_READY  : out std_logic;
            RW_MODE     : in  HitBufferMode_t;
            FLAG_RESET  : in std_logic;
            FLAG_RESET_DONE   : out std_logic;

            MODULE_ID   : in std_logic_vector(IndexAddrWidth-1 DOWNTO 0);
            MODULE_RE   : in std_logic;
            HIT_DATA    : out std_logic_vector(DataInputWidth-1 downto 0);
            HIT_ADDR    : out std_logic_vector(RawAddrWidth-1 downto 0);
            HIT_COUNT   : out std_logic_vector(IndexHitCountWidth-1 downto 0);
            VALID_DATA  : out std_logic;
            READ_DONE   : out std_logic;

            IBUF_RAW_ADDR    : in std_logic_vector(RawAddrWidth-1 downto 0);
            IBUF_DONE        : in std_logic;

            EVENT_DATA_OUT  : out std_logic_vector(EventInputWidth-1 downto 0);
            EVENT_RE        : in std_logic
        );
    end component hit_buffer;

    component controller
        port ( 
            CLK                 : in  std_logic;
            RESET               : in  std_logic;
            READY               : out std_logic;

            RW_MODE             : out RWMode_t;
            R_INDEX             : out integer;
            I_INDEX             : out integer;
            WBUF_EMPTY          : in std_logic_vector(NumHitBuffer-1 downto 0);
            RBUF_READY          : in std_logic_vector(NumHitBuffer-1 downto 0);
            IBUF_READY          : in std_logic_vector(NumHitBuffer-1 downto 0);
            FLAG_RESET          : out std_logic_vector(NumHitBuffer-1 downto 0);
            FLAG_RESET_DONE     : in std_logic_vector(NumHitBuffer-1 downto 0);

            EVENT_START         : in std_logic;
            EVENT_END           : in std_logic;

            W_START_CNTRL        : out std_logic;
            W_DONE_DCDR          : in std_logic;

            R_START_CNTRL        : out std_logic;
            R_DONE_OMGR          : in std_logic;

            I_START_CNTRL       : out std_logic;
            I_DONE_INFR         : in std_logic;

            DEBUG               : inout std_logic_vector(DebugWidth-1 downto 0)
        );
    end component controller;

    component output_manager is
        port ( 
            CLK                 : in  std_logic;
            RESET               : in  std_logic;
            READY               : out std_logic;

            EVENT_DATA_IN       : in EventOutput_t;
            EVENT_RE            : out std_logic;

            R_START_CNTRL       : in std_logic;
            R_DONE_OMGR         : out std_logic;
            RW_MODE             : in RWMode_t;
            R_INDEX             : in integer;

            MODULE_ID           : out std_logic_vector(IndexAddrWidth-1 downto 0);
            MODULE_RE           : out std_logic;
            HIT_DATA            : in HitBufferOutput_t;
            HIT_ADDR            : in HitAddrOutput_t;
            HIT_COUNT           : in HitCountOutput_t;
            VALID_DATA          : in std_logic_vector(NumHitBuffer-1 downto 0);
            READ_DONE           : in std_logic_vector(NumHitBuffer-1 downto 0);

            EDGE_CALC_RESET     : out std_logic_vector(NumEdgeCalc-1 downto 0);
            EDGE_CALC_READY     : in std_logic_vector(NumEdgeCalc-1 downto 0);
            EDGE_CALC_WREN      : out std_logic_vector(NumEdgeCalc-1 downto 0);
            MODULE_DATA_OUT     : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
            MODULE_DATA_ADDR    : out std_logic_vector(RawAddrWidth-1 downto 0);
            MODULE_DATA_INFO    : out std_logic_vector(ModuleDataInfoWidth-1 downto 0);
            MODULE_DATA_WE      : out std_logic;

            DEBUG               : inout std_logic_vector(DebugWidth-1 downto 0)
        );
    end component output_manager;

begin

    -- Signal Mappings
    EDGE_CALC_LAST <= '1' when read_done_hbufr > 0 else '0'; 

    -- Inference Data Passthrough and control
    INFERENCE_DATA <= hit_data_hbufr(i_index_cntrl);
    ibuf_raw_addr <= INFERENCE_ADDR;
    INFERENCE_START <= i_start_cntrl;
    i_done_infr <= INFERENCE_DONE; 
    

    ------------------------------
    -- Decoder
    ------------------------------
    decoder_0 : decoder
        port map (
            CLK                 => CLK,
            RESET               => RESET,
            READY               => READY,

            EVENT_START         => event_start_dcdr,
            EVENT_END           => event_end_dcdr,

            W_START_CNTRL        => w_start_cntrl,
            W_DONE_DCDR          => w_done_dcdr,

            META_DATA_FLAG      => META_DATA_FLAG,
            EVENT_DATA          => event_data_dcdr,
            EVENT_WE            => event_we_dcdr,

            DATA_IN             => DATA_IN,
            VALID_DATA_IN       => VALID_DATA_IN,

            RAW_DATA            => raw_data_dcdr,
            RAW_ADDR            => raw_addr_dcdr,
            RAW_WE              => raw_we_dcdr,

            DEBUG               => debug_dcdr
        );

    ------------------------------
    -- Hit Buffers
    ------------------------------
    GEN_HIT_BUFFER : for i in NumHitBuffer-1 downto 0 generate
    hit_buffer_gen : hit_buffer
        port map (
            CLK         => CLK,
            RESET       => RESET,
    
            EVENT_DATA_IN  => event_data_dcdr,
            EVENT_WE       => event_we_dcdr,
    
            RAW_DATA    => raw_data_dcdr,
            RAW_ADDR    => raw_addr_dcdr,
            RAW_WE      => raw_we_dcdr,

            WBUF_EMPTY  => wbuf_empty_hbufr(i),
            RBUF_READY  => rbuf_ready_hbufr(i),
            IBUF_READY  => ibuf_ready_hbufr(i),
            RW_MODE     => rw_mode_cntrl(i),
            FLAG_RESET  => flag_reset_cntrl(i),
            FLAG_RESET_DONE  => flag_reset_done_hbufr(i),

            MODULE_ID   => module_id_omgr,
            MODULE_RE   => module_re_omgr,
            HIT_DATA    => hit_data_hbufr(i),
            HIT_ADDR    => hit_addr_hbufr(i),
            HIT_COUNT   => hit_count_hbufr(i),
            VALID_DATA  => valid_data_hbufr(i),
            READ_DONE   => read_done_hbufr(i),

            IBUF_RAW_ADDR    => ibuf_raw_addr,
            IBUF_DONE        => i_done_infr,

            EVENT_DATA_OUT  => event_data_out_hbufr(i),
            EVENT_RE        => event_re_omgr
        );
    end generate GEN_HIT_BUFFER;

    ------------------------------
    -- Controller
    ------------------------------
    controller_0 : controller
        port map ( 
            CLK                 => CLK,
            RESET               => RESET,
            READY               => ready_cntrl,

            RW_MODE             => rw_mode_cntrl,
            R_INDEX             => r_index_cntrl,
            I_INDEX             => i_index_cntrl,
            WBUF_EMPTY          => wbuf_empty_hbufr,
            RBUF_READY          => rbuf_ready_hbufr,
            IBUF_READY          => ibuf_ready_hbufr,
            FLAG_RESET          => flag_reset_cntrl,
            FLAG_RESET_DONE     => flag_reset_done_hbufr,

            EVENT_START         => event_start_dcdr,
            EVENT_END           => event_end_dcdr,

            W_START_CNTRL       => w_start_cntrl,
            W_DONE_DCDR         => w_done_dcdr,

            R_START_CNTRL       => r_start_cntrl,
            R_DONE_OMGR         => r_done_omgr,

            I_START_CNTRL       => i_start_cntrl,
            I_DONE_INFR         => i_done_infr,

            DEBUG               => debug_cntrl
        );
    

    ------------------------------
    -- Output Manager
    ------------------------------
    output_manager_0 : output_manager
        port map ( 
            CLK                 => CLK,
            RESET               => RESET,
            READY               => ready_otptmgr,

            EVENT_DATA_IN       => event_data_out_hbufr,
            EVENT_RE            => event_re_omgr,
    
            R_START_CNTRL       => r_start_cntrl,
            R_DONE_OMGR         => r_done_omgr,
            RW_MODE             => rw_mode_cntrl,
            R_INDEX             => r_index_cntrl,

            MODULE_ID           => module_id_omgr,
            MODULE_RE           => module_re_omgr,
            HIT_DATA            => hit_data_hbufr,
            HIT_ADDR            => hit_addr_hbufr,
            HIT_COUNT           => hit_count_hbufr,
            VALID_DATA          => valid_data_hbufr,
            READ_DONE           => read_done_hbufr,

            EDGE_CALC_READY     => EDGE_CALC_READY,
            EDGE_CALC_RESET     => EDGE_CALC_RESET,
            EDGE_CALC_WREN      => EDGE_CALC_WREN,
            MODULE_DATA_OUT     => MODULE_DATA_OUT,
            MODULE_DATA_ADDR    => MODULE_DATA_ADDR,
            MODULE_DATA_INFO    => MODULE_DATA_INFO,
            MODULE_DATA_WE      => MODULE_DATA_WE,          
    
            DEBUG               => debug_otptmgr
        );
    


end module_mapper_arch;
