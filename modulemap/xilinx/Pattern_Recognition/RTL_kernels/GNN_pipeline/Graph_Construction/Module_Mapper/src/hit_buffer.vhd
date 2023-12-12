----------------------------------------------------------------------------------
-- Company: Univresity of Illinois
-- Engineer: Casey Smith
-- 
-- Create Date: 01/31/2022 01:38:55 PM
-- Design Name: Hit Buffer
-- Module Name: hit_buffer - Behavioral
-- Project Name: graph-constructor
-- Target Devices: UltraScale +
-- Tool Versions: Vivado 2021.1
-- Description: Organizes ultrascale RAM primatives for ping-pong memory structures of
--              module mapper. 
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
--use IEEE.MATH_REAL.all;
--use IEEE.STD_LOGIC_ARITH.all;
--use IEEE.STD_LOGIC_MISC.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
--use IEEE.STD_LOGIC_TEXTIO.all;
--use STD.TEXTIO.all;
library work;
use work.graph_constructor_package.all;

----------------------------------------------------------------------------------
-- Entity
----------------------------------------------------------------------------------
entity hit_buffer is
    Port (
      CLK         : in std_logic;
      RESET       : in std_logic;

      -- Decode Interface
      EVENT_DATA_IN  : in std_logic_vector(EventInputWidth-1 downto 0);
      EVENT_WE       : in std_logic;

      RAW_DATA    : in std_logic_vector(DataInputWidth-1 downto 0);
      RAW_ADDR    : in std_logic_vector(RawAddrWidth-1 downto 0);
      RAW_WE      : in std_logic;

      -- Controller Interface
      WBUF_EMPTY   : out std_logic;
      RBUF_READY   : out std_logic;
      IBUF_READY   : out std_logic;
      RW_MODE      : in HitBufferMode_t;
      FLAG_RESET        : in std_logic;
      FLAG_RESET_DONE   : out std_logic;

      -- Output Manager Interface
      MODULE_ID   : in std_logic_vector(IndexAddrWidth-1 DOWNTO 0);
      MODULE_RE   : in std_logic; 
      HIT_DATA    : out std_logic_vector(DataInputWidth-1 downto 0);
      HIT_ADDR    : out std_logic_vector(RawAddrWidth-1 downto 0);
      HIT_COUNT   : out std_logic_vector(IndexHitCountWidth-1 downto 0);
      VALID_DATA  : out std_logic;
      READ_DONE   : out std_logic;

      -- Inference Read Interface
      IBUF_RAW_ADDR    : in std_logic_vector(RawAddrWidth-1 downto 0);
      IBUF_DONE        : in std_logic;

      -- Event Intrface
      EVENT_DATA_OUT  : out std_logic_vector(EventInputWidth-1 downto 0);
      EVENT_RE        : in std_logic
    );
end hit_buffer;

