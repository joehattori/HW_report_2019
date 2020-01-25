library IEEE;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_1164.all;
use work.types.all;

entity Collatz is
  port (
    clk: in std_logic;
    clk_count: out std_logic_vector(31 downto 0) := (others => '0');
    top4: out top4_t := (others => ((others => '0'), (others => '0'), (others => '0')));
    all_finished: out std_logic := '0'
  );
end Collatz;

architecture Main of Collatz is
  component Mountain is
    port (
      clk: in std_logic;
      go: in std_logic;
      start: in std_logic_vector(9 downto 0);
      peak: out std_logic_vector(17 downto 0);
      len: out std_logic_vector(7 downto 0);
      continue: out std_logic
    );
  end component;

  component Sorter is
    port (
      clk: in std_logic;
      new_result: in result_t;
      top4: out top4_t
    );
  end component;

  signal clk_count_sig: std_logic_vector(31 downto 0) := (others => '0');
  signal all_finished_sig: std_logic := '0';
  signal go: std_logic := '1';
  signal start: std_logic_vector(8 downto 0) := (others => '0');
  signal peak: std_logic_vector(17 downto 0) := (others => '0');
  signal len: std_logic_vector(7 downto 0) := (others => '0');
  signal continue: std_logic := '1';

  signal odd_start: std_logic_vector(9 downto 0) := (others => '0');

  signal result_sig: result_t := ((others => '0'), (others => '0'), (others => '0'));

begin
  mountain_i: Mountain port map (
    clk => clk,
    go => go,
    start => odd_start,
    peak => peak,
    len => len,
    continue => continue
  );

  sorter_i: Sorter port map (
    clk => clk,
    new_result => result_sig,
    top4 => top4
  );

  clk_count <= clk_count_sig;
  odd_start <= start & '1';

  process (clk, all_finished_sig)
  begin
    if rising_edge(clk) and all_finished_sig = '0' then
      clk_count_sig <= clk_count_sig + 1;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if (continue = '0' and all_finished_sig = '0') then
        result_sig <= (start & '1', peak, len);
        start <= start + 1;

        if start >= 511 then
          all_finished <= '1';
        else
          go <= '1';
        end if;
      else
        go <= '0';
      end if;
    end if;
  end process;
end Main;
