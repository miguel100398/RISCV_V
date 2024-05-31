//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 20/02/2022
//RISCV32 package


package riscv32_pkg;

    //Parameters
    parameter RISCV32_DATA_WIDTH    = 32;
    parameter RISCV32_ADDR_WIDTH    = 32;
    parameter RISCV32_NUM_REGS_RF   = 32;
    parameter RISCV32_PC_RST_VAL    = 32'h00400000;
    parameter RISCV32_SP_REG        = 2;
    parameter RISCV32_SP_RST_VAL    = 32'hFFFFFFFF;
    parameter RISCV32_RF_ADDR_WIDTH = $clog2(RISCV32_NUM_REGS_RF);
    parameter RISCV32_OP_CODE_WIDTH = 7;
    parameter RISCV32_IMM_SHIFT     = 0;

    parameter RISCV32_R_TYPE_OP_CODE        = 7'b0110011;
    parameter RISCV32_I_TYPE_OP_CODE        = 7'b0010011;
    parameter RISCV32_S_TYPE_OP_CODE        = 7'b0100011;
    parameter RISCV32_B_TYPE_OP_CODE        = 7'b1100011;
    parameter RISCV32_J_TYPE_OP_CODE        = 7'b1101111;
    parameter RISCV32_LOAD_OP_CODE          = 7'b0000011;
    parameter RISCV32_FENCE_OP_CODE         = 7'b0001111;
    parameter RISCV32_ECALL_EBREAK_OP_CODE  = 7'b1110011;
    parameter RISCV32_LUI_OP_CODE           = 7'b0110111;
    parameter RISCV32_AUIPC_OP_CODE         = 7'b0010111;
    parameter RISCV32_JALR_OP_CODE          = 7'b1100111;

    parameter RISCV32_FUNCT3_ADD            = 3'b000;
    parameter RISCV32_FUNCT3_SLT            = 3'b010;
    parameter RISCV32_FUNCT3_SLTU           = 3'b011;
    parameter RISCV32_FUNCT3_XOR            = 3'b100;
    parameter RISCV32_FUNCT3_OR             = 3'b110;
    parameter RISCV32_FUNCT3_AND            = 3'b111;
    parameter RISCV32_FUNCT3_SLL            = 3'b001;
    parameter RISCV32_FUNCT3_BEQ            = 3'b000;
    parameter RISCV32_FUNCT3_LW             = 3'b010;
    parameter RISCV32_FUNCT3_BNE            = 3'b001;
    parameter RISCV32_FUNCT3_SRL            = 3'b101;
    parameter RISCV32_FUNCT7_SRA            = 7'b0100000;
    parameter RISCV32_FUNCT7_SUB            = 7'b0100000;

    typedef enum logic[2:0] {
        FETCH_S      = 3'd0,
        DECODE_S     = 3'd1,
        EXECUTE_S    = 3'd2,
        WRITE_BACK_S = 3'd3,
        MEM_ACCESS_S = 3'd4
    }riscv32_state_t;

    typedef enum logic[1:0]{
        RISCV_ALU_ADD    = 2'd0,
        RISCV_ALU_SUB    = 2'd1,
        RISCV_ALU_FUNCT  = 2'd2,
        RISCV_ALU_PASS_B = 2'd3
    } riscv_alu_op_e;
    
    typedef enum logic[2:0]{
        R_TYPE = 3'd0,
        I_TYPE = 3'd1,
        S_TYPE = 3'd2,
        B_TYPE = 3'd3,
        U_TYPE = 3'd4,
        J_TYPE = 3'd5} instr_type_e;

    typedef struct packed {
        logic[6:0] funct7;
        logic[4:0] rs2;
        logic[4:0] rs1;
        logic[2:0] funct3;
        logic[4:0] rd;
        logic[6:0] op;
    } r_type_instruction_t;

    typedef struct packed {
        logic[11:0] imm_11_0;
        logic[4:0] rs1;
        logic[2:0] funct3;
        logic[4:0] rd;
        logic[6:0] op;
    } i_type_instruction_t;

    typedef struct packed {
        logic[6:0] imm_11_5;
        logic[4:0] rs2;
        logic[4:0] rs1;
        logic[2:0] funct3;
        logic[4:0] imm_4_0;
        logic[6:0] op;
    } s_type_instruction_t;

    typedef struct packed {
        logic[6:0] imm_12_10_5;
        logic[4:0] rs2;
        logic[4:0] rs1;
        logic[2:0] funct3;
        logic[4:0] imm_4_1_11;
        logic[6:0] op;
    } b_type_instruction_t;

    typedef struct packed {
        logic[19:0] imm_31_12;
        logic[4:0] rd;
        logic[6:0] op;
    } u_type_instruction_t;

    typedef struct packed {
        logic[19:0] imm;
        logic[4:0] rd;
        logic[6:0] op;
    } j_type_instruction_t;

    typedef struct packed {
        logic[RISCV32_DATA_WIDTH-1:0] instruction;
        logic[RISCV32_DATA_WIDTH-1:0] pc_add4; 
        logic[RISCV32_DATA_WIDTH-1:0] pc;
        logic                         take_branch_pred;
    } if_id_t;

    typedef struct packed {
        logic                            RegWrite;
        logic                            MemRead;
        logic                            MemWrite;
        logic                            BNE;
        logic                            BEQ;
        logic[1:0]                       MemtoReg;
        riscv_alu_op_e                   riscv_alu_op;
        logic                            ALUsrcA;
        logic                            ALUsrcB;
        logic                            jump_en;
        logic[RISCV32_DATA_WIDTH-1:0]    rd_reg1;
        logic[RISCV32_DATA_WIDTH-1:0]    rd_reg2;
        logic[RISCV32_RF_ADDR_WIDTH-1:0] rs1;
        logic[RISCV32_RF_ADDR_WIDTH-1:0] rs2;
        logic[RISCV32_RF_ADDR_WIDTH-1:0] rd;
        logic[RISCV32_DATA_WIDTH-1:0]    pc_add4;
        logic[6:0]                       funct7;
        logic[2:0]                       funct3;
        logic[RISCV32_DATA_WIDTH-1:0]    pc; 
        logic[RISCV32_DATA_WIDTH-1:0]    immediate;
        logic                            take_branch_pred;
    } id_ex_t;

    typedef struct packed {
        logic                            RegWrite;
        logic                            MemRead;
        logic                            MemWrite;
        logic[1:0]                       MemtoReg;
        logic[RISCV32_RF_ADDR_WIDTH-1:0] rd;
        logic[RISCV32_DATA_WIDTH-1:0]    ALU_result;
        logic[RISCV32_DATA_WIDTH-1:0]    rd_reg2;
        logic[RISCV32_DATA_WIDTH-1:0]    pc_add4; 
    } ex_mem_t;

    typedef struct packed {
        logic                            RegWrite;
        logic[1:0]                       MemtoReg;
        logic[RISCV32_RF_ADDR_WIDTH-1:0] rd;
        logic[RISCV32_DATA_WIDTH-1:0]    ALU_result;
        logic[RISCV32_DATA_WIDTH-1:0]    data_mem;
        logic[RISCV32_DATA_WIDTH-1:0]    pc_add4; 
    } mem_wb_t;

    typedef struct packed {
        logic BNE;
        logic BEQ;
        logic MemRead;
        logic MemWrite;
        logic RegWrite;
        logic jump_en;
        logic take_branch_pred;
    } hazard_signals_t;

    parameter HAZARD_SIGNALS_WIDTH = $bits(hazard_signals_t);


endpackage: riscv32_pkg
