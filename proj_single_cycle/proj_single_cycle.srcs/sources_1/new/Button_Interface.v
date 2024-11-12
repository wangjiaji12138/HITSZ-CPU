`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/22 11:27:53
// Design Name: 
// Module Name: Button_Interface
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


module Button_Interface(
    input  wire         rst,
    input  wire         clk,
    input  wire [31:0]  addr,
    input  wire [ 4:0]  button,
    output  reg [31:0]  rdata
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            rdata <= 32'b0; 
        end
        else begin
            rdata <= {27'b0,button};
        end
    end
endmodule
