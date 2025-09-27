library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity async_fifo_rtl_reset_sync is
  port (
    clk        : in    std_logic;
    async_rstn : in    std_logic;
    sync_rstn  : out   std_logic
  );
end entity async_fifo_rtl_reset_sync;

architecture rtl of async_fifo_rtl_reset_sync is

  signal sync_rstn_reg1 : std_logic;
  signal sync_rstn_reg2 : std_logic;

begin

  p_sync : process (async_rstn, clk) is
  begin

    if (async_rstn = '0') then
      sync_rstn_reg1 <= '0';
      sync_rstn_reg2 <= '0';
    elsif rising_edge(clk) then
      sync_rstn_reg1 <= '1';
      sync_rstn_reg2 <= sync_rstn_reg1;
    end if;

  end process p_sync;

  sync_rstn <= sync_rstn_reg2;

end architecture rtl;
