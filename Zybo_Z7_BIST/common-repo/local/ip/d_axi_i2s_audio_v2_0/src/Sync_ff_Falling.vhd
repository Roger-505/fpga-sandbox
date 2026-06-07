----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/06/2016 11:04:19 AM
-- Design Name: 
-- Module Name: Sync_ff_Falling - Behavioral
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

------------------------------------------------------------------------
-- Module Declaration
------------------------------------------------------------------------
entity Sync_ff_Falling is
    Port ( 
		-- Input Clock
      CLK : in  STD_LOGIC;
		-- Asynchorn signal
      D_I : in  STD_LOGIC;
		-- Sync signal
      Q_O : out  STD_LOGIC
	);
end Sync_ff_Falling;

architecture Behavioral of Sync_ff_Falling is

------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
signal sreg : std_logic_vector(1 downto 0);

attribute ASYNC_REG : string;
attribute ASYNC_REG of sreg : signal is "TRUE";

attribute TIG : string;
attribute TIG of D_I: signal is "TRUE";

begin

------------------------------------------------------------------------
-- Output synchro with second CLK
------------------------------------------------------------------------
sync_b_proc_2: process(CLK)
begin
	if falling_edge(CLK) then
		Q_O <= sreg(1);
		sreg <= sreg(0) & D_I;
	end if;
end process;

end Behavioral;
