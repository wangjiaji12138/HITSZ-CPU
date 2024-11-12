`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/22 11:27:20
// Design Name: 
// Module Name: DLED_Interface
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


module DLED_Interface(
    input  wire         rst,
    input  wire         clk,
    input  wire         we,
    input  wire [31:0]  addr,
    input  wire [31:0]  wdata,
    
    output  reg [ 7:0]  dig_en,
    output  reg         DN_A,
    output  reg         DN_B,
    output  reg         DN_C,
    output  reg         DN_D,
    output  reg         DN_E,
    output  reg         DN_F,
    output  reg         DN_G,
    output  reg         DN_DP
    );
    
    reg  [31:0] wd_r;
    wire [31:0] wd_w;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            wd_r <= 32'b0;
        end
        else if(we && addr == 32'hfffff000) begin
            wd_r <= wdata;
        end
        else begin
            wd_r <= wd_r;
        end
    end
    
    assign wd_w = wd_r;
    
    wire [7:0]  A7,A6,A5,A4,A3,A2,A1,A0;
    Dig U_Dig7 (.rst(rst),.clk(clk),.data(wd_w[31:28]),.Dled(A7));
    Dig U_Dig6 (.rst(rst),.clk(clk),.data(wd_w[27:24]),.Dled(A6));
    Dig U_Dig5 (.rst(rst),.clk(clk),.data(wd_w[23:20]),.Dled(A5));
    Dig U_Dig4 (.rst(rst),.clk(clk),.data(wd_w[19:16]),.Dled(A4));
    Dig U_Dig3 (.rst(rst),.clk(clk),.data(wd_w[15:12]),.Dled(A3));
    Dig U_Dig2 (.rst(rst),.clk(clk),.data(wd_w[11: 8]),.Dled(A2));
    Dig U_Dig1 (.rst(rst),.clk(clk),.data(wd_w[ 7: 4]),.Dled(A1));
    Dig U_Dig0 (.rst(rst),.clk(clk),.data(wd_w[ 3: 0]),.Dled(A0));
    
    always @(*)begin
        case(dig_en)
            8'b11111110:    {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = A0;
            8'b11111101:    {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = A1;
            8'b11111011:    {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = A2;
            8'b11110111:    {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = A3;
            8'b11101111:    {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = A4;
            8'b11011111:    {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = A5;
            8'b10111111:    {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = A6;
            8'b01111111:    {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = A7;
            default:        {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = 8'b11111111;
        endcase
    end
    
    reg         counting;
    wire        count_end;
    reg [24:0]  count;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            counting <= 1'b0;
        end
        else if(we) begin
            counting <= 1'b1;
        end
        else begin
            counting <= counting;
        end
    end
    
    //2ms fresh
    assign count_end = counting & (count == 25'd19999);
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            count <= 25'd0;
        end
        else if(count_end) begin
            count <= 25'd0;
        end
        else if(counting) begin
            count <= count + 25'd1;
        end
        else begin
            count <= count;
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            dig_en <= 8'b11111110;
        end
        else if(count_end) begin
            dig_en <= {dig_en[6:0],dig_en[7]};
        end
        else begin
            dig_en <= dig_en;
        end
    end
endmodule
