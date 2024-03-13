//File: riscv_v_pkg.sv
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension package

package riscv_v_pkg;
import riscv_pkg::*;

//Time constants
parameter real CLK_FREQ                     = 50e6;
parameter time CLK_PERIOD                   = 1/CLK_FREQ;


//RISCV_V_Constants
parameter int RISCV_V_ELEN                  = 128;                                            //Maximum size in bits of a vector element that any operation can produce or consume
parameter int RISCV_V_VLEN                  = RISCV_V_ELEN;                                   //Size of a single  vector register  
parameter int RISCV_V_DATA_WIDTH            = RISCV_V_VLEN;                                   //Width of data in datapath
parameter int RISCV_V_NUM_ELEMENTS_REG      = RISCV_V_DATA_WIDTH / BYTE_WIDTH;                //Number of elements in each vector register
parameter int RISCV_V_NUM_BYTES_DATA        = RISCV_V_DATA_WIDTH / BYTE_WIDTH;                //Number of bytes in Data bus
parameter int RISCV_V_NUM_WORDS_DATA        = RISCV_V_DATA_WIDTH / WORD_WIDTH;                //Number of words in Data bus
parameter int RISCV_V_NUM_DWORDS_DATA       = RISCV_V_DATA_WIDTH / DWORD_WIDTH;               //Number of dwords in Data bus
parameter int RISCV_V_NUM_QWORDS_DATA       = RISCV_V_DATA_WIDTH / QWORD_WIDTH;               //Number of qwords in Data bus
parameter int RISCV_V_NUM_DQWORDS_DATA      = RISCV_V_DATA_WIDTH / DQWORD_WIDTH;              //Number of dqwords in Data bus
parameter int RISCV_V_NUM_QQWORDS_DATA      = RISCV_V_DATA_WIDTH / QQWORD_WIDTH;              //Number of dqwords in Data bus


//OPCODES
parameter logic [6:0] RISCV_V_TYPE_OP_CODE  = 7'b1010111;

typedef enum logic [2:0] {
    OPIVV = 3'b000,
    OPFVV = 3'b001,
    OPMVV = 3'b010,
    OPIVI = 3'b011,
    OPIVX = 3'b100,
    OPFVF = 3'b101,
    OPMVX = 3'b110,
    OPCFG = 3'b111
} riscv_v_funct3_e;
 
parameter logic [5:0] RISCV_V_FUNCT6_VADD     = 6'b000000;
parameter logic [5:0] RISCV_V_FUNCT6_VREDSUM  = 6'b000000;
parameter logic [5:0] RISCV_V_FUNCT6_VREDAND  = 6'b000001;
parameter logic [5:0] RISCV_V_FUNCT6_VSUB     = 6'b000010;
parameter logic [5:0] RISCV_V_FUNCT6_VREDOR   = 6'b000010;
parameter logic [5:0] RISCV_V_FUNCT6_VRSUB    = 6'b000011;
parameter logic [5:0] RISCV_V_FUNCT6_VREDXOR  = 6'b000011;
parameter logic [5:0] RISCV_V_FUNCT6_VMINU    = 6'b000100;
parameter logic [5:0] RISCV_V_FUNCT6_VREDMINU = 6'b000100;
parameter logic [5:0] RISCV_V_FUNCT6_VMIN     = 6'b000101;
parameter logic [5:0] RISCV_V_FUNCT6_VREDMIN  = 6'b000101;
parameter logic [5:0] RISCV_V_FUNCT6_VMAXU    = 6'b000110;
parameter logic [5:0] RISCV_V_FUNCT6_VREDMAXU = 6'b000110;
parameter logic [5:0] RISCV_V_FUNCT6_VMAX     = 6'b000111;
parameter logic [5:0] RISCV_V_FUNCT6_VREDMAX  = 6'b000111;
parameter logic [5:0] RISCV_V_FUNCT6_VAND     = 6'b001001;
parameter logic [5:0] RISCV_V_FUNCT6_VOR      = 6'b001010;
parameter logic [5:0] RISCV_V_FUNCT6_VXOR     = 6'b001011;
parameter logic [5:0] RISCV_V_FUNCT6_VADC     = 6'b010000;
parameter logic [5:0] RISCV_V_FUNCT6_VXUNARY0 = 6'b010010;
parameter logic [5:0] RISCV_V_FUNCT6_VSBC     = 6'b010010;
parameter logic [5:0] RISCV_V_FUNCT6_VMV      = 6'b010111;
parameter logic [5:0] RISCV_V_FUNCT6_VMSEQ    = 6'b011000;
parameter logic [5:0] RISCV_V_FUNCT6_VMANDN   = 6'b011000;
parameter logic [5:0] RISCV_V_FUNCT6_VMSNE    = 6'b011001;
parameter logic [5:0] RISCV_V_FUNCT6_VMAND    = 6'b011001;
parameter logic [5:0] RISCV_V_FUNCT6_VMSLTU   = 6'b011010;
parameter logic [5:0] RISCV_V_FUNCT6_VMOR     = 6'b011010;
parameter logic [5:0] RISCV_V_FUNCT6_VMSLT    = 6'b011011;
parameter logic [5:0] RISCV_V_FUNCT6_VMXOR    = 6'b011011;
parameter logic [5:0] RISCV_V_FUNCT6_VMSLEU   = 6'b011100;
parameter logic [5:0] RISCV_V_FUNCT6_VMORN    = 6'b011100;
parameter logic [5:0] RISCV_V_FUNCT6_VMSLE    = 6'b011101;
parameter logic [5:0] RISCV_V_FUNCT6_VMNAND   = 6'b011101;
parameter logic [5:0] RISCV_V_FUNCT6_VMSGTU   = 6'b011110;
parameter logic [5:0] RISCV_V_FUNCT6_VMNOR    = 6'b011110;
parameter logic [5:0] RISCV_V_FUNCT6_VMSGT    = 6'b011111;
parameter logic [5:0] RISCV_V_FUNCT6_VMXNOR   = 6'b011111;
parameter logic [5:0] RISCV_V_FUNCT6_VMULHU   = 6'b100100;
parameter logic [5:0] RISCV_V_FUNCT6_VSLL     = 6'b100101;
parameter logic [5:0] RISCV_V_FUNCT6_VMUL     = 6'b100101;
parameter logic [5:0] RISCV_V_FUNCT6_VMULHSU  = 6'b100110;
parameter logic [5:0] RISCV_V_FUNCT6_VSMUL    = 6'b100111;
parameter logic [5:0] RISCV_V_FUNCT6_VMULH    = 6'b100111;
parameter logic [5:0] RISCV_V_FUNCT6_VSRL     = 6'b101000;
parameter logic [5:0] RISCV_V_FUNCT6_VSRA     = 6'b101001;

