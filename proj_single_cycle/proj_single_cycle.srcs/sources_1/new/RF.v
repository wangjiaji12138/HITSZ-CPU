`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 15:56:15
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


module RF(
    input  wire        clk,
    input  wire        rst,
    input wire [ 1:0] op,
    input wire [31:0] pc4,
    input wire [31:0] ext,
    input wire [31:0] dou,
    input wire [31:0] C,
    input wire [31:0] rdo,
    
    input  wire [ 4:0] rR1,
    output wire  [31:0] rD1,
    
    input  wire [ 4:0] rR2,
    output wire  [31:0] rD2,
    
    input  wire        we,
    input  wire [ 4:0] wR
);
    // inner logic of RF
    reg [31:0] regs [31:0];
    reg [31:0] wD;
    assign rD1 = regs[rR1];
    assign rD2 = regs[rR2];
    
    always @(*) begin
        case (op)
            `RF_PC4:    begin wD = pc4; end
            `RF_EXT:    begin wD = ext; end
            `RF_RDO:    begin wD = dou; end
            `RF_ALU:    begin wD = C; end
            default:    begin wD = 32'b0;end 
         endcase    
    end
    
    //write wD
    always @(posedge clk or posedge rst)begin
        if(rst) begin
            regs[0] <= 32'b0;
            regs[1] <= 32'b0;
            regs[2] <= 32'b0;
            regs[3] <= 32'b0;
            regs[4] <= 32'b0;
            regs[5] <= 32'b0;
            regs[6] <= 32'b0;
            regs[7] <= 32'b0;
            regs[8] <= 32'b0;
            regs[9] <= 32'b0;
            regs[10] <= 32'b0;
            regs[11] <= 32'b0;
            regs[12] <= 32'b0;
            regs[13] <= 32'b0;
            regs[14] <= 32'b0;
            regs[15] <= 32'b0;
            regs[16] <= 32'b0;
            regs[17] <= 32'b0;
            regs[18] <= 32'b0;
            regs[19] <= 32'b0;
            regs[20] <= 32'b0;
            regs[21] <= 32'b0;
            regs[22] <= 32'b0;
            regs[23] <= 32'b0;
            regs[24] <= 32'b0;
            regs[25] <= 32'b0;
            regs[26] <= 32'b0;
            regs[27] <= 32'b0;
            regs[28] <= 32'b0;
            regs[29] <= 32'b0;
            regs[30] <= 32'b0;
            regs[31] <= 32'b0;
        end
        else if(we && wR!=0) begin
            regs[wR] <= wD;
        end else begin
            regs[wR] <= regs[wR];
        end
    end
    

   
    

endmodule
