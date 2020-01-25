library IEEE;
use IEEE.std_logic_1164.all;

package types is
  type result_t is record
    start: std_logic_vector(9 downto 0);
    peak: std_logic_vector(17 downto 0);
    len: std_logic_vector(7 downto 0);
  end record;

  type top4_t is array(0 to 3) of result_t;
  type top5_t is array(0 to 4) of result_t;
end package types;