//PIPE STAGES
typedef enum {RISCV_V_IF, RISCV_V_ID, RISCV_V_EXE, RISCV_V_MEM, RISCV_V_WB} PIPE_STAGES_E;
parameter RISCV_V_IF_2_ID_LATENCY   = 1;
parameter RISCV_V_ID_2_EXE_LATENCY  = 1;
parameter RISCV_V_EXE_2_MEM_LATENCY = 1;
parameter RISCV_V_MEM_2_WB_LATENCY  = 1;
parameter RISCV_V_IF_2_EXE_LATENCY  = RISCV_V_IF_2_ID_LATENCY + RISCV_V_ID_2_EXE_LATENCY;
parameter RISCV_V_IF_2_MEM_LATENCY  = RISCV_V_IF_2_ID_LATENCY + RISCV_V_ID_2_EXE_LATENCY + RISCV_V_EXE_2_MEM_LATENCY;
parameter RISCV_V_IF_2_WB_LATENCY   = RISCV_V_IF_2_ID_LATENCY + RISCV_V_ID_2_EXE_LATENCY + RISCV_V_EXE_2_MEM_LATENCY + RISCV_V_MEM_2_WB_LATENCY;
parameter RISCV_V_ID_2_MEM_LATENCY  =                           RISCV_V_ID_2_EXE_LATENCY + RISCV_V_EXE_2_MEM_LATENCY;
parameter RISCV_V_ID_2_WB_LATENCY   =                           RISCV_V_ID_2_EXE_LATENCY + RISCV_V_EXE_2_MEM_LATENCY + RISCV_V_MEM_2_WB_LATENCY;
parameter RISCV_V_EXE_2_WB_LATENCY  =                                                      RISCV_V_EXE_2_MEM_LATENCY + RISCV_V_MEM_2_WB_LATENCY;

//Regfile Constants
parameter bit RISCV_V_RF_RD_ASYNC           = 1'b1;
parameter bit RISCV_V_RF_REG_INPUTS         = 1'b0;
parameter bit RISCV_V_RF_USE_BYPASS         = 1'b1;
parameter int RISCV_V_RF_NUM_REGS           = 32;                                             //Number of registers in Register file
parameter int RISCV_V_RF_ADDR_WIDTH         = $clog2(RISCV_V_RF_NUM_REGS);                    //Width of addres of register file
parameter bit RISCV_V_RF_PROTECT_REG_ZERO   = 1'b0;
//Mask Regfile Constants
parameter bit RISCV_V_MASK_RF_RD_ASYNC      = 1'b1;
parameter bit RISCV_V_MASK_RF_REG_INPUTS    = 1'b0;
parameter int RISCV_V_MASK_RF_NUM_REGS      = 8;                                              //Number of mask registers in mask register file
parameter int RISCV_V_MASK_RF_ADDR_WIDTH    = $clog2(RISCV_V_MASK_RF_NUM_REGS);

parameter int RISCV_V_MAX_LMUL = 8;
parameter int RISCV_V_MAX_VLEN = RISCV_V_NUM_ELEMENTS_REG * RISCV_V_MAX_LMUL;

//CSR
parameter int RISCV_V_NUM_CSR = 8;
parameter int RISCV_V_NUM_RO_CSR = 2;
parameter int RISCV_V_NUM_RW_CSR = RISCV_V_NUM_CSR-RISCV_V_NUM_RO_CSR;
typedef enum logic [2:0] {VSEW_8 = 3'b000, VSEW_16 = 3'b001, VSEW_32 = 3'b010, VSEW_64 = 3'b011, VSEW_128 = 3'b100} riscv_v_vsew_t;
typedef enum logic [2:0] {LMUL_1 = 3'b000, LMUL_2  = 3'b001, LMUL_4  = 3'b010, LMUL_8  = 3'b011} riscv_v_vlmul_t;
typedef enum logic {UNDISTURBED = 1'b0, AGNOSTIC = 1'b1} riscv_v_agnostic_e;
typedef logic[$clog2(RISCV_V_MAX_VLEN)-1:0] riscv_v_vlen_t;
typedef logic[$clog2(RISCV_V_MAX_VLEN)-1:0] riscv_v_field_vstart_t;
typedef enum logic [1:0] {RNU = 2'b00, RNE = 2'b01, RDN = 2'b10, ROD = 2'b11} riscv_v_fixed_point_rounding_e;

typedef enum logic[$clog2(RISCV_V_NUM_CSR)-1:0] {VCSR_E, VXSAT_E, VXRM_E, VSTART_E, VLENB_E, VL_E, VTYPE_E, VSSTATUS_E} riscv_v_csr_e;


typedef struct packed {
    riscv_csr_status_e VS;        //vsstatus[10:9] vector context status field, Only valid when hypervisor extension is present
    logic [8:0]  reserved;
} riscv_v_vsstatus_t;

typedef struct packed {
    logic               vill;        // The vill bit is used to encode that a previous vset{i}vl{i} instruction attempted to write an unsupported value to vtype.
    riscv_v_agnostic_e  vma;         // Vector mask agnostic
    riscv_v_agnostic_e  vta;         // Vector tail agnostic 
    riscv_v_vsew_t      vsew;        // The value in vsew sets the dynamic selected element width (SEW).
    riscv_v_vlmul_t     vlmul;       // The vector length multiplier, LMUL, when greater than 1, represents the default number of vector registers that are combined to form a vector register group
} riscv_v_vtype_t;

typedef struct packed {
    riscv_v_vlen_t len;
} riscv_v_vl_t;

typedef struct packed {
    riscv_v_vlen_t len;
} riscv_v_vlenb_t;

typedef struct packed {
    riscv_v_field_vstart_t index;
} riscv_v_vstart_t;

typedef struct packed {
    riscv_v_fixed_point_rounding_e rounding_mode;
} riscv_v_vxrm_t;

typedef struct packed {
    logic saturate;
} riscv_v_vxsat_t;

typedef struct packed {
    riscv_v_fixed_point_rounding_e rounding_mode;
    logic                          saturate;
} riscv_v_vcsr_t;

parameter int RISCV_V_VSSTATUS_WIDTH = $bits(riscv_v_vsstatus_t);
parameter int RISCV_V_VTYPE_WIDTH    = $bits(riscv_v_vtype_t);
parameter int RISCV_V_VL_WIDTH       = $bits(riscv_v_vl_t);
parameter int RISCV_V_VLENB_WIDTH    = $bits(riscv_v_vlenb_t);
parameter int RISCV_V_VSTART_WIDTH   = $bits(riscv_v_vstart_t);
parameter int RISCV_V_VXRM_WIDTH     = $bits(riscv_v_vxrm_t);
parameter int RISCV_V_VXSAT_WIDTH    = $bits(riscv_v_vxsat_t);
parameter int RISCV_V_VCSR_WIDTH     = $bits(riscv_v_vcsr_t);


parameter riscv_v_vsstatus_t RISCV_V_VSSTATUS_RST_VAL = '{
    VS       : OFF,
    reserved : '0
};

