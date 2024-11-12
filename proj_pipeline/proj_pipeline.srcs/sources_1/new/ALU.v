`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 15:56:39
// Design Name: 
// Module Name: ALU
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

module ALU(
    input  wire [ 3:0] op,
    input  wire [31:0] A,
    input  wire [31:0] B,
    output wire [31:0] C,
    output wire [0:0]  f
);
    reg [31:0] output_C;
    reg [0:0] output_f;
    reg [31:0] output_C_n;
    assign C = output_C;
    assign f = output_f;
    
    // inner logic of ALU
    always @(*) begin
        case (op)
            `ALU_ADD:   begin output_C = A+B;end
            `ALU_SUB:   begin output_C = A-B;
                                output_f = (output_C !=32'b0);end
            `ALU_AND:   begin output_C = A&B;
                                output_f = (A==B);end
            `ALU_OR:    begin output_C = A|B;
                                output_f = A||B;end
            `ALU_XOR:   begin output_C = A^B;end
            `ALU_LL:    begin output_C = A<<(B[4:0]);end
            `ALU_RL:    begin output_C = A>>(B[4:0]);end
            `ALU_RA:    begin 
                if(A[31]) begin
                        output_C_n = (~A)>>(B[4:0]);
                        output_C = ~ output_C_n;
                    end
                else begin
                        output_C = A>>(B[4:0]);
                    end
                end
            `ALU_GE:    begin 
                if(A[31]==1'b0 && B[31]==1'b0)  begin
                    output_C = A>=B;
                    output_f = A>=B;
                end else if(A[31]==1'b0 && B[31]==1'b1) begin
                    output_C = 1;
                    output_f = 1;
                end else if(A[31]==1'b1 && B[31]==1'b0) begin
                    output_C = 0;
                    output_f = 0; 
                end else begin
                    output_C = A>=B;
                    output_f = A>=B;
                end
                end
             `ALU_GEU:    begin output_f = A>=B;end
             `ALU_LT:    begin 
                if(A[31]==1'b0 && B[31]==1'b0)  begin
                    output_C = A<B;
                    output_f = A<B;
                end else if(A[31]==1'b0 && B[31]==1'b1) begin
                    output_C = 0;
                    output_f = 0;
                end else if(A[31]==1'b1 && B[31]==1'b0) begin
                    output_C = 1;
                    output_f = 1; 
                end else begin
                    output_C = A<B;
                    output_f = A<B;
                end
                end
             `ALU_LTU:    begin output_C = A<B;
                                output_f = A<B;end
             default:    begin output_C = output_C;
                               output_f = output_C;
                            end
         endcase    
    end
endmodule
