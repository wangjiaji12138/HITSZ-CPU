// file: param.v
`ifndef CPU_PARAM
`define CPU_PARAM

    // npc_op:
    `define NPC_PC4      'b00
    `define NPC_B        'b01
    `define NPC_JMP      'b10
    `define NPC_JALR     'b11

    //rf_we
    `define RF_READ      'b0
    `define RF_WRITE     'b1
    
    //rf_wsel
    `define RF_PC4       'b00
    `define RF_EXT       'b01
    `define RF_RDO       'b10
    `define RF_ALU       'b11
    
    //sext_op
    `define EXT_I        'b000
    `define EXT_S        'b001
    `define EXT_B        'b010
    `define EXT_U        'b011
    `define EXT_J        'b100
    
    //alu_op
    `define ALU_ADD      'b0000
    `define ALU_SUB      'b0001
    `define ALU_AND      'b0010
    `define ALU_OR       'b0011
    `define ALU_XOR      'b0100
    `define ALU_LL       'b0101
    `define ALU_RL       'b0110
    `define ALU_RA       'b0111
    `define ALU_GE       'b1000
    `define ALU_GEU      'b1001
    `define ALU_LT       'b1010
    `define ALU_LTU      'b1011
    
    //alu_asel
    `define ALUA_RS1     'b0
    `define ALUA_PC      'b1
    
    //alu_bsel
    `define ALUB_EXT     'b0
    `define ALUB_RS2     'b1
    
    //dram_we
    `define DRAM_READ    'b0
    `define DRAM_WRITE   'b1
    
    //width
    `define WIDTH_8      'b000
    `define WIDTH_8S     'b001
    `define WIDTH_8U     'b010
    `define WIDTH_16     'b011
    `define WIDTH_16S    'b100
    `define WIDTH_16U    'b101
    `define WIDTH_32     'b110
    `define WIDTH_32S    'b111

    //state
    `define STATE_IDLE 'b0001
    `define STATE_WRIT 'b0010
    `define STATE_WORK 'b0100
    `define STATE_RETU 'b1000

`endif

