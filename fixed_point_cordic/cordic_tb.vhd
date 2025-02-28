----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2025 04:36:18 PM
-- Design Name: 
-- Module Name: cordic_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cordic_tb is
--  Port ( );
end cordic_tb;

architecture Behavioral of cordic_tb is 

component CORDIC
    port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en: in STD_LOGIC;
           data_rdy: out std_logic;
           x : inout sfixed (1 downto -30); 
           y : inout sfixed (1 downto -30);
           z : inout sfixed (1 downto -30)); 
end component;

-- Component signals
signal clk: std_logic;
signal reset: std_logic;
signal en: std_logic;
signal data_rdy: std_logic;
signal x : sfixed (1 downto -30);
signal y : sfixed (1 downto -30);
signal z : sfixed (1 downto -30);

begin

uut: CORDIC port map (
        clk  => clk,
        reset  => reset,
        en => en,
        data_rdy => data_rdy,
        x => x,
        y => y,
        z => z);

-- Angle configuration: 0.25
--z <= to_sfixed (0.25, 1, -30);

-- Reset signal delay
reset <= '1', '0' after 1200 ns;

-- Enable signal delay
en <= '0', '1' after 1800 ns;
-- Change angle
z <= to_sfixed (0.25, 1, -30),to_sfixed (0.12, 1, -30) after 6700ns;

-- Clock process definitions
clk_process :process
begin
	clk <= '0';
	wait for 100 ns;
	clk <= '1';
	wait for 100 ns;
end process;

end Behavioral;
