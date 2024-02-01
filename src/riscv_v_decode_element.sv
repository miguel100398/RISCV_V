//File: riscv_v_decode_element.sv
//Author: Miguel Bucio
//Date: 17/01/24
//Description: RISC-V Vector Decode element

module riscv_v_decode_element
import riscv_pkg::*, riscv_v_pkg::*;
(
    input  riscv_v_data_t           srca,
    input  riscv_v_data_t           srcb,
    input  riscv_v_vtype_t          vtype,
    input  riscv_v_vl_t             vl,
    input  riscv_v_vstart_t         vstart, 
    output riscv_v_alu_data_t       srca_alu,
    output riscv_v_alu_data_t       srcb_alu,
    output osize_vector_t           dst_osize_vector,
    output osize_vector_t           src_osize_vector,
    output osize_vector_t           is_greater_osize_vector,
    output osize_vector_t           is_less_osize_vector,
    output riscv_v_src_len_t        len
);

//Osize
riscv_v_osize_e src_osize;
riscv_v_osize_e dst_osize;
riscv_v_merge_data_t merge_osize[RISCV_V_NUM_VALID_OSIZES-1:1];
riscv_v_valid_data_t valid_osize[RISCV_V_NUM_VALID_OSIZES-1:0];

logic len_greater_than  [RISCV_V_NUM_ELEMENTS_REG-1:0];

assign dst_osize = riscv_v_osize_e'(vtype.vsew);
assign src_osize = riscv_v_osize_e'(vtype.vsew);

//Destination osize vector
assign dst_osize_vector[0] = (dst_osize == OSIZE_8);
assign dst_osize_vector[1] = (dst_osize == OSIZE_16);
assign dst_osize_vector[2] = (dst_osize == OSIZE_32);
assign dst_osize_vector[3] = (dst_osize == OSIZE_64);
assign dst_osize_vector[4] = (dst_osize == OSIZE_128);

//FIXME
assign src_osize_vector = dst_osize_vector;

assign len = vl.len;

//Is greater osize vector
assign is_greater_osize_vector[0] = 1'b1; //Bit 0 is always 1 since all osizes are greater than osize0
generate
    for (genvar osize_idx = 1; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_is_greater_osize_vector
        assign is_greater_osize_vector[osize_idx] = |dst_osize_vector[RISCV_V_NUM_VALID_OSIZES-1:osize_idx];
    end
endgenerate

//Is less osize vector
assign is_less_osize_vector[RISCV_V_NUM_VALID_OSIZES-1] = 1'b1; //MSB is always 1 since all osizes are less than MAX_OSIZE+1
generate
    for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES-1; osize_idx++) begin : gen_is_less_osize_vector
        assign is_less_osize_vector[osize_idx] = ~is_greater_osize_vector[osize_idx+1];
    end
endgenerate

//Len comparators
generate
    for (genvar len_idx = 0; len_idx < RISCV_V_NUM_ELEMENTS_REG; len_idx++) begin
        assign len_greater_than[len_idx] = (len > len_idx);
    end
endgenerate

//Assign data
assign srca_alu.data = srca;
assign srcb_alu.data = srcb;


generate
    for (genvar osize_idx = 1; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_merge_osize
        localparam NUM_BLOCKS_OSIZE = RISCV_V_NUM_BYTES_DATA / (2**osize_idx);
        localparam NUM_BITS_OSIZE   = (2**osize_idx)-1;

        always_comb begin
            merge_osize[osize_idx] = '0;
            for (int block_idx = 0; block_idx < NUM_BLOCKS_OSIZE; block_idx++) begin
            merge_osize[osize_idx][block_idx*(2**osize_idx) +: NUM_BITS_OSIZE] = {NUM_BITS_OSIZE{(dst_osize_vector[osize_idx])}};
        end
        end

    end
endgenerate

always_comb begin
    srca_alu.merge = '0;
    for (int osize_idx = 1; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
        srca_alu.merge |= merge_osize[osize_idx];
    end
end

generate
    for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_valid_osize 
        localparam NUM_BLOCKS_OSIZE = RISCV_V_NUM_BYTES_DATA / (2**osize_idx);
        localparam NUM_BITS_OSIZE   = (2**osize_idx);

        always_comb begin
            valid_osize[osize_idx] = '0;
            for (int block_idx = 0; block_idx < NUM_BLOCKS_OSIZE; block_idx++) begin
                valid_osize[osize_idx][block_idx*(2**osize_idx) +: NUM_BITS_OSIZE] = {NUM_BITS_OSIZE{(len_greater_than[block_idx])}};
            end
        end

    end
endgenerate

always_comb begin
    srca_alu.valid = '0;
    for (int osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
        srca_alu.valid |= valid_osize[osize_idx];
    end
end

assign srcb_alu.merge = srca_alu.merge;
assign srcb_alu.valid = srca_alu.valid;

endmodule: riscv_v_decode_element