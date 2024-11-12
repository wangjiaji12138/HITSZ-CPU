`timescale 1ns / 1ps

`include "defines.vh"
`include "param.v"
module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
`ifdef RUN_TRACE
    output wire [15:0]  inst_addr,
`else
    output wire [13:0]  inst_addr,
`endif
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_we,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);
`timescale 1ns / 1ps

    wire [31:0] NPC_npc;
    wire [31:0] NPC_pc4;
    
    wire [31:0] PC_pc;
    
    wire [31:0] RF_rD1;
    wire [31:0] RF_rD2;
    
    wire [31:0] SEXT_ext;
    
    wire [31:0] ALU_C;
    wire [0:0] ALU_f;
    
    wire[31:0] Digit_do;

    wire [1:0]  Ctrl_npc_op;
    wire [0:0]  Ctrl_rf_we;
    wire [2:0]  Ctrl_sext_op;
    wire [3:0]  Ctrl_alu_op;
    wire [0:0]  Ctrl_dram_we;
    wire [1:0]  Ctrl_rf_wsel;
    wire [0:0]  Ctrl_alu_asel;
    wire [0:0]  Ctrl_alu_bsel;
    wire [2:0]  Ctrl_width;
    
    wire [31:0] RF_WDSEL_output;
    
    assign inst_addr = PC_pc[15:2];
    assign Bus_addr = ALU_C;
    assign Bus_wdata = Digit_do;
    assign Bus_we = Ctrl_dram_we;

    PC U_PC (
        .rst        (cpu_rst),              // input  wire
        .clk        (cpu_clk),              // input  wire
        .din        (NPC_npc),              // input  wire [31:0]
        .pc         (PC_pc)                 // output  reg [31:0]
    );

    NPC U_NPC (
        .PC         (PC_pc),                 // input  wire [31:0]
        .npc        (NPC_npc),               // output wire [31:0]
        .pc4        (NPC_pc4),               // output wire [31:0]
        .PC_jal     (RF_rD1),                // input  wire [31:0]
        .offset     (SEXT_ext),              // input  wire [31:0]
        .br         (ALU_f),                 // input  wire [ 0:0]
        .op         (Ctrl_npc_op)            // input  wire [ 1:0]
    );

    RF U_RF (
        .clk        (cpu_clk),              // input  wire
        .rst        (cpu_rst),
        .op         (Ctrl_rf_wsel),         // input  wire [ 2:0]
        .pc4        (NPC_pc4),              // input  wire [31:0]
        .ext        (SEXT_ext),             // input  wire [31:0]
        .dou        (Digit_do),             // input  wire [31:0]
        .C          (ALU_C),                // input  wire [31:0]
        .rdo        (Bus_rdata),            // input  wire [31:0] 
        .rR1        (inst[19:15]),     // input  wire [ 4:0]
        .rD1        (RF_rD1),               // output reg  [31:0]
        
        .rR2        (inst[24:20]),     // input  wire [ 4:0]
        .rD2        (RF_rD2),               // output reg  [31:0]
        
        .we         (Ctrl_rf_we),           // input  wire [ 0:0]
        .wR         (inst[11:7])    // input  wire [ 4:0]
    );

    SEXT U_SEXT (
        .imm        (inst[31:7]),           // input  wire [12:0]
        .op         (Ctrl_sext_op),          // input wire [2:0]
        .ext        (SEXT_ext)              // output reg [31:0]
    );

    ALU U_ALU (
        .op         (Ctrl_alu_op),          // input  wire [3:0]
        .A          (Ctrl_alu_asel ? PC_pc : RF_rD1),        // input  wire [31:0]
        .B          (Ctrl_alu_bsel ? RF_rD2 : SEXT_ext),     // input  wire [31:0]
        .C          (ALU_C),                 // output reg[31:0]
        .f          (ALU_f)
    );

    Ctrl U_Ctrl (
        .opcode     (inst[6:0]),       // input  wire [6:0]
        .funct3     (inst[14:12]),     // input  wire [2:0]
        .funct7     (inst[31:25]),     // input  wire [6:0]
        .npc_op     (Ctrl_npc_op),          // output wire [1:0]
        .rf_we      (Ctrl_rf_we),           // output wire [0:0]
        .sext_op    (Ctrl_sext_op),         // output wire [2:0]
        .alu_op     (Ctrl_alu_op),          // output wire [3:0]
        .dram_we    (Ctrl_dram_we),         // output wire [0:0]
        .rf_wsel    (Ctrl_rf_wsel),         // output wire [2:0]
        .alu_asel   (Ctrl_alu_asel),        // output wire [0:0]
        .alu_bsel   (Ctrl_alu_bsel),        // output wire [0:0]
        .width      (Ctrl_width)            // output wire [2:0]
    );
    
    DIGIT U_DIGIT (
        .op     (Ctrl_width),               //input wire [ 1:0]
        .dig    (ALU_C),
        .rD2    (RF_rD2),
        .rdo    (Bus_rdata),
        .dou    (Digit_do)
    );
    

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1'b1;
    assign debug_wb_pc        = PC_pc;
    assign debug_wb_ena       = Ctrl_rf_we;
    assign debug_wb_reg       = inst[11:7];
    assign debug_wb_value     = RF_WDSEL_output;
`endif
endmodule
