Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned."+";
use IEEE.std_logic_unsigned."*";
use IEEE.numeric_std.ALL;

entity Collatz is
  port (
    clk: in std_logic;
    reset: in std_logic;
    start: in std_logic_vector(9 downto 0);
    peak: out std_logic_vector(17 downto 0);
    len: out std_logic_vector(7 downto 0);
    continue: out std_logic
  );
end Collatz;

architecture Main of Collatz is
  signal current_height: std_logic_vector(17 downto 0);
  signal current_peak: std_logic_vector(17 downto 0);
  signal current_len: std_logic_vector(7 downto 0);

  constant THREE_18: std_logic_vector(17 downto 0) := "000000000000000011";
  constant ZERO_8: std_logic_vector(7 downto 0) := "00000000";
  constant ONE_8: std_logic_vector(7 downto 0) := "00000001";
  constant ONE_18: std_logic_vector(17 downto 0) := "000000000000000001";

  function half(num: std_logic_vector) return std_logic_vector is
  begin
    return '0' & num(17 downto 1);
  end function;

  begin
  Climb: process (clk, reset, start)
  begin
    if reset = '1' then
      current_height <= ZERO_8 & start;
      current_peak <= ZERO_8 & start;
      current_len <= ZERO_8;
      continue <= '1';
    elsif clk'event and clk = '1' then
      if current_height = ONE_18 then
        continue <= '0';
      else
        if current_height(0) = '0' then
          current_height <= '0' & current_height(17 downto 1);
        else
          current_height <= std_logic_vector(to_unsigned(to_integer(unsigned(current_height * THREE_18)) + 1, 18));
        end if;

        if current_height > current_peak then
          current_peak <= current_height;
        end if;

        current_len <= current_len + ONE_8;
      end if;
    end if;

    peak <= current_peak;
    len <= current_len;
  end process;
end Main;
