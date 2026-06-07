-------------------------------------------------------------------------------
--
-- File: tpg.vhd
-- Author: Elod Gyorgy
-- Original Project: Zybo Z7 OOB demo
-- Date: 16 May 2017
--
-------------------------------------------------------------------------------
-- MIT License

-- Copyright (c) 2017 Digilent

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
-------------------------------------------------------------------------------
--
-- Purpose:
-- This module generates the moving color triangles of a fixed resolution
-- and outputs an AXI4-Stream with the video data.
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tpg is
   Generic (
      kMaxResolution : natural := 4096;
      kHorActive : natural := 1280;
      kVerActive : natural := 720
   );
    Port ( m_axis_tdata : out STD_LOGIC_VECTOR (23 downto 0);
           m_axis_tvalid : out STD_LOGIC;
           m_axis_tready : in STD_LOGIC;
           AxisClk : in STD_LOGIC;
           xrst_n : in std_logic;
           m_axis_tuser : out STD_LOGIC;
           m_axis_tlast : out STD_LOGIC);
end tpg;

architecture Behavioral of tpg is
signal xCntHor, xCntVer : integer range 0 to kMaxResolution - 1 := 0;
signal tvalid_int, tuser_int, tlast_int : std_logic;
signal xRed, xGreen, xBlue : std_logic_vector(7 downto 0);
signal cntDyn : integer range 0 to 2**28-1;

begin

VideoCounters: process(AxisClk)
begin
   if Rising_Edge(AxisClk) then
      if (xrst_n = '0') then
         xCntHor <= 0;
         xCntVer <= 0;
      elsif (m_axis_tready = '1' and tvalid_int = '1') then
         if (xCntHor = kHorActive - 1) then
            xCntHor <= 0;
            if (xCntVer = kVerActive - 1) then
               xCntVer <= 0;
            else
               xCntVer <= xCntVer + 1;
            end if;
         else
            xCntHor <= xCntHor + 1;
         end if;
      end if;
   end if;
end process;



DynamicPatternCounter: process(AxisClk)
begin
   if(rising_edge(AxisClk)) then
      if (xRst_n = '0') then
         cntDyn <= 0;
      else
         cntDyn <= cntDyn + 1;
      end if;
   end if;
end process;

TdataReg: process(AxisClk)
begin
   if(rising_edge(AxisClk)) then
      m_axis_tdata <= xRed & xBlue & xGreen;
   end if;
end process;

TvalidReg: process(AxisClk)
begin
   if(rising_edge(AxisClk)) then
      if (xRst_n = '0') then
         tvalid_int <= '0';
         tlast_int <= '0';
         tuser_int <= '0';
      else
         tvalid_int <= '1';
         tuser_int <= '0';
         tlast_int <= '0';
         if (xCntHor = 0 and xCntVer = 0) then
            tuser_int <= '1';
         end if;
         if (xCntHor = kHorActive - 1) then
            tlast_int <= '1';
         end if;
      end if;
   end if;
end process;

m_axis_tvalid <= tvalid_int;
m_axis_tuser <= tuser_int;
m_axis_tlast <= tlast_int;

xRed <= conv_std_logic_vector((-xCntVer - xCntHor - cntDyn/2**20),8)(7 downto 0);
xGreen <= conv_std_logic_vector((xCntHor - cntDyn/2**20),8)(7 downto 0);
xBlue <= conv_std_logic_vector((xCntVer - cntDyn/2**20),8)(7 downto 0);

end Behavioral;
