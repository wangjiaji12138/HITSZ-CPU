`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/22 14:06:07
// Design Name: 
// Module Name: Dig
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


module Dig(
    input wire          rst,
    input wire          clk,
    input wire [ 3:0]   data,
    output reg [ 7:0]   Dled   
    );
    
    always @(*) begin
        case(data)
            4'h0:Dled = 8'b00000011;
            4'h1:Dled = 8'b10011111;
            4'h2:Dled = 8'b00100101;
            4'h3:Dled = 8'b00001101;
            4'h4:Dled = 8'b10011001;
            4'h5:Dled = 8'b01001001;
            4'h6:Dled = 8'b01000001;
            4'h7:Dled = 8'b00011111;
            4'h8:Dled = 8'b00000001;
            4'h9:Dled = 8'b00011001;
            4'ha:Dled = 8'b00010001;
            4'hb:Dled = 8'b11000001;
            4'hc:Dled = 8'b11100101;
            4'hd:Dled = 8'b10000101;
            4'he:Dled = 8'b01100001;
            4'hf:Dled = 8'b01110001;
            default:Dled = 8'b11111111;
        endcase
    end
endmodule
