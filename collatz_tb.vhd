Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.ALL;

entity CollatzTb is
end CollatzTb;

architecture Main of CollatzTb is
  component Collatz port (
    clk: in std_logic;
    reset: in std_logic;
    start: in std_logic_vector(9 downto 0);
    peak: out std_logic_vector(17 downto 0);
    len: out std_logic_vector(7 downto 0);
    continue: out std_logic
  );
  end component;

  signal clk: std_logic;
  signal reset: std_logic;
  signal start: std_logic_vector(9 downto 0);
  signal peak: std_logic_vector(17 downto 0);
  signal len: std_logic_vector(7 downto 0);
  signal continue: std_logic;

  begin
    u0: Collatz port map (
      clk => clk,
      reset => reset,
      start => start,
      peak => peak,
      len => len,
      continue => continue
    );
  process
  begin
    wait for 1 ns;
    for i in 1 to 1023 loop
      report "executing" & integer'image(i);
      reset <= '1';
      start <= std_logic_vector(to_unsigned(i, 10));
      clk <= '0';
      wait for 1 ns;
      reset <= '0';

      while continue = '1' loop
        clk <= not clk;
        wait for 1 ns;
      end loop;

      report "result for " & integer'image(i);
      report "  peak: " & integer'image(to_integer(unsigned(peak)));
      report "  len: " & integer'image(to_integer(unsigned(len)));
    end loop;
    wait;
  end process;
end Main;
