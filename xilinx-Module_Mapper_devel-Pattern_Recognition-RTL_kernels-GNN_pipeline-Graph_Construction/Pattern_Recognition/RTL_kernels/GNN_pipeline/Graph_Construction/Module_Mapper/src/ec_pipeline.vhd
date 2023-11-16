----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Design Name: Edge Calculator Floating Point Pipeline
-- Module Name: ec_pipeline - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: Compute edge features of all hits between a single output module and 
-- modules it is an input too and populate adjacency matricies. Totals subgraph edgecount.
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
entity ec_pipeline is
    port ( 
        CLK                 : in  std_logic;
        RESET               : in  std_logic;
        READY               : out std_logic;

        START               : in std_logic;
        DONE                : out std_logic;
        
        -- Input Interface
        MODULE_INFO_ADDR    : out std_logic_vector(ModInfoAddrWidth-1 downto 0); 
        MODULE_INFO         : in std_logic_vector(ModInfoWidth-1 downto 0); 
        OUTPUT_HIT_ADDR     : out std_logic_vector(OutHitAddrWidth-1 downto 0);
        OUTPUT_HIT          : in std_logic_vector(ModuleDataOutputWidth-1 downto 0);
        OUTPUT_ID           : in std_logic_vector(RawAddrWidth-1 downto 0);
        INPUT_HIT_ADDR      : out std_logic_vector(InHitAddrWidth-1 downto 0);
        INPUT_HIT           : in std_logic_vector(ModuleDataOutputWidth-1 downto 0);
        INPUT_ID            : in std_logic_vector(RawAddrWidth-1 downto 0);

        -- Pipeline Interface
        EDGE_DATA_OUT       : out std_logic_vector(ModuleDataOutputWidth-1 downto 0);
        ADJ_ID_OUT          : out std_logic_vector(RawAddrWidth*2-1 downto 0);
        EDGE_WE             : out std_logic
    );
