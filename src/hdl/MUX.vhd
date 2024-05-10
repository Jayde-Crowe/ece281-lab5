----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2024 08:27:49 PM
-- Design Name: 
-- Module Name: MUX - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX is
port(
    i_input : in std_logic_vector (7 downto 0);
    i_numA : in std_logic_vector(7 downto 0);
    i_numB : in std_logic_vector(7 downto 0);
    i_dec : in std_logic_vector(1 downto 0);
    o_output : out std_logic_vector (7 downto 0)
    );
end MUX;

architecture Behavioral of MUX is

begin

o_output <= i_numA when i_dec = "00" else
            i_numB when i_dec = "01" else
            i_input when i_dec = "10";




end Behavioral;
