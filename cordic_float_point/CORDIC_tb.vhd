----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/13/2025 05:07:00 PM
-- Design Name: 
-- Module Name: CORDIC_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CORDIC_tb is
--  Port ( );
end CORDIC_tb;

architecture Behavioral of CORDIC_tb is

component CORDIC
    port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en: in STD_LOGIC;
           data_rdy: out std_logic;
           z : in float32;
           cos_out : out float32;
           sin_out : out float32); 
end component;

-- Component signals
signal clk: std_logic;
signal reset: std_logic;
signal en: std_logic;
signal data_rdy: std_logic;
signal z : float32 := to_float(-1.57);
signal cos_out : float32;
signal sin_out : float32;

constant frac: float32 := to_float(0.05);
constant h_pi: float32 := to_float(-1.57);
constant nh_pi: float32 := to_float(-1.57);

begin

uut: CORDIC port map (
        clk  => clk,
        reset  => reset,
        en => en,
        data_rdy => data_rdy,
        z => z,
        cos_out => cos_out,
        sin_out => sin_out);

-- Reset signal delay
reset <= '1', '0' after 1200 ns;

-- Enable signal delay
en <= '0', '1' after 1800 ns;

-- Clock process definitions
clk_process :process
begin
	clk <= '0';
	wait for 100 ns;
	clk <= '1';
	wait for 100 ns;
end process;

z_process :process
begin
    if z < nh_pi then
       z <= z + frac;
	wait for 5400 ns;
	z <= z + frac;
	wait for 5400 ns;
end process;

end Behavioral;
