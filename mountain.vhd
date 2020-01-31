library IEEE;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned."+";
use IEEE.std_logic_unsigned."*";
use IEEE.std_logic_unsigned."/=";
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity Mountain is
  port (
    clk: in std_logic := '0';
    go: in std_logic := '0';
    start: in std_logic_vector(8 downto 0) := (others => '0');
    data: in data_t := ((others => '0'), (others => '0'));
    peak: out std_logic_vector(17 downto 0) := (others => '0');
    len: out std_logic_vector(7 downto 0) := (others => '0');
    finished: out std_logic := '0';
    addr: out std_logic_vector(8 downto 0) := (others => '0')
  );
end Mountain;

architecture Main of Mountain is
  signal height_reg: std_logic_vector(17 downto 0) := (others => '0');
  signal peak_reg: std_logic_vector(17 downto 0) := (others => '0');
  signal len_reg: std_logic_vector(7 downto 0) := (others => '0');
  signal prev_len_reg: std_logic_vector(7 downto 0) := (others => '0');
  signal valid: std_logic := '0';
  signal odd_start: std_logic_vector(9 downto 0) := (others => '0');

  constant ONE: std_logic_vector(17 downto 0) := "000000000000000001";

begin
  peak <= peak_reg;
  len <= len_reg;
  addr <= height_reg(9 downto 1);
  odd_start <= start & '1';

  process (clk)
  begin
    if rising_edge(clk) then
      valid <= nor_reduce(height_reg(17 downto 10));
      prev_len_reg <= len_reg;
    end if;
  end process;

  mountain: process (clk, go, start)
    variable current_height: std_logic_vector(17 downto 0) := (others => '0');
    variable current_peak: std_logic_vector(17 downto 0) := (others => '0');
    variable current_len: std_logic_vector(7 downto 0) := (others => '0');
    variable shift: std_logic_vector(4 downto 0) := (others => '0');
  begin
    if rising_edge(clk) then
      if go = '1' then
        current_height := "00000000" & odd_start;
        current_peak := (others => '0');
        current_len := (others => '0');
        finished <= '0';
      elsif current_height = ONE then
        finished <= '1';
      elsif valid = '1' and data.len /= 0 then
        current_height := ONE;

        if data.peak < peak_reg then
          current_peak := peak_reg;
        else
          current_peak := data.peak;
        end if;

        current_len := prev_len_reg + data.len;
      else
        if current_height(0) = '1' then
          if current_height(3 downto 0) = "1111" then
            current_height := std_logic_vector(to_unsigned((to_integer(unsigned(current_height * "000000000000011011")) + 19) / 8, 18));
            current_len := current_len + 6;
          elsif current_height(2 downto 0) = "111" then
            current_height := std_logic_vector(to_unsigned((to_integer(unsigned(current_height * "000000000000001001")) + 5) / 4, 18));
            current_len := current_len + 4;
          elsif current_height(1 downto 0) = "11" then
            current_height := std_logic_vector(to_unsigned((to_integer(unsigned(current_height * "000000000000000011")) + 1) / 2, 18));
            current_len := current_len + 2;
          end if;

          current_height := (current_height(16 downto 0) & '1') + current_height;
          current_len := current_len + "00000001";
          if current_peak < current_height then
            current_peak := current_height;
          end if;
        end if;

        for i in 17 downto 0 loop
          if current_height(i) = '1' then
            shift := std_logic_vector(to_unsigned(i, 5));
          end if;
        end loop;

        for i in 4 downto 0 loop
          if shift(i) = '1' then
            current_height := std_logic_vector(to_unsigned(0, 2 ** i)) & current_height(17 downto 2 ** i);
            current_len := current_len + 2 ** i;
          end if;
        end loop;
      end if;
    end if;

    height_reg <= current_height;
    peak_reg <= current_peak;
    len_reg <= current_len;
  end process;
end Main;
