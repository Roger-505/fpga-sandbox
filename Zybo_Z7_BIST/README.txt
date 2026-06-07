Zybo Z7 Out-of-Box Demo Source
==================================

This is source code for the out-of-box demo that comes preloaded on the Zybo Z7-10 and
Zybo Z7-20. It is provided as-is for reference purposes, and will not be maintained to 
newer versions of Vivado.

Prerequisites
=======================

*Vivado 2016.4 (no other version of Vivado will work)
*Digilent boards files installed, as described here https://reference.digilentinc.com/learn/software/tutorials/vivado-board-files/start

Generate the Project
=======================

Open Vivado 2016.4, and navigate to the TCL Console. Use cd to navigate to either the 
Zybo_Z7_BIST/z10/demo/proj or Zybo_Z7_BIST/z20/demo/proj folder, depending on the board
variant you have. Then run:

source create_project.tcl

You will see the Vivado project get generated. The Xilinx SDK source code is also included in
Zybo_Z7_BIST/z10/demo/sdk (or Zybo_Z7_BIST/z20/demo/sdk).
