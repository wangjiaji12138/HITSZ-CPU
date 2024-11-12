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
    input  wire [31:0] PC,
    input  wire [31:0] PC_jal,
    input  wire [31:0] offset,
    input  wire        br,
    input  wire [ 1:0] op,
    output reg  [31:0] npc,
    output wire [31:0] pc4
);
    assign pc4 = PC + 4;
    
    always @(*) begin
        case (op)
            `NPC_PC4:   begin npc = PC+4;end
            `NPC_B:     begin npc = br ? PC+offset : PC+4;end
            `NPC_JMP:   begin npc = PC+offset;end    
            `NPC_JALR:  begin npc = (PC_jal+offset) & 32'hFFFF_FFFE; end
            default:    begin npc = PC+4;end 
         endcase    
    end
    
endmodule