parameter riscv_v_vtype_t RISCV_V_VTYPE_RST_VAL  = '{
    vill  : 1'b0,
    vma   : AGNOSTIC,
    vta   : AGNOSTIC,
    vsew  : VSEW_8,
    vlmul : LMUL_1
};

parameter riscv_v_vl_t RISCV_V_VL_RST_VAL = '{
    len : RISCV_V_NUM_ELEMENTS_REG
};

parameter riscv_v_vstart_t RISCV_V_VSTART_RST_VAL = '{
    index : '0
};

parameter riscv_v_vxrm_t RISCV_V_VXRM_RST_VAL = '{
    rounding_mode : RNU
};

parameter riscv_v_vxsat_t RISCV_V_VXSAT_RST_VAL = '{
    saturate : 1'b0
};

//Operation size enum
typedef enum logic[2:0] {OSIZE_8 = 3'd0, OSIZE_16 = 3'd1, OSIZE_32 = 3'd2, OSIZE_64 = 3'd3, OSIZE_128 = 3'd4} riscv_v_osize_e;
parameter int RISCV_V_NUM_VALID_OSIZES = 5;
typedef logic [RISCV_V_NUM_VALID_OSIZES-1:0] osize_vector_t;
typedef logic [RISCV_V_NUM_VALID_OSIZES-1:1] osize_is_greater_vector_t;
typedef logic [RISCV_V_NUM_VALID_OSIZES-2:0] osize_is_less_vector_t;
//ALU Enum
localparam int RISCV_V_NUM_ALUS = 4;
typedef enum logic[$clog2(RISCV_V_NUM_ALUS)-1:0] {LOGIC_ALU, ARITHMETIC_ALU, MASK_ALU, PERMUTATION_ALU} riscv_v_alu_e;

//Multiplier types
typedef enum logic[1:0] {VEDIC_LA_LB = 2'b00, VEDIC_LA_HB = 2'b01, VEDIC_HA_LB = 2'b10, VEDIC_HA_HB = 2'b11}  vedic_mul_idx_t;

//RISCV_V types
typedef logic  [RISCV_V_DATA_WIDTH-1:0]             riscv_v_bit_bus_t;
typedef Byte_t [RISCV_V_NUM_BYTES_DATA-1:0]         riscv_v_byte_bus_t;
`ifdef RISCV_V_USE_WORD
    typedef Word_t [RISCV_V_NUM_WORDS_DATA-1:0]     riscv_v_word_bus_t;
`endif //RISCV_V_USE_WORD
`ifdef RISCV_V_USE_DWORD
    typedef Dword_t [RISCV_V_NUM_DWORDS_DATA-1:0]   riscv_v_dword_bus_t;
`endif //RISCV_V_USE_DWORD
`ifdef RISCV_V_USE_QWORD
    typedef Qword_t [RISCV_V_NUM_QWORDS_DATA-1:0]   riscv_v_qword_bus_t;   
`endif //RISCV_V_USE_QWORD
`ifdef RISCV_V_USE_DQWORD
    typedef Dqword_t [RISCV_V_NUM_DQWORDS_DATA-1:0] riscv_v_dqword_bus_t;
`endif //RISCV_V_USE_DQWORD

typedef union packed{
    riscv_v_bit_bus_t           Bit;
    riscv_v_byte_bus_t          Byte;
    `ifdef RISCV_V_USE_WORD
        riscv_v_word_bus_t      Word;
    `endif // RISCV_V_USE_WORD
    `ifdef RISCV_V_USE_DWORD
        riscv_v_dword_bus_t     Dword;
    `endif // RISCV_V_USE_DWORD
    `ifdef RISCV_V_USE_QWORD
        riscv_v_qword_bus_t     Qword;
    `endif // RISCV_V_USE_QWORD
    `ifdef RISCV_V_USE_DQWORD
        riscv_v_dqword_bus_t    Dqword;
    `endif // RISCV_V_USE_DQWORD
} riscv_v_data_t;

typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] riscv_v_merge_data_t;
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] riscv_v_valid_data_t;
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] riscv_v_carry_in_t;
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] riscv_v_zf_t;
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] riscv_v_of_t;
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] riscv_v_cf_t;
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] riscv_v_sign_t;
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] riscv_v_less_than_t;
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] riscv_v_complement_t;

parameter RISCV_V_IMM_WIDTH = 5;
typedef logic[RISCV_V_IMM_WIDTH-1:0]      riscv_v_imm_t;

typedef struct packed{
    riscv_v_data_t       data;
    riscv_v_merge_data_t merge;
    riscv_v_valid_data_t valid;
} riscv_v_alu_data_t;

typedef struct packed{
    riscv_v_data_t       data;
    riscv_v_valid_data_t valid;
} riscv_v_wb_data_t;

