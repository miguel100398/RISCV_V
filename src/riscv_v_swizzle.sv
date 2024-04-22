//File: riscv_v_swizzle.sv
//Author: Miguel Bucio
//Date: 22/04/24
//Description: RISC-V Swwizzle module
`timescale 1ns/1ps

module riscv_v_swizzle
import riscv_pkg::*, riscv_v_pkg::*;
(
    input  riscv_v_data_t  src_data,
    input  logic           invert,
    input  osize_vector_t  osize_vec, 
    output riscv_v_data_t  result
);

riscv_v_data_t data_swizzle [RISCV_V_NUM_VALID_OSIZES];
riscv_v_data_t data_swizzle_sel;

//Swizzle data
generate
    for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
        localparam BLOCK_WIDTH = (BYTE_WIDTH*(2**osize_idx));
        localparam NUM_BLOCKS  = RISCV_V_DATA_WIDTH/BLOCK_WIDTH;
        always_comb begin
            for (int idx = 0; idx < NUM_BLOCKS; idx++) begin
                data_swizzle[osize_idx][(RISCV_V_DATA_WIDTH-1) - (idx*BLOCK_WIDTH) -: BLOCK_WIDTH] = src_data[(idx*BLOCK_WIDTH) +: BLOCK_WIDTH];
            end
        end

    end
endgenerate

always_comb begin
    data_swizzle_sel = '0;
    for (int osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
        data_swizzle_sel |= data_swizzle[osize_idx] & {$bits(data_swizzle_sel){osize_vec[osize_idx]}};
    end
end

assign result = (invert) ? data_swizzle_sel : src_data;

endmodule: riscv_v_swizzle