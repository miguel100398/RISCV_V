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

//Regfile Constants
parameter bit RISCV_V_RF_RD_ASYNC           = 1'b1;
parameter bit RISCV_V_RF_REG_INPUTS         = 1'b0;
parameter int RISCV_V_RF_NUM_REGS           = 32;                                             //Number of registers in Register file
parameter int RISCV_V_RF_ADDR_WIDTH         = $clog2(RISCV_V_RF_NUM_REGS);                    //Width of addres of register file
//Mask Regfile Constants
parameter bit RISCV_V_MASK_RF_RD_ASYNC      = 1'b1;
parameter bit RISCV_V_MASK_RF_REG_INPUTS    = 1'b0;
parameter int RISCV_V_MASK_RF_NUM_REGS      = 8;                                              //Number of mask registers in mask register file
parameter int RISCV_V_MASK_RF_ADDR_WIDTH    = $clog2(RISCV_V_MASK_RF_NUM_REGS);

parameter int RISCV_V_MAX_LMUL = 8;
parameter int RISCV_V_MAX_VLEN = RISCV_V_NUM_ELEMENTS_REG * RISCV_V_MAX_LMUL;

//CSR
typedef enum logic [2:0] {VSEW_8 = 3'b000, VSEW_16 = 3'b001, VSEW_32 = 3'b010, VSEW_64 = 3'b011, VSEW_128 = 3'b100} riscv_v_vsew_t;
typedef enum logic [2:0] {LMUL_1 = 3'b000, LMUL_2  = 3'b001, LMUL_4  = 3'b010, LMUL_8  = 3'b011} riscv_v_vlmul_t;
typedef enum logic {UNDISTURBED = 1'b0, AGNOSTIC = 1'b1} riscv_v_agnostic_e;
typedef logic[$clog2(RISCV_V_MAX_VLEN)-1:0] riscv_v_vlen_t;
typedef logic[$clog2(RISCV_V_MAX_VLEN)-1:0] riscv_v_field_vstart_t;
typedef enum logic [1:0] {RNU = 2'b00, RNE = 2'b01, RDN = 2'b10, ROD = 2'b11} riscv_v_fixed_point_rounding_e;

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


parameter riscv_v_vsstatus_t RISCV_V_VSSTATUS_RST_VAL = '{
    VS       : OFF,
    reserved : 'x
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
typedef enum logic[1:0] {LOGIC_ALU, ARITHMETIC_ALU, MASK_ALU, PERMUTATION_ALU} riscv_v_alu_e;

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
typedef logic[RISCV_V_NUM_ELEMENTS_REG-1:0]   riscv_v_mask_reg_t;
typedef riscv_v_mask_reg_t riscv_v_mask_regs_t [RISCV_V_MASK_RF_NUM_REGS];

//ALU Types
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] [BYTE_WIDTH-1:0]  riscv_v_src_byte_vector_t;
typedef logic[$clog2(RISCV_V_NUM_BYTES_DATA):0]             riscv_v_src_len_t;
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0]                   riscv_v_num_byte_vector_t;
typedef logic[RISCV_V_NUM_WORDS_DATA-1:0]                   riscv_v_num_word_vector_t;
typedef logic[RISCV_V_NUM_DWORDS_DATA-1:0]                  riscv_v_num_dword_vector_t;
typedef logic[RISCV_V_NUM_QWORDS_DATA-1:0]                  riscv_v_num_qword_vector_t;
typedef logic[RISCV_V_NUM_DQWORDS_DATA-1:0]                 riscv_v_num_dqword_vector_t;

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


endpackage: riscv_v_pkg