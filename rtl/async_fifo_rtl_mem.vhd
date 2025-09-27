library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity async_fifo_rtl_mem is
  generic (
    data_width : integer := 8;
    mem_depth  : integer := 3
  );
  port (
    rst_n         : in    std_logic; -- SEMATIKTE YOK
    w_clk         : in    std_logic;
    r_clk         : in    std_logic;
    fifo_full     : in    std_logic;
    fifo_empty    : in    std_logic;
    w_data        : in    std_logic_vector(data_width - 1 downto 0);
    w_addr_binary : in    std_logic_vector(mem_depth downto 0);
    r_addr_binary : in    std_logic_vector(mem_depth downto 0);
    r_data        : out   std_logic_vector(data_width - 1 downto 0)
  );
end entity async_fifo_rtl_mem;

architecture rtl of async_fifo_rtl_mem is

  type ram_type is array (0 to 2 ** mem_depth - 1) of std_logic_vector(data_width - 1 downto 0);

  signal fifo_mem   : ram_type;
  signal r_data_reg : std_logic_vector(data_width - 1 downto 0); -- (others => '0') yapmak sentez icin onerilmiyormus

begin

  --------------------------------------------
  --         ASYNC WRITE PROCESS            --
  --------------------------------------------
  p_write : process (w_clk) is
  begin

    if (rst_n = '0') then
      fifo_mem <= (others => x"00");
    elsif rising_edge(w_clk) then
      if (fifo_full = '0') then
        fifo_mem(TO_INTEGER(UNSIGNED(w_addr_binary(mem_depth - 1 downto 0)))) <= w_data;
      end if;
    end if;

  end process p_write;

  -------------------------------------------
  --         ASYNC READ PROCESS            --
  -------------------------------------------
  p_read : process (r_clk) is
  begin

    if (rst_n = '0') then
      r_data_reg <= (others => '0');
    elsif rising_edge(r_clk) then
      --   if (rst_n = '0') then yukarda yapildi zaten
      --     fifo_mem <= (others => x"00");
      if (fifo_empty = '0') then
        r_data_reg <= fifo_mem(TO_INTEGER(UNSIGNED(r_addr_binary(mem_depth - 1 downto 0))));
      end if;
    end if;

  end process p_read;

  r_data <= r_data_reg;

end architecture rtl;
