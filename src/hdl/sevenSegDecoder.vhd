----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2024 01:19:28 PM
-- Design Name: 
-- Module Name: sevenSegDecoder - Behavioral
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

entity sevenSegDecoder is
    Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
           --i_neg : in STD_LOGIC;
           o_S : out STD_LOGIC_VECTOR (6 downto 0));
end sevenSegDecoder;

architecture Behavioral of sevenSegDecoder is

begin

o_S(0) <= '1' when ((i_D = x"1") or
                    (i_D = x"4")or
                    (i_D = x"B") or
                    (i_D = x"C") or
                    (i_D = x"D") or
                    (i_D = x"E") or 
                    (i_D = x"F") ) else '0';

       
--o_S(0) <= '0' when i_neg = '0';
       
o_S(1) <= '1' when ((i_D = x"5") or
                    (i_D = x"6") or
                    (i_D = x"B") or 
                    (i_D = x"C") or 
                    (i_D = x"E") or 
                    (i_D = x"F") ) else '0';
      
o_S(2) <= '1' when ((i_D = x"2") or
                 (i_D = x"C") or
                 (i_D = x"E") or 
                 (i_D = x"F")) else '0';
            
 o_S(3) <= '1' when ((i_D = x"1") or
                  (i_D = x"4") or
                  (i_D = x"7") or
                  (i_D = x"9") or
                  (i_D = x"A") or
                  (i_D = x"E") or
                  (i_D = x"F")) else '0';
                  
o_S(4) <= '1' when ((i_D = x"1") or
                 (i_D = x"3") or
                 (i_D = x"4") or
                 (i_D = x"5") or
                 (i_D = x"7") or
                 (i_D = x"9") or
                 (i_D = x"E") or
                 (i_D = x"F")) else '0';
                 
o_S(5) <= '1' when ((i_D = x"1") or
                  (i_D = x"2") or
                  (i_D = x"3") or
                  (i_D = x"7") or
                  (i_D = x"C") or
                  (i_D = x"D") or
                  (i_D = x"E") or
                  (i_D = x"F") )  else '0';
                  
 o_S(6) <= '1' when ((i_D = x"0") or
                  (i_D = x"1") or
                  (i_D = x"7") or
                  (i_D = x"E")) else '0';


end Behavioral;
