library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity async_fifo_rtl_bin_to_gray is
  generic (
    mem_depth : integer := 3
  );
  port (
    rstn        : in    std_logic;
    addr_binary : in    std_logic_vector(mem_depth downto 0);
    addr_gray   : out   std_logic_vector(mem_depth downto 0)
  );
end entity async_fifo_rtl_bin_to_gray;

architecture rtl of async_fifo_rtl_bin_to_gray is

  signal addr_gray_reg : std_logic_vector(mem_depth downto 0);

begin

  p_bin_to_gray : process (addr_binary, rstn) is
  begin

    if (rstn = '0') then
      addr_gray_reg <= (others => '0');
    else
      addr_gray_reg <= addr_binary xor ('0' & addr_binary(mem_depth downto 1));
    end if;

  end process p_bin_to_gray;

  addr_gray <= addr_gray_reg;

end architecture rtl;
