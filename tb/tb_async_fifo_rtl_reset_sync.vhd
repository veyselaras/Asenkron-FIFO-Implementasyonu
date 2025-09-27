library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_async_fifo_rtl_reset_sync is
end entity tb_async_fifo_rtl_reset_sync;

architecture test of tb_async_fifo_rtl_reset_sync is

  component async_fifo_rtl_reset_sync is
    port (
      clk        : in    std_logic;
      async_rstn : in    std_logic;
      sync_rstn  : out   std_logic
    );
  end component async_fifo_rtl_reset_sync;

  signal clk        : std_logic;
  signal async_rstn : std_logic;
  signal sync_rstn  : std_logic;

begin

  async_fifo_rtl_reset_sync_inst : component async_fifo_rtl_reset_sync
    port map (
      clk        => clk,
      async_rstn => async_rstn,
      sync_rstn  => sync_rstn
    );

  p_clk_gen : process is
  begin

    clk <= '0';
    wait for 6 ns;
    clk <= '1';
    wait for 6 ns;

  end process p_clk_gen;

  p_test : process is
  begin

    async_rstn <= '0';
    wait for 33 ns;
    async_rstn <= '1';
    wait for 60 ns;
    assert FALSE
      report "sim done"
      severity failure;

  end process p_test;

end architecture test;
