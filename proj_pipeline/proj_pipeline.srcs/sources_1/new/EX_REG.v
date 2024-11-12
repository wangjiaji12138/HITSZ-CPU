`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/26 10:00:28
// Design Name: 
// Module Name: EX_REG
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


module EX_REG(
    input wire [ 0:0] clk,
    input wire [ 0:0] rst,
    input wire [ 1:0] ex_rf_wsel,
    input wire [ 0:0] ex_dram_we,
    input wire [ 2:0] ex_width,
    input wire [ 0:0] ex_rf_we,
    input wire [31:0] ex_pc,
    input wire [31:0] ex_pc4,
    input wire [ 4:0] ex_wR,
    input wire [31:0] ex_wD,
    input wire [31:0] ex_rD2,
    input wire [31:0] ex_alu_c,
    input wire [ 0:0] flush,
    input wire [ 0:0] stop,
    input wire [ 0:0] ex_have_inst,
    output reg [ 0:0] mem_have_inst,
    output reg [ 1:0] mem_rf_wsel,
    output reg [ 0:0] mem_dram_we,
    output reg [ 2:0] mem_width,
    output reg [ 0:0] mem_rf_we,
    output reg [31:0] mem_pc,
    output reg [31:0] mem_pc4,
    output reg [ 4:0] mem_wR,
    output reg [31:0] mem_wD,
    output reg [31:0] mem_rD2,
    output reg [31:0] mem_alu_c
    );
    wire rst_n = !rst;
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            mem_rf_wsel <= 2'b0; 
        end
        else if (stop) begin
            mem_rf_wsel <= mem_rf_wsel;
        end
        else if (flush) begin
            mem_rf_wsel <= 2'b0;
        end
        else begin
            mem_rf_wsel <= ex_rf_wsel; 
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            mem_dram_we <= 1'b0; 
        end
        else if (stop) begin
            mem_dram_we <= mem_dram_we;
        end
        else if (flush) begin
            mem_dram_we <= 1'b0;
        end
        else begin
            mem_dram_we <= ex_dram_we; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            mem_width <= 3'b0; 
        end
        else if (stop) begin
            mem_width <= mem_width;
        end
        else if (flush) begin
            mem_width <= 3'b0;
        end
        else begin
            mem_width <= ex_width; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            mem_rf_we <= 1'b0; 
        end
        else if (stop) begin
            mem_rf_we <= mem_rf_we;
        end
        else if (flush) begin
            mem_rf_we <= 1'b0;
        end
        else begin
            mem_rf_we <= ex_rf_we; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            mem_pc <= 32'b0; 
        end
        else if (stop) begin
            mem_pc <= mem_pc;
        end
        else if (flush) begin
            mem_pc <= 32'b0;
        end
        else begin
            mem_pc <= ex_pc; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            mem_pc4 <= 32'b0; 
        end
        else if (stop) begin
            mem_pc4 <= mem_pc4;
        end
        else if (flush) begin
            mem_pc4 <= 32'b0;
        end
        else begin
            mem_pc4 <= ex_pc4; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            mem_wR <= 5'b0; 
        end
        else if (stop) begin
            mem_wR <= mem_wR;
        end
        else if (flush) begin
            mem_wR <= 5'b0;
        end
        else begin
            mem_wR <= ex_wR; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            mem_rD2 <= 32'b0; 
        end
        else if (stop) begin
            mem_rD2 <= mem_rD2;
        end
        else if (flush) begin
            mem_rD2 <= 32'b0;
        end
        else begin
            mem_rD2 <= ex_rD2; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            mem_alu_c <= 32'b0; 
        end
        else if (stop) begin
            mem_alu_c <= mem_alu_c;
        end
        else if (flush) begin
            mem_alu_c <= 32'b0;
        end
        else begin
            mem_alu_c <= ex_alu_c; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            mem_have_inst <= 1'b0; 
        end
        else if (stop) begin
            mem_have_inst <= mem_have_inst;
        end
        else if (flush) begin
            mem_have_inst <= 1'b0;
        end
        else begin
            mem_have_inst <= ex_have_inst; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            mem_wD <= 32'b0; 
        end
        else if (stop) begin
            mem_wD <= mem_wD;
        end
        else if (flush) begin
            mem_wD <= 32'b0;
        end
        else begin
            mem_wD <= ex_wD; 
        end
    end
endmodule