//Regfile types
typedef logic[RISCV_V_RF_ADDR_WIDTH-1:0]  riscv_v_rf_addr_t;
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] riscv_v_rf_wr_en_t;
typedef riscv_v_data_t riscv_v_rf_regs_t [RISCV_V_RF_NUM_REGS];
//Mask Types
typedef logic[RISCV_V_MASK_RF_ADDR_WIDTH-1:0] riscv_v_mask_rf_addr_t;
typedef logic[RISCV_V_NUM_ELEMENTS_REG-1:0]   riscv_v_mask_t;
typedef riscv_v_mask_t riscv_v_mask_regs_t [RISCV_V_MASK_RF_NUM_REGS];

//ALU Types
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] [BYTE_WIDTH-1:0]  riscv_v_src_byte_vector_t;
typedef logic[$clog2(RISCV_V_NUM_BYTES_DATA):0]             riscv_v_src_len_t;
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0]                   riscv_v_num_byte_vector_t;
typedef logic[RISCV_V_NUM_WORDS_DATA-1:0]                   riscv_v_num_word_vector_t;
typedef logic[RISCV_V_NUM_DWORDS_DATA-1:0]                  riscv_v_num_dword_vector_t;
typedef logic[RISCV_V_NUM_QWORDS_DATA-1:0]                  riscv_v_num_qword_vector_t;
typedef logic[RISCV_V_NUM_DQWORDS_DATA-1:0]                 riscv_v_num_dqword_vector_t;

//Shuffler types
parameter int RISCV_V_SHUFFLER_SEL_WIDTH = $clog2(RISCV_V_NUM_ELEMENTS_REG);
typedef logic[RISCV_V_SHUFFLER_SEL_WIDTH-1:0] riscv_v_shuffler_sel_t;
typedef riscv_v_shuffler_sel_t riscv_v_shuffler_sel_vector_t [RISCV_V_NUM_ELEMENTS_REG-1:0];


//Opcode types
typedef enum logic[5:0] {BW_AND, BW_AND_REDUCT, 
                         BW_OR,  BW_OR_REDUCT,
                         BW_XOR, BW_XOR_REDUCT,
                         SLL, SRL, SRA,
                         ADDC, ADD, ADD_REDUCT,
                         SUBB, SUB, SUB_REDUCT,
                         SIGN_EXT, ZERO_EXT,
                         MINS, MINS_REDUCT, MINU, MINU_REDUCT,
                         MAXS, MAXS_REDUCT, MAXU, MAXU_REDUCT, 
                         MULLS, MULHS, MULLU, MULHU, 
                         SEQ, SNE, SLE, SLEU, SLT, SLTU, SGT, SGTU,
                         MAND, MNAND, MANDN, MXOR, MOR, MNOR, MORN, MXNOR,
                         I2V, V2I,
                         NOP} riscv_v_opcode_e;

//////////////////////Functions/////////////////////////////////////////////////////////////////

