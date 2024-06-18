//File: riscv_v_permutation_ALU.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension permutation ALU
`timescale 1ns/1ps

module riscv_v_permutation_ALU
import riscv_v_pkg::*, riscv_pkg::*;
(
    //Control signals
    input  logic                is_i2v,
    input  logic                is_v2i,
    input  riscv_v_alu_data_t   srca,
    input  riscv_v_alu_data_t   srcb,
    input  osize_vector_t       osize_vector,
    input  osize_vector_t       osize_greater_vector,
    `ifdef RISCV_V_INST 
        input riscv_v_opcode_e  opcode,
        input riscv_v_osize_e   osize,
    `endif //RISCV_V_INST
    output riscv_data_t         integer_data_out,
    output riscv_v_wb_data_t    vector_data_out   
);

riscv_data_t v2i_result_osize [RISCV_V_NUM_INT_VALID_OSIZES-1:0];

riscv_v_data_t i2v_src;
riscv_v_data_t i2v_result_qual_osize;
riscv_v_data_t i2v_result_qual;

riscv_v_data_t v2i_src;

//Integer to Vector
assign i2v_src    = srca.data & {RISCV_V_DATA_WIDTH{is_i2v}};

//Qualify result with is_i2v
//I2V does not require extra logic, Scalar data is already sign extend before getting to ALU and WR_EN is disabled for invalid bytes so PRF won't be modified
assign i2v_result_qual = i2v_src;

assign vector_data_out.valid = srca.valid;
assign vector_data_out.data  = i2v_result_qual;
 

//Extend Vector to Integer
assign v2i_src = srcb.data & {RISCV_V_DATA_WIDTH{is_v2i}};

generate
    for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_INT_VALID_OSIZES-1; osize_idx++) begin
        localparam OSIZE_WIDTH = (BYTE_WIDTH*(2**osize_idx));
        assign v2i_result_osize[osize_idx] = { {(RISCV_DATA_WIDTH-OSIZE_WIDTH){v2i_src[OSIZE_WIDTH-1]}}, v2i_src[OSIZE_WIDTH-1 : 0]} & {RISCV_DATA_WIDTH{osize_vector[osize_idx]}};
    end
    assign v2i_result_osize[RISCV_V_NUM_INT_VALID_OSIZES-1] = v2i_src[RISCV_DATA_WIDTH-1 : 0] & {RISCV_DATA_WIDTH{|osize_vector[RISCV_V_NUM_VALID_OSIZES-1:RISCV_V_NUM_INT_VALID_OSIZES-1]}};
endgenerate

//Vector to integer
always_comb begin
    integer_data_out = 0;
    for (int osize_idx = 0; osize_idx < RISCV_V_NUM_INT_VALID_OSIZES; osize_idx++) begin
        integer_data_out |= v2i_result_osize[osize_idx];
    end
end

endmodule: riscv_v_permutation_ALU