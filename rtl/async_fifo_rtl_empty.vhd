library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity async_fifo_rtl_empty is
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
end entity async_fifo_rtl_empty;

architecture rtl of async_fifo_rtl_empty is

  signal r_addr_binary_next : std_logic_vector(mem_depth downto 0);
  signal w_addr_gray_next   : std_logic_vector(mem_depth downto 0);
  signal r_addr_binary_reg  : std_logic_vector(mem_depth downto 0);
  signal o_empty_reg        : std_logic;

begin

  r_addr_binary_next <= STD_LOGIC_VECTOR(UNSIGNED(r_addr_binary) + (r_en and (not o_empty_reg)));
  w_addr_gray_next   <= r_addr_binary_next xor ('0' & r_addr_binary_next(mem_depth downto 1));

  p_full : process (r_clk) is
  begin

    if (rstn = '0') then
      r_addr_binary_reg <= (others => '0');
      o_empty_reg       <= '0';
    elsif (rising_edge(r_clk) and r_en = '1') then
      r_addr_binary_reg <= r_addr_binary_next;
      if (w_domainq2_addr_gray = w_addr_gray_next) then
        o_empty_reg <= '1';
      else
        o_empty_reg <= '0';
      end if;
    end if;

  end process p_full;

  o_empty       <= o_empty_reg;
  r_addr_binary <= r_addr_binary_reg;

end architecture rtl;
