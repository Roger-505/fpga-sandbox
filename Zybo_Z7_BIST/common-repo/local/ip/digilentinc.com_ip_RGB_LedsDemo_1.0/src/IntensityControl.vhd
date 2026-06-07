----------------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Author:  Bogdan Deac
--          Copyright 2017 Digilent, Inc.
----------------------------------------------------------------------------
--
-- Create Date:   05/15/2017 03:41:07 PM
-- Design Name:
-- Module Name:    IntensityControl - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions: Vivdo 2016.4
-- Description: This project is a demo for Zybo Z7 board. It tests the RGB leds.
--              This module returns the PWM period for different light intensities
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

entity IntensityControl is
  Port (
        Procent : in integer;
        Intensity : out integer
  );
end IntensityControl;

architecture Behavioral of IntensityControl is

begin

  Intensity <= 0 when Procent = 0 else
               25000 when Procent = 1 else
               50000 when Procent = 2 else
               125000 when Procent = 5 else
               250000 when Procent = 10 else
               375000 when Procent = 15 else
               500000 when Procent = 20 else
               625000 when Procent = 25 else
               750000 when Procent = 30 else
               875000 when Procent = 35 else
               1000000 when Procent = 40 else
               1125000 when Procent = 45 else
               1250000 when Procent = 50 else
               1375000 when Procent = 55 else
               1500000 when Procent = 60 else
               1625000 when Procent = 65 else
               1750000 when Procent = 70 else
               1875000 when Procent = 75 else
               2000000 when Procent = 80 else
               2125000 when Procent = 85 else
               2250000 when Procent = 90 else
               2375000 when Procent = 95 else
               2500000 when Procent = 100;

end Behavioral;
