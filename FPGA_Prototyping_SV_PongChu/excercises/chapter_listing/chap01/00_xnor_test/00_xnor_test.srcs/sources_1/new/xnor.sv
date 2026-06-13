`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2026 02:31:22 PM
// Design Name: 
// Module Name: xnor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module my_xnor(
    input i0,
    input i1,
    output eq
    );
    logic p0, p1;
    assign eq = p0 | p1;
    assign p0 = ~i0 & ~i1;
    assign p1 = i0 & i1;
endmodule
