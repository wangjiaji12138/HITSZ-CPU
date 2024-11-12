`timescale 1ns / 1ps
`include "param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/17 14:36:07
// Design Name: 
// Module Name: DIGIT
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


module DIGIT(
    input wire [ 2:0] op,
    input wire [31:0] dig,
    input wire [31:0] rD2,
    output reg [31:0] dou,
    input wire [31:0] rdo
    );
    
    wire [1:0]dig_b = dig[1:0];   //Bus 32/4
    wire [0:0]dig_h = dig[1:1];   //Bus 32/16
    wire [31:0] din;

    assign din = (op == `WIDTH_8S || op == `WIDTH_16S || op == `WIDTH_32S) ? rD2 : rdo;

    always @(*) begin
        if(op == `WIDTH_8) begin
            if(dig_b==2'b00) begin
                if(din[7]==1'b1) begin
                    dou = {24'hFFFFFF,din[7:0]};
                end
                else begin
                    dou = {24'h000000,din[7:0]};
                end
            end
            if(dig_b==2'b01) begin
                if(din[15]==1'b1) begin
                    dou = {24'hFFFFFF,din[15:8]};
                end
                else begin
                    dou = {24'h000000,din[15:8]};
                end
            end
            if(dig_b==2'b10) begin
                if(din[23]==1'b1) begin
                    dou = {24'hFFFFFF,din[23:16]};
                end
                else begin
                    dou = {24'h000000,din[23:16]};
                end
            end
            if(dig_b==2'b11) begin
                if(din[31]==1'b1) begin
                    dou = {24'hFFFFFF,din[31:24]};
                end
                else begin
                    dou = {24'h000000,din[31:24]};
                end
            end
        end
        else if(op == `WIDTH_8U) begin
            if(dig_b==2'b00) begin dou = {24'h000000,din[7:0]}; end
            else if(dig_b==2'b01) begin dou = {24'h000000,din[15:8]}; end
            else if(dig_b==2'b10) begin dou = {24'h000000,din[23:16]}; end
            else begin dou = {24'h000000,din[31:24]}; end
        end
        else if(op == `WIDTH_16) begin
            if(dig_h==1'b0) begin
                if(din[15]==1'b1) begin
                    dou = {16'hFFFF,din[15:0]};
                end
                else begin
                    dou = {16'h0000,din[15:0]};
                end
            end
            else begin
                if(din[31]==1'b1) begin
                    dou = {16'hFFFF,din[31:16]};
                end
                else begin
                    dou = {16'h0000,din[31:16]};
                end
            end
        end
        else if(op == `WIDTH_16U) begin
            if(dig_h==1'b0) begin dou = {16'h0000,din[15:0]}; end
            else begin dou = {16'h0000,din[31:16]}; end
        end
        else if(op == `WIDTH_8S) begin
            if(dig_b == 2'b00) begin dou = {rdo[31:8],din[7:0]}; end
            else if(dig_b == 2'b01) begin dou = {rdo[31:16],din[7:0],rdo[7:0]}; end
            else if(dig_b == 2'b10) begin dou = {rdo[31:24],din[7:0],rdo[15:0]}; end
            else begin dou = {din[7:0],rdo[23:0]}; end
        end
        else if(op == `WIDTH_16S) begin
            if(dig_h == 1'b0) begin dou = {rdo[31:16],din[15:0]}; end
            else begin dou = {din[15:0],rdo[15:0]}; end
        end
        else begin
            dou = din;
        end
    end
endmodule
