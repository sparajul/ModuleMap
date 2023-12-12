----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Design Name: Edge Calculator Input
-- Module Name: ec_input - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: Loads module mapper output into memory structures for edge calculation.
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
entity ec_input is
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

        -- Pipeline Interface
        MODULE_INFO_ADDR    : in std_logic_vector(ModInfoAddrWidth-1 downto 0); 
        MODULE_INFO         : out std_logic_vector(ModInfoWidth-1 downto 0); 
        OUTPUT_HIT_ADDR     : in std_logic_vector(OutHitAddrWidth-1 downto 0);
        OUTPUT_HIT          : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
        OUTPUT_ID           : out std_logic_vector(RawAddrWidth-1 downto 0);
        INPUT_HIT_ADDR      : in std_logic_vector(InHitAddrWidth-1 downto 0);
        INPUT_HIT           : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
        INPUT_ID            : out std_logic_vector(RawAddrWidth-1 downto 0)

    );
end ec_input;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture ec_input_arch of ec_input is

    -- State definitions for input process
    TYPE input_state_type is (
        s_idle,
        s_out_info_0,
        s_out_hits_0,
        s_out_hits_1,
        s_mod_info_0,
        s_in_hits_0,
        s_in_hits_1,
        s_wait_0,
        s_done);
    signal input_state : input_state_type;
    signal input_rtn_state : input_state_type;
    signal wait_count         :   integer;

    -- Output Module Hits
    signal out_hit_we                : std_logic_vector(0 downto 0);
    signal out_hit_addr              : std_logic_vector(OutHitAddrWidth-1 downto 0);
    signal out_hit_din               : std_logic_vector(HitDataOutputWidth-1 downto 0);             
    -- Output Module ID
    signal out_id_din               : std_logic_vector(RawAddrWidth-1 downto 0);

    -- Input Module Hits
    signal in_hit_we                : std_logic_vector(0 downto 0);
    signal in_hit_addr              : std_logic_vector(InHitAddrWidth-1 downto 0);
    signal in_hit_din               : std_logic_vector(HitDataOutputWidth-1 downto 0);             
    -- Input Module ID
    signal in_id_din               : std_logic_vector(RawAddrWidth-1 downto 0);            

    -- Hit Info
    signal mod_info_we                : std_logic_vector(0 downto 0);
    signal mod_info_addr              : std_logic_vector(ModInfoAddrWidth-1 downto 0);
    signal mod_info_din               : std_logic_vector(ModInfoWidth-1 downto 0);             

    -- Input Control
    signal expected_hit_count           : std_logic_vector(MDIHitCntWidth-1 downto 0); 
    signal expected_in_mod_count        : std_logic_vector(MDIInputModCntWidth-1 downto 0);

    signal mux_select               : std_logic;
    signal out_hit_addr_mux              : std_logic_vector(OutHitAddrWidth-1 downto 0);
    signal in_hit_addr_mux              : std_logic_vector(InHitAddrWidth-1 downto 0);
    signal mod_info_addr_mux              : std_logic_vector(ModInfoAddrWidth-1 downto 0);

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
    out_hit_addr_mux <= out_hit_addr when mux_select = '1' else OUTPUT_HIT_ADDR;
    in_hit_addr_mux <=  in_hit_addr when mux_select = '1' else INPUT_HIT_ADDR;        
    mod_info_addr_mux <= mod_info_addr when mux_select = '1' else MODULE_INFO_ADDR;
    
    ------------------------------
    -- Input Control Process
    ------------------------------
    input_process : process(CLK)
    begin
        if ( rising_edge(CLK) ) then
            if (RESET = '1') then
                DONE <= '0';
                READY <= '1';
                wait_count <= 0;
                out_hit_addr <= (others => '0');
                in_hit_addr <= (others => '0');
                mod_info_addr <= (others => '0');
                mod_info_din <= (others => '0');
                out_hit_we <= "0";
                in_hit_we <= "0";
                mod_info_we <= "0";
                mux_select <= '0';
                expected_in_mod_count <= (others => '0');
                expected_hit_count <= (others => '0');
                input_state <= s_idle;
            else
                -- Data pipeline
                out_hit_din <= MODULE_DATA_OUT;
                out_id_din <= MODULE_DATA_ADDR;

                in_hit_din <= MODULE_DATA_OUT;
                in_id_din <= MODULE_DATA_ADDR;
                
                --Default Assignments
                out_hit_we <= "0";
                in_hit_we <= "0";
                mod_info_we <= "0";
                DONE <= '0';

                case(input_state) is

                    when s_idle =>
                        
                        if (START = '1') then
                            -- Reset all memory pointers
                            out_hit_addr <= (others => '0');
                            in_hit_addr <= (others => '0');
                            mod_info_addr <= (others => '0');
                            mod_info_din <= (others => '0');
                            mux_select <= '1';
                            READY <= '0';
                            input_state <= s_out_hits_0; 
                        else 
                            mux_select <= '0';
                            input_state <= s_idle;
                        end if;

                    when s_out_hits_0 =>
                        if (MODULE_DATA_WE = '1') then
            
                            if(MODULE_DATA_OUT(MWInFlag) = '1') then
                                --Module Word
                                expected_in_mod_count <= MODULE_DATA_INFO(MDIInputModCntMSB downto MDIInputModCntLSB);
                                expected_hit_count <= MODULE_DATA_INFO(MDIHitCntMSB downto MDIHitCntLSB); 
                                --Module Info Work
                                mod_info_din(MIOModFlag) <= '1';
                                mod_info_din(MIValidFlag) <= '1';
                                mod_info_din(MIHitCntMSB downto MIHitCntLSB) <= MODULE_DATA_INFO(MDIHitCntMSB downto MDIHitCntLSB);
                                mod_info_din(MIInModCntMSB downto MIInModCntLSB) <= MODULE_DATA_INFO(MDIInputModCntMSB downto MDIInputModCntLSB);
                                mod_info_din(MIOffsetMSB downto MIOffsetLSB) <= (others => '0');
                                mod_info_addr <= mod_info_addr + 1;
                                mod_info_we <= "1";
                            end if;                     
                            input_state <= s_out_hits_1;
                        else 
                            input_state <= s_out_hits_0;
                        end if;
                

                    when s_out_hits_1 =>
                        if (expected_hit_count > 0 ) then
                            out_hit_we <= "1";
                            expected_hit_count <= expected_hit_count - 1;
                            out_hit_addr <= out_hit_addr + 1;
                        else
                            input_state <= s_in_hits_0;
                        end if;


                    when s_in_hits_0 =>
                        if (MODULE_DATA_WE = '1') then
                
                            if(MODULE_DATA_OUT(MWInFlag) = '1') then
                                --Module Word
                                expected_hit_count <= MODULE_DATA_INFO(MDIHitCntMSB downto MDIHitCntLSB);
                                --Module Info Word
                                mod_info_din(MIOModFlag) <= '0';
                                mod_info_din(MIValidFlag) <= '1';
                                mod_info_din(MIHitCntMSB downto MIHitCntLSB) <= MODULE_DATA_INFO(MDIHitCntMSB downto MDIHitCntLSB);
                                mod_info_din(MIInModCntMSB downto MIInModCntLSB) <= (others => '0');
                                mod_info_din(MIOffsetMSB downto MIOffsetLSB) <= in_hit_addr + 1;
                                mod_info_addr <= mod_info_addr + 1;
                                mod_info_we <= "1";
                                
                                                
                            end if;
                            expected_in_mod_count <= expected_in_mod_count - 1;                     
                            input_state <= s_in_hits_1;
                        elsif (LAST = '1') then
                            -- There was no data for this module so skip to next
                            expected_hit_count <= (others => '0');
                            expected_in_mod_count <= expected_in_mod_count - 1;
                            -- Mark module infop as invalid
                            mod_info_din(MIOModFlag) <= '0';
                            mod_info_din(MIValidFlag) <= '0';
                            mod_info_din(MIHitCntMSB downto MIHitCntLSB) <= (others => '0');
                            mod_info_din(MIInModCntMSB downto MIInModCntLSB) <= (others => '0');
                            mod_info_din(MIOffsetMSB downto MIOffsetLSB) <= (others => '0');
                            mod_info_addr <= mod_info_addr + 1;
                            mod_info_we <= "1";

                            input_state <= s_in_hits_1;
                        else 
                            input_state <= s_in_hits_0;
                        end if;
                     
                    when s_in_hits_1 =>
                        if (expected_hit_count > 0 ) then
                            in_hit_we <= "1";
                            expected_hit_count <= expected_hit_count - 1;
                            in_hit_addr <= in_hit_addr + 1;
                        elsif (expected_in_mod_count > 0) then
                            input_state <= s_in_hits_0;
                        else
                            input_state <= s_done;
                        end if;
                       
                    when s_wait_0 =>
                        if (wait_count = 0) then
                            input_state <= input_rtn_state;
                        else
                            wait_count <= wait_count - 1; 
                            input_state <= s_wait_0;
                        end if;
                        

                    when s_done =>
                        DONE <= '1';
                        READY <= '1';
                        input_state <= s_idle;
                    
                    when others =>
                        input_state <= s_idle;

                end case;
            end if;
        end if;
    end process input_process;

    
   

    ------------------------------
    -- Output Module Hit Ram & IDs
    ------------------------------
    out_hit_ram : spram_wrapper
    generic map (
        RAM_WIDTH     => HitDataOutputWidth,
        RAM_DEPTH     => OutHitDepth,
        ADDR_BITS     => OutHitAddrWidth,
        RAM_LATENCY   => 2,
        RAM_MODE      => "no_change",
        RAM_PRIMITIVE => RAMType,
        INIT_MEM_FILE => "out_mod.mem",
        INIT_MEM_PARAM => "0"
    )
    port map (
        clka  => CLK,
        wea   => out_hit_we,
        addra => out_hit_addr_mux,
        dina  => out_hit_din,
        douta => OUTPUT_HIT
    );

    out_id_ram : spram_wrapper
    generic map (
        RAM_WIDTH     => RawAddrWidth,
        RAM_DEPTH     => OutHitDepth,
        ADDR_BITS     => OutHitAddrWidth,
        RAM_LATENCY   => 2,
        RAM_MODE      => "no_change",
        RAM_PRIMITIVE => RAMType,
        INIT_MEM_FILE => "out_mod.mem",
        INIT_MEM_PARAM => "0"
    )
    port map (
        clka  => CLK,
        wea   => out_hit_we,
        addra => out_hit_addr_mux,
        dina  => out_id_din,
        douta => OUTPUT_ID
    );

    ------------------------------
    -- Input Module Hit Ram
    ------------------------------
    in_hit_ram : spram_wrapper
    generic map (
        RAM_WIDTH     => HitDataOutputWidth,
        RAM_DEPTH     => InHitDepth,
        ADDR_BITS     => InHitAddrWidth,
        RAM_LATENCY   => 2,
        RAM_MODE      => "no_change",
        RAM_PRIMITIVE => RAMType,
        INIT_MEM_FILE => "in_mod.mem",
        INIT_MEM_PARAM => "0"
    )
    port map (
        clka  => CLK,
        wea   => in_hit_we,
        addra => in_hit_addr_mux,
        dina  => in_hit_din,
        douta => INPUT_HIT
    );

    in_id_ram : spram_wrapper
    generic map (
        RAM_WIDTH     => RawAddrWidth,
        RAM_DEPTH     => InHitDepth,
        ADDR_BITS     => InHitAddrWidth,
        RAM_LATENCY   => 2,
        RAM_MODE      => "no_change",
        RAM_PRIMITIVE => RAMType,
        INIT_MEM_FILE => "in_mod.mem",
        INIT_MEM_PARAM => "0"
    )
    port map (
        clka  => CLK,
        wea   => in_hit_we,
        addra => in_hit_addr_mux,
        dina  => in_id_din,
        douta => INPUT_ID
    );

    ------------------------------
    -- Hit Info Ram
    ------------------------------
    mod_info_ram : spram_wrapper
    generic map (
        RAM_WIDTH     => ModInfoWidth,
        RAM_DEPTH     => ModInfoDepth,
        ADDR_BITS     => ModInfoAddrWidth,
        RAM_LATENCY   => 2,
        RAM_MODE      => "no_change",
        RAM_PRIMITIVE => RAMType,
        INIT_MEM_FILE => "info_mod.mem",
        INIT_MEM_PARAM => "0"
    )
    port map (
        clka  => CLK,
        wea   => mod_info_we,
        addra => mod_info_addr_mux,
        dina  => mod_info_din,
        douta => MODULE_INFO
    );

 
end ec_input_arch;
