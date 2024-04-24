//File: riscv_v_extend.sv
//Author: Miguel Bucio
//Date: 12/01/24
//Description: RISC-V Vector extension sign/zero extend
`timescale 1ns/1ps

module riscv_v_extend
import riscv_v_pkg::*, riscv_pkg::*;
(
    input  logic                        is_zero_ext,
    input  logic                        is_sign_ext,
    input  osize_vector_t               src_osize_vector,
    input  osize_vector_t               dst_osize_vector,
    input  riscv_v_alu_data_t           src,
    output riscv_v_src_byte_vector_t    result
);

localparam NUM_EXT_BLOCKS   = RISCV_V_NUM_BYTES_DATA;

//Is sign or zero extend
logic is_ext;

//src gated
riscv_v_src_byte_vector_t src_gated;

//Extend source to dest                      DEST OSIZE (128-16)         SRC OSIZE(64-8)
riscv_v_src_byte_vector_t src_ext_osize [RISCV_V_NUM_VALID_OSIZES-1:1][RISCV_V_NUM_VALID_OSIZES-2:0];
riscv_v_src_byte_vector_t src_ext_osize_sel;


assign is_ext = is_zero_ext | is_sign_ext;

//Gate source
generate
    for (genvar block = 0; block < NUM_EXT_BLOCKS; block++) begin : gen_gate_src 
        assign src_gated[block] = src.data.Byte[block] & {BYTE_WIDTH{is_ext}};
    end
endgenerate

//Shhift src data
generate
    for (genvar dst_osize_idx = 1; dst_osize_idx < RISCV_V_NUM_VALID_OSIZES; dst_osize_idx++) begin : gen_dst_osize_shift 
        for (genvar src_osize_idx = 0; src_osize_idx < dst_osize_idx; src_osize_idx++) begin : gen_src_osize_shift
            localparam SRC_WIDTH         = (BYTE_WIDTH*(2**src_osize_idx));
            localparam DEST_WIDTH        = (BYTE_WIDTH*(2**dst_osize_idx));
            localparam NUM_ELEMENTS_DEST = RISCV_V_DATA_WIDTH / DEST_WIDTH;
            localparam DEST_OFFSET       = (2**dst_osize_idx);
            localparam SRC_OFFSET        = (2**src_osize_idx);
            localparam NUM_BYTES_SRC     = (SRC_WIDTH/BYTE_WIDTH);
            localparam NUM_BYTES_DST     = (DEST_WIDTH/BYTE_WIDTH);
            localparam SIGN_WIDTH        = DEST_WIDTH-SRC_WIDTH;
            always_comb begin
                src_ext_osize[dst_osize_idx][src_osize_idx] = '0;
                for (int element_idx = 0; element_idx < NUM_ELEMENTS_DEST; element_idx++) begin
                    src_ext_osize[dst_osize_idx][src_osize_idx][(element_idx*DEST_OFFSET) +: NUM_BYTES_DST] = {{SIGN_WIDTH{(src_gated[((element_idx*SRC_OFFSET) + (NUM_BYTES_SRC-1))][BYTE_WIDTH-1] & is_sign_ext)}}, src_gated[(element_idx*SRC_OFFSET) +: NUM_BYTES_SRC]} & {DEST_WIDTH{(src_osize_vector[src_osize_idx] && dst_osize_vector[dst_osize_idx])}};
                end
            end
        end
    end 
endgenerate

always_comb begin
    src_ext_osize_sel = '0;
    for (int dst_osize_idx = 1; dst_osize_idx < RISCV_V_NUM_VALID_OSIZES; dst_osize_idx++) begin 
        for (int src_osize_idx = 0; src_osize_idx < dst_osize_idx; src_osize_idx++) begin : gen_src_osize_shift
            src_ext_osize_sel |= src_ext_osize[dst_osize_idx][src_osize_idx];
        end
    end
end

assign result = src_ext_osize_sel;


endmodule: riscv_v_extend