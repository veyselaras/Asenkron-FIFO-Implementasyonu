library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity async_fifo_rtl_top is
  generic (
    data_width : integer := 8;
    mem_depth  : integer := 3
  );
  port (
    w_clk      : in    std_logic;
    r_clk      : in    std_logic;
    async_rstn : in    std_logic;
    w_en       : in    std_logic;
    r_en       : in    std_logic;
    w_data     : in    std_logic_vector(data_width - 1 downto 0);
    o_full     : out   std_logic;
    o_empty    : out   std_logic;
    r_data     : out   std_logic_vector(data_width - 1 downto 0)
  );
end entity async_fifo_rtl_top;

architecture rtl of async_fifo_rtl_top is

  component async_fifo_rtl_reset_sync is
    port (
      clk        : in    std_logic;
      async_rstn : in    std_logic;
      sync_rstn  : out   std_logic
    );
  end component async_fifo_rtl_reset_sync;

  signal w_rstn : std_logic;
  signal r_rstn : std_logic;

  component async_fifo_rtl_mem is
    generic (
      data_width : integer := 8;
      mem_depth  : integer := 3
    );
    port (
      rst_n         : in    std_logic;
      w_clk         : in    std_logic;
      r_clk         : in    std_logic;
      fifo_full     : in    std_logic;
      fifo_empty    : in    std_logic;
      w_data        : in    std_logic_vector(data_width - 1 downto 0);
      w_addr_binary : in    std_logic_vector(mem_depth downto 0);
      r_addr_binary : in    std_logic_vector(mem_depth downto 0);
      r_data        : out   std_logic_vector(data_width - 1 downto 0)
    );
  end component async_fifo_rtl_mem;

  -- signal w_clk         :std_logic;
  -- signal r_clk         :std_logic;
  --   signal fifo_full  : std_logic;
  --   signal fifo_empty : std_logic;
  -- signal w_data        :std_logic_vector(data_width - 1 downto 0);
  signal w_addr_binary : std_logic_vector(mem_depth downto 0);
  signal r_addr_binary : std_logic_vector(mem_depth downto 0);
  -- signal r_data        :std_logic_vector(data_width - 1 downto 0)

  component async_fifo_rtl_full is
    generic (
      mem_depth : integer := 3
    );
    port (
      w_clk                : in    std_logic;
      rstn                 : in    std_logic;
      w_en                 : in    std_logic;
      r_domainq2_addr_gray : in    std_logic_vector(mem_depth downto 0);
      w_addr_binary        : out   std_logic_vector(mem_depth downto 0);
      o_full               : out   std_logic
    );
  end component async_fifo_rtl_full;

  signal r_domainq2_addr_gray : std_logic_vector(mem_depth downto 0);

  component async_fifo_rtl_empty is
    generic (
      mem_depth : integer := 3
    );
    port (
      r_clk                : in    std_logic;
      rstn                 : in    std_logic;
      r_en                 : in    std_logic;
      w_domainq2_addr_gray : in    std_logic_vector(mem_depth downto 0);
      r_addr_binary        : out   std_logic_vector(mem_depth downto 0);
      o_empty              : out   std_logic
    );
  end component async_fifo_rtl_empty;

  signal w_domainq2_addr_gray : std_logic_vector(mem_depth downto 0);

  component async_fifo_rtl_gray_sync is
    generic (
      mem_depth : integer := 3
    );
    port (
      w_clk                : in    std_logic;
      r_clk                : in    std_logic;
      rstn                 : in    std_logic;
      w_addr_binary        : in    std_logic_vector(mem_depth downto 0);
      r_addr_binary        : in    std_logic_vector(mem_depth downto 0);
      r_domain_w_addr_gray : out   std_logic_vector(mem_depth downto 0);
      w_domain_r_addr_gray : out   std_logic_vector(mem_depth downto 0)
    );
  end component async_fifo_rtl_gray_sync;

begin

  async_fifo_rtl_reset_sync_inst_w : component async_fifo_rtl_reset_sync
    port map (
      clk        => w_clk,
      async_rstn => async_rstn,
      sync_rstn  => w_rstn
    );

  async_fifo_rtl_reset_sync_inst_r : component async_fifo_rtl_reset_sync
    port map (
      clk        => r_clk,
      async_rstn => async_rstn,
      sync_rstn  => r_rstn
    );

  async_fifo_rtl_mem_inst : component async_fifo_rtl_mem
    generic map (
      data_width => data_width,
      mem_depth  => mem_depth
    )
    port map (
      rst_n         => async_rstn,
      w_clk         => w_clk,
      r_clk         => r_clk,
      fifo_full     => o_full,
      fifo_empty    => o_empty,
      w_data        => w_data,
      w_addr_binary => w_addr_binary,
      r_addr_binary => r_addr_binary,
      r_data        => r_data
    );

  async_fifo_rtl_full_inst : component async_fifo_rtl_full
    generic map (
      mem_depth => mem_depth
    )
    port map (
      w_clk                => w_clk,
      rstn                 => w_rstn,
      w_en                 => w_en,
      r_domainq2_addr_gray => r_domainq2_addr_gray,
      w_addr_binary        => w_addr_binary,
      o_full               => o_full
    );

  async_fifo_rtl_empty_inst : component async_fifo_rtl_empty
    generic map (
      mem_depth => mem_depth
    )
    port map (
      r_clk                => r_clk,
      rstn                 => r_rstn,
      r_en                 => r_en,
      w_domainq2_addr_gray => w_domainq2_addr_gray,
      r_addr_binary        => r_addr_binary,
      o_empty              => o_empty
    );

  async_fifo_rtl_gray_sync_inst : component async_fifo_rtl_gray_sync
    generic map (
      mem_depth => mem_depth
    )
    port map (
      w_clk                => w_clk,
      r_clk                => r_clk,
      rstn                 => async_rstn,
      w_addr_binary        => w_addr_binary,
      r_addr_binary        => r_addr_binary,
      r_domain_w_addr_gray => w_domainq2_addr_gray,
      w_domain_r_addr_gray => r_domainq2_addr_gray
    );

end architecture rtl;
