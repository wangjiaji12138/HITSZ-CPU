`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/26 10:00:28
// Design Name: 
// Module Name: Data_Hazard_Detection
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


module Data_Hazard_Detection(
    input wire [ 4:0] id_rs1,
    input wire [ 4:0] id_rs2,
    input wire [ 0:0] id_rf1,
    input wire [ 0:0] id_rf2,
    
    input wire [ 0:0] ex_rf_we,
    input wire [ 0:0] mem_rf_we,
    input wire [ 0:0] wb_rf_we,
    input wire [ 0:0] ex_dram_we,
    input wire [31:0] ex_wD,
    input wire [31:0] mem_wD, 
    input wire [31:0] wb_wD,  
    
    input wire [ 4:0] ex_wR,
    input wire [ 4:0] mem_wR,
    input wire [ 4:0] wb_wR,
    
    output reg [ 0:0] npc_stop,
    output reg [ 0:0] IF_ID_stop,
    output reg [ 0:0] ID_EX_flush,
    output wire [ 0:0] if_forwA, 
    output wire [ 0:0] if_forwB,
    output  reg [31:0] forward_dataA,
    output  reg [31:0] forward_dataB
    );
    wire rs1_id_ex_hazard = (ex_wR == id_rs1) & id_rs1 !=5'b0 & ex_rf_we & id_rf1;
    wire rs2_id_ex_hazard = (ex_wR == id_rs2) & id_rs2 !=5'b0 & ex_rf_we & id_rf2;
    
    wire rs1_id_mem_hazard = (mem_wR == id_rs1) & id_rs1 !=5'b0 & mem_rf_we & id_rf1;
    wire rs2_id_mem_hazard = (mem_wR == id_rs2) & id_rs2 !=5'b0 & mem_rf_we & id_rf2;
    
    wire rs1_id_wb_hazard = (wb_wR == id_rs1) & id_rs1 !=5'b0 & wb_rf_we & id_rf1;
    wire rs2_id_wb_hazard = (wb_wR == id_rs2) & id_rs2 !=5'b0 & wb_rf_we & id_rf2;
     
    wire load_use_hazard = (rs1_id_ex_hazard | rs2_id_ex_hazard) & ex_rf_wsel == `RF_RDO;
    assign if_forwA = rs1_id_ex_hazard | rs1_id_mem_hazard | rs1_id_wb_hazard;
    assign if_forwB = rs2_id_ex_hazard | rs2_id_mem_hazard | rs2_id_wb_hazard;
    always @(*) begin
        if(rs1_id_ex_hazard) begin
            forward_dataA = ex_wD;
        end
        else if (rs1_id_mem_hazard) begin
            forward_dataA = mem_wD;
        end
        else if (rs1_id_wb_hazard) begin
            forward_dataA = wb_wD;
        end
        else begin
             forward_dataA = 32'b0;
        end
    end
    
    always @(*) begin
        if(rs2_id_ex_hazard) begin
            forward_dataB = ex_wD;
        end
        else if (rs2_id_mem_hazard) begin
            forward_dataB = mem_wD;
        end
        else if (rs2_id_wb_hazard) begin
            forward_dataB = wb_wD;
        end
        else begin
             forward_dataB = 32'b0;
        end
    end
    
    always @(*) begin
        if(load_use_hazard) begin
            npc_stop = 1'b1;
            IF_ID_stop = 1'b1;
            ID_EX_flush = 1'b1;
        end
        else begin
            npc_stop = 1'b0;
            IF_ID_stop = 1'b0;
            ID_EX_flush = 1'b0;
        end
    end
endmodule
