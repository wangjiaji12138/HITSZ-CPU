`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 15:49:26
// Design Name: 
// Module Name: PC
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


module PC(
    input  wire        rst,
    input  wire        clk,
    input  wire [31:0] din,
    output  reg [31:0] pc  
);
    // inner logic of PC
    always @(posedge rst or posedge clk) begin
        if(rst) begin
            pc <= 32'b0;
        end
        else begin
            pc <= din;
        end
    end
    
endmodule
