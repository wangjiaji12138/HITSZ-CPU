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
    wire [0:0] jump;
    wire [31:0] pc_jump;
    wire [0:0] ALU_f;
    
    wire[31:0] Digit_do;
    
    wire [0:0] Ctrl_alu_asel;
    wire [0:0] Ctrl_alu_bsel;
    wire [2:0] Ctrl_sext_op; 
    wire [0:0] Ctrl_id_rf1;
    wire [0:0] Ctrl_id_rf2;
    wire [3:0] id_branch;
    wire [3:0] ex_branch;
    
    wire [31:0] if_pc4;
    wire [31:0] id_pc4;
    wire [31:0] ex_pc4;
    wire [31:0] mem_pc4;
    
    wire [31:0] if_pc;
    wire [31:0] id_pc;
    wire [31:0] ex_pc;
    wire [31:0] mem_pc;
    wire [31:0] wb_pc;
    
    wire [31:0] if_inst;
    wire [31:0] id_inst;
   
    wire [ 1:0] id_rf_wsel;
    wire [ 1:0] ex_rf_wsel;
    wire [ 1:0] mem_rf_wsel;
    
    wire [ 0:0] id_dram_we;
    wire [ 0:0] ex_dram_we;
    wire [ 0:0] mem_dram_we;
    
    wire [ 3:0] id_alu_op;
    wire [ 3:0] ex_alu_op;
    
    wire [ 1:0] id_npc_op;
    wire [ 1:0] ex_npc_op;
    
    wire [ 2:0] id_width;
    wire [ 2:0] ex_width;
    wire [ 2:0] mem_width;
    
    wire [ 0:0] id_rf_we;
    wire [ 0:0] ex_rf_we;
    wire [ 0:0] mem_rf_we;
    wire [ 0:0] wb_rf_we;
    
    wire [ 4:0] id_wR;
    wire [ 4:0] ex_wR;
    wire [ 4:0] mem_wR;
    wire [ 4:0] wb_wR;
    
    wire [31:0] id_rD1;
    wire [31:0] ex_rD1;
    
    wire [31:0] id_rD2;
    wire [31:0] ex_rD2;
    wire [31:0] mem_rD2;
    
    wire [31:0] id_ext;
    wire [31:0] ex_ext;
    wire [31:0] mem_ext;
    
    wire [31:0] id_alu_a;
    wire [31:0] ex_alu_a;
    
    wire [31:0] id_alu_b;
    wire [31:0] ex_alu_b;
    
    wire [31:0] id_rD1_forwd = if_forwA ? forward_dataA: id_rD1; 
    assign id_alu_a = Ctrl_alu_asel ? id_pc : id_rD1_forwd;
    
    wire [31:0] id_rD2_forwd = if_forwB ? forward_dataB : id_rD2;
    assign id_alu_b = Ctrl_alu_bsel ? id_rD2_forwd : id_ext;
    
    

    
    wire [31:0] ex_alu_c;
    wire [31:0] mem_alu_c;
    
    wire [31:0] ex_wD = ex_rf_wsel == `RF_EXT ? ex_ext :ex_alu_c ;
    wire [31:0] mem_wD;
    wire [31:0] mem_wD2;
    wire [31:0] wb_wD;
    
    wire [0:0] IF_ID_flush,ID_EX_flush;
    wire [0:0] ID_EX_Data_flush;
    wire [0:0] ID_EX_Control_flush;
    assign ID_EX_flush = ID_EX_Data_flush | ID_EX_Control_flush;
    wire [0:0] IF_ID_stop;
    wire [0:0] npc_stop;
    wire [0:0] if_forwA; 
    wire [0:0] if_forwB;
    wire [31:0] forward_dataA;
    wire [31:0] forward_dataB;
    
    wire [0:0] id_have_inst,ex_have_inst,mem_have_inst,wb_have_inst;
    assign inst_addr = if_pc[15:2];
    assign Bus_addr = mem_alu_c;
    assign Bus_wdata = Digit_do;
    assign Bus_we = mem_dram_we;

    assign mem_wD2 = mem_rf_wsel ==2'b00 ? mem_pc4 :
                     mem_rf_wsel ==2'b10 ? Digit_do :
                     mem_rf_wsel ==2'b11 || mem_rf_wsel == 2'b01 ? mem_wD : 32'b0;

    PC U_PC (
        .din        (NPC_npc),              // input  wire [31:0]
        .pc         (if_pc)                 // output  reg [31:0]
        
    );

    NPC U_NPC (
        .rst        (cpu_rst),              // input  wire
        .clk        (cpu_clk),              // input  wire
        .pc         (if_pc),                 // input  wire [31:0]
        .npc        (NPC_npc),               // output wire [31:0]
        .pc4        (if_pc4),               // output wire [31:0]
        .stop       (npc_stop),
        .pc_jal     (ex_pc),
        .pc_jalr    (ex_alu_c),
        .offset     (ex_ext),  
        .br         (ALU_f),                 // input  wire [ 0:0]
        .op         (ex_npc_op),            // input  wire [ 1:0]
        .jump       (jump),
        .pc_jump    (pc_jump)
    );

    RF U_RF (
        .clk        (cpu_clk),              // input  wire
        .rst        (cpu_rst),
        .rR1        (id_inst[19:15]),     // input  wire [ 4:0]
        .rD1        (id_rD1),               // output reg  [31:0]
        
        .rR2        (id_inst[24:20]),     // input  wire [ 4:0]
        .rD2        (id_rD2),               // output reg  [31:0]
        
        .we         (wb_rf_we),           // input  wire [ 0:0]
        .wR         (wb_wR),    // input  wire [ 4:0]
        .wD         (wb_wD)
    );

    SEXT U_SEXT (
        .imm        (id_inst[31:7]),           // input  wire [12:0]
        .op         (Ctrl_sext_op),          // input wire [2:0]
        .ext        (id_ext)              // output reg [31:0]
    );
    
    ALU U_ALU (
        .op         (ex_alu_op),          // input  wire [3:0]
        .A          (ex_alu_a),        // input  wire [31:0]
        .B          (ex_alu_b),     // input  wire [31:0]
        .C          (ex_alu_c),                 // output reg[31:0]
        .f          (ALU_f)
    );

    Ctrl U_Ctrl (
        .opcode     (id_inst[6:0]),       // input  wire [6:0]
        .funct3     (id_inst[14:12]),     // input  wire [2:0]
        .funct7     (id_inst[31:25]),     // input  wire [6:0]
        .npc_op     (id_npc_op),          // output wire [1:0]
        .rf_we      (id_rf_we),           // output wire [0:0]
        .sext_op    (Ctrl_sext_op),         // output wire [2:0]
        .alu_op     (id_alu_op),          // output wire [3:0]
        .dram_we    (id_dram_we),         // output wire [0:0]
        .rf_wsel    (id_rf_wsel),         // output wire [2:0]
        .alu_asel   (Ctrl_alu_asel),        // output wire [0:0]
        .alu_bsel   (Ctrl_alu_bsel),        // output wire [0:0]
        .width      (id_width),            // output wire [2:0]
        .branch     (id_branch),
        .id_rf1      (Ctrl_id_rf1),
        .id_rf2      (Ctrl_id_rf2),
        .id_have_inst (id_have_inst)
    );
    
    DIGIT U_DIGIT (
        .op     (mem_width),               //input wire [ 1:0]
        .alu    (mem_alu_c),
        .rD2    (mem_rD2),
        .rdo    (Bus_rdata),
        .dou    (Digit_do)
    );
    
    IF_REG U_IF_REG (
        .clk        (cpu_clk),
        .rst        (cpu_rst),
        .if_pc      (if_pc),
        .if_pc4     (if_pc4),
        .if_inst    (inst),
        .flush      (IF_ID_flush),
        .stop       (IF_ID_stop),
        .id_pc      (id_pc),
        .id_pc4     (id_pc4),
        .id_inst    (id_inst)
    );
    
    ID_REG U_ID_REG (
        .clk        (cpu_clk),
        .rst        (cpu_rst),
        .id_rf_wsel (id_rf_wsel),
        .id_dram_we (id_dram_we),
        .id_alu_op  (id_alu_op),
        .id_npc_op  (id_npc_op),
        .id_width   (id_width),
        .id_rf_we   (id_rf_we),
        .id_pc      (id_pc),
        .id_pc4     (id_pc4),
        .id_wR      (id_inst[11:7]),
        .id_rD2     (id_rD2_forwd),
        .id_alu_a   (id_alu_a),
        .id_alu_b   (id_alu_b),
        .id_ext     (id_ext),
        .flush      (ID_EX_flush),
        .stop       (1'b0),
        .id_have_inst (id_have_inst),
        .id_branch (id_branch),
        
        .ex_rf_wsel (ex_rf_wsel),
        .ex_dram_we (ex_dram_we),
        .ex_alu_op  (ex_alu_op),
        .ex_npc_op  (ex_npc_op),
        .ex_width   (ex_width),
        .ex_rf_we   (ex_rf_we),
        .ex_pc      (ex_pc),
        .ex_pc4     (ex_pc4),
        .ex_wR      (ex_wR),
        .ex_rD2     (ex_rD2),
        .ex_alu_a   (ex_alu_a),
        .ex_alu_b   (ex_alu_b),
        .ex_ext     (ex_ext),
        .ex_have_inst (ex_have_inst),
        .ex_branch  (ex_branch)
    );
    EX_REG U_EX_REG (
        .clk        (cpu_clk),
        .rst        (cpu_rst),   
        .ex_rf_wsel (ex_rf_wsel),
        .ex_dram_we (ex_dram_we),
        .ex_width   (ex_width),
        .ex_rf_we   (ex_rf_we),
        .ex_pc      (ex_pc),
        .ex_pc4     (ex_pc4),
        .ex_wR      (ex_wR),
        .ex_wD      (ex_wD),
        .ex_rD2     (ex_rD2),
        .ex_alu_c   (ex_alu_c),
        .flush      (1'b0),
        .stop       (1'b0),
        .ex_have_inst (ex_have_inst),
        
        .mem_rf_wsel    (mem_rf_wsel),
        .mem_dram_we    (mem_dram_we),
        .mem_width      (mem_width),
        .mem_rf_we      (mem_rf_we),
        .mem_pc         (mem_pc),
        .mem_pc4        (mem_pc4),
        .mem_wR         (mem_wR),
        .mem_wD         (mem_wD),
        .mem_rD2        (mem_rD2),
        .mem_alu_c      (mem_alu_c),
        .mem_have_inst (mem_have_inst)
    );
    
    MEM_REG U_MEM_REG(
        .clk        (cpu_clk),
        .rst        (cpu_rst),
        .mem_rf_we  (mem_rf_we),
        .mem_pc     (mem_pc),
        .mem_wR     (mem_wR),
        .mem_wD     (mem_wD2),
        .flush      (1'b0),
        .stop       (1'b0),
        .mem_have_inst (mem_have_inst),  
        .wb_pc      (wb_pc),    
        .wb_rf_we   (wb_rf_we),
        .wb_wR      (wb_wR),
        .wb_wD      (wb_wD),
        .wb_have_inst (wb_have_inst)
    );
    
    Data_Hazard_Detection U_Data_Hazard_Detection (
        .id_rs1         (id_inst[19:15]),
        .id_rs2         (id_inst[24:20]),
        .id_rf1         (Ctrl_id_rf1),        
        .id_rf2         (Ctrl_id_rf2),
        
        .ex_rf_we       (ex_rf_we),  
        .mem_rf_we      (mem_rf_we),
        .wb_rf_we       (wb_rf_we),
        .ex_dram_we     (ex_dram_we),
        .ex_wD          (ex_wD),
        .mem_wD         (mem_wD2), 
        .wb_wD          (wb_wD),  
        
        .ex_wR          (ex_wR),
        .mem_wR         (mem_wR),
        .wb_wR          (wb_wR),
        
        .npc_stop       (npc_stop),
        .IF_ID_stop     (IF_ID_stop),
        .ID_EX_flush    (ID_EX_Data_flush),
        .if_forwA       (if_forwA), 
        .if_forwB       (if_forwB),
        .forward_dataA  (forward_dataA),
        .forward_dataB  (forward_dataB)
    );
    
    Control_Hazard_Detection U_Control_Hazard_Detection (
        .branch      (ex_branch),
        .br          (ALU_f),
        .IF_ID_flush (IF_ID_flush),
        .ID_EX_flush (ID_EX_Control_flush)
    );
    Branch_Detection U_Branch_Detection (
        .clk        (cpu_clk),
        .rst        (cpu_rst),
        .pc         (if_pc),
        .inst       (inst),
        .br         (ALU_f),
        .pc_jump    (pc_jump),
        .ex_branch  (ex_branch),
        .jump       (jump)
    );
`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = wb_have_inst;
    assign debug_wb_pc        = wb_pc;
    assign debug_wb_ena       = wb_rf_we;
    assign debug_wb_reg       = wb_wR;
    assign debug_wb_value     = wb_wD;
`endif
endmodule
