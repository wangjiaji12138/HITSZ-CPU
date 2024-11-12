`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/17 14:36:22
// Design Name: 
// Module Name: RF_WDSEL
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


module RF_WDSEL(
    input wire        clk,
    input wire [ 1:0] op,
    input wire [31:0] pc4,
    input wire [31:0] ext,
    input wire [31:0] dou,
    input wire [31:0] C,
    input wire [31:0] rdo,
    output wire [31:0] out
    );
    
    always @(*) begin
        case (op)
            `RF_PC4:    begin out = pc4; end
            `RF_EXT:    begin out = ext; end
            `RF_RDO:    begin out = dou; end
            `RF_ALU:    begin out = C; end
            default:    begin out = out;end 
         endcase    
    end
    
endmodule
