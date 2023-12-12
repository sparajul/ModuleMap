----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Design Name: Edge Calculator Output
-- Module Name: ec_output - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: Reads adjacency matricies and outputs edge features above trhreshold. 
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
entity ec_output is
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
end ec_output;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture ec_output_arch of ec_output is


    -- State definitions for output process
    TYPE ec_output_state_type is (
        s_idle,
        s_read_0,
        s_wait_0,
        s_done);
    signal ec_output_state : ec_output_state_type;
    signal ec_output_rtn_state : ec_output_state_type;
    signal wait_count         :   integer;

    signal edge_count : std_logic_vector(EdgeParamAddrWidth-1 downto 0);
    signal rd_count : std_logic_vector(EdgeParamAddrWidth-1 downto 0);
    signal edge_addr : std_logic_vector(EdgeParamAddrWidth-1 downto 0);

    signal edge_logic_we : std_logic_vector(0 downto 0);
    signal writing        : std_logic;
    signal reading_done   : std_logic;


    
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
    edge_logic_we(0) <= EDGE_WE; 
    EDGE_DATA_COUNT <= edge_count;
    edge_addr <= edge_count when (writing = '1') else rd_count;
    DONE <= reading_done;
    

    ------------------------------
    -- Output Write Process       
    ------------------------------
    ec_output_write_process : process(CLK)
    begin
        if ( rising_edge(CLK) ) then
            if (RESET = '1') then
                edge_count <= (others => '0'); 
            elsif (reading_done = '1') then 
                edge_count <= (others => '0');        
            elsif (EDGE_WE = '1') then
                edge_count <= edge_count + 1;
            end if;
        end if;
    end process ec_output_write_process;
    
    ------------------------------
    -- Output Control Process     
    ------------------------------
    ec_output_process : process(CLK)
    begin
        if ( rising_edge(CLK) ) then
            if (RESET = '1') then
                reading_done <= '0';
                wait_count <= 0;
                writing <= '1';
                EDGE_DATA_READY <= '0';
                rd_count <= (others => '0'); 
                ec_output_state <= s_idle;
            else
                -- Data pipeline

                --Default Assignments
                reading_done <= '0';
                
                case(ec_output_state) is

                    when s_idle =>
                        if (START = '1') then
                            rd_count <= (others => '0'); 
                            writing <= '0';
                            ec_output_state <= s_read_0;
                        else 
                            ec_output_state <= s_idle;
                        end if;
                    
                    when s_read_0 =>
                        EDGE_DATA_READY <= '1';
                        if (rd_count = edge_count) then
                            ec_output_state <= s_done;    
                         elsif (EDGE_RE = '1') then
                            rd_count <= rd_count + 1;
                            ec_output_state <= s_read_0;
                        end if;
                       

                    when s_wait_0 =>
                        if (wait_count = 0) then
                            ec_output_state <= ec_output_rtn_state;
                        else
                            wait_count <= wait_count - 1; 
                            ec_output_state <= s_wait_0;
                        end if;
                        

                    when s_done =>
                        EDGE_DATA_READY <= '0';
                        reading_done <= '1';
                        writing <= '1';
                        ec_output_state <= s_idle;
                    
                    when others =>
                        ec_output_state <= s_idle;

                end case;
            end if;
        end if;
    end process ec_output_process;


    ------------------------------
    -- Edge Parameter Ram
    ------------------------------
    edge_parameter_ram : spram_wrapper
    generic map (
        RAM_WIDTH     => EdgeParamWidth,
        RAM_DEPTH     => EdgeParamDepth,
        ADDR_BITS     => EdgeParamAddrWidth,
        RAM_LATENCY   => 2,
        RAM_MODE      => "no_change",
        RAM_PRIMITIVE => RAMType,
        INIT_MEM_FILE => "edge_param.mem",
        INIT_MEM_PARAM => "0"
    )
    port map (
        clka  => CLK,
        wea   => edge_logic_we,
        addra => edge_addr,
        dina  => EDGE_DATA_IN,
        douta => EDGE_DATA_OUT
    );

    ------------------------------
    -- Adjacency Matrix Ram
    ------------------------------
    adj_matrix_ram : spram_wrapper
    generic map (
        RAM_WIDTH     => AdjMatrixWidth,
        RAM_DEPTH     => AdjMatrixDepth,
        ADDR_BITS     => AdjMatrixAddrWidth,
        RAM_LATENCY   => 2,
        RAM_MODE      => "no_change",
        RAM_PRIMITIVE => RAMType,
        INIT_MEM_FILE => "adj_matrix.mem",
        INIT_MEM_PARAM => "0"
    )
    port map (
        clka  => CLK,
        wea   => edge_logic_we,
        addra => edge_addr,
        dina  => ADJ_ID_IN,
        douta => ADJ_ID_OUT
    );
             

end ec_output_arch;
