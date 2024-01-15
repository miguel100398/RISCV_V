//File: riscv_v_extend.sv
//Author: Miguel Bucio
//Date: 12/01/24
//Description: RISC-V Vector extension sign/zero extend

module riscv_v_extend
import riscv_v_pkg::*, riscv_pkg::*;
(
    input  logic                        is_zero_ext,
    input  logic                        is_sign_ext,
    input  osize_vector_t               src_osize_vector,
    input  osize_vector_t               dst_osize_vector,
    input  riscv_v_alu_data_t           srca,
    output riscv_v_src_byte_vector_t    result
);

localparam NUM_EXT_BLOCKS   = RISCV_V_NUM_BYTES_DATA;

//Is sign or zero extend
logic is_ext;

//srcA gated
riscv_v_src_byte_vector_t srca_gated;

//Sign vector
riscv_v_num_byte_vector_t sign_vector;
riscv_v_num_byte_vector_t sign_vector_with_past;

assign is_ext = is_zero_ext | is_sign_ext;

//Gate source A
generate
    for (genvar block = 0; block < NUM_EXT_BLOCKS; block++) begin : gen_gate_srcA 
        assign srca_gated[block] = srca.data.Byte[block] & {BYTE_WIDTH{is_ext}};
    end
endgenerate

//Get sign
always_comb begin
    sign_vector = '0;
    for (int osize_idx = 0; osize_idx < (RISCV_V_NUM_VALID_OSIZES-1); osize_idx++) begin
        automatic int OFFSET = 2**osize_idx;
        automatic int NUM_ELEMENTS = RISCV_V_DATA_WIDTH / (BYTE_WIDTH*OFFSET);
        //Get sign from byte
        for (int element_idx = 1; element_idx <= NUM_ELEMENTS; element_idx++) begin
            
            sign_vector[(element_idx*OFFSET)-1] |= (srca_gated[(element_idx*OFFSET)-1][BYTE_WIDTH-1]) & src_osize_vector[osize_idx] & is_sign_ext;

        end
    end
end

//Get past value
always_comb begin
    sign_vector_with_past[0] = sign_vector[0];
    for (int byte_idx = 1;  byte_idx < RISCV_V_NUM_BYTES_DATA; byte_idx++) begin
        sign_vector_with_past[byte_idx] = (srca.merge[byte_idx]) ? sign_vector[byte_idx] : sign_vector_with_past[byte_idx-1];
    end
end


//Sign or zero extend

//First byte is always data
assign result[0] = srca_gated[0];
generate
    for (genvar block = 1; block < NUM_EXT_BLOCKS; block++) begin : gen_extend
        assign result[block] = (srca.merge[block]) ? srca_gated[block] : {BYTE_WIDTH{sign_vector_with_past[block]}};
    end
endgenerate

endmodule: riscv_v_extend