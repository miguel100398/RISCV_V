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

//RISCV_V_Constants
parameter int RISCV_V_ELEN                  = 128;                                            //Maximum size in bits of a vector element that any operation can produce or consume
parameter int RISCV_V_VLEN                  = RISCV_V_ELEN;                                   //Size of a single  vector register  
parameter int RISCV_V_DATA_WIDTH            = RISCV_V_VLEN;                                   //Width of data in datapath
parameter int RISCV_V_NUM_BYTES_DATA        = RISCV_V_DATA_WIDTH / BYTE_WIDTH;                //Number of bytes in Data bus
parameter int RISCV_V_NUM_WORDS_DATA        = RISCV_V_DATA_WIDTH / WORD_WIDTH;                //Number of words in Data bus
parameter int RISCV_V_NUM_DWORDS_DATA       = RISCV_V_DATA_WIDTH / DWORD_WIDTH;               //Number of dwords in Data bus
parameter int RISCV_V_NUM_QWORDS_DATA       = RISCV_V_DATA_WIDTH / QWORD_WIDTH;               //Number of qwords in Data bus
parameter int RISCV_V_NUM_DQWORDS_DATA      = RISCV_V_DATA_WIDTH / DQWORD_WIDTH;              //Number of dqwords in Data bus

//Regfile Constants
parameter int RISCV_V_RF_NUM_REGS           = 32;                                             //Number of registers in Register file
parameter int RISCV_V_RF_ADDR_WIDTH         = $clog2(RISCV_V_RF_NUM_REGS);                    //Width of addres of register file

typedef enum logic[1:0] {RF_RD_PORT_A = 2'b00, RF_RD_PORT_B = 2'b01, RF_WR_PORT = 2'b10} rf_port_e;

//Operation size enum
typedef enum logic[2:0] {OSIZE_8, OSIZE_16, OSIZE_32, OSIZE_64, OSIZE_128} riscv_v_osize_e;
parameter int RISCV_V_NUM_VALID_OSIZES = 5;
typedef logic [RISCV_V_NUM_VALID_OSIZES-1:0] osize_vector_t;
//ALU Enum
typedef enum logic {LOGIC_ALU} riscv_v_alu_e;

//Common types
typedef logic[BYTE_WIDTH-1:0]   Byte_t;
typedef logic[WORD_WIDTH-1:0]   Word_t;
typedef logic[DWORD_WIDTH-1:0]  Dword_t;
typedef logic[QWORD_WIDTH-1:0]  Qword_t;
typedef logic[DQWORD_WIDTH-1:0] Dqword_t;

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
typedef logic[RISCV_V_NUM_BYTES_DATA-1:0] [BYTE_WIDTH-1:0] riscv_v_src_byte_vector_t;
typedef logic[$clog2(RISCV_V_NUM_BYTES_DATA):0] riscv_v_src_len_t;

//Opcode types
typedef enum logic[3:0] {BW_AND, BW_AND_REDUCT, 
                         BW_OR,  BW_OR_REDUCT,
                         BW_XOR, BW_XOR_REDUCT,
                         SLL, SRL, SRA, 
                         NOP} riscv_v_opcode_e;

//////////////////////Functions/////////////////////////////////////////////////////////////////

function logic[$clog2(RISCV_V_NUM_VALID_OSIZES)-1:0] f_count_trailing_zeroes_osize(int src);
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

function logic[$clog2(RISCV_V_NUM_VALID_OSIZES)-1:0] f_count_trailing_ones_osize(int src);
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


/////////////////////////////////////////MACROS/////////////////////////////////////////
//Zero extend signal to size
//`define RISCV_V_ZX(signal, size)\
 //   {{size-$bits(signal)}{1'b0},signal}
`define RISCV_V_ZX(signal, size)\
    {{(size-$bits(signal)){1'b0}}, signal}

//Sign extend signal to size
`define RISCV_V_SX(signal, size)\
    {{(size-$bits(signal)){signal[$bits(signal)-1]}},signal}


endpackage: riscv_v_pkg