function automatic logic[$clog2(RISCV_V_NUM_VALID_OSIZES)-1:0] f_count_trailing_zeroes_osize(int src);
    automatic int count = 0;
    for (int i=0; i<32; i++) begin
        if (src[i] == 1'b1) begin
            break;
        end 
        count++;
    end
    count = (count > RISCV_V_NUM_VALID_OSIZES-2) ? RISCV_V_NUM_VALID_OSIZES-2 : count;
    return count[$clog2(RISCV_V_NUM_VALID_OSIZES)-1:0];
endfunction: f_count_trailing_zeroes_osize

function automatic logic[$clog2(RISCV_V_NUM_VALID_OSIZES)-1:0] f_count_trailing_ones_osize(int src);
    automatic int count = 0;
    for (int i=0; i<32; i++) begin
        if (src[i] == 1'b0) begin
            break;
        end 
        count++;
    end
    count = (count > RISCV_V_NUM_VALID_OSIZES-2) ? RISCV_V_NUM_VALID_OSIZES-2 : count;
    return count[$clog2(RISCV_V_NUM_VALID_OSIZES)-1:0];
endfunction: f_count_trailing_ones_osize

function automatic int f_vedic_mul_get_prev_results(int mul_level, int min_mul_level, vedic_mul_idx_t mul_idx,  bit get_mid_prev_results);
    if (mul_level < min_mul_level) begin
        return 1;
    end
    if ((mul_idx inside {VEDIC_LA_HB, VEDIC_HA_LB}) &&  ~get_mid_prev_results) begin
        return 1;
    end
    if (mul_level == min_mul_level) begin
        return (get_mid_prev_results) ? 4 : 2;
    end
    if (get_mid_prev_results) begin
        return (f_vedic_mul_get_prev_results(mul_level-1, min_mul_level, mul_idx, get_mid_prev_results) * 4) + 4;
    end else begin
        return (f_vedic_mul_get_prev_results(mul_level-1, min_mul_level, mul_idx, get_mid_prev_results) * 2) + 2;
    end
endfunction: f_vedic_mul_get_prev_results

function automatic bit f_vedic_mul_valid_prev_result(int mul_level, int min_mul_level, vedic_mul_idx_t mul_idx, bit get_mid_prev_results);
    if (mul_level < min_mul_level) begin
        return 1'b0;
    end
    if ((mul_idx inside {VEDIC_LA_HB, VEDIC_HA_LB}) &&  ~get_mid_prev_results) begin
        return 1'b0;
    end
    return 1'b1;
endfunction: f_vedic_mul_valid_prev_result

function automatic int f_vedic_mul_num_prev_results_level_diff(int mul_level, int result_level, bit get_mid_prev_results);
    int diff_mul_result_level;

    diff_mul_result_level = mul_level - result_level;
    if (get_mid_prev_results) begin
        return (4**diff_mul_result_level);
    end else begin
        return (2**diff_mul_result_level);
    end
endfunction: f_vedic_mul_num_prev_results_level_diff

function automatic int f_vedic_mul_start_prev_idx(int osize);
    int osize_width;
    int num_results = 0;
    for (int i=1; i <= osize; i++) begin
        osize_width  = (BYTE_WIDTH*(2**(i-1)));
        num_results  += (RISCV_V_DATA_WIDTH/osize_width);
    end

    return num_results;

endfunction: f_vedic_mul_start_prev_idx

function automatic logic f_is_vector_op(riscv_instr_op_t opcode);
    return opcode == RISCV_V_TYPE_OP_CODE;
endfunction: f_is_vector_op

function automatic logic f_is_scalar_op(riscv_v_funct3_e funct3);
    return f_is_scalar_vector_op(funct3) || f_is_scalar_imm_op(funct3) || f_is_scalar_int_op(funct3) || f_is_scalar_fp_op(funct3);
endfunction: f_is_scalar_op

function automatic logic f_is_vector_vector_op(riscv_v_funct3_e funct3);
    return (~funct3[2] && ~(&funct3[1:0]));
endfunction: f_is_vector_vector_op

function automatic logic f_is_scalar_vector_op(riscv_v_funct3_e funct3);
    //FIXME: is scalar_vector only set for reduction operations if needed
    //Actual implementation: ALU takes data from element 0 for reduct operations
    //Possible implementation: Duplicate data in  bypass module and ALU won't need to mux the data to get it from element 0
    return 1'b0;//(funct3[2] || (&funct3[1:0]));
endfunction: f_is_scalar_vector_op

function  automatic logic f_is_scalar_imm_op(riscv_v_funct3_e funct3);
    return funct3 == OPIVI;
endfunction: f_is_scalar_imm_op

function automatic logic f_is_scalar_int_op(riscv_v_funct3_e funct3);
    return funct3 == OPIVX ||
           funct3 == OPMVX ||
           funct3 == OPCFG;
endfunction: f_is_scalar_int_op

function automatic logic f_is_scalar_fp_op(riscv_v_funct3_e funct3);
    return  funct3 == OPFVF;
endfunction: f_is_scalar_fp_op

function automatic logic f_is_i2v(riscv_instr_funct6_t funct6, logic funct3_is_OPIVX);
    return (funct6 == RISCV_V_FUNCT6_VMV) && funct3_is_OPIVX;
endfunction: f_is_i2v 

function automatic logic f_is_v2i(riscv_instr_funct6_t funct6, logic funct3_is_OPIVV);
    return (funct6 == RISCV_V_FUNCT6_VMV) && funct3_is_OPIVV;
endfunction: f_is_v2i

function automatic logic f_is_and(riscv_instr_funct6_t funct6, logic funct3_is_OPMVV, logic funct3_is_OPI);
    logic is_and = 1'b0;
    
    is_and  = (funct6 == RISCV_V_FUNCT6_VMAND)   && funct3_is_OPMVV;
    is_and |= (funct6 == RISCV_V_FUNCT6_VMNAND)  && funct3_is_OPMVV;
    is_and |= (funct6 == RISCV_V_FUNCT6_VMANDN)  && funct3_is_OPMVV;
    is_and |= (funct6 == RISCV_V_FUNCT6_VAND)    && funct3_is_OPI;
    is_and |= (funct6 == RISCV_V_FUNCT6_VREDAND) && funct3_is_OPMVV;

    return is_and;
endfunction: f_is_and 

function automatic logic f_is_or(riscv_instr_funct6_t funct6, logic funct3_is_OPMVV, logic funct3_is_OPI);
    logic is_or = 1'b0;

    is_or  = (funct6 == RISCV_V_FUNCT6_VMOR)   && funct3_is_OPMVV;
    is_or |= (funct6 == RISCV_V_FUNCT6_VMNOR)  && funct3_is_OPMVV;
    is_or |= (funct6 == RISCV_V_FUNCT6_VMORN)  && funct3_is_OPMVV;
    is_or |= (funct6 == RISCV_V_FUNCT6_VOR)    && funct3_is_OPI;
    is_or |= (funct6 == RISCV_V_FUNCT6_VREDOR) && funct3_is_OPMVV;

    return is_or;
endfunction: f_is_or 

function automatic logic f_is_xor(riscv_instr_funct6_t funct6, logic funct3_is_OPMVV, logic funct3_is_OPI);
    logic is_xor = 1'b0;

    is_xor  = (funct6 == RISCV_V_FUNCT6_VMXOR)   && funct3_is_OPMVV;
    is_xor |= (funct6 == RISCV_V_FUNCT6_VMXNOR)  && funct3_is_OPMVV;
    is_xor |= (funct6 == RISCV_V_FUNCT6_VXOR)    && funct3_is_OPI;
    is_xor |= (funct6 == RISCV_V_FUNCT6_VREDXOR) && funct3_is_OPMVV;

    return is_xor;
endfunction: f_is_xor

function automatic logic f_is_negate_srca(riscv_instr_funct6_t funct6, logic funct3_is_OPMVV);
    logic is_negate_srca = 1'b0;

    is_negate_srca  = (funct6 == RISCV_V_FUNCT6_VMANDN) && funct3_is_OPMVV;
    is_negate_srca |= (funct6 == RISCV_V_FUNCT6_VMORN)  && funct3_is_OPMVV;

    return is_negate_srca;
endfunction: f_is_negate_srca

function automatic logic f_is_negate_result(riscv_instr_funct6_t funct6, logic funct3_is_OPMVV);
    logic is_negate_result = 1'b0;

    is_negate_result  = (funct6 == RISCV_V_FUNCT6_VMNAND) && funct3_is_OPMVV;
    is_negate_result |= (funct6 == RISCV_V_FUNCT6_VMNOR)  && funct3_is_OPMVV;
    is_negate_result |= (funct6 == RISCV_V_FUNCT6_VMXNOR) && funct3_is_OPMVV;

    return is_negate_result;
endfunction: f_is_negate_result

function automatic logic f_is_mask(riscv_instr_funct6_t funct6, logic funct3_is_OPMVV);
    logic is_mask = 1'b0;

    is_mask  = (funct6 == RISCV_V_FUNCT6_VMAND)  && funct3_is_OPMVV;
    is_mask |= (funct6 == RISCV_V_FUNCT6_VMNAND) && funct3_is_OPMVV;
    is_mask |= (funct6 == RISCV_V_FUNCT6_VMANDN) && funct3_is_OPMVV;
    is_mask |= (funct6 == RISCV_V_FUNCT6_VMOR)   && funct3_is_OPMVV;
    is_mask |= (funct6 == RISCV_V_FUNCT6_VMNOR)  && funct3_is_OPMVV;
    is_mask |= (funct6 == RISCV_V_FUNCT6_VMORN)  && funct3_is_OPMVV;
    is_mask |= (funct6 == RISCV_V_FUNCT6_VMXNOR) && funct3_is_OPMVV;
    is_mask |= (funct6 == RISCV_V_FUNCT6_VMXOR)  && funct3_is_OPMVV; 

    return is_mask;
endfunction: f_is_mask

function automatic logic f_is_shift(riscv_instr_funct6_t funct6, logic funct3_is_OPI);
    logic is_shift = 1'b0;

    is_shift = (funct6 == RISCV_V_FUNCT6_VSLL) && funct3_is_OPI;
    is_shift = (funct6 == RISCV_V_FUNCT6_VSRL) && funct3_is_OPI;
    is_shift = (funct6 == RISCV_V_FUNCT6_VSRA) && funct3_is_OPI;

    return is_shift;
endfunction: f_is_shift

function automatic logic f_is_left(riscv_instr_funct6_t funct6, logic funct3_is_OPI);
    logic is_left = 1'b0;

    is_left = (funct6 == RISCV_V_FUNCT6_VSLL) && funct3_is_OPI;

    return is_left;
endfunction: f_is_left 

function automatic logic f_is_arith(riscv_instr_funct6_t funct6, logic funct3_is_OPI);
    logic is_arith = 1'b0;

    is_arith = (funct6 == RISCV_V_FUNCT6_VSRA) && funct3_is_OPI;

    return is_arith;
endfunction: f_is_arith

function automatic logic f_is_reduct(riscv_instr_funct6_t funct6, logic funct3_is_OPMVV);
    logic is_reduct = 1'b0;

    is_reduct  = (funct6 == RISCV_V_FUNCT6_VREDAND)  && funct3_is_OPMVV;
    is_reduct |= (funct6 == RISCV_V_FUNCT6_VREDOR)   && funct3_is_OPMVV;
    is_reduct |= (funct6 == RISCV_V_FUNCT6_VREDXOR)  && funct3_is_OPMVV;
    is_reduct |= (funct6 == RISCV_V_FUNCT6_VREDSUM)  && funct3_is_OPMVV;
    is_reduct |= (funct6 == RISCV_V_FUNCT6_VREDMAX)  && funct3_is_OPMVV;
    is_reduct |= (funct6 == RISCV_V_FUNCT6_VREDMAXU) && funct3_is_OPMVV;
    is_reduct |= (funct6 == RISCV_V_FUNCT6_VREDMIN)  && funct3_is_OPMVV;
    is_reduct |= (funct6 == RISCV_V_FUNCT6_VREDMINU) && funct3_is_OPMVV;

    return is_reduct;
endfunction: f_is_reduct

function automatic logic f_is_add(riscv_instr_funct6_t funct6, logic funct3_is_OPI, logic funct3_is_OPMVV);
    logic is_add = 1'b0;

    is_add  = (funct6 == RISCV_V_FUNCT6_VADD)    && funct3_is_OPI;
    is_add |= (funct6 == RISCV_V_FUNCT6_VREDSUM) && funct3_is_OPMVV;
    is_add |= (funct6 == RISCV_V_FUNCT6_VADC)    && funct3_is_OPI;

    return is_add;
endfunction: f_is_add 

function automatic logic f_is_sub(riscv_instr_funct6_t funct6, logic funct3_is_OPI, logic funct3_is_OPMVV, logic funct3_is_OPIVV_OPIVX, logic funct3_is_OPIVX_OPIVI);
    logic is_sub = 1'b0;

    is_sub  = (funct6 == RISCV_V_FUNCT6_VSUB)     && funct3_is_OPIVV_OPIVX;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VSBC)     && funct3_is_OPIVV_OPIVX;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VMIN)     && funct3_is_OPIVV_OPIVX;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VMINU)    && funct3_is_OPIVV_OPIVX;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VREDMIN)  && funct3_is_OPMVV;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VREDMINU) && funct3_is_OPMVV;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VMAX)     && funct3_is_OPIVV_OPIVX;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VMAXU)    && funct3_is_OPIVV_OPIVX;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VREDMAX)  && funct3_is_OPMVV;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VREDMAXU) && funct3_is_OPMVV;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VMSEQ)    && funct3_is_OPI;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VMSNE)    && funct3_is_OPI;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VMSLTU)   && funct3_is_OPIVV_OPIVX;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VMSLT)    && funct3_is_OPIVV_OPIVX;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VMSLE)    && funct3_is_OPI;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VMSLEU)   && funct3_is_OPI;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VMSGT)    && funct3_is_OPIVX_OPIVI;
    is_sub |= (funct6 == RISCV_V_FUNCT6_VMSGTU)   && funct3_is_OPIVX_OPIVI;

    return is_sub;
