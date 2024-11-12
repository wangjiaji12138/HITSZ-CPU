`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/22 11:28:15
// Design Name: 
// Module Name: Switches_Interface
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


module Switches_Interface(
    input  wire         rst,
    input  wire         clk,
    input  wire [31:0]  addr,
    input  wire [23:0]  sw,
    output  reg [31:0]  rdata
    );
    
    always @(*) begin
        if(rst) begin
            rdata = 32'b0; 
        end
        else begin
            rdata = {8'b0,sw};
        end
    end
endmodule
