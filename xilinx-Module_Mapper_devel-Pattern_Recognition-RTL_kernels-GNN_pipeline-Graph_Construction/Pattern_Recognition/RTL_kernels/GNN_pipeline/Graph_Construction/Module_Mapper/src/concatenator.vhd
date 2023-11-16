----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Design Name: Concatenator
-- Module Name: concatenator - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: Concatenates outputs from N Edge Calculators into single data structure. 
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
entity concatenator is
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
end concatenator;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture concatenator_arch of concatenator is


    -- State definitions for output process
    TYPE concatenator_state_type is (
        s_idle,
        s_read_0,
        s_read_1,
        s_read_2,
        s_wait_0,
        s_done);
    signal concatenator_state : concatenator_state_type;
    signal concatenator_rtn_state : concatenator_state_type;
    signal wait_count         :   integer;

    signal edge_count : std_logic_vector(EdgeParamAddrWidth-1 downto 0);
    signal rd_count : std_logic_vector(EdgeParamAddrWidth-1 downto 0);
    signal rd_index : integer := 0;

    signal edge_dina : std_logic_vector(ModuleDataOutputWidth-1 downto 0);
    signal adj_dina  : std_logic_vector(RawAddrWidth*2-1 downto 0);
    signal edge_addr : std_logic_vector(ConcatAddrWidth-1 downto 0);
    signal edge_logic_we : std_logic_vector(0 downto 0);
    
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
    edge_dina <= EDGE_DATA_IN(rd_index);
    adj_dina <= ADJ_ID_IN(rd_index);

    ------------------------------
    -- Read Process     
    ------------------------------
    concatenator_process : process(CLK)
    begin
        if ( rising_edge(CLK) ) then
            if (RESET = '1') then
                DONE <= '0';
                READY <= '0';
                rd_index <= 0;
                edge_logic_we(0) <= '0';
                rd_count <= (others => '0'); 
                EDGE_RE <= (others => '0'); 
                edge_addr <= (others => '0'); 
                wait_count <= 0;
                concatenator_state <= s_idle;
            else
                -- Data pipeline

                --Default Assignments
                edge_logic_we(0) <= '0';

                case(concatenator_state) is

                    when s_idle =>
                        READY <= '1';
                        DONE <= '0';
                        if (START = '1') then
                            concatenator_state <= s_read_0;
                        else 
                            concatenator_state <= s_idle;
                        end if;
                    
                    when s_read_0 =>
                        if (EDGE_DATA_READY(rd_index) = '1') then
                                -- If indexed edge calculator has data enable readout
                                EDGE_RE(rd_index) <= '1';
                                wait_count <= 0;
                                concatenator_state <= s_wait_0;
                                concatenator_rtn_state <= s_read_1; 
                                --concatenator_state <= s_read_1;  
                            elsif(rd_index < NumEdgeCalculators - 1) then
                                -- Look at next edge calc
                                rd_index <= rd_index + 1;
                                concatenator_state <= s_read_0;
                            else
                                -- Wrap to first edge calc
                                rd_index <= 0;
                                concatenator_state <= s_read_0;
                        end if;

                    when s_read_1 =>
                        -- Get number of edges to read
                        edge_count <= EDGE_DATA_COUNT(rd_index);
                        edge_logic_we(0) <= '1';
                        edge_addr <= edge_addr + 1;
                        concatenator_state <= s_read_2;

                    when s_read_2 =>
                        if (rd_count < edge_count - 1) then
                            -- Write as long as there is data
                            edge_logic_we(0) <= '1';
                            edge_addr <= edge_addr + 1;
                            rd_count <= rd_count + 1; 
                            concatenator_state <= s_read_2;  
                        elsif(rd_index < NumEdgeCalculators - 1) then
                            -- Disable readout of current edge calc and move to next
                            EDGE_RE(rd_index) <= '0';
                            rd_index <= rd_index + 1;
                            rd_count <= (others => '0'); 
                            concatenator_state <= s_read_0;
                        else
                            -- Disable readout of current edge calc Wrap to first edge calc
                            EDGE_RE(rd_index) <= '0';
                            rd_index <= 0;
                            rd_count <= (others => '0'); 
                            concatenator_state <= s_read_0;
                        end if;

                    when s_wait_0 =>
                        if (wait_count = 0) then
                            concatenator_state <= concatenator_rtn_state;
                        else
                            wait_count <= wait_count - 1; 
                            concatenator_state <= s_wait_0;
                        end if;
                        

                    when s_done =>
                        edge_addr <= (others => '0');
                        DONE <= '1'; 
                        concatenator_state <= s_idle;
                    
                    when others =>
                        concatenator_state <= s_idle;

                end case;
            end if;
        end if;
    end process concatenator_process;

    ------------------------------
    -- Output Process       
    ------------------------------
    -- concatenator_write_process : process(CLK)
    -- begin
    --     if ( rising_edge(CLK) ) then
    --         if (RESET = '1') then
                
    --         else
                
    --         end if;
    --     end if;
    -- end process concatenator_write_process;


    ------------------------------
    -- Edge Parameter Ram
    ------------------------------
    concat_edge_parameter_ram : spram_wrapper
    generic map (
        RAM_WIDTH     => EdgeParamWidth,
        RAM_DEPTH     => ConcatDepth,
        ADDR_BITS     => ConcatAddrWidth,
        RAM_LATENCY   => 2,
        RAM_MODE      => "no_change",
        RAM_PRIMITIVE => RAMType,
        INIT_MEM_FILE => "concat_edge_param.mem",
        INIT_MEM_PARAM => "0"
    )
    port map (
        clka  => CLK,
        wea   => edge_logic_we,
        addra => edge_addr,
        dina  => edge_dina,
        douta => EDGE_DATA_OUT
    );

    ------------------------------
    -- Adjacency Matrix Ram
    ------------------------------
    concat_adj_matrix_ram : spram_wrapper
    generic map (
        RAM_WIDTH     => AdjMatrixWidth,
        RAM_DEPTH     => ConcatDepth,
        ADDR_BITS     => ConcatAddrWidth,
        RAM_LATENCY   => 2,
        RAM_MODE      => "no_change",
        RAM_PRIMITIVE => RAMType,
        INIT_MEM_FILE => "concat_adj_matrix.mem",
        INIT_MEM_PARAM => "0"
    )
    port map (
        clka  => CLK,
        wea   => edge_logic_we,
        addra => edge_addr,
        dina  => adj_dina,
        douta => ADJ_ID_OUT
    );
             

    
end concatenator_arch;