endfunction: f_is_sub 

function automatic logic f_is_mul(riscv_instr_funct6_t funct6,  logic funct3_is_OPM);
    logic is_mul = 1'b0;

    is_mul  = (funct6 == RISCV_V_FUNCT6_VMUL)   && funct3_is_OPM;
    is_mul |= (funct6 == RISCV_V_FUNCT6_VMULH)  && funct3_is_OPM;
    is_mul |= (funct6 == RISCV_V_FUNCT6_VMULHU) && funct3_is_OPM;

    return is_mul;
endfunction: f_is_mul

function automatic logic f_is_zero_ext(riscv_instr_funct6_t funct6, logic funct3_is_OPMVV, logic[4:0] vs1);
    logic is_zero_ext = 1'b0;

    is_zero_ext = (funct6 == RISCV_V_FUNCT6_VXUNARY0) && funct3_is_OPMVV && ~vs1[0];

    return is_zero_ext;
endfunction: f_is_zero_ext

function automatic logic f_is_sign_ext(riscv_instr_funct6_t funct6, logic funct3_is_OPMVV, logic[4:0] vs1);
    logic is_sign_ext = 1'b0;
    
    is_sign_ext = (funct6 == RISCV_V_FUNCT6_VXUNARY0) && funct3_is_OPMVV && vs1[0];

    return is_sign_ext;
