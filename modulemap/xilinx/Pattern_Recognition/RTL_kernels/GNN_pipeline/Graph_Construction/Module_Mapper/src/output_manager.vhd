----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Create Date: 01/31/2022 01:38:55 PM
-- Design Name: Graph Constructor
-- Module Name: output_manager - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: Parses output read out by module ide as stored in module map. 
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
entity output_manager is
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
end output_manager;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture output_manager_arch of output_manager is

    -- State definitions for decode process
    TYPE output_manager_state_type is (
        s_idle,
        s_read_out_module_0,
        s_read_out_module_1,
        s_read_in_modules_0,
        s_read_in_modules_1,
        s_select_edge_calc_0,
        s_wait_0,
        s_done);
    signal output_manager_state : output_manager_state_type;
    signal output_manager_rtn_state : output_manager_state_type;

    signal module_map_din     :   std_logic_vector(ModuleMapWidth-1 downto 0);
    signal module_map_dout    :   std_logic_vector(ModuleMapWidth-1 downto 0);
    signal module_map_addr    :   std_logic_vector(ModuleMapAddrWidth-1 downto 0);
    signal module_map_we      :   std_logic_vector(0 DOWNTO 0);

    signal read_buffer_index  :   integer :=0;
    signal edge_calc_index    :   integer;
    signal wait_count         :   integer;

    --Module Map Word
    signal mmw_io_flag         : std_logic;
    signal mmw_incount         : std_logic_vector(MMInCountWidth-1 downto 0);
    signal mmw_layer_id        : std_logic_vector(MWLayerIDWidth-1 downto 0);
    signal mmw_module_id       : std_logic_vector(MWModuleIDWidth-1 downto 0);

    -- Module Info
    signal module_count        : std_logic_vector(MMInCountWidth-1 downto 0);
    signal hit_cnt             : std_logic_vector(HitCountOutputWidth-1 downto 0);
    signal io_flag             : std_logic;

    component spram_wrapper
        generic (
            RAM_WIDTH     : integer := 32;
            RAM_DEPTH     : integer := 64;
            ADDR_BITS     : integer := 6;
            RAM_LATENCY   : integer := 2;
            RAM_MODE      : string := "no_change";
            RAM_PRIMITIVE : string := "block";
            INIT_MEM_FILE : string := "";
            INIT_MEM_PARAM : string := "0"
        );
            port (
            clka  : IN  STD_LOGIC;
            wea   : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN  STD_LOGIC_VECTOR(ADDR_BITS-1 DOWNTO 0);
            dina  : IN  STD_LOGIC_VECTOR(RAM_WIDTH-1 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(RAM_WIDTH-1 DOWNTO 0)
        );
  end component spram_wrapper;

    
begin

    -- Signal Mappings
    DEBUG <= x"DDDD";
    MODULE_DATA_OUT <= HIT_DATA(read_buffer_index);
    MODULE_DATA_ADDR <= HIT_ADDR(read_buffer_index);
    EVENT_RE <= '0';

    mmw_io_flag <= module_map_dout(MMIO_Flag);
    mmw_incount <= module_map_dout(MMInCountMSB downto MMInCountLSB);
    mmw_layer_id <= module_map_dout(MMLayerIDMSB downto MMLayerIDLSB);
    mmw_module_id <= module_map_dout(MMModuleIDMSB downto MMModuleIDLSB);
    
    ------------------------------
    -- Module Data Output Process
    ------------------------------
    output_manager_process : process(CLK)
    begin
        if ( rising_edge(CLK) ) then
            if (RESET = '1') then
                MODULE_ID <= (others => '0');
                MODULE_RE <= '0';
                READY <= '1';
                R_DONE_OMGR <= '0';
                MODULE_DATA_WE <= '0';
                EDGE_CALC_RESET <= (others => '1');
                EDGE_CALC_WREN <= (others => '0');
                module_map_addr <= (others => '0');
                module_map_din <= (others => '0');
                module_map_we <= (others => '0');
                module_count <= (others => '0');
                hit_cnt <= (others => '0');
                io_flag <= '0';
                edge_calc_index <= 0;
                read_buffer_index <= 0;
                output_manager_state <= s_idle;
            else
                -- Data pipeline

                --Default Assignments
                read_buffer_index <= R_INDEX;
                MODULE_DATA_WE <= '0';
                MODULE_RE <= '0';
                EDGE_CALC_RESET <= (others => '0');

                case(output_manager_state) is

                    when s_idle =>
                        R_DONE_OMGR <= '0';
                        if (R_START_CNTRL = '1') then
                            output_manager_state <= s_select_edge_calc_0;
                        else 
                            output_manager_state <= s_idle;
                        end if;
                    
                    when s_select_edge_calc_0 =>
                        if (EDGE_CALC_READY(edge_calc_index) = '0') then
                            -- Index Edge Calc is Busy Select Next One
                            if (edge_calc_index < (NumEdgeCalc - 1) ) then 
                                edge_calc_index <= edge_calc_index + 1;
                            else
                                edge_calc_index <= 0;
                            end if;
                            output_manager_state <= s_select_edge_calc_0;
                        else
                            -- Index Edge Calc is Available
                            EDGE_CALC_WREN(edge_calc_index) <= '1';
                            output_manager_state <= s_read_out_module_0;
                        end if;
                    
                    -- Output Module ------------------------------------
                    when s_read_out_module_0 =>
                        if(module_map_addr < MapLength-1) then 
                            -- Setup Map Address for Read
                            MODULE_ID <= mmw_module_id;
                            module_map_addr <= module_map_addr + 1;
                            MODULE_RE <= '1';
                            
                            --Module Data Info
                            io_flag <= mmw_io_flag;
                            module_count <= mmw_incount;

                            wait_count <= 3;
                            output_manager_state <= s_wait_0;
                            output_manager_rtn_state <= s_read_out_module_1;
                        else 
                            output_manager_state <= s_done;
                        end if;

                    when s_read_out_module_1 =>
                        -- If data is valid capture it
                        if (READ_DONE(read_buffer_index) = '0') then
                            MODULE_DATA_INFO <= io_flag & "000" & module_count & hit_cnt;
                            MODULE_DATA_WE <= '1';
                            output_manager_state <= s_read_out_module_1;
                        -- Else if no output modules to read then halt edge calc loading and wait.
                        elsif(VALID_DATA(read_buffer_index) = '0') then
                            MODULE_DATA_INFO <= (others => '0');
                            --EDGE_CALC_WREN <= (others => '0');
                            EDGE_CALC_RESET(edge_calc_index) <= '1';
                            output_manager_state <= s_done;
                        -- Else if no input modules to read then halt edge calc loading and wait. 
                        elsif(module_count = 0) then
                            MODULE_DATA_INFO <= (others => '0');
                            --EDGE_CALC_WREN <= (others => '0');
                            EDGE_CALC_RESET(edge_calc_index) <= '1';
                            output_manager_state <= s_done;
                        -- Else read first input module
                        else
                            output_manager_state <= s_read_in_modules_0;
                        end if;

                    -- Input Modules -----------------------------------
                    when s_read_in_modules_0 =>
                        if(module_map_addr < MapLength) then 
                            -- Setup Map Address for Read
                            MODULE_ID <= mmw_module_id;
                            module_map_addr <= module_map_addr + 1;
                            MODULE_RE <= '1';
                            
                            --Module Data Info
                            io_flag <= mmw_io_flag;

                            wait_count <= 3;
                            output_manager_state <= s_wait_0;
                            output_manager_rtn_state <= s_read_in_modules_1;
                        else 
                            output_manager_state <= s_done;
                        end if;

                    when s_read_in_modules_1 =>
                        -- If data is valid capture it
                        if (READ_DONE(read_buffer_index) = '0') then
                            MODULE_DATA_INFO <= io_flag & "000" & "0000" & hit_cnt;
                            MODULE_DATA_WE <= '1';
                            output_manager_state <= s_read_in_modules_1;
                        -- Else if reading last module then halt edge calc loading and wait. 
                        elsif(module_count = 1) then
                            MODULE_DATA_INFO <= (others => '0');
                            --EDGE_CALC_WREN <= (others => '0');
                            module_count <= (others => '0');
                            output_manager_state <= s_done;
                        -- Else read next module
                        else
                            module_count <= module_count - 1;
                            output_manager_state <= s_read_in_modules_0;
                        end if;
                    -------------------------------------------------------
                    

                    when s_wait_0 =>
                        if (wait_count = 0) then
                            hit_cnt <= HIT_COUNT(read_buffer_index);
                            output_manager_state <= output_manager_rtn_state;
                        else
                            wait_count <= wait_count - 1; 
                            output_manager_state <= s_wait_0;
                        end if;
                        
                    when s_done =>
                        R_DONE_OMGR <= '1';
                        EDGE_CALC_WREN <= (others => '0');
                        module_map_addr <= (others => '0');
                        output_manager_state <= s_idle;
                    
                    when others =>
                        output_manager_state <= s_idle;

                end case;
            end if;
        end if;
    end process output_manager_process;

------------------------------
-- Module Map RAM
------------------------------
module_map_ram : spram_wrapper
    generic map (
        RAM_WIDTH     => ModuleMapWidth,
        RAM_DEPTH     => ModuleMapAddrWidth,
        ADDR_BITS     => RawAddrWidth,
        RAM_LATENCY   => 2,
        RAM_MODE      => "no_change",
        RAM_PRIMITIVE => RAMType,
        INIT_MEM_FILE => "module_map.mem",
        INIT_MEM_PARAM => "0"
    )
    port map (
        clka  => CLK,
        wea   => module_map_we,
        addra => module_map_addr,
        dina  => module_map_din,
        douta => module_map_dout
    );
                

end output_manager_arch;
