library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_async_fifo_rtl_empty is
  generic (
    mem_depth : integer := 3
  );
end entity tb_async_fifo_rtl_empty;

architecture rtl of tb_async_fifo_rtl_empty is

  component async_fifo_rtl_empty is
    generic (
      mem_depth : integer := 8
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

  signal r_clk                : std_logic;
  signal rstn                 : std_logic;
  signal r_en                 : std_logic;
  signal w_domainq2_addr_gray : std_logic_vector(mem_depth downto 0);
  signal r_addr_binary        : std_logic_vector(mem_depth downto 0);
  signal o_empty              : std_logic;

begin

  dut : component async_fifo_rtl_empty
    generic map (
      mem_depth => mem_depth
    )
    port map (
      r_clk                => r_clk,
      rstn                 => rstn,
      r_en                 => r_en,
      w_domainq2_addr_gray => w_domainq2_addr_gray,
      r_addr_binary        => r_addr_binary,
      o_empty              => o_empty

    );

  p_clk_gen : process is
  begin

    r_clk <= '0';
    wait for 6 ns;
    r_clk <= '1';
    wait for 6 ns;

  end process p_clk_gen;

  p_test : process is
  begin

    r_en                 <= '0';
    w_domainq2_addr_gray <= "0000";
    rstn                 <= '0';
    wait for 50 ns;
    rstn                 <= '1';
    wait for 20 ns;
    r_en                 <= '1';
    wait until rising_edge(r_clk);
    w_domainq2_addr_gray <= "1100";
    wait for 200 ns;
    assert FALSE
      report "sim done"
      severity FAILURE;

  end process p_test;

end architecture rtl;
