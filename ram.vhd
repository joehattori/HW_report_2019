library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity RAM is
  port (
    clk: in std_logic := '0';
    addr: in std_logic_vector(8 downto 0) := (others => '0');
    writable: in std_logic := '0';
    data_in: in data_t := ((others => '0'), (others => '0'));
    data_out: out data_t := ((others => '0'), (others => '0'))
  );
end RAM;

architecture Main of RAM is
  signal ram_reg: ram_data_t := (others => ((others => '0'), (others => '0')));

begin
  data_out <= ram_reg(to_integer(unsigned(addr)));

  process(clk)
  begin
    if rising_edge(clk) then
      if writable = '1' then
        ram_reg(to_integer(unsigned(addr))) <= data_in;
      end if;
    end if;
  end process;
end Main;
