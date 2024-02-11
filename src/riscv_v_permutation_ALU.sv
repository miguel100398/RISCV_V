//File: riscv_v_permutation_ALU.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension permutation ALU

module riscv_v_permutation_ALU
import riscv_v_pkg::*, riscv_pkg::*;
(
    //Control signals
    input  logic                is_i2v,
    input  logic                is_v2i,
    input  riscv_data_t         integer_data_in,
    input  riscv_v_alu_data_t   vector_data_in,
    `ifdef RISCV_V_INST 
        input riscv_v_opcode_e  opcode,
    `endif //RISCV_V_INST
    output riscv_data_t         integer_data_out,
    output riscv_v_wb_data_t    vector_data_out   
);

 
//Integer to vector
always_comb begin
    vector_data_out.data  = '0;
    vector_data_out.valid = '0;

    vector_data_out.data[RISCV_DATA_WIDTH-1:0] = integer_data_in & {RISCV_DATA_WIDTH{is_i2v}};
    vector_data_out.valid[(RISCV_DATA_WIDTH/BYTE_WIDTH)-1:0] = {(RISCV_DATA_WIDTH/BYTE_WIDTH){is_i2v}};
end

//Vector to integer
assign  integer_data_out = vector_data_in.data[RISCV_DATA_WIDTH-1:0] & {RISCV_DATA_WIDTH{is_v2i}};

endmodule: riscv_v_permutation_ALU