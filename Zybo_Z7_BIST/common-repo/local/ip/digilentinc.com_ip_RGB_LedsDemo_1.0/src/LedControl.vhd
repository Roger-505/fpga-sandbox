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

entity LedControl is
  Port (
        Clock : in std_logic;
        cIntensity : in integer;
        cStep : in integer;
        cTimeToDisplay : in integer;
        cRGB_Leds : out std_logic_vector(2 downto 0)
  );
end LedControl;

architecture Behavioral of LedControl is

-- Constants that represent the time periods for light intensities (PWM)
--constant kPWM_Period : integer := 2500000;
constant kPWM_Period : integer := 1500000;
constant kPeriod1 : integer := 25000;

signal cLed : std_logic := '0'; -- The PWN generated signal
signal cCounter : integer := 0; -- The refresh led's period
signal cDisplayCounter : integer := 0; -- The amount of time to maintatin a light
                                       -- intensity on a led
signal cLedSelect : integer := 0; -- The led selector: 0 = B, 1 = G, 2 = R, 3 = All
signal cNewLed : std_logic := '0'; -- This signal is triggered when the transition
                                   -- to a new led is made
signal cLightIntensity : integer := 0; -- The light intensity for a led
signal cNewLightIntensity : std_logic := '0'; -- This signal is triggered when a new
                                              -- light intensity should be used
signal cGoUp : std_logic := '1'; -- This signal is '1' when the light intensity
                                 -- increases and '0' when the light intensity
                                 -- decreases

begin

-- This process generates the light intensities and triggers the cNewLed signal
-- when a new led should be used
generateIntensityProcess: process(Clock, cNewLightIntensity)
begin
  if(rising_edge(Clock)) then
    if(cNewLightIntensity = '1') then
      if(cGoUp = '1') then
        if(cLightIntensity > cIntensity) then
          cGoUp <= '0'; -- go down
        else
          cLightIntensity <= cLightIntensity + cStep;
          cNewLed <= '0';
        end if;
      else
        if(cLightIntensity < kPeriod1) then
          cLightIntensity <= 0;
          cGoUp <= '1'; -- go up
          cNewLed <= '1';
        else
          cLightIntensity <= cLightIntensity - cStep;
          cNewLed <= '0';
        end if;
      end if;
    end if;
  end if;
end process generateIntensityProcess;

-- This process signals when a new light intensity should be used
changeIntensityProcess: process(Clock)
begin
  if(rising_edge(Clock)) then
    if(cDisplayCounter = cTimeToDisplay) then
      cDisplayCounter <= 0;
      cNewLightIntensity <= '1';
    else
      cDisplayCounter <= cDisplayCounter + 1;
      cNewLightIntensity <= '0';
    end if;
  end if;
end process changeIntensityProcess;

-- This process selects the next led based on cNewLed signal
cNewLedProcess: process(Clock, cNewLed)
begin
  if(rising_edge(Clock)) then
    if(cNewLed = '1') then
      if(cLedSelect > 3) then
        cLedSelect <= 0;
      else
        cLedSelect <= cLedSelect + 1;
      end if;
    else
      if(cLedSelect > 3) then
        cLedSelect <= 0;
      end if;
    end if;
  end if;
end process cNewLedProcess;

-- This process generates the PWM signal for different light intensities
cLedProcess: process(Clock)
begin
  if(rising_edge(Clock)) then
    if(cCounter = kPWM_Period) then
      cCounter <= 0;
      cLed <= '1';
    elsif cCounter > cLightIntensity then
      cLed <= '0';
      cCounter <= cCounter + 1;
    else
      cLed <= '1';
      cCounter <= cCounter + 1;
    end if;
  end if;
end process cLedProcess;

-- This process selects the right output leds based in cLedSelect signal
ledSelectProcess: process(Clock, cLedSelect)
begin
  if(rising_edge(Clock)) then
    case cLedSelect is
      when 0 => cRGB_Leds(0) <= cLed;
                cRGB_Leds(1) <= '0';
                cRGB_Leds(2) <= '0';

      when 1 => cRGB_Leds(0) <= '0';
                cRGB_Leds(1) <= cLed;
                cRGB_Leds(2) <= '0';

      when 2 => cRGB_Leds(0) <= '0';
                cRGB_Leds(1) <= '0';
                cRGB_Leds(2) <= cLed;

      when 3 => cRGB_Leds(0) <= cLed;
                cRGB_Leds(1) <= cLed;
                cRGB_Leds(2) <= cLed;

      when others => cRGB_Leds(0) <= '0';
                     cRGB_Leds(1) <= '0';
                     cRGB_Leds(2) <= '0';
    end case;
  end if;
end process ledSelectProcess;

end Behavioral;