end ec_pipeline;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture ec_pipeline_arch of ec_pipeline is

    -- State definitions for FP pipeline process
    TYPE ec_pipeline_state_type is (
        s_idle,
        s_read_out_info_0,
        s_loop_out_nodes_0,
        s_load_out_node_0,
        s_loop_in_nodes_0,
        s_read_in_info_0,
        s_load_in_node_0,
        s_wait_0,
        s_done);
    signal ec_pipeline_state : ec_pipeline_state_type;
    signal ec_pipeline_rtn_state : ec_pipeline_state_type;
    signal wait_count         :   integer;

    signal fp_enable          : std_logic;

    -- Input Control
    signal expected_out_hit_count           : std_logic_vector(MDIHitCntWidth-1 downto 0);
    signal expected_in_mod_count        : std_logic_vector(MDIInputModCntWidth-1 downto 0);
    signal in_mod_count        : std_logic_vector(MDIInputModCntWidth-1 downto 0);
    signal expected_in_hit_count           : std_logic_vector(MDIHitCntWidth-1 downto 0); 

    signal module_info_index    : std_logic_vector(ModInfoAddrWidth-1 downto 0); 
    signal output_hit_index   : std_logic_vector(OutHitAddrWidth-1 downto 0);
    signal input_hit_index      : std_logic_vector(InHitAddrWidth-1 downto 0);

    -- Output Hit Fifo
    signal ohfifo_wren          : std_logic;
    signal ohfifo_rden          : std_logic;
    signal ohfifo_dout          : std_logic_vector(ModuleDataOutputWidth-1 downto 0);
    -- Output ID FIFO
    signal oidfifo_wren          : std_logic;
    signal oidfifo_rden          : std_logic;
    signal oidfifo_dout          : std_logic_vector(RawAddrWidth-1 downto 0);
    -- Input ID FIFO
    signal iidfifo_wren          : std_logic;
    signal iidfifo_rden          : std_logic;
    signal iidfifo_dout          : std_logic_vector(RawAddrWidth-1 downto 0);
    -- Slope FIFO
    signal mfifo_wren          : std_logic;
    signal mfifo_rden          : std_logic;
    signal mfifo_din           : std_logic_vector(FP_Width*2-1 downto 0);
    signal mfifo_dout          : std_logic_vector(FP_Width*2-1 downto 0);

    -- Processing Pipeline
    -- Stage 0
    signal tvalid_Ri    : std_logic;
    signal tdata_Ri     : std_logic_vector(HWRCoordWidth-1 downto 0); 
    signal tvalid_Ro    : std_logic;
    signal tdata_Ro     : std_logic_vector(HWRCoordWidth-1 downto 0); 
    signal tvalid_Zi  : std_logic;
    signal tdata_Zi  : std_logic_vector(HWRCoordWidth-1 downto 0);
    signal tvalid_Zo  : std_logic;
    signal tdata_Zo  : std_logic_vector(HWRCoordWidth-1 downto 0);
    signal tvalid_Phii  : std_logic;
    signal tdata_Phii  : std_logic_vector(HWRCoordWidth-1 downto 0);
    signal tvalid_Phio  : std_logic;
    signal tdata_Phio  : std_logic_vector(HWRCoordWidth-1 downto 0);

    --Stage 1
    signal result_tvalid_subR : std_logic;
    signal result_tdata_subR  : std_logic_vector(HWRCoordWidth-1 downto 0);
    signal result_tvalid_subZ  : std_logic;
    signal result_tdata_subZ  : std_logic_vector(HWRCoordWidth-1 downto 0);
    signal result_tvalid_subPhi  : std_logic;
    signal result_tdata_subPhi  : std_logic_vector(HWRCoordWidth-1 downto 0);

    --Stage 2
    signal result_tvalid_divPhi  : std_logic;
    signal result_tdata_divPhi  : std_logic_vector(HWRCoordWidth-1 downto 0);
    signal result_tvalid_divZ  : std_logic;
    signal result_tdata_divZ  : std_logic_vector(HWRCoordWidth-1 downto 0);

    --Stage 3
    signal result_tvalid_macPhi : std_logic;
    signal result_tdata_macPhi  : std_logic_vector(HWRCoordWidth-1 downto 0);
    signal result_tvalid_macZ  : std_logic;
    signal result_tdata_macZ  : std_logic_vector(HWRCoordWidth-1 downto 0); 

    signal hit_data_int       :   std_logic_vector(HitDataOutputWidth-1 downto 0);
    signal read_buffer_index  :   integer :=0;
    signal edge_calc_index    :   integer;

    COMPONENT fp_sub_0
        PORT (
            aclk : IN STD_LOGIC;
            aclken : IN STD_LOGIC;
            s_axis_a_tvalid : IN STD_LOGIC;
            s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            s_axis_b_tvalid : IN STD_LOGIC;
            s_axis_b_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            m_axis_result_tvalid : OUT STD_LOGIC;
            m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
        END COMPONENT;

    COMPONENT fp_div_0
        PORT (
            aclk : IN STD_LOGIC;
            aclken : IN STD_LOGIC;
            s_axis_a_tvalid : IN STD_LOGIC;
            s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            s_axis_b_tvalid : IN STD_LOGIC;
            s_axis_b_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            m_axis_result_tvalid : OUT STD_LOGIC;
            m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT fp_gtoe_0
        PORT (
            aclk : IN STD_LOGIC;
            aclken : IN STD_LOGIC;
            s_axis_a_tvalid : IN STD_LOGIC;
            s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            s_axis_b_tvalid : IN STD_LOGIC;
            s_axis_b_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            m_axis_result_tvalid : OUT STD_LOGIC;
            m_axis_result_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
        END COMPONENT;
    
    COMPONENT fp_mult_add_0
        PORT (
          aclk : IN STD_LOGIC;
          aclken : IN STD_LOGIC;
          s_axis_a_tvalid : IN STD_LOGIC;
          s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          s_axis_b_tvalid : IN STD_LOGIC;
          s_axis_b_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          s_axis_c_tvalid : IN STD_LOGIC;
          s_axis_c_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          m_axis_result_tvalid : OUT STD_LOGIC;
          m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    component fifo_wrapper
        generic (
            FIFO_WIDTH       : integer := 32;
            FIFO_DEPTH       : integer := 2048;
            FIFO_COUNT_WIDTH : integer := 12;
            FIFO_LATENCY     : integer := 0;
            FIFO_MODE        : string;
            FIFO_PRIMITIVE   : string
        );
        port (
            clk         : IN  STD_LOGIC;
            srst        : IN  STD_LOGIC;
            din         : IN  STD_LOGIC_VECTOR(FIFO_WIDTH-1 DOWNTO 0);
            wr_en       : IN  STD_LOGIC;
            rd_en       : IN  STD_LOGIC;
            dout        : OUT STD_LOGIC_VECTOR(FIFO_WIDTH-1 DOWNTO 0);
            full        : OUT STD_LOGIC;
            empty       : OUT STD_LOGIC;
            data_count  : OUT STD_LOGIC_VECTOR(FIFO_COUNT_WIDTH-1 DOWNTO 0);
            wr_rst_busy : OUT STD_LOGIC;
            rd_rst_busy : OUT STD_LOGIC
        );
    end component fifo_wrapper;

begin

    -- Signal Mappings
    MODULE_INFO_ADDR <= module_info_index; 
    OUTPUT_HIT_ADDR <= output_hit_index; 
    INPUT_HIT_ADDR <= input_hit_index; 

    -- Outout
    EDGE_DATA_OUT <= mfifo_dout(FP_Width*2 - 1 downto FP_Width) & result_tdata_macZ & mfifo_dout(FP_Width - 1 downto 0) & result_tdata_macPhi;
    ADJ_ID_OUT <= oidfifo_dout & iidfifo_dout;    
    EDGE_WE <= result_tvalid_macPhi;

    -- Read delayed output hit on valid outout from Dividers for MAC input
    ohfifo_rden <= result_tvalid_divPhi;
    -- Write delayed Slope values for output with MAC results
    mfifo_wren <= result_tvalid_divPhi;

    --Read IDs and slope on valid outout from MAC
    oidfifo_rden <= result_tvalid_macPhi;
    iidfifo_rden <= result_tvalid_macPhi;
    mfifo_rden <= result_tvalid_macPhi;

    mfifo_din <= result_tdata_divZ & result_tdata_divPhi;

    ------------------------------
    -- FP Pipeline Control Process
    ------------------------------
    edge_calculator_process : process(CLK)
    begin
        if ( rising_edge(CLK) ) then
            if (RESET = '1') then
                fp_enable <= '1';

                tvalid_Ri <= '0';
                tdata_Ri <= (others => '0');
                tvalid_Ro <= '0';
                tdata_Ro <= (others => '0');
                tvalid_Zi <= '0';
                tdata_Zi <= (others => '0');
                tvalid_Zo <= '0';
                tdata_Zo<= (others => '0');
                tvalid_Phii <= '0';
                tdata_Phii <= (others => '0');
                tvalid_Phio <= '0';
                tdata_Phio <= (others => '0'); 
                wait_count <= 0;

                module_info_index <= (others => '0'); 
                output_hit_index <= (others => '0'); 
                input_hit_index <= (others => '0'); 

                expected_out_hit_count <= (others => '0'); 
                expected_in_mod_count <= (others => '0'); 
                expected_in_hit_count <= (others => '0'); 

                in_mod_count <= (others => '0'); 

                ohfifo_wren <= '0';
                oidfifo_wren <= '0';
                iidfifo_wren <= '0';

                ec_pipeline_state <= s_idle;
            else
                -- Data pipeline

                --Default Assignments
                ohfifo_wren <= '0';
                oidfifo_wren <= '0'; 
                iidfifo_wren <= '0';
                DONE <= '0';
                
                -- Reset FP input between calculations to ease data checking
                tvalid_Ri <= '0';
                tdata_Ri <= (others => '0');
                tvalid_Zi <= '0';
                tdata_Zi <= (others => '0');
                tvalid_Phii <= '0';
                tdata_Phii <= (others => '0');

                         
                case(ec_pipeline_state) is
                    
                    when s_idle =>
                        if (START = '1') then
                            module_info_index <= module_info_index + 1;
                            wait_count <= MemReadDelay;
                            ec_pipeline_state <= s_wait_0;
                            ec_pipeline_rtn_state <= s_read_out_info_0;
                        else 
                            ec_pipeline_state <= s_idle;
                        end if;

                    when s_read_out_info_0 =>
                        expected_out_hit_count <= MODULE_INFO(MIHitCntMSB downto MIHitCntLSB);
                        expected_in_mod_count <= MODULE_INFO(MIInModCntMSB downto MIInModCntLSB);
                        ec_pipeline_state <= s_loop_out_nodes_0;

                    when s_loop_out_nodes_0 =>
                        if(output_hit_index < expected_out_hit_count) then
                            in_mod_count <= expected_in_mod_count;
                            output_hit_index <= output_hit_index + 1;
                            wait_count <= MemReadDelay;
                            ec_pipeline_state <= s_wait_0;
                            ec_pipeline_rtn_state <= s_load_out_node_0;
                        else
                            wait_count <= ResultDelay;
                            ec_pipeline_state <= s_wait_0;
                            ec_pipeline_rtn_state <= s_done;  
                        end if;

                    when s_load_out_node_0 =>
                        -- Send Output Hit/Node Coordinate to Edge Calculation Pipeline
                        tvalid_Ro <= '1';
                        tdata_Ro <= OUTPUT_HIT(HWRCoordMSB downto HWRCoordLSB);
                        tvalid_Zo <= '1';
                        tdata_Zo <= OUTPUT_HIT(HWZCoordMSB downto HWZCoordLSB);
                        tvalid_Phio <= '1';
                        tdata_Phio <= OUTPUT_HIT(HWPhiCoordMSB downto HWPhiCoordLSB);
                        ec_pipeline_state <= s_loop_in_nodes_0;

                    
                    when s_loop_in_nodes_0 =>  
                        -- If there are still input modules to read compute edges for all of thier hits
                        -- with the current output hit
                        if(in_mod_count > 0) then
                            in_mod_count <= in_mod_count - 1;
                            module_info_index <= module_info_index + 1;
                            wait_count <= MemReadDelay; 
                            ec_pipeline_state <= s_wait_0;
                            ec_pipeline_rtn_state <= s_read_in_info_0;
                        else
                            module_info_index <= "00001";
                            ec_pipeline_state <= s_loop_out_nodes_0;  
                        end if;

                    when s_read_in_info_0 =>
                        expected_in_hit_count <= MODULE_INFO(MIHitCntMSB downto MIHitCntLSB);
                        input_hit_index <= MODULE_INFO(MIOffsetMSB downto MIOffsetLSB);   
                        wait_count <= MemReadDelay;
                        ec_pipeline_state <= s_wait_0;
                        ec_pipeline_rtn_state <= s_load_in_node_0;
                        
                    

                    when s_load_in_node_0 =>
                        -- Send Coordinate Set to Edge Calculation Pipeline
                        tvalid_Ri <= '1';
                        tdata_Ri <= INPUT_HIT(HWRCoordMSB downto HWRCoordLSB);                    
                        tvalid_Zi <= '1';
                        tdata_Zi <= INPUT_HIT(HWZCoordMSB downto HWZCoordLSB);
                        tvalid_Phii <= '1';
                        tdata_Phii <= INPUT_HIT(HWPhiCoordMSB downto HWPhiCoordLSB);

                        -- Capture output hit for downstream intercept calculation
                        ohfifo_wren <= '1';
                        oidfifo_wren <= '1';
                        iidfifo_wren <= '1';
                        
                        if(input_hit_index < expected_in_hit_count) then
                            input_hit_index <= input_hit_index + 1;
                            -- Delay to check for Phi periodicity
                            ec_pipeline_state <= s_load_in_node_0; 
                        else
                            -- Delay to check for Phi periodicity
                            ec_pipeline_state <= s_loop_in_nodes_0;  
                        end if;

                    when s_wait_0 =>
                        if (wait_count = 0) then
                            ec_pipeline_state <= ec_pipeline_rtn_state;
                        else
                            wait_count <= wait_count - 1; 
                            ec_pipeline_state <= s_wait_0;
                        end if;
                        

                    when s_done =>
                        tvalid_Ri <= '0';
                        tdata_Ri <= (others => '0');
                        tvalid_Ro <= '0';
                        tdata_Ro <= (others => '0');
                        tvalid_Zi <= '0';
                        tdata_Zi <= (others => '0');
                        tvalid_Zo <= '0';
                        tdata_Zo<= (others => '0');
                        tvalid_Phii <= '0';
                        tdata_Phii <= (others => '0');
                        tvalid_Phio <= '0';
                        tdata_Phio <= (others => '0'); 
                        DONE <= '1';
                        ec_pipeline_state <= s_idle;
                    
                    when others =>
                        ec_pipeline_state <= s_idle;

                end case;
            end if;
        end if;
    end process edge_calculator_process;

    -- Output Hit FIFO                         
    output_hit_fifo : fifo_wrapper
    generic map (
      FIFO_WIDTH       => ModuleDataOutputWidth,
      FIFO_DEPTH       => OutHitFifoDepth,
      FIFO_COUNT_WIDTH => 5,
      FIFO_LATENCY     => 0,
      FIFO_MODE        => "fwft",
      FIFO_PRIMITIVE   => RAMType
    )
    port map (
      clk         => CLK,
      srst        => RESET,
      din         => OUTPUT_HIT,
      wr_en       => ohfifo_wren,
      rd_en       => ohfifo_rden ,
      dout        => ohfifo_dout,
      full        => open,
      empty       => open,
      data_count  => open,
      wr_rst_busy => open,
      rd_rst_busy => open
    );

     -- Output ID FIFO                         
     output_id_fifo : fifo_wrapper
     generic map (
       FIFO_WIDTH       => RawAddrWidth,
       FIFO_DEPTH       => HitIDFifoDepth,
       FIFO_COUNT_WIDTH => 5,
       FIFO_LATENCY     => 0,
       FIFO_MODE        => "fwft",
       FIFO_PRIMITIVE   => RAMType
     )
     port map (
       clk         => CLK,
       srst        => RESET,
       din         => OUTPUT_ID,
       wr_en       => oidfifo_wren,
       rd_en       => oidfifo_rden ,
       dout        => oidfifo_dout,
       full        => open,
       empty       => open,
       data_count  => open,
       wr_rst_busy => open,
       rd_rst_busy => open
     );

      -- Input ID FIFO                         
    input_id_fifo : fifo_wrapper
    generic map (
      FIFO_WIDTH       => RawAddrWidth,
      FIFO_DEPTH       => HitIDFifoDepth,
      FIFO_COUNT_WIDTH => 5,
      FIFO_LATENCY     => 0,
      FIFO_MODE        => "fwft",
      FIFO_PRIMITIVE   => RAMType
    )
    port map (
      clk         => CLK,
      srst        => RESET,
      din         => INPUT_ID,
      wr_en       => iidfifo_wren,
      rd_en       => iidfifo_rden ,
      dout        => iidfifo_dout,
      full        => open,
      empty       => open,
      data_count  => open,
      wr_rst_busy => open,
      rd_rst_busy => open
    );

    -- Slope FIFO                         
    slope_fifo : fifo_wrapper
    generic map (
      FIFO_WIDTH       => FP_Width * 2,
      FIFO_DEPTH       => SlopeFifoDepth,
      FIFO_COUNT_WIDTH => 5,
      FIFO_LATENCY     => 0,
      FIFO_MODE        => "fwft",
      FIFO_PRIMITIVE   => RAMType
    )
    port map (
      clk         => CLK,
      srst        => RESET,
      din         => mfifo_din,
      wr_en       => mfifo_wren,
      rd_en       => mfifo_rden ,
      dout        => mfifo_dout,
      full        => open,
      empty       => open,
      data_count  => open,
      wr_rst_busy => open,
      rd_rst_busy => open
    );

    -- Result = A-B 
    -- Ri-Ro
    sub_R : fp_sub_0
    PORT MAP (
        aclk => CLK,
        aclken => fp_enable,
        s_axis_a_tvalid => tvalid_Ro,
        s_axis_a_tdata => tdata_Ro,
        s_axis_b_tvalid => tvalid_Ri,
        s_axis_b_tdata => tdata_Ri,
        m_axis_result_tvalid => result_tvalid_subR,
        m_axis_result_tdata => result_tdata_subR
    );

    -- Result = A-B 
    -- Zi-Zo
    sub_Z : fp_sub_0
    PORT MAP (
        aclk => CLK,
        aclken => fp_enable,
        s_axis_a_tvalid => tvalid_Zo,
        s_axis_a_tdata => tdata_Zo,
        s_axis_b_tvalid => tvalid_Zi,
        s_axis_b_tdata => tdata_Zi,
        m_axis_result_tvalid => result_tvalid_subZ,
        m_axis_result_tdata => result_tdata_subZ
    );

    -- Result = A-B 
    -- Phii-Phio
    sub_Phi : fp_sub_0
    PORT MAP (
         aclk => CLK,
         aclken => fp_enable,
         s_axis_a_tvalid => tvalid_Phio,
         s_axis_a_tdata => tdata_Phio,
         s_axis_b_tvalid => tvalid_Phii,
         s_axis_b_tdata => tdata_Phii,
         m_axis_result_tvalid => result_tvalid_subPhi,
         m_axis_result_tdata => result_tdata_subPhi
    );

     -- Result = 1 when A >= B
    -- gtoe_0 : fp_gtoe_0
    -- PORT MAP (
    --     aclk => CLK,
    --     aclken => fp_enable,
    --     s_axis_a_tvalid => s_axis_a_tvalid,
    --     s_axis_a_tdata => s_axis_a_tdata,
    --     s_axis_b_tvalid => s_axis_b_tvalid,
    --     s_axis_b_tdata => s_axis_b_tdata,
    --     m_axis_result_tvalid => m_axis_result_tvalid,
    --     m_axis_result_tdata => m_axis_result_tdata
    -- );

    -- Will need to break FP result here to pause pipeline for Phi periodicity calculation 

    -- Result = A  / B
    -- (Phio-Phii) / (Ro-Ri)
    div_Phi : fp_div_0
    PORT MAP (
      aclk => CLK,
      aclken => fp_enable,
      s_axis_a_tvalid => result_tvalid_subPhi,
      s_axis_a_tdata => result_tdata_subPhi,
      s_axis_b_tvalid => result_tvalid_subR,
      s_axis_b_tdata => result_tdata_subR,
      m_axis_result_tvalid => result_tvalid_divPhi,
      m_axis_result_tdata => result_tdata_divPhi
    );

    -- Result = A  / B
    -- (Zo-Zi) / (Ro-Ri)
    div_Z : fp_div_0
    PORT MAP (
      aclk => CLK,
      aclken => fp_enable,
      s_axis_a_tvalid => result_tvalid_subZ,
      s_axis_a_tdata => result_tdata_subZ,
      s_axis_b_tvalid => result_tvalid_subR,
      s_axis_b_tdata => result_tdata_subR,
      m_axis_result_tvalid => result_tvalid_divZ,
      m_axis_result_tdata => result_tdata_divZ
    );

    -- Result = (A*B) + C
    -- Phi0 = -divPhi*Ro + Phio
    mult_add_Phi: fp_mult_add_0
    PORT MAP (
        aclk => CLK,
        aclken => fp_enable,
        s_axis_a_tvalid => result_tvalid_divPhi,
        s_axis_a_tdata => result_tdata_divPhi,
        s_axis_b_tvalid => result_tvalid_divPhi,
        s_axis_b_tdata => ohfifo_dout(HWRCoordMSB downto HWRCoordLSB),
        s_axis_c_tvalid => result_tvalid_divPhi,
        s_axis_c_tdata => ohfifo_dout(HWPhiCoordMSB downto HWPhiCoordLSB),
        m_axis_result_tvalid => result_tvalid_macPhi,
        m_axis_result_tdata => result_tdata_macPhi
    );

    -- Result = (A*B) + C
    -- Z0 = -divZ*Ro + Zo
    mult_add_Z : fp_mult_add_0
    PORT MAP (
        aclk => CLK,
        aclken => fp_enable,
        s_axis_a_tvalid => result_tvalid_divZ,
        s_axis_a_tdata => result_tdata_divZ,
        s_axis_b_tvalid => result_tvalid_divZ ,
        s_axis_b_tdata => ohfifo_dout(HWRCoordMSB downto HWRCoordLSB),
        s_axis_c_tvalid => result_tvalid_divZ,
        s_axis_c_tdata => ohfifo_dout(HWZCoordMSB downto HWZCoordLSB),
        m_axis_result_tvalid => result_tvalid_macZ,
        m_axis_result_tdata => result_tdata_macZ
    );
                

end ec_pipeline_arch;
