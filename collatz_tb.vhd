library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use work.types.all;

entity CollatzTb is
end CollatzTb;

architecture Main of CollatzTb is
  component Collatz is
    port (
      clk: in std_logic;
      clk_count: out std_logic_vector(31 downto 0) := (others => '0');
      top4: out top4_t;
      all_finished: out std_logic
    );
  end component;

  signal clk: std_logic;
  signal clk_count: std_logic_vector(31 downto 0) := (others => '0');
  signal top4: top4_t := (others => ((others => '0'), (others => '0'), (others => '0')));
  signal all_finished: std_logic := '0';
  signal finished: std_logic := '0';
  signal printed: std_logic := '0';

begin
  main: Collatz port map (
    clk => clk,
    clk_count => clk_count,
    top4 => top4,
    all_finished => all_finished
  );

  clock: process
  begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
  end process;

  print: process(clk)
  begin
    if rising_edge(clk) and all_finished = '1' and finished = '0' then
      finished <= '1';
    end if;

    if finished = '1' and printed = '0' then
      printed <= '1';
      report "results";
      report "It took " & integer'image(to_integer(unsigned(clk_count))) & " clocks";

      for i in 0 to 3 loop
        report "Start: " & integer'image(to_integer(unsigned(top4(i).start)));
        report " peak: " & integer'image(to_integer(unsigned(top4(i).peak)));
        report " len: " & integer'image(to_integer(unsigned(top4(i).len)));
      end loop;
    end if;
  end process;
end Main;
