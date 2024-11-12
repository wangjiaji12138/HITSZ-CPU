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
    output  reg [31:0] ext
);
    // inner logic of SEXT
    always @(*) begin
        case(op)
            `EXT_I: ext = imm[31] ? {20'b1111_1111_1111_1111_1111,imm[31:20]} : {20'b0000_0000_0000_0000_0000,imm[31:20]};
            `EXT_S: ext = imm[31] ? {20'b1111_1111_1111_1111_1111,imm[31:25],imm[11:7]} : {20'b0000_0000_0000_0000_0000,imm[31:25],imm[11:7]};
            `EXT_B: ext = imm[31] ? {19'b111_1111_1111_1111_1111,imm[31],imm[7],imm[30:25],imm[11:8],1'b0} : {19'b000_0000_0000_0000_0000,imm[31],imm[7],imm[30:25],imm[11:8],1'b0};
            `EXT_U: ext = imm[31] ? {imm[31:12],12'b0000_0000_0000} : {imm[31:12],12'b0000_0000_0000};
            `EXT_J: ext = imm[31] ? {11'b111_1111_1111,imm[31],imm[19:12],imm[20],imm[30:21],1'b0} : {11'b000_0000_0000,imm[31],imm[19:12],imm[20],imm[30:21],1'b0};
            default:ext = 32'b0;
        endcase
    end
endmodule
