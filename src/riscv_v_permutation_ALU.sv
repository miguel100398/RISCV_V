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
riscv_v_data_t i2v_result;
riscv_v_data_t i2v_result_qual_osize;
riscv_v_data_t i2v_result_qual;

//Integer to Vector
assign i2v_result = srca.data;

generate
    assign i2v_result_qual_osize[BYTE_WIDTH-1:0] = i2v_result[BYTE_WIDTH-1:0];        //First Byte is always valid with all osizes

    //Qualify Bytes with osize
    for (genvar osize_idx = 1; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
        assign i2v_result_qual_osize[(BYTE_WIDTH*(2**(osize_idx-1))) +: (BYTE_WIDTH*(2**(osize_idx-1)))] = i2v_result[(BYTE_WIDTH*(2**(osize_idx-1))) +: (BYTE_WIDTH*(2**(osize_idx-1)))] & {(BYTE_WIDTH*(2**(osize_idx-1))){osize_greater_vector[osize_idx]}};
    end

endgenerate

//Qualify result with is_i2v
assign i2v_result_qual = i2v_result_qual_osize & {RISCV_V_DATA_WIDTH{is_i2v}};;

assign vector_data_out.valid = srca.valid;
assign vector_data_out.data  = i2v_result_qual;
 

//Extend Vector to Integer
generate
    for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_INT_VALID_OSIZES-1; osize_idx++) begin
        localparam OSIZE_WIDTH = (BYTE_WIDTH*(2**osize_idx));
        assign v2i_result_osize[osize_idx] = { {(RISCV_DATA_WIDTH-OSIZE_WIDTH){srcb.data[OSIZE_WIDTH-1]}}, srcb.data[OSIZE_WIDTH-1 : 0]} & {RISCV_DATA_WIDTH{osize_vector[osize_idx]}};
    end
    assign v2i_result_osize[RISCV_V_NUM_INT_VALID_OSIZES-1] = srcb.data[RISCV_DATA_WIDTH-1 : 0] & {RISCV_DATA_WIDTH{|osize_vector[RISCV_V_NUM_VALID_OSIZES-1:RISCV_V_NUM_INT_VALID_OSIZES-1]}};
endgenerate

//Vector to integer
always_comb begin
    integer_data_out = 0;
    for (int osize_idx = 0; osize_idx < RISCV_V_NUM_INT_VALID_OSIZES; osize_idx++) begin
        integer_data_out |= v2i_result_osize[osize_idx];
    end
    integer_data_out &= {RISCV_DATA_WIDTH{is_v2i}};
end

endmodule: riscv_v_permutation_ALU