endfunction: f_is_sign_ext

function automatic logic f_is_set_equal(riscv_instr_funct6_t funct6, logic funct3_is_OPI);
    logic is_set_equal = 1'b0;

    is_set_equal  = (funct6 == RISCV_V_FUNCT6_VMSEQ)    && funct3_is_OPI;
    is_set_equal |= (funct6 == RISCV_V_FUNCT6_VMSLE)    && funct3_is_OPI;
    is_set_equal |= (funct6 == RISCV_V_FUNCT6_VMSLEU)   && funct3_is_OPI;

    return is_set_equal;
endfunction: f_is_set_equal

function automatic logic f_is_set_nequal(riscv_instr_funct6_t funct6, logic funct3_is_OPI);
    logic is_set_nequal = 1'b0;

    is_set_nequal = (funct6 == RISCV_V_FUNCT6_VMSNE)    && funct3_is_OPI;

    return is_set_nequal;
endfunction: f_is_set_nequal

function automatic logic f_is_set_less(riscv_instr_funct6_t funct6, logic funct3_is_OPIVV_OPIVX, logic funct3_is_OPI);
    logic is_set_less = 1'b0;

    is_set_less  = (funct6 == RISCV_V_FUNCT6_VMSLTU)   && funct3_is_OPIVV_OPIVX;
    is_set_less |= (funct6 == RISCV_V_FUNCT6_VMSLT)    && funct3_is_OPIVV_OPIVX;
    is_set_less |= (funct6 == RISCV_V_FUNCT6_VMSLE)    && funct3_is_OPI;
    is_set_less |= (funct6 == RISCV_V_FUNCT6_VMSLEU)   && funct3_is_OPI;

    return is_set_less;
endfunction: f_is_set_less

function automatic logic f_is_set_greater(riscv_instr_funct6_t funct6, logic funct3_is_OPIVX_OPIVI);
    logic is_set_greater = 1'b0;

    is_set_greater  = (funct6 == RISCV_V_FUNCT6_VMSGT)    && funct3_is_OPIVX_OPIVI;
    is_set_greater |= (funct6 == RISCV_V_FUNCT6_VMSGTU)   && funct3_is_OPIVX_OPIVI;

    return is_set_greater;
endfunction: f_is_set_greater

function automatic logic f_is_max(riscv_instr_funct6_t funct6, logic funct3_is_OPIVV_OPIVX, logic funct3_is_OPMVV);
    logic is_max = 1'b0;

    is_max  = (funct6 == RISCV_V_FUNCT6_VMAX)     && funct3_is_OPIVV_OPIVX;
    is_max |= (funct6 == RISCV_V_FUNCT6_VMAXU)    && funct3_is_OPIVV_OPIVX;
    is_max |= (funct6 == RISCV_V_FUNCT6_VREDMAX)  && funct3_is_OPMVV;
    is_max |= (funct6 == RISCV_V_FUNCT6_VREDMAXU) && funct3_is_OPMVV;

    return is_max;
endfunction: f_is_max

function automatic logic f_is_min(riscv_instr_funct6_t funct6, logic funct3_is_OPIVV_OPIVX, logic funct3_is_OPMVV);
    logic is_min = 1'b0;

    is_min  = (funct6 == RISCV_V_FUNCT6_VMIN)     && funct3_is_OPIVV_OPIVX;
    is_min |= (funct6 == RISCV_V_FUNCT6_VMINU)    && funct3_is_OPIVV_OPIVX;
    is_min |= (funct6 == RISCV_V_FUNCT6_VREDMIN)  && funct3_is_OPMVV;
    is_min |= (funct6 == RISCV_V_FUNCT6_VREDMINU) && funct3_is_OPMVV;

    return is_min;
endfunction: f_is_min 

function automatic logic f_is_high(riscv_instr_funct6_t funct6,  logic funct3_is_OPM);
    logic is_high = 1'b0;

    is_high  = (funct6 == RISCV_V_FUNCT6_VMULH)  && funct3_is_OPM;
    is_high |= (funct6 == RISCV_V_FUNCT6_VMULHU) && funct3_is_OPM;

    return is_high;
endfunction: f_is_high

function automatic logic f_is_signed(riscv_instr_funct6_t funct6, logic funct3_is_OPI, logic funct3_is_OPMVV, logic funct3_is_OPIVV_OPIVX, logic funct3_is_OPIVX_OPIVI, logic funct3_is_OPM);
    logic is_signed = 1'b0;

    is_signed  = (funct6 == RISCV_V_FUNCT6_VADD)    && funct3_is_OPI;
    is_signed |= (funct6 == RISCV_V_FUNCT6_VADC)    && funct3_is_OPI;
    is_signed |= (funct6 == RISCV_V_FUNCT6_VREDSUM) && funct3_is_OPMVV;
    is_signed |= (funct6 == RISCV_V_FUNCT6_VSUB)    && funct3_is_OPIVV_OPIVX;
    is_signed |= (funct6 == RISCV_V_FUNCT6_VSBC)    && funct3_is_OPIVV_OPIVX;
    is_signed |= (funct6 == RISCV_V_FUNCT6_VMAX)    && funct3_is_OPIVV_OPIVX;
    is_signed |= (funct6 == RISCV_V_FUNCT6_VREDMAX) && funct3_is_OPMVV;
    is_signed |= (funct6 == RISCV_V_FUNCT6_VMIN)    && funct3_is_OPIVV_OPIVX;
    is_signed |= (funct6 == RISCV_V_FUNCT6_VREDMIN) && funct3_is_OPMVV;
    is_signed |= (funct6 == RISCV_V_FUNCT6_VMUL)    && funct3_is_OPM;
    is_signed |= (funct6 == RISCV_V_FUNCT6_VMULH)   && funct3_is_OPM;
    is_signed |= (funct6 == RISCV_V_FUNCT6_VMSLT)   && funct3_is_OPIVV_OPIVX;
    is_signed |= (funct6 == RISCV_V_FUNCT6_VMSLE)   && funct3_is_OPI;
    is_signed |= (funct6 == RISCV_V_FUNCT6_VMSGT)   && funct3_is_OPIVX_OPIVI;

    return is_signed;
