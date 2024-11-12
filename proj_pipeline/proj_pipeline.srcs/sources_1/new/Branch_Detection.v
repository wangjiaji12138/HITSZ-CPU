`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/26 10:00:28
// Design Name: 
// Module Name: Control_Hazard_Detection
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


module Branch_Detection(
    input  wire        clk,
    input  wire        rst,
    input wire [31:0]  pc,
    input  wire [31:0] inst,
    input  wire [ 0:0] br,
    input wire [3:0] ex_branch,
    output wire [31:0] pc_jump,
    output  reg [0:0] jump
    );
    wire [6:0] opcode = inst[6:0];
    wire [2:0] funct3 = inst[14:12];
    wire [6:0] funct7 = inst[31:25];
    reg [1:0] branchs [5:0];    //beq,bne,blt,blu,bge,bgeu
    wire [3:0] branch = (opcode ==7'b1100011 && funct3 == 4'b000) ? `BRANCH_BEQ:
                     (opcode ==7'b1100011 && funct3 == 4'b001) ? `BRANCH_BNE:
                     (opcode ==7'b1100011 && funct3 == 4'b100) ? `BRANCH_BLT:
                     (opcode ==7'b1100011 && funct3 == 4'b110) ? `BRANCH_BLTU:
                     (opcode ==7'b1100011 && funct3 == 4'b101) ? `BRANCH_BGE:
                     (opcode ==7'b1100011 && funct3 == 4'b111) ? `BRANCH_BGEU: 4'b0;
    wire ja = (branch ==4'b0111) || (branch ==4'b1000);                  
    wire r_type = (opcode == 7'b0110011) ? 1'b1 : 1'b0;
    wire i_type = (opcode == 7'b0010011 || opcode == 7'b0000011 || opcode ==7'b1100111) ? 1'b1 : 1'b0;
    wire s_type = (opcode == 7'b0100011) ? 1'b1 : 1'b0;
    wire b_type = (opcode == 7'b1100011) ? 1'b1 : 1'b0;
    wire u_type = (opcode == 7'b0110111 || opcode == 7'b0010111) ? 1'b1 : 1'b0;
    wire j_type = (opcode == 7'b1101111) ? 1'b1 : 1'b0;
    
    wire [2:0] sext_op =  i_type ? `EXT_I:
                      s_type ? `EXT_S:
                      b_type ? `EXT_B:
                      u_type ? `EXT_U:
                      j_type ? `EXT_J:3'b000;
    wire [31:7] imm = inst[31:7];
    reg  [31:0] ext;
    always @(*) begin
        case(sext_op)
            `EXT_I: ext = imm[31] ? {20'b1111_1111_1111_1111_1111,imm[31:20]} : {20'b0000_0000_0000_0000_0000,imm[31:20]};
            `EXT_S: ext = imm[31] ? {20'b1111_1111_1111_1111_1111,imm[31:25],imm[11:7]} : {20'b0000_0000_0000_0000_0000,imm[31:25],imm[11:7]};
            `EXT_B: ext = imm[31] ? {19'b111_1111_1111_1111_1111,imm[31],imm[7],imm[30:25],imm[11:8],1'b0} : {19'b000_0000_0000_0000_0000,imm[31],imm[7],imm[30:25],imm[11:8],1'b0};
            `EXT_U: ext = imm[31] ? {imm[31:12],12'b0000_0000_0000} : {imm[31:12],12'b0000_0000_0000};
            `EXT_J: ext = imm[31] ? {11'b111_1111_1111,imm[31],imm[19:12],imm[20],imm[30:21],1'b0} : {11'b000_0000_0000,imm[31],imm[19:12],imm[20],imm[30:21],1'b0};
            default:ext = 32'b0;
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            branchs[0] <= 2'b0;
            branchs[1] <= 2'b0;
            branchs[2] <= 2'b0;
            branchs[3] <= 2'b0;
            branchs[4] <= 2'b0;
            branchs[5] <= 2'b0;
            jump <= 1'b0;
        end
        else begin
            if(br && ex_branch !=4'b0) begin
                if(branchs[branch] == 2'b00) begin
                    branchs[branch] <= 2'b01;
                    jump <= 1'b0;
                end
                else if(branchs[branch] == 2'b01) begin
                    branchs[branch] <= 2'b11;
                    jump <= 1'b1;
                end
                else if(branchs[branch] == 2'b10) begin
                    branchs[branch] <= 2'b11;
                    jump <= 1'b1;
                end
                else if(branchs[branch] == 2'b11) begin
                    branchs[branch] <= 2'b11;
                    jump <= 1'b1;
                end
            end
            else if(ex_branch !=4'b0)begin
                if(branchs[branch] == 2'b00) begin
                    branchs[branch] <= 2'b00;
                    jump <= 1'b0;
                end
                else if(branchs[branch] == 2'b01) begin
                    branchs[branch] <= 2'b00;
                    jump <= 1'b0;
                end
                else if(branchs[branch] == 2'b10) begin
                    branchs[branch] <= 2'b00;
                    jump <= 1'b0;
                end
                else if(branchs[branch] == 2'b11) begin
                    branchs[branch] <= 2'b10;
                    jump <= 1'b1;
                end
            end
            else begin 
                branchs[branch] <= branchs[branch];
                jump <= jump;
            end
        end
    end
    
    assign pc_jump = pc+ ext;
endmodule
