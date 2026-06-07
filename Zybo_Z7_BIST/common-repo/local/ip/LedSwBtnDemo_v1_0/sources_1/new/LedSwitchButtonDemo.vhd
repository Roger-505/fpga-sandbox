----------------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Author:  Bogdan Deac
--          Copyright 2017 Digilent, Inc.
----------------------------------------------------------------------------
--
-- Create Date:    05/04/2017 04:16:54 PM
-- Design Name:
-- Module Name:    LedSwitchButtonDemo - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions: Vivdo 2016.4
-- Description: This project is a demo for Zybo Z7 board. It tests the leds,
--              the switches and the buttons. It has three operational modes:
--              1. Snake animation:   Default snake animation on 4 leds, forward and backward,
--                                    each led has a different light intensity
--              2. Switch animation:  Each switch will turn on the led above it.
--                                    The rest of the leds will run the Snake animation
--              3. Button animation:  For this animation only 3 buttons are available
--                                    BTN1, BTN2, and BTN3. BTN0 is reserved for another
--                                    purposes. This animation will work only if the
--                                    Switch animation is active. The Switch animation
--                                    will turn on the led which coresponds to a switch.
--                                    The Button animation will turn off the led for
--                                    which the coresponding switch is turned on. The rest
--                                    of the leds will run the Snake animation.
--              All the constants are defined relative to 100 MHz
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

entity LedSwitchButtonDemo is
  Port (
        Clock : in std_logic;
        cSwitch : in std_logic_vector(3 downto 0);
        cButton : in std_logic_vector(2 downto 0);
        cLed : out std_logic_vector(3 downto 0)
  );
end LedSwitchButtonDemo;

architecture Behavioral of LedSwitchButtonDemo is

-- 2500000 => devide the Clock to obtain 2ms
constant kPWM_Period : integer := 2500000;
constant kPeriod70 : integer := 1750000;
constant kPeriod50 : integer := 1250000;
constant kPeriod30 : integer := 750000;
constant kPeriod15 : integer := 375000;
constant kPeriod5 : integer := 125000;
constant kPeriod2 : integer := 50000;
constant kPeriod1 : integer := 25000;
constant kPeriod0 : integer := 0;

signal cCounter0 : integer := 0;
signal cCounter1 : integer := 0;
signal cCounter2 : integer := 0;
signal cCounter3 : integer := 0;

-- Each Rom store the intensities for a led for each step.
-- In each memory are stored the forward and backward moves
-- for a led
type RomArray_t is array (0 to 13) of integer;
constant led0Levels : RomArray_t := ( kPeriod0, kPeriod0, kPeriod0, kPWM_Period,
                                      kPWM_Period, kPWM_Period, kPWM_Period,
                                      kPeriod30, kPeriod15, kPeriod2, kPeriod0,
                                      kPeriod0, kPeriod0, kPeriod0);

constant led1Levels : RomArray_t := ( kPeriod0, kPeriod0, kPWM_Period, kPeriod30,
                                      kPeriod15, kPeriod2, kPeriod0, kPeriod0,
                                      kPWM_Period, kPeriod30, kPeriod15, kPeriod2,
                                      kPeriod0, kPeriod0);

constant led2Levels : RomArray_t := ( kPeriod0, kPWM_Period, kPeriod30, kPeriod15,
                                      kPeriod2, kPeriod0, kPeriod0, kPeriod0,
                                      kPeriod0, kPWM_Period, kPeriod30,
                                      kPeriod15, kPeriod2, kPeriod0);

constant led3Levels : RomArray_t := ( kPWM_Period, kPeriod30, kPeriod15,
                                      kPeriod2, kPeriod0, kPeriod0, kPeriod0,
                                      kPeriod0, kPeriod0, kPeriod0, kPWM_Period,
                                      kPWM_Period, kPWM_Period, kPWM_Period);

-- This is a counter that is incremented with kPeriodSnake frecquency
-- It represents the actual state of the snake. It is used as address
-- for each led rom
signal cSnake : integer := 0;
signal cSnakeCounter : integer := 0;
constant kPeriodSnake : integer := 20000000;

begin

-- This process generates the addresses for the leds roms
cSnake_process: process(Clock)
begin
    if(rising_edge(Clock)) then
        if(cSnakeCounter = kPeriodSnake) then
            cSnakeCounter <= 0;
            if(cSnake > 12) then
                cSnake <= 0;
            else
                cSnake <= cSnake + 1;
            end if;
        else
            cSnakeCounter <= cSnakeCounter + 1;
        end if;
    end if;
end process cSnake_process;

cCounter0_process: process(Clock, cSwitch(0))
begin
    if(rising_edge(Clock)) then
        if(cSwitch(0) = '1') then
            cLed(0) <= not(cButton(0) or cButton(1) or cButton(2));
        else
            if(cCounter0 = kPWM_Period) then
                cLed(0) <= '1';
                cCounter0 <= 0;
            else
                if(cCounter0 < led0Levels(cSnake)) then
                    cLed(0) <= '1';
                    cCounter0 <= cCounter0 + 1;
                else
                    cLed(0) <= '0';
                    cCounter0 <= cCounter0 + 1;
                end if;
            end if;
        end if;
    end if;
end process cCounter0_process;

cCounter1_process: process(Clock, cSwitch(1))
begin
    if(rising_edge(Clock)) then
        if(cSwitch(1) = '1') then
            cLed(1) <= not(cButton(0) or cButton(1) or cButton(2));
        else
            if(cCounter1 = kPWM_Period) then
                cLed(1) <= '1';
                cCounter1 <= 0;
            else
                if(cCounter1 < led1Levels(cSnake)) then
                    cLed(1) <= '1';
                    cCounter1 <= cCounter1 + 1;
                else
                    cLed(1) <= '0';
                    cCounter1 <= cCounter1 + 1;
                end if;
            end if;
        end if;
    end if;
end process cCounter1_process;

cCounter2_process: process(Clock, cSwitch(2))
begin
    if(rising_edge(Clock))then
        if(cSwitch(2) = '1') then
            cLed(2) <= not(cButton(0) or cButton(1) or cButton(2));
        else
            if(cCounter2 = kPWM_Period) then
                cLed(2) <= '1';
                cCounter2 <= 0;
            else
                if(cCounter2 < led2Levels(cSnake)) then
                    cLed(2) <= '1';
                    cCounter2 <= cCounter2 + 1;
                else
                    cLed(2) <= '0';
                    cCounter2 <= cCounter2 + 1;
                end if;
            end if;
        end if;
    end if;
end process cCounter2_process;

cCounter3_process: process(Clock, cSwitch(3))
begin
    if(rising_edge(Clock))then
        if(cSwitch(3) = '1') then
            cLed(3) <= not(cButton(0) or cButton(1) or cButton(2));
        else
            if(cCounter3 = kPWM_Period) then
                cLed(3) <= '1';
                cCounter3 <= 0;
            else
                if(cCounter3 < led3Levels(cSnake)) then
                    cLed(3) <= '1';
                    cCounter3 <= cCounter3 + 1;
                else
                    cLed(3) <= '0';
                    cCounter3 <= cCounter3 + 1;
                end if;
            end if;
        end if;
    end if;
end process cCounter3_process;

end Behavioral;
