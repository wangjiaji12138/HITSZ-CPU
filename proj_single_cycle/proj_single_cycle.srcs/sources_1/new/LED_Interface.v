`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/22 11:27:35
// Design Name: 
// Module Name: LED_Interface
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


module LED_Interface(
    input  wire         rst,
    input  wire         clk,
    input  wire         we,
    input  wire [31:0]  addr,
    input  wire [23:0]  wdata,
    output reg  [31:0]  led
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            led <= 24'b0; 
        end
        else if (we && addr == 32'hfffff060)begin
            led <= wdata[23:0];
        end
        else begin
            led <= led;
        end
    end
endmodule
