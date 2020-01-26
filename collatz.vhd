library IEEE;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned."+";
use IEEE.std_logic_unsigned."*";
use IEEE.std_logic_unsigned."-";
use IEEE.std_logic_unsigned."<";
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity Collatz is
  port (
    clk: in std_logic := '0';
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
      data: in data_t;
      peak: out std_logic_vector(17 downto 0);
      len: out std_logic_vector(7 downto 0);
      finished: out std_logic;
      addr: out std_logic_vector(8 downto 0)
    );
  end component;

  component Sorter is
    port (
      clk: in std_logic;
      new_result: in result_t;
      top4: out top4_t
    );
  end component;

  component RAM is
    port (
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      writable: in std_logic;
      data_in: in data_t;
      data_out: out data_t
    );
  end component;

  signal clk_count_reg: std_logic_vector(31 downto 0) := (others => '0');
  signal all_finished_reg: std_logic := '0';
  signal go: std_logic := '1';
  signal start: std_logic_vector(8 downto 0) := (others => '0');
  signal odd_start: std_logic_vector(9 downto 0) := "0000000001";
  signal peak: std_logic_vector(17 downto 0) := (others => '0');
  signal len: std_logic_vector(7 downto 0) := (others => '0');
  signal finished: std_logic_vector(1 downto 0) := (others => '0');

  signal result_reg: result_t := ((others => '0'), (others => '0'), (others => '0'));
  signal addr: std_logic_vector(8 downto 0) := (others => '0');
  signal addr_ram: std_logic_vector(8 downto 0) := (others => '0');

  signal writable: std_logic := '0';
  signal data_in: data_t := ((others => '0'), (others => '0'));
  signal data_out: data_t := ((others => '0'), (others => '0'));

begin
  mountain_i: Mountain port map (
    clk => clk,
    go => go,
    start => odd_start,
    data => data_out,
    peak => peak,
    len => len,
    finished => finished(0),
    addr => addr
  );

  sorter_i: Sorter port map (
    clk => clk,
    new_result => result_reg,
    top4 => top4
  );

  ram_i: RAM port map (
    clk => clk,
    addr => addr_ram,
    writable => writable,
    data_in => data_in,
    data_out => data_out
  );

  clk_count <= clk_count_reg;
  odd_start <= start & '1';
  all_finished <= all_finished_reg;

  process (clk, all_finished_reg)
  begin
    if rising_edge(clk) and all_finished_reg = '0' then
      clk_count_reg <= clk_count_reg + 1;
    end if;
  end process;

  process (clk)
    variable next_start: std_logic_vector(8 downto 0) := (others => '0');
  begin
    if rising_edge(clk) then
      if finished = "01" and all_finished_reg = '0' then
        next_start := start + 1;
        start <= next_start;
        result_reg <= (start & '1', peak, len);
        data_in <= (peak, len);
        addr_ram <= start;
        writable <= '1';

        if start < 511 then
          go <= '1';
        else
          all_finished_reg <= '1';
        end if;
      else
        writable <= '0';
        addr_ram <= addr;
        go <= '0';
      end if;
      finished(1) <= finished(0);
    end if;
  end process;
end Main;
