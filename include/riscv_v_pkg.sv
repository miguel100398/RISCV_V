//File: riscv_v_pkg.sv
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension package

package riscv_v_pkg;

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
parameter int RISCV_V_RF_NUM_REGS           = 32;                                             //Number of registers in Register file
parameter int RISCV_V_RF_ADDR_WIDTH         = $clog2(RISCV_V_RF_NUM_REGS);                    //Width of addres of register file

typedef enum logic[1:0] {RF_RD_PORT_A = 2'b00, RF_RD_PORT_B = 2'b01, RF_WR_PORT = 2'b10} rf_port_e;

//Operation size enum
typedef enum logic[2:0] {OSIZE_8 = 3'd0, OSIZE_16 = 3'd1, OSIZE_32 = 3'd2, OSIZE_64 = 3'd3, OSIZE_128 = 3'd4} riscv_v_osize_e;
parameter int RISCV_V_NUM_VALID_OSIZES = 5;
typedef logic [RISCV_V_NUM_VALID_OSIZES-1:0] osize_vector_t;
typedef logic [RISCV_V_NUM_VALID_OSIZES-1:1] osize_is_greater_vector_t;
typedef logic [RISCV_V_NUM_VALID_OSIZES-2:0] osize_is_less_vector_t;
//ALU Enum
typedef enum logic[1:0] {LOGIC_ALU, ARITHMETIC_ALU, MASK_ALU} riscv_v_alu_e;

//Common types
typedef logic[BYTE_WIDTH-1:0]   Byte_t;
typedef logic[WORD_WIDTH-1:0]   Word_t;
typedef logic[DWORD_WIDTH-1:0]  Dword_t;
typedef logic[QWORD_WIDTH-1:0]  Qword_t;
typedef logic[DQWORD_WIDTH-1:0] Dqword_t;
typedef logic[QQWORD_WIDTH-1:0] Qqword_t;

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

//ALU Types
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] [BYTE_WIDTH-1:0]  riscv_v_src_byte_vector_t;
typedef logic[$clog2(RISCV_V_NUM_BYTES_DATA):0]             riscv_v_src_len_t;
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0]                   riscv_v_num_byte_vector_t;
typedef logic[RISCV_V_NUM_WORDS_DATA-1:0]                   riscv_v_num_word_vector_t;
typedef logic[RISCV_V_NUM_DWORDS_DATA-1:0]                  riscv_v_num_dword_vector_t;
typedef logic[RISCV_V_NUM_QWORDS_DATA-1:0]                  riscv_v_num_qword_vector_t;
typedef logic[RISCV_V_NUM_DQWORDS_DATA-1:0]                 riscv_v_num_dqword_vector_t;

//Mask Types
typedef logic[RISCV_V_NUM_ELEMENTS_REG-1:0]   riscv_v_mask_reg_t;

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