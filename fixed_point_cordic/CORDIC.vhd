----------------------------------------------------------------------------------
-- Company: center for research and advanced studies of the national polytechnic institute
-- Engineer: M.Sc. Luis Elias Salgado Solano
-- 
-- Create Date: 28/02/2025 12:54:00 PM
-- Design Name: 
-- Module Name: CORDIC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library IEEE_PROPOSED;
use IEEE_PROPOSED.FIXED_PKG.ALL;

entity CORDIC is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en: in STD_LOGIC; -- enable computation process signal
           data_rdy: out std_logic; -- computation finish flag
           x : inout sfixed (1 downto -30); 
           y : inout sfixed (1 downto -30); 
           z : in sfixed (1 downto -30));
end CORDIC;

architecture Behavioral of CORDIC is

-- Array table type
subtype WORD is sfixed (1 downto -30);
type TAB is array (0 to 23) of WORD;

-- Table of discrete values for arcttan(2^-n)
constant arct_v : TAB := (
to_sfixed (0.7853981633974483, 1, -30),to_sfixed (0.4636476090008061, 1, -30),
to_sfixed (0.2449786631268641, 1, -30),to_sfixed (0.1243549945467614, 1, -30),
to_sfixed (0.0624188099959573, 1, -30),to_sfixed (0.0312398334302682, 1, -30),
to_sfixed (0.0156237286204768, 1, -30),to_sfixed (0.0078123410601011, 1, -30),
to_sfixed (0.0039062301319669, 1, -30),to_sfixed (0.0019531225164788, 1, -30),
to_sfixed (0.0009765621895593, 1, -30),to_sfixed (0.0004882812111948, 1, -30),
to_sfixed (0.0002441406201493, 1, -30),to_sfixed (0.0001220703118936, 1, -30),
to_sfixed (6.103515617420877e-05, 1, -30),to_sfixed (3.051757811552e-05, 1, -30),
to_sfixed (1.525878906131576e-05, 1, -30),to_sfixed (7.629394531101e-06, 1, -30),
to_sfixed (3.814697265606496e-06, 1, -30),to_sfixed (1.907348632810e-06, 1, -30),
to_sfixed (9.536743164059608e-07, 1, -30),to_sfixed (4.768371582030e-07, 1, -30),
to_sfixed (2.384185791015579e-07, 1, -30),to_sfixed (1.192092895507e-07, 1, -30));

signal theta_var: sfixed (1 downto -30):= to_sfixed (0, 1, -30); -- Variable angle signal 

signal x_var: sfixed (1 downto -30):= to_sfixed (1, 1, -30); -- Variable x signal initialized in 1
signal y_var: sfixed (1 downto -30):= to_sfixed (0, 1, -30); -- Variable y signal initialized in 0

-- process signals
signal cnt: unsigned(4 downto 0) := to_unsigned(0,5);
-- Adjust constant reciprocal 1/1.64676
constant adj_c : sfixed := to_sfixed (0.60725303019262071, 1, -30);

begin

process(clk,cnt,en,reset,z,theta_var)
begin
if reset = '1' then
theta_var <= z;
data_rdy <= '0';
elsif rising_edge(clk) then
if en = '1' then
if cnt <= to_unsigned(23,5) then
data_rdy <= '0';
if theta_var >= to_sfixed (0, 1, -30) then -- sigma sign criterion (5)
x_var <= resize(x_var - shift_right(y_var, to_integer(cnt)), 1, -30); -- eq (2) Using right shifs for 2^-n power 
y_var <= resize(y_var + shift_right(x_var, to_integer(cnt)), 1, -30); -- eq (3) and resizing for rounding the result
theta_var <= resize(theta_var - arct_v(to_integer(cnt)), 1, -30); -- eq (4)
else 
x_var <= resize(x_var + shift_right(y_var, to_integer(cnt)), 1, -30); -- eq (2)
y_var <= resize(y_var - shift_right(x_var, to_integer(cnt)), 1, -30); -- eq (3)
theta_var <= resize(theta_var + arct_v(to_integer(cnt)), 1, -30); -- eq (4)
end if;
else
x <= resize(x_var*adj_c, 1, -30); -- Adjust multiplication for cos(z)
y <= resize(y_var*adj_c, 1, -30); -- Adjust multiplication for sin(z)
x_var <= to_sfixed (1, 1, -30);
y_var <= to_sfixed (0, 1, -30);
theta_var <= z;  -- Take the new value
data_rdy <= '1'; -- Enable data ready flag
end if;
else -- Return to default sta
theta_var <= z;
data_rdy <= '0';
end if;
end if;
end process;


-- Main counter
process(clk,en,reset)
begin
if reset = '1' then
cnt <= to_unsigned(0,5);
elsif rising_edge(clk) then
if en = '1' then
if cnt < 24 then
cnt <= cnt + 1;
else
cnt <= to_unsigned(0,5);
end if;
else
cnt <= to_unsigned(0,5);
end if;
end if;
end process;

end Behavioral;
