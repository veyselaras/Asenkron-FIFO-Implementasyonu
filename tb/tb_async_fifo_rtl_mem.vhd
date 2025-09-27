library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_async_fifo_rtl_mem is
  generic (
    data_width : integer := 8;
    mem_depth  : integer := 3
  );
end entity tb_async_fifo_rtl_mem;

architecture test of tb_async_fifo_rtl_mem is

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

  signal rst_n         : std_logic; -- SEMATIKTE YOK
  signal w_clk         : std_logic;
  signal r_clk         : std_logic;
  signal fifo_full     : std_logic;
  signal fifo_empty    : std_logic;
  signal w_data        : std_logic_vector(data_width - 1 downto 0);
  signal w_addr_binary : std_logic_vector(mem_depth downto 0);
  signal r_data        : std_logic_vector(data_width - 1 downto 0);
  signal r_addr_binary : std_logic_vector(mem_depth downto 0);

begin

  async_fifo_rtl_mem_inst : component async_fifo_rtl_mem
    generic map (
      data_width => data_width,
      mem_depth  => mem_depth
    )
    port map (
      rst_n         => rst_n,
      w_clk         => w_clk,
      r_clk         => r_clk,
      fifo_full     => fifo_full,
      fifo_empty    => fifo_empty,
      w_data        => w_data,
      w_addr_binary => w_addr_binary,
      r_addr_binary => r_addr_binary,
      r_data        => r_data
    );

  p_clk_gen_w : process is
  begin

    w_clk <= '0';
    wait for 5 ns;
    w_clk <= '1';
    wait for 5 ns;

  end process p_clk_gen_w;

  p_clk_gen_r : process is
  begin

    r_clk <= '0';
    wait for 6 ns;
    r_clk <= '1';
    wait for 6 ns;

  end process p_clk_gen_r;

  p_test : process is
  begin

    rst_n         <= '0';
    fifo_full     <= '0';
    fifo_empty    <= '1';
    w_data        <= x"AA";
    w_addr_binary <= x"0";
    r_addr_binary <= x"0";
    wait for 30 ns;
    rst_n         <= '1';
    wait until falling_edge(w_clk);
    w_data        <= x"BB";
    w_addr_binary <= x"1";
    wait until falling_edge(w_clk);
    w_data        <= x"CC";
    w_addr_binary <= x"2";
    wait until falling_edge(w_clk);
    fifo_empty    <= '0';
    wait until falling_edge(r_clk);
    r_addr_binary <= x"1";
    wait until falling_edge(w_clk);
    w_data        <= x"FF";
    w_addr_binary <= x"3";
    wait until falling_edge(r_clk);
    r_addr_binary <= x"2";
    wait until falling_edge(r_clk);
    r_addr_binary <= x"3";
    wait for 30 ns;

    assert FALSE
      report "sim done"
      severity FAILURE;

  end process p_test;

end architecture test;