----------------------------------------------------------------------------------
-- Architechture
----------------------------------------------------------------------------------
architecture hit_buffer_arch of hit_buffer is

  --Input parsing
  signal mw_flag_in      : std_logic;
  signal module_id_in       : std_logic_vector(MWModuleIDWidth-1 downto 0);


  -- Multiplex
  signal raw_we_mux : std_logic_vector(0 DOWNTO 0);
  signal raw_addr_mux : std_logic_vector(RawAddrWidth-1 downto 0);
  signal raw_read_addr : std_logic_vector(RawAddrWidth-1 downto 0);

  signal index_we_mux : std_logic_vector(0 DOWNTO 0);
  signal index_addr_mux : std_logic_vector(IndexAddrWidth-1 downto 0);

  signal flag_we_mux : std_logic_vector(0 DOWNTO 0);
  signal flag_addr_mux : std_logic_vector(FlagAddrWidth-1 downto 0);

  signal event_we_mux : std_logic_vector(0 DOWNTO 0);
  signal event_re_mux : std_logic_vector(0 DOWNTO 0);
  
  signal raw_dout    : std_logic_vector(DataInputWidth-1 downto 0);

  --Index Registers  
  signal index_din    : std_logic_vector(IndexDataWidth-1 downto 0);
  signal index_din_r1    : std_logic_vector(IndexDataWidth-1 downto 0);
  signal index_dout    : std_logic_vector(IndexDataWidth-1 downto 0);
  signal index_addr : std_logic_vector(IndexAddrWidth-1 downto 0);
  signal index_addr_r1 : std_logic_vector(IndexAddrWidth-1 downto 0);
  signal index_we : std_logic;

  signal flag_din  : STD_LOGIC_VECTOR(FlagDataWidth-1 downto 0);
  signal flag_dout : STD_LOGIC_VECTOR(FlagDataWidth-1 downto 0);

  --Write 
  signal index_raw_addr    : std_logic_vector(MWModuleIDWidth-1 downto 0);
  signal index_hit_count : std_logic_vector(IndexHitCountWidth-1 downto 0);

  --Read
  signal flag_rd_addr : std_logic_vector(FlagAddrWidth-1 downto 0);
  signal raw_rd_addr : std_logic_vector(MWModuleIDWidth-1 downto 0) := (others => '0');
  signal raw_hit_count : std_logic_vector(IndexHitCountWidth-1 downto 0);
  signal valid_data_r1 : std_logic;
  
  signal flag : std_logic;
  signal flag_set : std_logic_vector(FlagDataWidth-1 downto 0);

  signal flag_reset_addr : std_logic_vector(FlagAddrWidth-1 downto 0); -- 16-

  -- Write Buffer Empty process
  signal wbuf_empty_int : std_logic;
  signal wbuf_empty_set : std_logic;
  signal wbuf_empty_clr : std_logic;

  -- State definitions for write process
  TYPE write_state_type is (
    sw_idle,
    sw_writing);
  signal write_state : write_state_type;
  signal write_rtn_state : write_state_type;

  -- Read Buffer Ready process
  signal rbuf_ready_int : std_logic;
  signal rbuf_ready_set : std_logic;
  signal rbuf_ready_clr : std_logic;

  -- State definitions for read process
  TYPE read_state_type is (
    sr_idle,
    sr_read_index_0,
    sr_read_raw_0,
    sr_read_done,
    sr_read_wait);
  signal read_state : read_state_type;
  signal read_rtn_state : read_state_type;

  -- Pipeline for read addr
  signal hit_addr_r1 : std_logic_vector(RawAddrWidth-1 downto 0);
  signal hit_addr_r2 : std_logic_vector(RawAddrWidth-1 downto 0);

  -- Inference Buffer Read Ready process
  signal ibuf_ready_int : std_logic;
  signal ibuf_ready_set : std_logic;
  signal ibuf_ready_clr : std_logic;

  -- State definitions for inference read process
  TYPE inference_state_type is (
    ir_idle,
    ir_read_raw_0,
    ir_read_done,
    ir_read_wait);
  signal iread_state : inference_state_type;
  signal iread_rtn_state : inference_state_type;

  -- State definitions for reset process
  TYPE flag_state_type is (
    sf_idle,
    sf_reseting);
  signal flag_state : flag_state_type;
  signal flag_rtn_state : flag_state_type;

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

  ------------------------------
  -- Event Header Fifo
  ------------------------------
  event_fifo : fifo_wrapper
    generic map (
      FIFO_WIDTH       => EventInputWidth,
      FIFO_DEPTH       => 16,
      FIFO_COUNT_WIDTH => 5,
      FIFO_LATENCY     => 0,
      FIFO_MODE        => "fwft",
      FIFO_PRIMITIVE   => RAMType
    )
    port map (
      clk         => CLK,
      srst        => RESET,
      din         => EVENT_DATA_IN,
      wr_en       => event_we_mux(0),
      rd_en       => event_re_mux(0),
      dout        => EVENT_DATA_OUT,
      full        => open,
      empty       => open,
      data_count  => open,
      wr_rst_busy => open,
      rd_rst_busy => open
    );

  -- Ping Pong Mux
  event_we_mux(0) <= EVENT_WE when RW_MODE = writing else '0';
  event_re_mux(0) <= EVENT_RE when RW_MODE = constructing else '0';


  ------------------------------
  -- Raw Data RAM
  ------------------------------
  raw_data_ram : spram_wrapper
    generic map (
      RAM_WIDTH     => DataInputWidth,
      RAM_DEPTH     => RawDepth,
      ADDR_BITS     => RawAddrWidth,
      RAM_LATENCY   => 2,
      RAM_MODE      => "no_change",
      RAM_PRIMITIVE => RAMType,
      INIT_MEM_FILE => "raw_data_ram.mem",
      INIT_MEM_PARAM => "0"
    )
    port map (
      clka  => CLK,
      wea   => raw_we_mux,
      addra => raw_addr_mux,
      dina  => RAW_DATA,
      douta => raw_dout
    );

  -- Ping Pong Mux
  raw_we_mux(0) <= RAW_WE when RW_MODE = writing else '0';
  
  with RW_MODE select raw_addr_mux <=  
    RAW_ADDR when writing,
    IBUF_RAW_ADDR when inferencing,
    raw_rd_addr when constructing;

  HIT_DATA <= raw_dout;
  HIT_ADDR <= hit_addr_r2;

  ------------------------------
  -- Index RAM
  ------------------------------
  index_ram : spram_wrapper
    generic map (
      RAM_WIDTH     => IndexDataWidth,
      RAM_DEPTH     => IndexDepth,
      ADDR_BITS     => IndexAddrWidth,
      RAM_LATENCY   => 2,
      RAM_MODE      => "no_change",
      RAM_PRIMITIVE => RAMType,
      INIT_MEM_FILE => "index_ram.mem",
      INIT_MEM_PARAM => "0"
    )
    port map (
      clka  => CLK,
      wea   => index_we_mux,
      addra => index_addr_mux,
      dina  => index_din,
      douta => index_dout
    );

  -- Ping Pong Mux
  index_we_mux(0) <= index_we when RW_MODE = writing else '0';
  index_addr_mux <= index_addr when RW_MODE = writing else MODULE_ID;
  index_din_r1 <= index_hit_count & index_raw_addr;
  

  ------------------------------
  -- Flag RAM
  ------------------------------
  flag_ram : spram_wrapper
    generic map (
      RAM_WIDTH     => FlagDataWidth,
      RAM_DEPTH     => FlagDepth,
      ADDR_BITS     => FlagAddrWidth,
      RAM_LATENCY   => 2,
      RAM_MODE      => "write_first",
      RAM_PRIMITIVE => RAMType,
      INIT_MEM_FILE => "flag_ram.mem",
      INIT_MEM_PARAM => "0"
    )
    port map (
      clka  => CLK,
      wea   => flag_we_mux,
      addra => flag_addr_mux,
      dina  => flag_din,
      douta => flag_dout
    );
    
  flag_we_mux <=  (others => '1') when FLAG_RESET = '1' else index_we_mux ;
  flag_din <= (others => '0') when FLAG_RESET = '1' else (flag_dout or flag_set);
  flag_rd_addr <= flag_reset_addr when FLAG_RESET = '1' else MODULE_ID(MWModuleIDWidth-1 downto FlagDataExp);
  flag_addr_mux <= index_addr(MWModuleIDWidth-1 downto FlagDataExp) when RW_MODE = writing 
              else flag_rd_addr;
  
  -- Input Parsing
  mw_flag_in <= RAW_DATA(MWInFlag);
  module_id_in <= RAW_DATA(MWModuleIDMSB downto MWModuleIDLSB);
 
  WBUF_EMPTY <= wbuf_empty_int;
  RBUF_READY <= rbuf_ready_int;
  IBUF_READY <= ibuf_ready_int;

  flag <= flag_dout(conv_integer(MODULE_ID(FlagAddrWidth-1 downto 0))); 
  flag_set <= std_logic_vector(shift_left(unsigned(FlagSetBit), conv_integer(index_addr(FlagAddrWidth-1 downto 0))));

  ------------------------------
  -- Write Buffer Empty Process   
  ------------------------------
  write_buffer_empty_process : process(CLK)
  begin
    if ( rising_edge(CLK) ) then
      if (RESET = '1') then
        wbuf_empty_int <= '1';
      else
        if (wbuf_empty_set = '1') then
          wbuf_empty_int <= '1';
        elsif (wbuf_empty_clr = '1') then
          wbuf_empty_int <= '0';
        end if;
      end if;
    end if;
  end process write_buffer_empty_process;

  ------------------------------
  -- Write Control Processes    
  ------------------------------
  write_process : process(CLK)
  begin
    if ( rising_edge(CLK) ) then
      if (RESET = '1') then
        rbuf_ready_set <= '0';
        wbuf_empty_clr <= '0';
        index_hit_count <= (others => '0');
        write_state <= sw_idle;
      else
        -- Data pipeline
        index_din <= index_din_r1;
        index_addr <= index_addr_r1;

        --Default Assignments
        index_we <= '0';
        rbuf_ready_set <= '0';
        wbuf_empty_clr <= '0';
              
        case(write_state) is 
                
          when sw_idle =>
            if (RW_MODE = writing and RAW_WE = '1' and mw_flag_in = '1') then
              wbuf_empty_clr <= '1';
              index_addr_r1 <= module_id_in;
              index_raw_addr <= RAW_ADDR;
              write_state <= sw_writing;
            else 
              write_state <= sw_idle;     
            end if;

          when sw_writing =>
            if (EVENT_WE = '1') then
              -- End of event: Write last index and set ready for reading
              -- before returning to idle state
              index_we <= '1';
              index_hit_count <= (others => '0');
              rbuf_ready_set <= '1';
              write_state <= sw_idle;
            elsif (mw_flag_in = '1') then
              index_we <= '1';
              index_hit_count <= (others => '0');
              index_addr_r1 <= module_id_in;
              index_raw_addr <= RAW_ADDR;
              write_state <= sw_writing;
            elsif (mw_flag_in = '0') then
              index_hit_count <= index_hit_count + 1;
              write_state <= sw_writing;
            end if;
                  
          when others =>
            write_state <= sw_idle;

        end case;
      end if;
    end if;
  end process write_process;

  ------------------------------
  -- Read Buffer Ready Process   
  ------------------------------
  read_ready_process : process(CLK)
  begin
    if ( rising_edge(CLK) ) then
      if (RESET = '1') then
        rbuf_ready_int <= '0';
      else
        if (rbuf_ready_set = '1') then
          rbuf_ready_int <= '1';
        elsif (rbuf_ready_clr = '1') then
          rbuf_ready_int <= '0';
        end if;
      end if;
    end if;
  end process read_ready_process;

  ------------------------------
  -- Read Control Processes for Graph Construction   
  ------------------------------
  read_process : process(CLK)
  begin
    if ( rising_edge(CLK) ) then
      if (RESET = '1') then
        rbuf_ready_clr <= '0';
        READ_DONE <= '0';
        raw_rd_addr <= (others => '0');
        raw_hit_count <= (others => '0');
        HIT_COUNT <= (others => '0');
        valid_data_r1 <= '0';
        read_state <= sr_idle;
        read_rtn_state <=sr_idle;
      else
        -- Data pipelines
        VALID_DATA <= valid_data_r1;
        hit_addr_r1 <= raw_addr_mux;
        hit_addr_r2 <= hit_addr_r1;

        --Default Assignments
        READ_DONE <= '0';
        rbuf_ready_clr <= '0';
        ibuf_ready_set <= '0';
              
        case(read_state) is
                
          when sr_idle =>
            HIT_COUNT <= (others => '0');
            if (RW_MODE = constructing and MODULE_RE = '1') then
              rbuf_ready_clr <= '1';
              READ_DONE <= '0';
              read_state <= sr_read_wait;
              read_rtn_state <= sr_read_index_0;
            else 
              read_state <= sr_idle;     
            end if;

          when sr_read_index_0 =>
            if (flag = '1') then
              raw_rd_addr <= index_dout(IndexRawAddrMSB downto IndexRawAddrLSB);
              raw_hit_count <= index_dout(IndexHitCountMSB downto IndexHitCountLSB);
              HIT_COUNT <= index_dout(IndexHitCountMSB downto IndexHitCountLSB);
              read_state <= sr_read_raw_0;
            else
              read_state <= sr_read_done;
            end if;

          when sr_read_raw_0 =>
            if (raw_hit_count > 0) then
              valid_data_r1 <= '1';
              raw_rd_addr <= raw_rd_addr + 1;
              raw_hit_count <= raw_hit_count - 1;
              read_state <= sr_read_raw_0;
            else
              read_state <= sr_read_done;
            end if;

          when sr_read_done =>
            -- Mark buffer ready for inferencing
            ibuf_ready_set <= '1';
            READ_DONE <= '1';
            valid_data_r1 <= '0';
            read_state <= sr_idle;

          when sr_read_wait =>
            read_state <= read_rtn_state;
                  
          when others =>
            read_state <= sr_idle;

        end case;
      end if;
    end if;
  end process read_process;

  ------------------------------
  -- Inference Buffer Ready Process   
  ------------------------------
  inference_ready_process : process(CLK)
  begin
    if ( rising_edge(CLK) ) then
      if (RESET = '1') then
        ibuf_ready_int <= '0';
      else
        if (ibuf_ready_set = '1') then
          ibuf_ready_int <= '1';
        elsif (ibuf_ready_clr = '1') then
          ibuf_ready_int <= '0';
        end if;
      end if;
    end if;
  end process inference_ready_process;

  ------------------------------
  -- Inference Control Processes
  ------------------------------
  inference_process : process(CLK)
  begin
    if ( rising_edge(CLK) ) then
      if (RESET = '1') then
        ibuf_ready_clr <= '0';
        wbuf_empty_set <= '0'; 
        iread_state <= ir_idle;
        iread_rtn_state <= ir_idle;
      else
        -- Data pipelines

        --Default Assignments
        ibuf_ready_clr <= '0';
        wbuf_empty_set <= '0'; 
              
        case(iread_state) is
                
          when ir_idle =>
            if (RW_MODE = inferencing) then
              ibuf_ready_clr <= '1';
              iread_state <= ir_read_wait;
              iread_rtn_state <= ir_read_raw_0;
            else 
              iread_state <= ir_idle;     
            end if;

          when ir_read_raw_0 =>
            if (IBUF_DONE = '1') then
              iread_state <= ir_read_done;
            else
              iread_state <= ir_read_raw_0;
            end if;

          when ir_read_done =>
            wbuf_empty_set <= '1'; 
            iread_state <= ir_idle;

          when ir_read_wait =>
            iread_state <= iread_rtn_state;
                  
          when others =>
            iread_state <= ir_idle;

        end case;
      end if;
    end if;
  end process inference_process;

  ------------------------------
  -- Flag Reset Processes    
  ------------------------------
  flag_reset_process : process(CLK)
  begin
    if ( rising_edge(CLK) ) then
      if (RESET = '1') then
        FLAG_RESET_DONE <= '0';
        flag_reset_addr <= (others => '0');
        flag_state <= sf_idle;
      else
        -- Data pipeline

        --Default Assignments
        
        case(flag_state) is
                
          when sf_idle =>
            if (FLAG_RESET = '1') then
              flag_state <= sf_reseting;
            else 
              flag_state <= sf_idle;     
            end if;
          
          when sf_reseting =>
            if(unsigned(flag_reset_addr) < FlagDepth-1) then
              flag_reset_addr <= flag_reset_addr + 1;
              flag_state <= sf_reseting;
            elsif (FLAG_RESET = '0') then
              FLAG_RESET_DONE <= '0';
              flag_reset_addr <= (others => '0');
              flag_state <= sf_idle;
            else
              FLAG_RESET_DONE <= '1';
            end if;

          when others =>
            flag_state <= sf_idle;

        end case;
      end if;
    end if;
  end process flag_reset_process;


end hit_buffer_arch;

