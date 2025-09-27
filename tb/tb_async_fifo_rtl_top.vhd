library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_async_fifo_rtl_top is
  generic (
    data_width : integer := 8;
    mem_depth  : integer := 3
  );
end entity tb_async_fifo_rtl_top;

architecture test of tb_async_fifo_rtl_top is

  component async_fifo_rtl_top is
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
  end component async_fifo_rtl_top;

  signal w_clk      : std_logic;
  signal r_clk      : std_logic;
  signal async_rstn : std_logic;
  signal w_en       : std_logic;
  signal r_en       : std_logic;
  signal w_data     : std_logic_vector(data_width - 1 downto 0);
  signal o_full     : std_logic;
  signal o_empty    : std_logic;
  signal r_data     : std_logic_vector(data_width - 1 downto 0);

begin

  async_fifo_rtl_top_inst : component async_fifo_rtl_top
    generic map (
      data_width => data_width,
      mem_depth  => mem_depth
    )
    port map (
      w_clk      => w_clk,
      r_clk      => r_clk,
      async_rstn => async_rstn,
      w_en       => w_en,
      r_en       => r_en,
      w_data     => w_data,
      o_full     => o_full,
      o_empty    => o_empty,
      r_data     => r_data
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
    wait for 7 ns;
    r_clk <= '1';
    wait for 7 ns;

  end process p_clk_gen_r;

  p_test : process is
  begin

    async_rstn <= '0';
    w_en       <= '0';
    r_en       <= '0';
    w_data     <= x"0F";
    wait for 37 ns;
    wait until falling_edge(w_clk);
    async_rstn <= '1';
    wait until falling_edge(w_clk);
    w_en       <= '1';
    wait until falling_edge(w_clk);
    w_data     <= x"F0";
    wait until falling_edge(w_clk);
    w_data     <= x"F0";
    wait until falling_edge(w_clk);
    w_data     <= x"AA";
    wait until falling_edge(w_clk);
    w_data     <= x"CC";
    wait until falling_edge(w_clk);
    w_data     <= x"11";
    wait until falling_edge(w_clk);
    w_data     <= x"55";
    wait until falling_edge(w_clk);
    w_data     <= x"FF";
    wait for 30 ns;
    w_en       <= '0';
    r_en       <= '1';
    wait for 200 ns;
    w_en       <= '1';
    wait for 700 ns;

    assert FALSE
      report "sim done"
      severity failure;

  end process p_test;

end architecture test;
