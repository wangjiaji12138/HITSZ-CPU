`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/26 10:00:28
// Design Name: 
// Module Name: ID_REG
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


module ID_REG(
    input wire [ 0:0] clk,
    input wire [ 0:0] rst,
    input wire [ 1:0] id_rf_wsel,
    input wire [ 0:0] id_dram_we,
    input wire [ 3:0] id_alu_op,
    input wire [ 1:0] id_npc_op,
    input wire [ 2:0] id_width,
    input wire [ 0:0] id_rf_we,
    input wire [31:0] id_pc,
    input wire [31:0] id_pc4,
    input wire [ 4:0] id_wR,
    input wire [31:0] id_rD2,
    input wire [31:0] id_alu_a,
    input wire [31:0] id_alu_b,
    input wire [31:0] id_ext,
    input wire [ 0:0] flush,
    input wire [ 0:0] stop,
    input wire [ 0:0] id_have_inst,
    input wire [ 3:0] id_branch,
    output reg [ 0:0] ex_have_inst,
    output reg [ 1:0] ex_rf_wsel,
    output reg [ 0:0] ex_dram_we,
    output reg [ 3:0] ex_alu_op,
    output reg [ 1:0] ex_npc_op,
    output reg [ 2:0] ex_width,
    output reg [ 0:0] ex_rf_we,
    output reg [31:0] ex_pc,
    output reg [31:0] ex_pc4,
    output reg [ 4:0] ex_wR,
    output reg [31:0] ex_rD2,
    output reg [31:0] ex_alu_a,
    output reg [31:0] ex_alu_b,
    output reg [31:0] ex_ext,
    output reg [ 3:0] ex_branch
    );
    wire rst_n = !rst;
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_rf_wsel <= 2'b0; 
        end
        else if (stop) begin
            ex_rf_wsel <= ex_rf_wsel;
        end
        else if (flush) begin
            ex_rf_wsel <= 2'b0;
        end
        else begin
            ex_rf_wsel <= id_rf_wsel; 
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_dram_we <= 1'b0; 
        end
        else if (stop) begin
            ex_dram_we <= ex_dram_we;
        end
        else if (flush) begin
            ex_dram_we <= 1'b0;
        end
        else begin
            ex_dram_we <= id_dram_we; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_alu_op <= 4'b0; 
        end
        else if (stop) begin
            ex_alu_op <= ex_alu_op;
        end
        else if (flush) begin
            ex_alu_op <= 4'b0;
        end
        else begin
            ex_alu_op <= id_alu_op; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_npc_op <= 2'b0; 
        end
        else if (stop) begin
            ex_npc_op <= ex_npc_op;
        end
        else if (flush) begin
            ex_npc_op <= 2'b0;
        end
        else begin
            ex_npc_op <= id_npc_op; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_width <= 3'b0; 
        end
        else if (stop) begin
            ex_width <= ex_width;
        end
        else if (flush) begin
            ex_width <= 3'b0;
        end
        else begin
            ex_width <= id_width; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_rf_we <= 1'b0; 
        end
        else if (stop) begin
            ex_rf_we <= ex_rf_we;
        end
        else if (flush) begin
            ex_rf_we <= 1'b0;
        end
        else begin
            ex_rf_we <= id_rf_we; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_pc <= 32'b0; 
        end
        else if (stop) begin
            ex_pc <= ex_pc;
        end
        else if (flush) begin
            ex_pc <= 32'b0;
        end
        else begin
            ex_pc <= id_pc; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_pc4 <= 32'b0; 
        end
        else if (stop) begin
            ex_pc4 <= ex_pc4;
        end
        else if (flush) begin
            ex_pc4 <= 32'b0;
        end
        else begin
            ex_pc4 <= id_pc4; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_wR <= 5'b0; 
        end
        else if (stop) begin
            ex_wR <= ex_wR;
        end
        else if (flush) begin
            ex_wR <= 5'b0;
        end
        else begin
            ex_wR <= id_wR; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_rD2 <= 32'b0; 
        end
        else if (stop) begin
            ex_rD2 <= ex_rD2;
        end
        else if (flush) begin
            ex_rD2 <= 32'b0;
        end
        else begin
            ex_rD2 <= id_rD2; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_alu_a <= 32'b0; 
        end
        else if (stop) begin
            ex_alu_a <= ex_alu_a;
        end
        else if (flush) begin
            ex_alu_a <= 32'b0;
        end
        else begin
            ex_alu_a <= id_alu_a; 
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_alu_b <= 32'b0; 
        end
        else if (stop) begin
            ex_alu_b <= ex_alu_b;
        end
        else if (flush) begin
            ex_alu_b <= 32'b0;
        end
        else begin
            ex_alu_b <= id_alu_b; 
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_ext <= 32'b0; 
        end
        else if (stop) begin
            ex_ext <= ex_ext;
        end
        else if (flush) begin
            ex_ext <= 32'b0;
        end
        else begin
            ex_ext <= id_ext; 
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_have_inst <= 1'b0; 
        end
        else if (stop) begin
            ex_have_inst <= ex_have_inst;
        end
        else if (flush) begin
            ex_have_inst <= 1'b0;
        end
        else begin
            ex_have_inst <= id_have_inst; 
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ex_branch <= 4'b0; 
        end
        else if (stop) begin
            ex_branch <= ex_branch;
        end
        else if (flush) begin
            ex_branch <= 4'b0;
        end
        else begin
            ex_branch <= id_branch; 
        end
    end
endmodule
