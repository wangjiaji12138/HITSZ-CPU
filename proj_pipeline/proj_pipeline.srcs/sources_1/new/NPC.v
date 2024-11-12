`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 15:56:50
// Design Name: 
// Module Name: NPC
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

module NPC(
    input  wire        rst,
    input  wire        clk,
    input  wire [31:0] pc,
    input  wire [31:0] pc_jal,
    input  wire [31:0] pc_jalr,
    input  wire [31:0] offset,
    input  wire        br,
    input  wire [ 0:0] stop,
    input wire [0:0] jump,
    input wire [31:0] pc_jump,
    input  wire [ 1:0] op,
    output reg  [31:0] npc,
    output wire [31:0] pc4
);
    assign pc4 = pc + 4;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            npc <= 32'b0;
        end
        else if(stop) begin
            npc <= npc;
        end
        else if(jump) begin
            npc <= pc_jump; 
        end
        else begin
            case (op)
                `NPC_PC4:   begin npc <= pc4;end
                `NPC_B:     begin npc <= br ? pc_jal+offset : pc4;end
                `NPC_JMP:   begin npc <= pc_jal+offset;end    
                `NPC_JALR:  begin npc <= pc_jalr & 32'hFFFF_FFFE; end
                default:    begin npc <= pc4;end 
            endcase
         end    
    end
   
endmodule
