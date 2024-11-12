`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/26 10:00:28
// Design Name: 
// Module Name: Control_Hazard_Detection
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

module Control_Hazard_Detection(
    input  wire [ 3:0] branch,
    input  wire [ 0:0] br,
    output wire [ 0:0] IF_ID_flush,
    output wire [ 0:0] ID_EX_flush
    );
    
    assign IF_ID_flush = ((branch!=4'b0) && (ja || br)) ? 1'b1 : 1'b0;
    assign ID_EX_flush = ((branch!=4'b0) && (ja || br)) ? 1'b1 : 1'b0;
endmodule
