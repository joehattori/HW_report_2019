library IEEE;
use IEEE.std_logic_unsigned."+";
use IEEE.std_logic_1164.all;
use work.types.all;

entity Sorter is
  port (
    clk: in std_logic := '0';
    new_result: in result_t := ((others => '0'), (others => '0'), (others => '0'));
    top4: out top4_t := (others => ((others => '0'), (others => '0'), (others => '0')))
  );
end sorter;

architecture Main of Sorter is
  signal current_top4: top4_t := (others => ((others => '0'), (others => '0'), (others => '0')));

begin

  process(clk)
    variable results: top4_t := (others => ((others => '0'), (others => '0'), (others => '0')));
    variable swp: result_t := ((others => '0'), (others => '0'), (others => '0'));
    variable new_result_tmp: result_t := ((others => '0'), (others => '0'), (others => '0'));
    variable is_equal: std_logic := '0';
  begin
    if rising_edge(clk) then
      results := current_top4;
      new_result_tmp := new_result;
      is_equal := '0';

      for i in 0 to 3 loop
        if results(i).peak = new_result_tmp.peak then
          is_equal := '1';
          if results(i).len < new_result_tmp.len then
            swp.start := results(i).start;
            results(i).start := new_result_tmp.start;
            new_result_tmp.start := swp.start;

            swp.len := results(i).len;
            results(i).len := new_result_tmp.len;
            new_result_tmp.len := swp.len;
          end if;
        end if;
      end loop;

      if is_equal = '0' then
        for i in 0 to 3 loop
          if results(i).peak < new_result_tmp.peak then
            swp.start := results(i).start;
            results(i).start := new_result_tmp.start;
            new_result_tmp.start := swp.start;

            swp.peak := results(i).peak;
            results(i).peak := new_result_tmp.peak;
            new_result_tmp.peak := swp.peak;

            swp.len := results(i).len;
            results(i).len := new_result_tmp.len;
            new_result_tmp.len := swp.len;
          end if;
        end loop;
      end if;

      current_top4 <= results;
    end if;
  end process;

  top4 <= current_top4;
end Main;
