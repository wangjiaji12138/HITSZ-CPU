`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 15:56:27
// Design Name: 
// Module Name: SEXT
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

module SEXT(
    input  wire [31:7] imm,
    input  wire [ 2:0] op,
    output wire [31:0] ext
);
    assign ext = (op==`EXT_I && imm[31]==1'b1) ? {20'b1111_1111_1111_1111_1111,imm[31:20]}:
                  (op==`EXT_I && imm[31]==1'b0) ? {20'b0000_0000_0000_0000_0000,imm[31:20]}:
                  (op==`EXT_S && imm[31]==1'b1) ? {20'b1111_1111_1111_1111_1111,imm[31:25],imm[11:7]}:
                  (op==`EXT_S && imm[31]==1'b0) ? {20'b0000_0000_0000_0000_0000,imm[31:25],imm[11:7]}:
                  (op==`EXT_B && imm[31]==1'b1) ? {19'b111_1111_1111_1111_1111,imm[31],imm[7],imm[30:25],imm[11:8],1'b0}:
                  (op==`EXT_B && imm[31]==1'b0) ? {19'b000_0000_0000_0000_0000,imm[31],imm[7],imm[30:25],imm[11:8],1'b0}:
                  (op==`EXT_U && imm[31]==1'b1) ? {imm[31:12],12'b0000_0000_0000}:
                  (op==`EXT_U && imm[31]==1'b0) ? {imm[31:12],12'b0000_0000_0000}:
                  (op==`EXT_J && imm[31]==1'b1) ? {11'b111_1111_1111,imm[31],imm[19:12],imm[20],imm[30:21],1'b0}:
                  (op==`EXT_J && imm[31]==1'b0) ? {11'b000_0000_0000,imm[31],imm[19:12],imm[20],imm[30:21],1'b0}:32'b0;
    // inner logic of SEXT
endmodule
