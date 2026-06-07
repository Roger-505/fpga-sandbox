----------------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Author:  Bogdan Deac
--          Copyright 2017 Digilent, Inc.
----------------------------------------------------------------------------
--
-- Create Date:   05/15/2017 03:41:07 PM
-- Design Name:
-- Module Name:    RGB_LedsDemo - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions: Vivdo 2016.4
-- Description: This project is a demo for Zybo Z7 board. It tests the RGB leds.
--              The demo has the following functionality: The Blue led is turned
--              on and off with different light intensities. After that the Green
--              led is turned on and off with different light intensities. After
--              that the Red led is turned on and off with different light intensities.
--              After that all leds (Red, Green and Blue) are turned on and off with
--              different light intensities. After that the demo is repeated.
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

entity RGB_LedsDemo is
  Generic (LEDS : integer;
           PROCENT : integer;
           STEP : integer;
           TIME_TO_DISPLAY : integer
  );

  Port (
        Clock : in std_logic;
        cRGB_Leds : out std_logic_vector((3 * LEDS - 1) downto 0)
  );
end RGB_LedsDemo;

architecture Behavioral of RGB_LedsDemo is

component LedControl is
  Port (
        Clock : in std_logic;
        cIntensity : in integer;
        cStep : in integer;
        cTimeToDisplay : in integer;
        cRGB_Leds : out std_logic_vector(2 downto 0)
  );
end component;

component IntensityControl is
  Port (
        Procent : in integer;
        Intensity : out integer
  );
end component;

signal cIntensity : integer := 0;

begin

-- Generate the needed number of components
  GEN_LED: for I in 0 to LEDS - 1 generate
    LED_X: LedControl port map(Clock, cIntensity, STEP, TIME_TO_DISPLAY, cRGB_Leds((3 * I + 2) downto (3 * I)));
  end generate GEN_LED;

  INT: IntensityControl port map(PROCENT, cIntensity);

end Behavioral;
