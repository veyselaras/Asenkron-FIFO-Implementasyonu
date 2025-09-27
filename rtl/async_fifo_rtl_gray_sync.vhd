library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity async_fifo_rtl_gray_sync is
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
end entity async_fifo_rtl_gray_sync;

architecture rtl of async_fifo_rtl_gray_sync is

  component async_fifo_rtl_bin_to_gray is
    generic (
      mem_depth : integer := 3
    );
    port (
      rstn        : in    std_logic;
      addr_binary : in    std_logic_vector(mem_depth downto 0);
      addr_gray   : out   std_logic_vector(mem_depth downto 0)
    );
  end component async_fifo_rtl_bin_to_gray;

  signal r_addr_gray              : std_logic_vector(mem_depth downto 0);
  signal w_addr_gray              : std_logic_vector(mem_depth downto 0);
  signal two_ff_sync_for_wdomain1 : std_logic_vector(mem_depth downto 0);
  signal two_ff_sync_for_wdomain2 : std_logic_vector(mem_depth downto 0); -- buyuk kisim cikacak olan
  signal two_ff_sync_for_rdomain1 : std_logic_vector(mem_depth downto 0);
  signal two_ff_sync_for_rdomain2 : std_logic_vector(mem_depth downto 0); -- buyuk kisim cikacak olan
  signal r_domain_w_addr_gray_reg : std_logic_vector(mem_depth downto 0); -- buyuk kisim cikacak olan
  signal w_domain_r_addr_gray_reg : std_logic_vector(mem_depth downto 0); -- buyuk kisim cikacak olan

begin

  ins_for_empty_control : component async_fifo_rtl_bin_to_gray
    generic map (
      mem_depth => mem_depth
    )
    port map (
      rstn        => rstn,
      addr_binary => r_addr_binary,
      addr_gray   => r_addr_gray
    );

  ins_for_full_control : component async_fifo_rtl_bin_to_gray
    generic map (
      mem_depth => mem_depth
    )
    port map (
      rstn        => rstn,
      addr_binary => w_addr_binary,
      addr_gray   => w_addr_gray
    );

  full_control : process (w_clk) is
  begin

    if (rstn = '0') then
      two_ff_sync_for_wdomain1 <= (others => '0');
      two_ff_sync_for_wdomain2 <= (others => '0');
      w_domain_r_addr_gray_reg <= (others => '0');
    elsif rising_edge(w_clk) then
      two_ff_sync_for_wdomain2 <= two_ff_sync_for_wdomain1;
      two_ff_sync_for_wdomain1 <= r_addr_gray;
      w_domain_r_addr_gray_reg <= two_ff_sync_for_wdomain2;
    end if;

  end process full_control;

  empty_control : process (r_clk) is
  begin

    if (rstn = '0') then
      --   fifo_empty_reg           <= '1';
      two_ff_sync_for_rdomain1 <= (others => '0');
      two_ff_sync_for_rdomain2 <= (others => '0');
      r_domain_w_addr_gray_reg <= (others => '0');
    elsif rising_edge(r_clk) then
      two_ff_sync_for_rdomain2 <= two_ff_sync_for_rdomain1;
      two_ff_sync_for_rdomain1 <= w_addr_gray;
      r_domain_w_addr_gray_reg <= two_ff_sync_for_rdomain2;
    end if;

  end process empty_control;

  r_domain_w_addr_gray <= r_domain_w_addr_gray_reg;
  w_domain_r_addr_gray <= w_domain_r_addr_gray_reg;

end architecture rtl;
