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
        if shift(4) = '1' then
          current_height := "0000000000000000" & current_height(17 downto 16);
          current_len := current_len + "00010000";
        end if;
        if shift(3) = '1' then
          current_height := "00000000" & current_height(17 downto 8);
          current_len := current_len + "00001000";
        end if;
        if shift(2) = '1' then
          current_height := "0000" & current_height(17 downto 4);
          current_len := current_len + "00000100";
        end if;
        if shift(1) = '1' then
          current_height := "00" & current_height(17 downto 2);
          current_len := current_len + "00000010";
        end if;
        if shift(0) = '1' then
          current_height := "0" & current_height(17 downto 1);
          current_len := current_len + "00000001";
        end if;
      end if;
    end if;

    height_reg <= current_height;
    peak_reg <= current_peak;
    len_reg <= current_len;
  end process;
end Main;
