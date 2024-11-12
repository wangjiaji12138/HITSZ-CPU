`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/26 10:00:28
// Design Name: 
// Module Name: MEM_REG
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


module MEM_REG(
    input wire [ 0:0] clk,
    input wire [ 0:0] rst,
    input wire [ 0:0] mem_rf_we,
    input wire [31:0] mem_pc,
    input wire [ 4:0] mem_wR,
    input wire [31:0] mem_wD,
    input wire [ 0:0] flush,
    input wire [ 0:0] stop,
    input wire [ 0:0] mem_have_inst,
    output reg [ 0:0] wb_have_inst,
    output reg [31:0] wb_pc,    
    output reg [ 0:0] wb_rf_we,
    output reg [ 4:0] wb_wR,
    output reg [31:0] wb_wD
    );
    wire rst_n = !rst;
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            wb_pc <= 32'b0; 
        end
        else if (stop) begin
            wb_pc <= wb_pc;
        end
        else if (flush) begin
            wb_pc <= 32'b0;
        end
        else begin
            wb_pc <= mem_pc; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            wb_rf_we <= 1'b0; 
        end
        else if (stop) begin
            wb_rf_we <= wb_rf_we;
        end
        else if (flush) begin
            wb_rf_we <= 1'b0;
        end
        else begin
            wb_rf_we <= mem_rf_we; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            wb_wR <= 5'b0; 
        end
        else if (stop) begin
            wb_wR <= wb_wR;
        end
        else if (flush) begin
            wb_wR <= 5'b0;
        end
        else begin
            wb_wR <= mem_wR; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            wb_wD <= 32'b0; 
        end
        else if (stop) begin
            wb_wD <= wb_wD;
        end
        else if (flush) begin
            wb_wD <= 32'b0;
        end
        else begin
            wb_wD <= mem_wD; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            wb_have_inst <= 1'b0; 
        end
        else if (stop) begin
            wb_have_inst <= wb_have_inst;
        end
        else if (flush) begin
            wb_have_inst <= 1'b0;
        end
        else begin
            wb_have_inst <= mem_have_inst; 
        end
    end
endmodule
