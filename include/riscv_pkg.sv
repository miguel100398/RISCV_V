//File: riscv_pkg.sv
//Author: Miguel Bucio
//Date: 25/09/23
//Description: RISC-V package



package riscv_pkg;

`ifndef RISCV_REGRESSION 
    parameter string RISCV_ROM_FILE = "sort_final_project.mem";
`else 
    parameter string RISCV_ROM_FILE = "../../../../../../assembly_code/sort_final_project.mem";        //Relative path only to be used with vivado and running regression, if using different tool the path could need to be changed

`endif //RISCV_REGRESSION

//Time constants
parameter real CLK_FREQ                     = 50e6;
parameter time CLK_PERIOD                   = 1/CLK_FREQ;

//Common constants
parameter int BYTE_WIDTH                    = 8;
parameter int WORD_WIDTH                    = 16;
parameter int DWORD_WIDTH                   = 32;
parameter int QWORD_WIDTH                   = 64;
parameter int DQWORD_WIDTH                  = 128;
parameter int QQWORD_WIDTH                  = 256;

//RISCV  Constants
parameter bit RISCV_USE_ROB               = 1'b1;

parameter int RISCV_DATA_WIDTH            = DWORD_WIDTH;                                    //Width of data in datapath
parameter int RISCV_NUM_BYTES_DATA        = RISCV_DATA_WIDTH / BYTE_WIDTH;                //Number of bytes in Data bus
parameter int RISCV_NUM_WORDS_DATA        = RISCV_DATA_WIDTH / WORD_WIDTH;                //Number of words in Data bus
parameter int RISCV_NUM_DWORDS_DATA       = RISCV_DATA_WIDTH / DWORD_WIDTH;               //Number of dwords in Data bus
parameter int RISCV_NUM_QWORDS_DATA       = RISCV_DATA_WIDTH / QWORD_WIDTH;               //Number of qwords in Data bus
parameter int RISCV_NUM_DQWORDS_DATA      = RISCV_DATA_WIDTH / DQWORD_WIDTH;              //Number of dqwords in Data bus
parameter int RISCV_NUM_QQWORDS_DATA      = RISCV_DATA_WIDTH / QQWORD_WIDTH;              //Number of dqwords in Data bus

parameter int RISCV_RAM_ADDR_WIDTH        = 6;

parameter logic [6:0]RISCV_R_TYPE_OP_CODE        = 7'b0110011;
parameter logic [6:0]RISCV_R_SHFT_TYPE_OP_CODE   = 7'b0010011;
parameter logic [6:0]RISCV_I_TYPE_OP_CODE        = 7'b0010011;
parameter logic [6:0]RISCV_S_TYPE_OP_CODE        = 7'b0100011;
parameter logic [6:0]RISCV_B_TYPE_OP_CODE        = 7'b1100011;
parameter logic [6:0]RISCV_J_TYPE_OP_CODE        = 7'b1101111;
parameter logic [6:0]RISCV_LOAD_OP_CODE          = 7'b0000011;
parameter logic [6:0]RISCV_FENCE_OP_CODE         = 7'b0001111;
parameter logic [6:0]RISCV_ECALL_EBREAK_OP_CODE  = 7'b1110011;
parameter logic [6:0]RISCV_LUI_OP_CODE           = 7'b0110111;
parameter logic [6:0]RISCV_AUIPC_OP_CODE         = 7'b0010111;
parameter logic [6:0]RISCV_JALR_OP_CODE          = 7'b1100111;

parameter logic [2:0]RISCV_FUNCT3_JALR           = 3'b000;
parameter logic [2:0]RISCV_FUNCT3_SB             = 3'b000;
parameter logic [2:0]RISCV_FUNCT3_SH             = 3'b001;
parameter logic [2:0]RISCV_FUNCT3_SW             = 3'b010;
parameter logic [2:0]RISCV_FUNCT3_LB             = 3'b000;
parameter logic [2:0]RISCV_FUNCT3_LH             = 3'b001;
parameter logic [2:0]RISCV_FUNCT3_LW             = 3'b010;
parameter logic [2:0]RISCV_FUNCT3_LBU            = 3'b100;
parameter logic [2:0]RISCV_FUNCT3_LHU            = 3'b101;
parameter logic [2:0]RISCV_FUNCT3_ADD            = 3'b000;
parameter logic [2:0]RISCV_FUNCT3_ADDI           = 3'b000;
parameter logic [2:0]RISCV_FUNCT3_SUB            = 3'b000;
parameter logic [2:0]RISCV_FUNCT3_SLT            = 3'b010;
parameter logic [2:0]RISCV_FUNCT3_SLTI           = 3'b010;
parameter logic [2:0]RISCV_FUNCT3_SLTU           = 3'b011;
parameter logic [2:0]RISCV_FUNCT3_SLTIU          = 3'b011;
parameter logic [2:0]RISCV_FUNCT3_XOR            = 3'b100;
parameter logic [2:0]RISCV_FUNCT3_XORI           = 3'b100;
parameter logic [2:0]RISCV_FUNCT3_OR             = 3'b110;
parameter logic [2:0]RISCV_FUNCT3_ORI            = 3'b110;
parameter logic [2:0]RISCV_FUNCT3_AND            = 3'b111;
parameter logic [2:0]RISCV_FUNCT3_ANDI           = 3'b111;
parameter logic [2:0]RISCV_FUNCT3_SLL            = 3'b001;
parameter logic [2:0]RISCV_FUNCT3_SLLI           = 3'b001; 
parameter logic [2:0]RISCV_FUNCT3_BEQ            = 3'b000;
parameter logic [2:0]RISCV_FUNCT3_BLT            = 3'b100;
parameter logic [2:0]RISCV_FUNCT3_BGE            = 3'b101;
parameter logic [2:0]RISCV_FUNCT3_BLTU           = 3'b110;
parameter logic [2:0]RISCV_FUNCT3_BGEU           = 3'b111;
parameter logic [2:0]RISCV_FUNCT3_BNE            = 3'b001;
parameter logic [2:0]RISCV_FUNCT3_SRL            = 3'b101;
parameter logic [2:0]RISCV_FUNCT3_SRLI           = 3'b101;
parameter logic [2:0]RISCV_FUNCT3_SRA            = 3'b101;
parameter logic [2:0]RISCV_FUNCT3_SRAI           = 3'b101;
parameter logic [2:0]RISCV_FUNCT3_MUL            = 3'b000;
parameter logic [2:0]RISCV_FUNCT3_DIV            = 3'b100;      
parameter logic [6:0]RISCV_FUNCT7_SRA            = 7'b0100000;
parameter logic [6:0]RISCV_FUNCT7_SRL            = 7'b0000000;
parameter logic [6:0]RISCV_FUNCT7_SUB            = 7'b0100000;
parameter logic [6:0]RISCV_FUNCT7_MUL            = 7'b0000001;
parameter logic [6:0]RISCV_FUNCT7_DIV            = 7'b0000001;
parameter logic [6:0]RISCV_FUNCT7_GEN            = 7'b0000000;
parameter logic [6:0]RISCV_FUNCT7_SPEC           = 7'b0100000;

parameter int RISCV_FUNCT3_BRANCH_SIGN_POS       = 1;
parameter int RISCV_FUNCT3_LOAD_SIGN_POS         = 2;

parameter int RISCV_LS_SIZE_BEGIN               = 1;
parameter int RISCV_LS_SIZE_END                 = 0;

//Instruction 
parameter int RISCV_INSTR_WIDTH                 = 32;                                             //Width of instructions
parameter int RISCV_INSTR_FUNCT7_WIDTH          = 7;
parameter int RISCV_INSTR_FUNCT6_WIDTH          = 6;
parameter int RISCV_INSTR_FUNCT3_WIDTH          = 3;
parameter int RISCV_INSTR_RS_WIDTH              = 5;
parameter int RISCV_INSTR_RD_WIDTH              = 5;
parameter int RISCV_INSTR_OP_WIDTH              = 7;
parameter int RISCV_INSTR_IMM_11_0_WIDTH        = 12;
parameter int RISCV_INSTR_IMM_11_5_WIDTH        = 7;
parameter int RISCV_INSTR_IMM_4_0_WIDTH         = 5;
parameter int RISCV_INSTR_IMM_12_10_5_WIDTH     = 7;
parameter int RISCV_INSTR_IMM_4_1_11_WIDTH      = 5;
parameter int RISCV_INSTR_IMM_31_12_WIDTH       = 20;
parameter int RISCV_INSTR_IMM_JUMP_WIDTH        = 20;
parameter int RISCV_INSTR_MASK_WIDTH            = 1;

typedef logic [RISCV_INSTR_FUNCT7_WIDTH-1:0]        riscv_instr_funct7_t;
typedef logic [RISCV_INSTR_FUNCT6_WIDTH-1:0]        riscv_instr_funct6_t;
typedef logic [RISCV_INSTR_FUNCT3_WIDTH-1:0]        riscv_instr_funct3_t;
typedef logic [RISCV_INSTR_RS_WIDTH-1:0]            riscv_instr_rs_t;
typedef logic [RISCV_INSTR_RD_WIDTH-1:0]            riscv_instr_rd_t;
typedef logic [RISCV_INSTR_OP_WIDTH-1:0]            riscv_instr_op_t;
typedef logic [RISCV_INSTR_IMM_11_0_WIDTH-1:0]      riscv_instr_imm_11_0_t;
typedef logic [RISCV_INSTR_IMM_11_5_WIDTH-1:0]      riscv_instr_imm_11_5_t;
typedef logic [RISCV_INSTR_IMM_4_0_WIDTH-1:0]       riscv_instr_imm_4_0_t;
typedef logic [RISCV_INSTR_IMM_12_10_5_WIDTH-1:0]   riscv_instr_imm_12_10_5_t;
typedef logic [RISCV_INSTR_IMM_4_1_11_WIDTH-1:0]    riscv_instr_imm_4_1_11_t;
typedef logic [RISCV_INSTR_IMM_31_12_WIDTH-1:0]     riscv_instr_imm_31_12_t;
typedef logic [RISCV_INSTR_IMM_JUMP_WIDTH-1:0]      riscv_instr_imm_jump_t;
typedef logic [RISCV_INSTR_MASK_WIDTH-1:0]          riscv_instr_mask_t;

typedef struct packed {
        riscv_instr_funct7_t    funct7;
        riscv_instr_rs_t        rs2;
        riscv_instr_rs_t        rs1;
        riscv_instr_funct3_t    funct3;
        riscv_instr_rd_t        rd;
        riscv_instr_op_t        op;
    } riscv_r_type_instruction_t;

    typedef struct packed {
        riscv_instr_imm_11_0_t  imm_11_0;
        riscv_instr_rs_t        rs1;
        riscv_instr_funct3_t    funct3;
        riscv_instr_rd_t        rd;
        riscv_instr_op_t        op;
    } riscv_i_type_instruction_t;

    typedef struct packed {
        riscv_instr_imm_11_5_t  imm_11_5;
        riscv_instr_rs_t        rs2;
        riscv_instr_rs_t        rs1;
        riscv_instr_funct3_t    funct3;
        riscv_instr_imm_4_0_t   imm_4_0;
        riscv_instr_op_t        op;
    } riscv_s_type_instruction_t;

    typedef struct packed {
        riscv_instr_imm_12_10_5_t   imm_12_10_5;
        riscv_instr_rs_t            rs2;
        riscv_instr_rs_t            rs1;
        riscv_instr_funct3_t        funct3;
        riscv_instr_imm_4_1_11_t    imm_4_1_11;
        riscv_instr_op_t            op;
    } riscv_b_type_instruction_t;

    typedef struct packed {
        riscv_instr_imm_31_12_t     imm_31_12;
        riscv_instr_rd_t            rd;
        riscv_instr_op_t            op;
    } riscv_u_type_instruction_t;

    typedef struct packed {
        riscv_instr_imm_jump_t  imm;
        riscv_instr_rd_t        rd;
        riscv_instr_op_t        op;
    } riscv_j_type_instruction_t;

    typedef struct packed {
        riscv_instr_funct6_t  funct6;
        riscv_instr_mask_t    vm;
        riscv_instr_rs_t      vs2;
        riscv_instr_rs_t      vs1;
        riscv_instr_funct3_t  funct3;
        riscv_instr_rd_t      vd;
        riscv_instr_op_t      op;
    } riscv_v_type_instruction_t;

    typedef union packed {
        riscv_r_type_instruction_t      R;
        riscv_i_type_instruction_t      I;
        riscv_s_type_instruction_t      S;
        riscv_b_type_instruction_t      B;
        riscv_u_type_instruction_t      U;
        riscv_j_type_instruction_t      J;
        riscv_v_type_instruction_t      V;
        logic [RISCV_INSTR_WIDTH-1:0]   raw;
    } riscv_instruction_t;

//Common types
typedef logic[BYTE_WIDTH-1:0]   Byte_t;
typedef logic[WORD_WIDTH-1:0]   Word_t;
typedef logic[DWORD_WIDTH-1:0]  Dword_t;
typedef logic[QWORD_WIDTH-1:0]  Qword_t;
typedef logic[DQWORD_WIDTH-1:0] Dqword_t;
typedef logic[QQWORD_WIDTH-1:0] Qqword_t;

//RISCV types
typedef logic  [RISCV_DATA_WIDTH-1:0]             riscv_bit_bus_t;
typedef Byte_t [RISCV_NUM_BYTES_DATA-1:0]         riscv_byte_bus_t;
`ifdef RISCV_USE_WORD
    typedef Word_t [RISCV_NUM_WORDS_DATA-1:0]     riscv_word_bus_t;
