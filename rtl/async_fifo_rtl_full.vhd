library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity async_fifo_rtl_full is
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
end entity async_fifo_rtl_full;

architecture rtl of async_fifo_rtl_full is

  signal w_addr_binary_reg  : std_logic_vector(mem_depth  downto 0);
  signal w_addr_binary_next : std_logic_vector(mem_depth  downto 0);
  signal w_gray_addr_next   : std_logic_vector(mem_depth  downto 0);
  signal o_full_reg         : std_logic;

begin

  w_addr_binary_next <= STD_LOGIC_VECTOR(UNSIGNED(w_addr_binary) + (w_en and (not o_full_reg)));
  w_gray_addr_next   <= w_addr_binary_next xor ('0' & w_addr_binary_next(mem_depth downto 1));

  p_full : process (w_clk) is
  begin

    if (rstn = '0') then
      w_addr_binary_reg <= (others => '0');
      o_full_reg        <= '0';
    elsif (rising_edge(w_clk) and w_en = '1') then
      w_addr_binary_reg <= w_addr_binary_next;
      if (w_gray_addr_next = (not r_domainq2_addr_gray(mem_depth downto mem_depth - 1)
                              & r_domainq2_addr_gray(mem_depth - 2 downto 0))) then
        o_full_reg <= '1';
      else
        o_full_reg <= '0';
      end if;
    end if;

  end process p_full;

  o_full        <= o_full_reg;
  w_addr_binary <= w_addr_binary_reg;

end architecture rtl;
