//File: riscv_v_decode_element.sv
//Author: Miguel Bucio
//Date: 17/01/24
//Description: RISC-V Vector Decode element
`timescale 1ns/1ps

module riscv_v_decode_element
import riscv_pkg::*, riscv_v_pkg::*;
(
    input  riscv_instr_rs_t         srca_addr,
    input  riscv_v_data_t           srca,
    input  riscv_v_data_t           srcb,
    input  riscv_v_vtype_t          vtype,
    input  riscv_v_vl_t             vl,
    input  riscv_v_vstart_t         vstart, 
    input  logic                    is_zero_ext,
    input  logic                    is_sign_ext,
    input  logic                    is_mask,
    input  logic                    is_reduct,
    input  logic                    use_mask,
    input  riscv_v_mask_t           mask,
    output riscv_v_alu_data_t       srca_alu,
    output riscv_v_alu_data_t       srcb_alu,
    output riscv_v_mask_t           mask_osize_sel,
    `ifdef RISCV_V_INST
        output riscv_v_src_len_t    len,
        output riscv_v_osize_e      osize,
    `endif //RISCV_V_INST
    output osize_vector_t           dst_osize_vector,
    output osize_vector_t           src_osize_vector,
    output osize_vector_t           is_greater_osize_vector,
    output osize_vector_t           is_less_osize_vector
    
);

logic is_extend;

//Osize
riscv_v_osize_e dst_osize;
osize_vector_t               src_osize_vector_ext;
riscv_v_osize_shift_stikcy_t src_osize_vector_sticky;
riscv_v_merge_data_t merge_osize[RISCV_V_NUM_VALID_OSIZES-1:1];
riscv_v_valid_data_t valid_osize[RISCV_V_NUM_VALID_OSIZES-1:0];
riscv_v_valid_data_t valid_osize_sel;

logic len_greater_than  [RISCV_V_NUM_ELEMENTS_REG-1:0];
logic start_less_than   [RISCV_V_NUM_ELEMENTS_REG-1:0];

riscv_v_mask_t       mask_osize [RISCV_V_NUM_VALID_OSIZES];
riscv_v_valid_data_t mask_valid;
riscv_v_valid_data_t is_mask_valid;
riscv_v_valid_data_t is_reduct_osize [RISCV_V_NUM_VALID_OSIZES-1];
riscv_v_valid_data_t is_reduct_osize_sel;
riscv_v_valid_data_t is_reduct_valid;

assign dst_osize = riscv_v_osize_e'(vtype.vsew);

//Destination osize vector
assign dst_osize_vector[0] = (dst_osize == OSIZE_8);
assign dst_osize_vector[1] = (dst_osize == OSIZE_16);
assign dst_osize_vector[2] = (dst_osize == OSIZE_32);
assign dst_osize_vector[3] = (dst_osize == OSIZE_64);
assign dst_osize_vector[4] = (dst_osize == OSIZE_128);

//Get source osize for Shift/Zero extend
assign is_extend = is_zero_ext | is_sign_ext;
always_comb begin
    unique case(srca_addr[RISCV_V_EXTEND_SHIFT_END:RISCV_V_EXTEND_SHIFT_BEGIN])
        RISCV_V_EXT_SHIFT_3 : {src_osize_vector_ext, src_osize_vector_sticky} = {dst_osize_vector, {RISCV_V_OSIZE_SHIFT_STICKY_WIDTH{1'b0}}} >> 3;
        RISCV_V_EXT_SHIFT_2 : {src_osize_vector_ext, src_osize_vector_sticky} = {dst_osize_vector, {RISCV_V_OSIZE_SHIFT_STICKY_WIDTH{1'b0}}} >> 2;
        RISCV_V_EXT_SHIFT_1 : {src_osize_vector_ext, src_osize_vector_sticky} = {dst_osize_vector, {RISCV_V_OSIZE_SHIFT_STICKY_WIDTH{1'b0}}} >> 1;
        default: src_osize_vector_ext = 'x;
    endcase
    //Set Osize to if OSIZE was shifted out;
    src_osize_vector_ext[0] |= |src_osize_vector_sticky;
end

assign src_osize_vector = (is_extend) ? src_osize_vector_ext : dst_osize_vector;

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
    for (genvar len_idx = 0; len_idx < RISCV_V_NUM_ELEMENTS_REG; len_idx++) begin : gen_len_greater_than
        assign len_greater_than[len_idx] = (unsigned'(vl.len) >= unsigned'(len_idx+1));
    end
endgenerate

//Start comparators
generate
    for (genvar start_idx = 0; start_idx < RISCV_V_NUM_ELEMENTS_REG; start_idx++) begin : gen_start_less_than 
        assign start_less_than[start_idx] = (unsigned'(vstart.index) < unsigned'(start_idx+1));
    end
endgenerate

//Disable upper elements if is reduct operation
generate
    for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES-1; osize_idx++) begin : gen_reduct 
        always_comb begin
            is_reduct_osize[osize_idx] = '0;
            //Set lower bits to 1 depending on OSIZE
            is_reduct_osize[osize_idx][0 +: (2**osize_idx)] = {(2**osize_idx){dst_osize_vector[osize_idx]}};
        end
    end 
endgenerate

//Select is_reduct
always_comb begin
    is_reduct_osize_sel = '0;
    for(int osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES-1; osize_idx++) begin
        is_reduct_osize_sel |= is_reduct_osize[osize_idx];
    end
end

assign is_reduct_valid = ({RISCV_V_NUM_BYTES_DATA{~is_reduct}} | is_reduct_osize_sel);

//Mask

//Get different Masks with osize
generate
    for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_mask_osize
        localparam NUM_BLOCKS_OSIZE = RISCV_V_NUM_BYTES_DATA / (2**osize_idx);
        localparam BYTES_PER_BLOCK  = RISCV_V_NUM_BYTES_DATA / NUM_BLOCKS_OSIZE;
        for (genvar block_idx = 0; block_idx < NUM_BLOCKS_OSIZE; block_idx++) begin : gen_mask_osize_block 
            assign mask_osize[osize_idx][(block_idx * BYTES_PER_BLOCK) +: BYTES_PER_BLOCK] = {BYTES_PER_BLOCK{(mask[block_idx] & (dst_osize_vector[osize_idx]))}};
        end
    end 
endgenerate

//Select final mask
always_comb begin
    mask_osize_sel = '0;
    for (int osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
        mask_osize_sel |= mask_osize[osize_idx];
    end
end

//Disable upper elements if destination is mask registers
assign is_mask_valid = { {RISCV_V_NUM_BYTES_DATA - RISCV_V_NUM_BYTES_ALLOCATE_MASK{(~is_mask)}}, {RISCV_V_NUM_BYTES_ALLOCATE_MASK{1'b1}} };

//Element is valid if ~use_mask | mask[i];
assign mask_valid = ({RISCV_V_NUM_BYTES_DATA{~use_mask}} | mask_osize_sel);


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
                valid_osize[osize_idx][block_idx*(2**osize_idx) +: NUM_BITS_OSIZE] = {NUM_BITS_OSIZE{(len_greater_than[block_idx] & start_less_than[block_idx] & dst_osize_vector[osize_idx])}};
            end
        end

    end
endgenerate

//Select Valid osize
always_comb begin
    valid_osize_sel = '0;
    for (int osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
        valid_osize_sel |= valid_osize[osize_idx];
    end 
end

always_comb begin
    srca_alu.valid = valid_osize_sel;
    srcb_alu.valid = valid_osize_sel;
    //Turn off valid bits with mask
    srca_alu.valid &= mask_valid;
    //Turn off valid bits if is_reduct
    srca_alu.valid &= is_reduct_valid;
    //Turn off valid bits if is_mask
    srca_alu.valid &= is_mask_valid;
end

assign srcb_alu.merge = srca_alu.merge;

`ifdef RISCV_V_INST 
    assign len   = vl.len;
    assign osize = riscv_v_osize_e'(vtype.vsew);
`endif //RISCV_V_INST

endmodule: riscv_v_decode_element