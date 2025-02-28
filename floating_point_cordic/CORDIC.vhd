----------------------------------------------------------------------------------
-- Company: center for research and advanced studies of the national polytechnic institute
-- Engineer: M.Sc. Luis Elias Salgado Solano
-- 
-- Create Date: 01/10/2025 04:13:08 PM
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
use IEEE_PROPOSED.FLOAT_PKG.ALL;

entity CORDIC is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en: in STD_LOGIC; -- enable computation process signal
           data_rdy: out std_logic; -- computation finish flag
           z : in float32; -- input's angle
           cos_out : out float32; -- cos(Tetha)
           sin_out : out float32); -- sin(Tetha)
end CORDIC;

architecture Behavioral of CORDIC is
-- Process' signals
constant z_in: float32 := to_float(0.3);
-- Initial values
signal x_trig : float32 := to_float(1.0); -- 1.0 initial condition
signal y_trig : float32 := to_float(0.0); -- 0.0 initial condition
signal z_trig: float32; -- Tetha angle variable

-- Array table type
subtype WORD8 is float32;
type TAB05 is array (0 to 23) of WORD8;

-- Adjust constant reciprocal 1/1.64676
constant adj_c : float32 := to_float(0.6072530301926207);

-- Table of discrete values for arcttan(2^-n)
constant arct_v : TAB05 := (
to_float(0.7853981633974483),to_float(0.4636476090008061),
to_float(0.2449786631268641),to_float(0.1243549945467614),
to_float(0.0624188099959573),to_float(0.0312398334302682),
to_float(0.0156237286204768),to_float(0.0078123410601011),
to_float(0.0039062301319669),to_float(0.0019531225164788),
to_float(0.0009765621895593),to_float(0.0004882812111948),
to_float(0.0002441406201493),to_float(0.0001220703118936),
to_float(6.103515617420877e-05),to_float(3.051757811552e-05),
to_float(1.525878906131576e-05),to_float(7.629394531101e-06),
to_float(3.814697265606496e-06),to_float(1.907348632810e-06),
to_float(9.536743164059608e-07),to_float(4.768371582030e-07),
to_float(2.384185791015579e-07),to_float(1.192092895507e-07));

-- Table of discrete values for 2^-n
constant two_pow : TAB05 := (
to_float(1),
to_float(0.5),
to_float(0.25),
to_float(0.125),
to_float(0.0625),
to_float(0.03125),
to_float(0.015625),
to_float(0.0078125),
to_float(0.00390625),
to_float(0.001953125),
to_float(0.0009765625),
to_float(0.00048828125),
to_float(0.000244140625),
to_float(0.0001220703125),
to_float(6.103515625e-05),
to_float(3.0517578125e-05),
to_float(1.52587890625e-05),
to_float(7.62939453125e-06),
to_float(3.814697265625e-06),
to_float(1.9073486328125e-06),
to_float(9.5367431640625e-07),
to_float(4.76837158203125e-07),
to_float(2.384185791015625e-07),
to_float(1.1920928955078125e-07));

-- Auxiliar signals
signal en_comp : std_logic := '0'; -- enable algorithm
signal count : unsigned(4 downto 0) := to_unsigned(0,5); -- main counter

-- State machine types
type Tstate is (state_0, state_1, state_2);
   signal state: Tstate;
   signal next_state: Tstate;

begin
-- Mealy state machine for the algorithm
PROCESS(clk, reset, count)
   BEGIN
      IF reset = '1' THEN
            state <=state_0;
      ELSIF rising_edge(clk) THEN
            state <= next_state;
      END IF;
   END PROCESS;
   
 PROCESS (state, en, count)
   BEGIN
      CASE state IS
         WHEN state_0 => -- Default state
            if en = '1' then
               if rising_edge(clk) then
                  en_comp  <= '1';
                  data_rdy <= '0';
               end if;
               next_state <= state_1;
            else
               en_comp  <= '0';
               data_rdy <= '0';
               next_state <= state_0;
            end if;
         WHEN state_1 => -- Enable computation state
               if count <= 23 then
                  en_comp  <= '1';
                  data_rdy <= '0';
                  next_state <= state_1;
               else
                  en_comp  <= '0';
                  data_rdy <= '0';
                  cos_out <= x_trig*adj_c; -- cos output signal adjustment
                  sin_out <= y_trig*adj_c; -- sin output signal adjustment
                  next_state <= state_2;
               end if;
         WHEN state_2 =>
            if en = '1' then
               next_state <= state_0;
            else
               next_state <= state_2;
            end if;
            en_comp  <= '0';
            data_rdy <= '1'; -- enable flag
         WHEN OTHERS =>
            next_state <= state_0;
      END CASE;
 END PROCESS;


-- Sigma conditionals
process(clk, reset, count, en_comp)
begin
if reset = '1' or en_comp = '0' then
z_trig <= z;
x_trig <= to_float(1.0);
y_trig <= to_float(0.0);
elsif rising_edge(clk) then
if z_trig >= to_float(0.0) then -- Adition or substraction selection as function of the angle
z_trig <= z_trig - arct_v(to_integer(count));
x_trig <= x_trig - (two_pow(to_integer(count))*y_trig);
y_trig <= y_trig + (two_pow(to_integer(count))*x_trig);
else
z_trig <= z_trig + arct_v(to_integer(count));
x_trig <= x_trig + (two_pow(to_integer(count))*y_trig);
y_trig <= y_trig - (two_pow(to_integer(count))*x_trig);
end if;
end if;
end process;

-- Counter
process(clk, reset)
begin
if reset = '1' then
count <= to_unsigned(0,5);
elsif rising_edge(clk) then 
if en_comp = '1' then
count <= count + 1;
else
count <= to_unsigned(0,5);
end if;
end if;
end process;


end Behavioral;
