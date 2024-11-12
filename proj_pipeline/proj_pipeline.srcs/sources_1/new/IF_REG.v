`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/26 10:00:28
// Design Name: 
// Module Name: IF_REG
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

module IF_REG(
    input wire [ 0:0] clk,
    input wire [ 0:0] rst,
    input wire [31:0] if_pc,
    input wire [31:0] if_pc4,
    input wire [31:0] if_inst,
    input wire [ 0:0] flush,
    input wire [ 0:0] stop,
    output reg [31:0] id_pc,
    output reg [31:0] id_pc4,
    output reg [31:0] id_inst
    
    );
    
    wire rst_n = !rst;
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            id_pc <= 32'b0; 
        end
        else if (stop) begin
            id_pc <= id_pc;
        end
        else if (flush) begin
            id_pc <= 32'b0;
        end
        else begin
            id_pc <= if_pc; 
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            id_pc4 <= 32'b0; 
        end
        else if (stop) begin
            id_pc4 <= id_pc4;
        end
        else if (flush) begin
            id_pc4 <= 32'b0;
        end
        else begin
            id_pc4 <= if_pc4; 
        end
    end
       
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            id_inst <= 32'b0; 
        end
        else if (stop) begin
            id_inst <= id_inst;
        end
        else if (flush) begin
            id_inst <= 32'b0;
        end
        else begin
            id_inst <= if_inst; 
        end
    end
endmodule