endfunction: f_is_signed

function automatic logic f_use_carry(riscv_instr_funct6_t funct6, logic funct3_is_OPI, logic funct3_is_OPIVV_OPIVX);
    logic use_carry = 1'b0;

    use_carry  = (funct6 == RISCV_V_FUNCT6_VADC)    && funct3_is_OPI;
    use_carry |= (funct6 == RISCV_V_FUNCT6_VSBC)    && funct3_is_OPIVV_OPIVX;

    return use_carry;
endfunction: f_use_carry 

function automatic riscv_instr_funct6_t f_riscv_v_opcode_to_funct6(riscv_v_opcode_e opcode);
    case (opcode)
        BW_AND          : return RISCV_V_FUNCT6_VAND;
        BW_AND_REDUCT   : return RISCV_V_FUNCT6_VREDAND;
        BW_OR           : return RISCV_V_FUNCT6_VOR;
        BW_OR_REDUCT    : return RISCV_V_FUNCT6_VREDOR;
        BW_XOR          : return RISCV_V_FUNCT6_VXOR;
        BW_XOR_REDUCT   : return RISCV_V_FUNCT6_VREDXOR;
        SLL             : return RISCV_V_FUNCT6_VSLL;
        SRL             : return RISCV_V_FUNCT6_VSRL;
        SRA             : return RISCV_V_FUNCT6_VSRA;
        ADDC            : return RISCV_V_FUNCT6_VADC;
        ADD             : return RISCV_V_FUNCT6_VADD;
        ADD_REDUCT      : return RISCV_V_FUNCT6_VREDSUM;
        SUBB            : return RISCV_V_FUNCT6_VSBC;
        SUB             : return RISCV_V_FUNCT6_VSUB;
        SUB_REDUCT      : return RISCV_V_FUNCT6_VRSUB;
        SIGN_EXT        : return RISCV_V_FUNCT6_VXUNARY0;
        ZERO_EXT        : return RISCV_V_FUNCT6_VXUNARY0;
        MINS            : return RISCV_V_FUNCT6_VMIN;
        MINS_REDUCT     : return RISCV_V_FUNCT6_VREDMIN;
        MINU            : return RISCV_V_FUNCT6_VMINU;
        MINU_REDUCT     : return RISCV_V_FUNCT6_VREDMINU;
        MAXS            : return RISCV_V_FUNCT6_VMAX;
        MAXS_REDUCT     : return RISCV_V_FUNCT6_VREDMAX;
        MAXU            : return RISCV_V_FUNCT6_VMAXU;
        MAXU_REDUCT     : return RISCV_V_FUNCT6_VREDMAXU;
        MULLS           : return RISCV_V_FUNCT6_VMUL;
        MULHS           : return RISCV_V_FUNCT6_VMULH;
        MULLU           : return RISCV_V_FUNCT6_VMUL;
        MULHU           : return RISCV_V_FUNCT6_VMULHU;
        SEQ             : return RISCV_V_FUNCT6_VMSEQ;
        SNE             : return RISCV_V_FUNCT6_VMSNE;
        SLE             : return RISCV_V_FUNCT6_VMSLE;
        SLEU            : return RISCV_V_FUNCT6_VMSLEU;
        SLT             : return RISCV_V_FUNCT6_VMSLT;
        SLTU            : return RISCV_V_FUNCT6_VMSLTU;
        SGT             : return RISCV_V_FUNCT6_VMSGT;
        SGTU            : return RISCV_V_FUNCT6_VMSGTU;
        MAND            : return RISCV_V_FUNCT6_VMAND;
        MNAND           : return RISCV_V_FUNCT6_VMNAND;
        MANDN           : return RISCV_V_FUNCT6_VMANDN;
        MXOR            : return RISCV_V_FUNCT6_VMXOR;
        MOR             : return RISCV_V_FUNCT6_VMOR;
        MNOR            : return RISCV_V_FUNCT6_VMNOR;
        MORN            : return RISCV_V_FUNCT6_VMORN;
        MXNOR           : return RISCV_V_FUNCT6_VMXNOR;
        I2V             : return RISCV_V_FUNCT6_VMV;
        V2I             : return RISCV_V_FUNCT6_VMV;
        NOP             : return '0;
        default         : begin
            $fatal(1, "opcode not supported yet, opcode: %0s", opcode.name());
            return 'x;
        end
    endcase
endfunction: f_riscv_v_opcode_to_funct6

function automatic riscv_v_opcode_e f_riscv_v_get_opcode(riscv_instruction_t instr);
        bit found = 0;
        riscv_v_opcode_e op;


        unique case(instr.V.funct6)
            //VADD VREDSUM VFADD
            RISCV_V_FUNCT6_VADD : begin
                //VADD
                if (instr.V.funct3 inside {OPIVV, OPIVX, OPIVI}) begin
                    op    = ADD;
                    found = 1;
                //VREDSUM
                end else if (instr.V.funct3 inside{OPMVV, OPMVX}) begin
                    op    = ADD_REDUCT;
                    found = 1;
                end
                //VFADD Not supported
            end
            //VAND, VAADD, VFSGNJN
            RISCV_V_FUNCT6_VAND : begin
                //VAND
                if (instr.V.funct3 inside {OPIVV, OPIVX, OPIVI}) begin
                    op    = BW_AND;
                    found = 1;
                end
                //VADD Not supported
                //VFSGNJN Not supported
            end
            //VOR, VASUBU, VFSGNJX
            RISCV_V_FUNCT6_VOR : begin
                //VAND
                if (instr.V.funct3 inside {OPIVV, OPIVX, OPIVI}) begin
                    op    = BW_OR;
                    found = 1;
                end
                //VASUBU Not supported
                //VFSGNJX Not supported
            end
        endcase

        if (~found) begin
            riscv_v_funct3_e funct3_enum;
            funct3_enum = riscv_v_funct3_e'(instr.V.funct3);
            $fatal(1, $sformatf("Not supported op, funct6: 0x%0h, funct3: %s", instr.V.funct6, funct3_enum.name()));
            return  NOP;
        end

        return op;
endfunction: f_riscv_v_get_opcode  

endpackage: riscv_v_pkg