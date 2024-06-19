//File: riscv_v_reduct_src.sv
//Author: Miguel Bucio
//Date: 19/06/24
//Description: RISC-V Vector extension Reduct src
`timescale 1ns/1ps

module riscv_v_reduct_src
import riscv_v_pkg::*, riscv_pkg::*;
(
    input  riscv_v_data_t    src,
    input  logic             is_reduct,
    input  logic             is_reduct_n,
    input  osize_vector_t    osize_vector,
    input  osize_vector_t    is_greater_osize_vector, 
    input  riscv_v_data_t    result,
    output riscv_v_data_t    src_o
);

    logic           greater_than_sel   [RISCV_V_NUM_VALID_OSIZES-1:1];
    riscv_v_data_t  src_gated;

    riscv_v_data_t  result_gated;
    riscv_v_data_t  result_gated_osize [RISCV_V_NUM_VALID_OSIZES-2:0];
    riscv_v_data_t  result_shifted     [RISCV_V_NUM_VALID_OSIZES-2:0];
    riscv_v_data_t  result_selected;

    //Gate result with is_reduct
    assign result_gated = result & {RISCV_V_DATA_WIDTH{is_reduct}};

    generate

        //Greater than and is_reduct to gate src
        for (genvar osize_idx = 1; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_greater_than_sel
            assign greater_than_sel[osize_idx] = is_reduct_n | is_greater_osize_vector[osize_idx];
        end

        //Gate src
        //First Byte is a bypass without gate
        assign src_gated.Byte[0] = src.Byte[0];
        for (genvar osize_idx = 1; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_gate_src 
            localparam WIDTH     = (8 * (2**(osize_idx-1)));
            localparam START_IDX = (8 * (2**(osize_idx-1)));
            assign src_gated[START_IDX +: WIDTH] = src[START_IDX +: WIDTH] & {WIDTH{greater_than_sel[osize_idx]}};
        end

        //Gate result with osize
        for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES-1; osize_idx++) begin : gen_gate_result_osize
            assign result_gated_osize[osize_idx] = result_gated & {RISCV_V_DATA_WIDTH{osize_vector[osize_idx]}};
        end

        //Shift result
        for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES-1; osize_idx++) begin : gen_result_shift
            assign result_shifted[osize_idx] = result_gated_osize[osize_idx] << (8*(2**osize_idx));
        end 

        //Select shihft result
        always_comb begin
            result_selected = 0;
            for (int osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES-1; osize_idx++) begin
                result_selected |= result_shifted[osize_idx];
            end
        end

    endgenerate

    //Get output src
    assign src_o = src_gated | result_selected;

endmodule: riscv_v_reduct_src