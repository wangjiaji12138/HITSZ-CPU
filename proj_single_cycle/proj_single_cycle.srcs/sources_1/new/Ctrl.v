`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 15:52:30
// Design Name: 
// Module Name: RF
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


module Ctrl(
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output wire [1:0] npc_op,
    output wire [0:0] rf_we,
    output wire [2:0] sext_op,
    output wire [3:0] alu_op,
    output wire [0:0] dram_we,
    output wire [1:0] rf_wsel,
    output wire [0:0] alu_asel,
    output wire [0:0] alu_bsel,
    output wire [2:0] width
);

    // inner logic of CTRL

    wire r_type = (opcode == 7'b0110011) ? 1'b1 : 1'b0;
    wire i_type = (opcode == 7'b0010011 || opcode == 7'b0000011 || opcode ==7'b1100111) ? 1'b1 : 1'b0;
    wire s_type = (opcode == 7'b0100011) ? 1'b1 : 1'b0;
    wire b_type = (opcode == 7'b1100011) ? 1'b1 : 1'b0;
    wire u_type = (opcode == 7'b0110111 || opcode == 7'b0010111) ? 1'b1 : 1'b0;
    wire j_type = (opcode == 7'b1101111) ? 1'b1 : 1'b0;
    
    assign npc_op = (!opcode[6]) ? `NPC_PC4:
                     opcode[6] && i_type ? `NPC_JALR:
                     opcode[6] && b_type ? `NPC_B:
                     opcode[6] && j_type ? `NPC_JMP : 2'b0;
    
    assign rf_we = (r_type || i_type|| u_type || j_type) ? `RF_WRITE : `RF_READ;
    
    assign rf_wsel = (r_type || (i_type && opcode[4])) || (u_type && !opcode[5])? `RF_ALU:
                     (i_type && opcode[6]) || j_type ? `RF_PC4:
                      i_type ? `RF_RDO:`RF_EXT;
                      
    assign sext_op = i_type ? `EXT_I:
                      s_type ? `EXT_S:
                      b_type ? `EXT_B:
                      u_type ? `EXT_U:
                      j_type ? `EXT_J:3'b000;
                      
    assign alu_op =  (opcode == 7'b0110011 && funct3 == 3'b000 && !funct7[5])||(opcode == 7'b0010011 && funct3==3'b000)||
                     (opcode == 7'b0000011)||opcode == 7'b1100111||opcode ==7'b0010111||s_type ? `ALU_ADD :
                     (opcode == 7'b0110011 && funct3 == 3'b000 && funct7[5])||(opcode == 7'b1100011 && funct3 == 3'b001) ? `ALU_SUB:
                     (opcode == 7'b0110011 && funct3 == 3'b111)||(opcode == 7'b0010011 && funct3 == 3'b111)||(opcode == 7'b1100011 && funct3 == 3'b000) ? `ALU_AND:
                     (opcode == 7'b0110011 && funct3 == 3'b110)||(opcode == 7'b0010011 && funct3 == 3'b110) ? `ALU_OR:
                     (opcode == 7'b0110011 && funct3 == 3'b100)||(opcode == 7'b0010011 && funct3 == 3'b100) ? `ALU_XOR:
                     (opcode == 7'b0110011 && funct3 == 3'b001)||(opcode == 7'b0010011 && funct3 == 3'b001) ? `ALU_LL:
                     (opcode == 7'b0110011 && funct3 == 3'b101 && !funct7[5])||(opcode == 7'b0010011 && funct3 == 3'b101 && !funct7[5]) ? `ALU_RL:
                     (opcode == 7'b0110011 && funct3 == 3'b101 && funct7[5])||(opcode == 7'b0010011 && funct3 == 3'b101 && funct7[5]) ? `ALU_RA:
                     (opcode == 7'b1100011 && funct3 == 3'b101) ? `ALU_GE:
                     (opcode == 7'b1100011 && funct3 == 3'b111) ? `ALU_GEU:
                     (opcode == 7'b1100011 && funct3 == 3'b100)||(opcode == 7'b0010011 && funct3 == 3'b010)||(opcode == 7'b0110011 && funct3 == 3'b010) ? `ALU_LT:
                     (opcode == 7'b1100011 && funct3 == 3'b110)||(opcode == 7'b0010011 && funct3 == 3'b011)||(opcode == 7'b0110011 && funct3 == 3'b011) ? `ALU_LTU:4'b0000;
     
     assign alu_asel = (opcode==7'b0010111) ? `ALUA_PC : `ALUA_RS1;
     
     assign alu_bsel = (r_type ||b_type) ? `ALUB_RS2 : `ALUB_EXT;
     
     assign dram_we = s_type ? `DRAM_WRITE : `DRAM_READ;
     
     assign width = (opcode == 7'b0000011 && funct3 == 3'b000) ? `WIDTH_8:
                    (opcode == 7'b0000011 && funct3 == 3'b100) ? `WIDTH_8U:
                    (opcode == 7'b0000011 && funct3 == 3'b001) ? `WIDTH_16:
                    (opcode == 7'b0000011 && funct3 == 3'b101) ? `WIDTH_16U:
                    (opcode == 7'b0000011 && funct3 == 3'b010) ? `WIDTH_32:
                    (opcode == 7'b0100011 && funct3 == 3'b000) ? `WIDTH_8S:
                    (opcode == 7'b0100011 && funct3 == 3'b001) ? `WIDTH_16S:
                    (opcode == 7'b0100011 && funct3 == 3'b010) ? `WIDTH_32S:`WIDTH_32;

                     

endmodule
