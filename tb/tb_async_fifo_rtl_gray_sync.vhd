library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_async_fifo_rtl_gray_sync is
  generic (
    mem_depth : integer := 3
  );
end entity tb_async_fifo_rtl_gray_sync;

architecture test of tb_async_fifo_rtl_gray_sync is

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

  signal w_clk                : std_logic;
  signal r_clk                : std_logic;
  signal rstn                 : std_logic;
  signal w_addr_binary        : std_logic_vector(mem_depth downto 0);
  signal r_addr_binary        : std_logic_vector(mem_depth downto 0);
  signal r_domain_w_addr_gray : std_logic_vector(mem_depth downto 0);
  signal w_domain_r_addr_gray : std_logic_vector(mem_depth downto 0);

begin

  dut : component async_fifo_rtl_gray_sync
    generic map (
      mem_depth => mem_depth
    )
    port map (
      w_clk                => w_clk,
      r_clk                => r_clk,
      rstn                 => rstn,
      w_addr_binary        => w_addr_binary,
      r_addr_binary        => r_addr_binary,
      r_domain_w_addr_gray => r_domain_w_addr_gray,
      w_domain_r_addr_gray => w_domain_r_addr_gray
    );

  p_clkgen_w : process is
  begin

    w_clk <= '0';
    wait for 5 ns;
    w_clk <= '1';
    wait for 5 ns;

  end process p_clkgen_w;

  p_clkgen_r : process is
  begin

    r_clk <= '0';
    wait for 7.5 ns;
    r_clk <= '1';
    wait for 7.5 ns;

  end process p_clkgen_r;

  p_test : process is
  begin

    w_addr_binary <= (others => '0');
    r_addr_binary <= (others => '0');
    rstn          <= '0';
    wait for 30 ns;
    rstn          <= '1';
    wait until falling_edge(w_clk);
    wait until falling_edge(w_clk);
    wait until falling_edge(w_clk);
    w_addr_binary <= STD_LOGIC_VECTOR(unsigned(w_addr_binary) + 1);
    wait until falling_edge(w_clk);
    w_addr_binary <= STD_LOGIC_VECTOR(unsigned(w_addr_binary) + 1);
    -- wait until falling_edge(r_clk);
    -- r_addr_binary <= STD_LOGIC_VECTOR(unsigned(r_addr_binary) + 1);
    wait until falling_edge(w_clk);
    w_addr_binary <= STD_LOGIC_VECTOR(unsigned(w_addr_binary) + 1);
    wait until falling_edge(w_clk);
    w_addr_binary <= STD_LOGIC_VECTOR(unsigned(w_addr_binary) + 1);
    -- wait until falling_edge(r_clk);
    -- r_addr_binary <= STD_LOGIC_VECTOR(unsigned(r_addr_binary) + 1);
    wait until falling_edge(w_clk);
    w_addr_binary <= STD_LOGIC_VECTOR(unsigned(w_addr_binary) + 1);
    -- wait until falling_edge(r_clk);
    -- r_addr_binary <= STD_LOGIC_VECTOR(unsigned(r_addr_binary) + 1);

    for i in 0 to 100 loop

      wait until falling_edge(w_clk);
      w_addr_binary <= STD_LOGIC_VECTOR(unsigned(w_addr_binary) + 1);

    end loop;

    wait for 30 ns;
    assert false
      report "sim dome"
      severity FAILURE;

  end process p_test;

end architecture test;