`endif //RISCV_USE_WORD
`ifdef RISCV_USE_DWORD
    typedef Dword_t [RISCV_NUM_DWORDS_DATA-1:0]   riscv_dword_bus_t;
`endif //RISCV_USE_DWORD
`ifdef RISCV_USE_QWORD
    typedef Qword_t [RISCV_NUM_QWORDS_DATA-1:0]   riscv_qword_bus_t;   
`endif //RISCV_USE_QWORD
`ifdef RISCV_USE_DQWORD
    typedef Dqword_t [RISCV_NUM_DQWORDS_DATA-1:0] riscv_dqword_bus_t;
`endif //RISCV_USE_DQWORD

typedef union packed{
    riscv_bit_bus_t           Bit;
    riscv_byte_bus_t          Byte;
    `ifdef RISCV_USE_WORD
        riscv_word_bus_t      Word;
    `endif // RISCV_USE_WORD
    `ifdef RISCV_USE_DWORD
        riscv_dword_bus_t     Dword;
    `endif // RISCV_USE_DWORD
    `ifdef RISCV_USE_QWORD
        riscv_qword_bus_t     Qword;
    `endif // RISCV_USE_QWORD
    `ifdef RISCV_USE_DQWORD
        riscv_dqword_bus_t    Dqword;
    `endif // RISCV_USE_DQWORD
} riscv_data_t;

typedef logic [RISCV_RAM_ADDR_WIDTH-1:0] riscv_ram_addr_t;

//CSR
typedef enum logic [1:0] {OFF = 2'b00, ON = 2'b01, DIRTY = 2'b10, RSVD = 2'b11} riscv_csr_status_e;   //FIXME: Check if this values are correct

typedef struct packed {
    riscv_csr_status_e VS;         //mstatus[10:9] Vector Status Attempts to execute any vector instruction, or to access the vector CSRs, raise an illegal-instruction exception when mstatus.VS is set to Off.
    logic [8:0]  reserved;         //mstatus[8:0] Reserved for other riscv functionalities
} riscv_mstatus_t;

parameter mstatus_t riscv_mstatus_rst_val  = '{
    VS       : ON,
    reserved : 'x
};

//PC
parameter int RISCV_PC_WIDTH           = 32;
typedef logic [RISCV_PC_WIDTH-1:0] riscv_pc_t;

parameter riscv_pc_t RISCV_PC_RST_VAL  = 'h00400000;

//ICACHE
parameter int RISCV_ICACHE_NUM_INSTR        = 256;
parameter int RISCV_ICACHE_NUM_INSTR_NORM   = RISCV_ICACHE_NUM_INSTR << 2;
parameter int RISCV_ICACHE_LINE_SIZE        = 4;
parameter int RISCV_ICACHE_NUM_LINES        = RISCV_ICACHE_NUM_INSTR_NORM/RISCV_ICACHE_LINE_SIZE;
parameter int RISCV_ICACHE_SEL_BEGIN        = $clog2(RISCV_ICACHE_NUM_INSTR_NORM);
parameter int RISCV_ICACHE_SEL_END          = $clog2(RISCV_ICACHE_LINE_SIZE) + 2;

typedef riscv_instruction_t                                       riscv_icache_line_t           [RISCV_ICACHE_LINE_SIZE-1:0];
typedef riscv_instruction_t [RISCV_ICACHE_LINE_SIZE-1:0]          riscv_icache_line_packed_t;
typedef riscv_icache_line_packed_t                                riscv_icache_mem_t            [RISCV_ICACHE_NUM_LINES-1:0];
typedef logic [RISCV_ICACHE_SEL_BEGIN:RISCV_ICACHE_SEL_END]       riscv_icache_sel_t;

//IFQ
parameter int RISCV_IFQ_CACHE_PC_BEGIN = RISCV_INSTR_WIDTH-1;
parameter int RISCV_IFQ_CACHE_PC_END   = RISCV_ICACHE_SEL_END;
parameter int RISCV_IFQ_FIFO_PC_BEGIN  = RISCV_INSTR_WIDTH-1;
parameter int RISCV_IFQ_FIFO_PC_END    = 2;

parameter bit RISCV_IFQ_BYPASS_EN      = 1'b1;
parameter int RISCV_IFQ_NUM_ENTRIES    = 16;
parameter int RISCV_IFQ_NUM_RD_PORTS   = 1;
parameter int RISCV_IFQ_NUM_WR_PORTS   = RISCV_ICACHE_LINE_SIZE;
parameter bit RISCV_IFQ_INIT_FULL_SEQ  = 1'b0;

parameter int RISCV_IFQ_PTR_WIDTH        = $clog2(RISCV_IFQ_NUM_ENTRIES);
parameter int RISCV_IFQ_WR_PTR_END       = $clog2(RISCV_IFQ_NUM_WR_PORTS);
parameter int RISCV_IFQ_RD_PTR_END       = (RISCV_IFQ_NUM_RD_PORTS > RISCV_IFQ_NUM_WR_PORTS) ? RISCV_IFQ_WR_PTR_END : $clog2(RISCV_IFQ_NUM_RD_PORTS);

parameter int RISCV_IF_INSTR_PORT        = 0;

typedef logic [RISCV_IFQ_CACHE_PC_BEGIN : RISCV_IFQ_CACHE_PC_END] riscv_ifq_pc_cache_t;
typedef logic [RISCV_IFQ_FIFO_PC_BEGIN  : RISCV_IFQ_FIFO_PC_END]  riscv_ifq_pc_fifo_t;

typedef logic [RISCV_IFQ_PTR_WIDTH:RISCV_IFQ_WR_PTR_END]                riscv_ifq_wr_ptr_t;                           
typedef logic [RISCV_IFQ_PTR_WIDTH:RISCV_IFQ_RD_PTR_END]                riscv_ifq_rd_ptr_t;

parameter int RISCV_IFQ_WR_PTR_WIDTH = $bits(riscv_ifq_wr_ptr_t);
parameter int RISCV_IFQ_RD_PTR_WIDTH = $bits(riscv_ifq_rd_ptr_t);

typedef riscv_instruction_t  riscv_dispatch_intr_t [RISCV_IFQ_NUM_RD_PORTS-1:0];

//Regfile Constants
parameter bit RISCV_RF_PROTECT_REG_ZERO   = 1'b1;
parameter int RISCV_RF_NUM_WR_PORTS       = 1;
parameter int RISCV_RF_NUM_RD_PORTS       = 2; 
parameter int RISCV_RF_NUM_REGS           = 32;                                             //Number of registers in Register file
parameter int RISCV_RF_ADDR_WIDTH         = $clog2(RISCV_RF_NUM_REGS);                    //Width of addres of register file

parameter int RISCV_RF_RD_PORT            = 0;
parameter int RISCV_RF_RS1_PORT           = 0;
parameter int RISCV_RF_RS2_PORT           = 1;
parameter int RISCV_RF_WR_EN_PORT         = 0;
parameter int RISCV_RF_WR_DATA_PORT       = 0;
parameter int RISCV_RF_WR_ADDR_PORT       = 0;

//Regfile types
typedef logic[RISCV_RF_ADDR_WIDTH-1:0]  riscv_rf_addr_t;
typedef logic[RISCV_RF_NUM_REGS-1:1]    riscv_rf_en_t;

typedef riscv_data_t                    riscv_rf_regs_t    [RISCV_RF_NUM_REGS];
typedef riscv_rf_en_t                   riscv_rf_wr_en_t   [RISCV_RF_NUM_WR_PORTS-1:0];
typedef riscv_rf_addr_t                 riscv_rf_rd_addr_t [RISCV_RF_NUM_RD_PORTS-1:0];
typedef riscv_rf_addr_t                 riscv_rf_wr_addr_t [RISCV_RF_NUM_WR_PORTS-1:0];
typedef riscv_data_t                    riscv_rf_rd_data_t [RISCV_RF_NUM_RD_PORTS-1:0];
typedef riscv_data_t                    riscv_rf_wr_data_t [RISCV_RF_NUM_WR_PORTS-1:0];

//TAG FIFO
parameter int RISCV_TAG_FIFO_NUM_ENTRIES    = (2*RISCV_RF_NUM_REGS);
parameter int RISCV_TAG_FIFO_NUM_RD_PORTS   = 1;
parameter int RISCV_TAG_FIFO_NUM_WR_PORTS   = 1;
parameter bit RISCV_TAG_FIFO_BYPASS_EN      = 1'b1;
parameter bit RISCV_TAG_FIFO_INIT_FULL_SEQ  = 1'b1;
parameter int RISCV_TAG_FIFO_PORT           = 0;

//Register Status Table (RST)
parameter int RISCV_RST_NUM_ENTRIES    = 32;
parameter int RISCV_RST_NUM_WR_PORTS   = 2;
parameter int RISCV_RST_NUM_RD_PORTS   = 2;
parameter int RISCV_RST_VALID_WIDTH    = 1;
parameter int RISCV_RST_TAG_WIDTH      = $clog2(RISCV_TAG_FIFO_NUM_ENTRIES);
parameter int RISCV_RST_TOKEN_WIDTH    = RISCV_RST_VALID_WIDTH + RISCV_RST_TAG_WIDTH;
parameter int RISCV_RST_ADDR_WIDTH     = $clog2(RISCV_RST_NUM_ENTRIES);
parameter int RISCV_RST_TAG_WR_PORT    = 0; //Write port used to update table with new tag
parameter int RISCV_RST_CDB_CLEAR_PORT = 1; //Write port used to get cdb tag to be cleaned
parameter int RISCV_RST_BIT_BEGIN      = (RISCV_RF_PROTECT_REG_ZERO) ? 1 : 0;

typedef logic [RISCV_RST_ADDR_WIDTH-1:0] riscv_rst_addr_t;
typedef logic [RISCV_RST_TAG_WIDTH-1:0]  riscv_rst_tag_t;

typedef riscv_rst_tag_t riscv_tag_fifo_data_in_t  [RISCV_TAG_FIFO_NUM_WR_PORTS-1:0];
typedef riscv_rst_tag_t riscv_tag_fifo_data_out_t [RISCV_TAG_FIFO_NUM_RD_PORTS-1:0];

typedef struct packed {
    logic           valid;
    riscv_rst_tag_t tag;
} riscv_rst_token_t;

typedef riscv_rst_token_t riscv_rst_wr_data_t  [RISCV_RST_NUM_WR_PORTS-1:0];            //Data of second port is cdb_tag to be cleaned
typedef logic             riscv_rst_wr_en_t    [0:0];                                   //Second port doesn't need wr_en
typedef riscv_rst_addr_t  riscv_rst_wr_addr_t  [0:0];                                   //Second port doesn't need address

typedef riscv_rst_tag_t   riscv_rst_rd_data_t  [RISCV_RST_NUM_RD_PORTS-1:0];
typedef logic             riscv_rst_rd_valid_t [RISCV_RST_NUM_RD_PORTS-1:0];
typedef riscv_rst_addr_t  riscv_rst_rd_addr_t  [RISCV_RST_NUM_RD_PORTS-1:0];

typedef riscv_rst_token_t riscv_rst_table_t    [RISCV_RST_NUM_ENTRIES-1:0];

typedef enum logic [2:0] {
    RISCV_INT_ALU_ADD  = 3'b000,
    RISCV_INT_ALU_SUB  = 3'b001,
    RISCV_INT_ALU_AND  = 3'b010,
    RISCV_INT_ALU_OR   = 3'b011,
    RISCV_INT_ALU_XOR  = 3'b100,
    RISCV_INT_ALU_SLL  = 3'b101,
    RISCV_INT_ALU_SRL  = 3'b110,
    RISCV_INT_ALU_SRA  = 3'b111
} riscv_int_alu_op_e;

typedef enum logic {
    RISCV_ALU_UNSIGNED   = 1'b0,
    RISCV_ALU_SIGNED     = 1'b1
} riscv_alu_sign_e;

typedef enum logic [1:0] {
    RISCV_INT_ALU_LT  = 2'b00,
    RISCV_INT_ALU_GT  = 2'b01,
    RISCV_INT_ALU_EQ  = 2'b10,
    RISCV_INT_ALU_NEQ = 2'b11
} riscv_int_alu_cmp_e;

typedef enum logic {
    RISCV_INT_ALU_NO_BRANCH = 1'b0,
    RISCV_INT_ALU_IS_BRANCH = 1'b1
} riscv_int_alu_branch_e;

typedef enum logic {
    RISCV_INT_ALU_NO_SET = 1'b0,
    RISCV_INT_ALU_IS_SET = 1'b1
} riscv_int_alu_set_e;

typedef enum logic {
    RISCV_IS_LOAD  = 1'b0,
    RISCV_IS_STORE = 1'b1
} riscv_ls_e;

typedef enum logic[1:0] {
    RISCV_LS_SIZE_B       = 2'b00,
    RISCV_LS_SIZE_H       = 2'b01,
    RISCV_LS_SIZE_W       = 2'b10,
    RISCV_LS_SIZE_INVALID = 2'b11
} riscv_ls_size_e;

typedef struct packed{
    riscv_alu_sign_e   is_signed;   //1bit
    riscv_int_alu_op_e op;          //3bit
} riscv_int_alu_op_t;

typedef struct packed{
    riscv_alu_sign_e   is_signed;   //1bit
    riscv_ls_e         is_ls;       //1bit
    riscv_ls_size_e    ls_size;     //2bits
} riscv_ls_alu_op_t;

typedef union packed {
    riscv_int_alu_op_t  int_alu;
    riscv_ls_alu_op_t   ls_alu;
} riscv_alu_op_t;

//Queue opcode
typedef struct packed {
    riscv_int_alu_branch_e      is_branch;
    riscv_int_alu_set_e         is_set;
    riscv_int_alu_cmp_e         cmp;
    riscv_alu_op_t              op;
} riscv_queue_op_t;

//Execution Queue
parameter int RISCV_EX_QUEUE_CDB_BYPASS = 1;
parameter int RISCV_NUM_INT_QUEUE      = 1;
parameter int RISCV_NUM_LS_QUEUE       = 1;
parameter int RISCV_NUM_MUL_QUEUE      = 1;
parameter int RISCV_NUM_DIV_QUEUE      = 1;
parameter int RISCV_NUM_EX_QUEUE       = RISCV_NUM_INT_QUEUE + RISCV_NUM_LS_QUEUE + RISCV_NUM_MUL_QUEUE + RISCV_NUM_DIV_QUEUE;
parameter int RISCV_INT_QUEUE_NUM_ENTRIES = 4;
parameter int RISCV_INT_QUEUE_USE_OPCODE  = 1;
parameter int RISCV_INT_QUEUE_USE_ADDR    = 0;
parameter int RISCV_INT_QUEUE_CDB_BYPASS  = RISCV_EX_QUEUE_CDB_BYPASS;
parameter int RISCV_LS_QUEUE_NUM_ENTRIES  = 4;
parameter int RISCV_LS_QUEUE_USE_OPCODE   = 1;
parameter int RISCV_LS_QUEUE_USE_ADDR     = 1;
parameter int RISCV_LS_QUEUE_CDB_BYPASS   = 0;
parameter int RISCV_MUL_QUEUE_NUM_ENTRIES = 4;
parameter int RISCV_MUL_QUEUE_USE_OPCODE  = 0;
parameter int RISCV_MUL_QUEUE_USE_ADDR    = 0;
parameter int RISCV_MUL_QUEUE_CDB_BYPASS  = RISCV_EX_QUEUE_CDB_BYPASS;
parameter int RISCV_DIV_QUEUE_NUM_ENTRIES = 4;
parameter int RISCV_DIV_QUEUE_USE_OPCODE  = 0;
parameter int RISCV_DIV_QUEUE_USE_ADDR    = 0;
parameter int RISCV_DIV_QUEUE_CDB_BYPASS  = RISCV_EX_QUEUE_CDB_BYPASS;

//ALU LATENCIES
parameter int RISCV_INT_ALU_LAT           = 1;
parameter int RISCV_LD_ST_ALU_LAT         = 1;
parameter int RISCV_MUL_ALU_LAT           = 4;
parameter int RISCV_DIV_ALU_LAT           = 7;

parameter int RISCV_IMM_BEGIN          = 31;
parameter int RISCV_IMM_END            = 7;

parameter int RISCV_LS_IMM_BITS_WIDHT  = 12;

typedef enum logic[1:0] {INT_QUEUE=2'b00, LS_QUEUE=2'b01, MUL_QUEUE=2'b10, DIV_QUEUE=2'b11} ex_queue_e;

typedef logic [RISCV_IMM_BEGIN:RISCV_IMM_END]   riscv_imm_bits_t;
typedef logic [RISCV_LS_IMM_BITS_WIDHT-1:0]     riscv_ls_imm_bits_t;

typedef logic riscv_int_queue_bit_t [RISCV_NUM_INT_QUEUE-1:0];
typedef logic riscv_ls_queue_bit_t  [RISCV_NUM_LS_QUEUE-1:0];
typedef logic riscv_mul_queue_bit_t [RISCV_NUM_MUL_QUEUE-1:0];
typedef logic riscv_div_queue_bit_t [RISCV_NUM_DIV_QUEUE-1:0];

typedef struct {
    riscv_int_queue_bit_t int_queue;
    riscv_ls_queue_bit_t  ls_queue;
    riscv_mul_queue_bit_t mul_queue;
    riscv_div_queue_bit_t div_queue;
} riscv_ex_queue_disp_t;

typedef struct packed{
    riscv_rst_tag_t rd_tag;
    riscv_data_t    rs1_data;
    riscv_rst_tag_t rs1_tag;
    logic           rs1_val;
    riscv_data_t    rs2_data;
    riscv_rst_tag_t rs2_tag;
    logic           rs2_val;
} riscv_queue_data_t;

typedef struct packed{
    riscv_queue_op_t    opcode;
    riscv_queue_data_t  queue_data;
} riscv_int_queue_data_t;

typedef struct packed{
    riscv_ls_imm_bits_t ls_imm;
    riscv_ls_alu_op_t   opcode;
    riscv_queue_data_t  queue_data;
} riscv_ls_queue_data_t;

typedef struct packed{
    riscv_queue_data_t  queue_data;
} riscv_mul_queue_data_t;

typedef struct packed{
    riscv_queue_data_t  queue_data;
} riscv_div_queue_data_t;

typedef struct packed{
    riscv_ls_imm_bits_t ls_imm;
    riscv_queue_op_t    opcode;
    riscv_queue_data_t  queue_data;
} riscv_all_queue_data_t;

typedef struct packed {
    riscv_queue_op_t    opcode;
    riscv_data_t        rs1_data;
    riscv_data_t        rs2_data;
    riscv_rst_tag_t     rd_tag;
} riscv_queue_data_out_with_op_t;

typedef struct packed {
    riscv_data_t        rs1_data;
    riscv_data_t        rs2_data;
    riscv_rst_tag_t     rd_tag;
} riscv_queue_data_out_without_op_t;

typedef struct packed {
    riscv_ls_alu_op_t        opcode;
    riscv_data_t             address;
    riscv_data_t             rs2_data;
    riscv_rst_tag_t          rd_tag;
} riscv_queue_data_out_ls_t;

typedef struct packed {
    riscv_queue_op_t    opcode;
    riscv_data_t        address;
    riscv_data_t        rs1_data;
    riscv_data_t        rs2_data;
    riscv_rst_tag_t     rd_tag;
} riscv_all_queue_data_out_t;

typedef struct {
    riscv_data_t    result;
    riscv_rst_tag_t rd_tag;
    logic           alu_branch;
    logic           branch_taken;
    logic           zero_f;
    logic           cout_f;
    logic           ov_f;
} riscv_int_alu_out_t;

typedef struct {
    riscv_data_t    result;
    riscv_rst_tag_t rd_tag;
} riscv_mul_alu_out_t;

typedef struct {
    riscv_data_t        rs1_data;
    riscv_data_t        rs2_data;
    riscv_rst_tag_t     rd_tag;
    logic               en;
} riscv_div_alu_in_t;

typedef struct packed {
    riscv_data_t    result;
    riscv_rst_tag_t rd_tag;
    logic           busy;
} riscv_div_alu_out_t;

typedef struct {
    riscv_ls_alu_op_t        opcode;
    riscv_data_t             address;
    riscv_data_t             rs2_data;
    riscv_rst_tag_t          rd_tag;
    logic                    en;
} riscv_ls_alu_in_t;

typedef struct {
    riscv_data_t    result;
    riscv_rst_tag_t rd_tag;
    bit             en;
} riscv_ld_st_alu_out_t;

typedef struct {
    riscv_int_queue_bit_t ready_int;
    riscv_mul_queue_bit_t ready_mul;
    riscv_div_queue_bit_t ready_div;
    riscv_ls_queue_bit_t  ready_ld_st;
    riscv_div_queue_bit_t div_busy;
} riscv_issue_unit_in_t;

typedef struct {
    riscv_int_queue_bit_t issue_int;
    riscv_mul_queue_bit_t issue_mul;
    riscv_div_queue_bit_t issue_div;
    riscv_ls_queue_bit_t  issue_ld_st;
    riscv_ls_queue_bit_t  ls_en;
    riscv_div_queue_bit_t div_en;
    riscv_int_queue_bit_t int_cdb_ctrl;
    riscv_div_queue_bit_t div_cdb_ctrl;
    riscv_mul_queue_bit_t mul_cdb_ctrl;
    riscv_ls_queue_bit_t  ld_st_cdb_ctrl;
    logic cdb_valid;
} riscv_issue_unit_out_t;

typedef enum logic[1:0] {RF_RD_PORT_A = 2'b00, RF_RD_PORT_B = 2'b01, RF_WR_PORT = 2'b10} rf_port_e;
typedef enum logic      {BR_NORMAL_OPERATION = 1'd0,    BR_STALLING = 1'd1}    branch_state_e;
typedef enum logic      {JALR_NORMAL_OPERARTION = 1'd0, JALR_EXECUTING = 1'd1} jalr_state_e;


typedef enum logic[2:0]{
    R_TYPE = 3'd0,
    I_TYPE = 3'd1,
    S_TYPE = 3'd2,
    B_TYPE = 3'd3,
    U_TYPE = 3'd4,
    J_TYPE = 3'd5} instr_type_e;

parameter int RISCV_ORDER_QUEUE_NUM_ENTRIES = 32;
parameter int RISCV_ORDER_QUEUE_PTR_WIDTH   = $clog2(RISCV_ORDER_QUEUE_NUM_ENTRIES);
typedef logic [RISCV_ORDER_QUEUE_PTR_WIDTH-1:0] riscv_order_queue_ptr_t;

typedef enum logic [1:0]{
    RD_TAG_IS_VALID = 2'b00,
    IS_BRANCH       = 2'b01,
    IS_STORE        = 2'b10
}   dispatch_inst_type_t;

parameter int RISCV_REGFILE_TMP_NUM_REGS = 64;

typedef struct packed {
    riscv_rf_addr_t         rd_reg;
    riscv_pc_t              pc;
    dispatch_inst_type_t    inst_type;
    riscv_data_t            spec_data;
    logic                   spec_valid;
    logic                   valid;
    logic                   branch_taken;
} regfile_tmp_data_t;

//////////////////////Functions/////////////////////////////////////////////////////////////////

function automatic bit f_is_power_of_2 (int src);
    return ($ceil($clog2(src)) != $floor($clog2(src)));
endfunction: f_is_power_of_2

endpackage: riscv_pkg