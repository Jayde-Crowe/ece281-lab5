----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2024 07:28:47 PM
-- Design Name: 
-- Module Name: controller_fsm - Behavioral
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

entity controller_fsm is
port( i_clk : in std_logic;
      i_reset : in std_logic;
      i_adv : in std_logic;
      o_cycle : out std_logic_vector (3 downto 0)
);
end controller_fsm;

architecture Behavioral of controller_fsm is

type State is  (stateZero, stateOne, stateTwo, stateThree);
signal f_Q, f_Q_next : State;
signal i_en : std_logic := '1';

--type State is  (stateZero, stateOne, stateTwo, stateThree);

begin

-- NEXT STATE 

f_Q_next <= stateOne when (f_Q = stateZero) else
            stateTwo when (f_Q = stateOne) else
            stateThree when (f_Q = stateTwo) else
            stateZero;

-- OUTPUT LOGIC
           
with f_Q select

    o_cycle <="1000" when stateZero,
              "0100" when stateOne,
              "0010" when stateTwo,
              "0001" when stateThree;
              
              
    enable_process : process(i_clk)
     
     begin           
                if(rising_edge(i_clk)) then
                if(i_adv = '1' and i_en = '1') then 
                    f_Q <= f_Q_next;
                    i_en <= '0';
                elsif(i_adv = '0' and i_en = '0') then 
                    i_en <= '1' after 500 ns;
                elsif(i_reset = '1') then
                    f_Q <= stateZero;
                end if;
           end if;
                end process;




end Behavioral;
