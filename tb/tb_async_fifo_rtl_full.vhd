library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_async_fifo_rtl_full is
  generic (
    mem_depth : integer := 3
  );
end entity tb_async_fifo_rtl_full;

architecture rtl of tb_async_fifo_rtl_full is

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

  signal w_clk                : std_logic;
  signal rstn                 : std_logic;
  signal w_en                 : std_logic;
  signal r_domainq2_addr_gray : std_logic_vector(mem_depth downto 0);
  signal w_addr_binary        : std_logic_vector(mem_depth downto 0);
  signal o_full               : std_logic;

begin

  dut : component async_fifo_rtl_full
    generic map (
      mem_depth => mem_depth
    )
    port map (
      w_clk                => w_clk,
      rstn                 => rstn,
      w_en                 => w_en,
      r_domainq2_addr_gray => r_domainq2_addr_gray,
      w_addr_binary        => w_addr_binary,
      o_full               => o_full
    );

  p_w_clk_gen : process is
  begin

    w_clk <= '0';
    wait for 5 ns;
    w_clk <= '1';
    wait for 5 ns;

  end process p_w_clk_gen;

  p_test : process is
  begin

    w_en                 <= '0';
    r_domainq2_addr_gray <= (others => '0');
    rstn                 <= '0';
    wait until falling_edge(w_clk);
    rstn                 <= '1';
    w_en                 <= '1';
    wait for 200 ns;
    r_domainq2_addr_gray <= "0001";
    wait for 20 ns;
    w_en                 <= '0';
    wait for 50 ns;
    assert false
      report "sim dome"
      severity FAILURE;

  end process p_test;

end architecture rtl;
