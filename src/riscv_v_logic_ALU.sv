//File: riscv_v_logic_ALU.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extension logical ALU

module riscv_v_logic_ALU
import riscv_v_pkg::*;
(
    //Control signals
    input  logic              is_reduct,
    input  logic              is_and,
    input  logic              is_or,
    input  logic              is_xor,
    input  logic              is_shift,
    input  logic              is_left,
    input  logic              is_arith,
    input  osize_vector_t     osize_vector,
    //Input sources
    input  riscv_v_alu_data_t srca,
    input  riscv_v_alu_data_t srcb,
    //Output result
    output riscv_v_wb_data_t  result
);
    logic is_reduct_n;
    osize_vector_t is_greater_osize_vector;
    osize_vector_t is_less_osize_vector;

    //Bitwise results
    riscv_v_src_byte_vector_t and_result;
    riscv_v_src_byte_vector_t or_result;
    riscv_v_src_byte_vector_t xor_result;
    riscv_v_src_byte_vector_t shifter_result;

    assign is_reduct_n = ~is_reduct;

    //Generate is_greater_osize
    generate
        //Bit 0 is always 1 since all osizes are greater than osize0
        assign is_greater_osize_vector[0] = 1'b1;
        //Lower half
        for (genvar idx=1; idx <= (RISCV_V_NUM_VALID_OSIZES/2); idx++) begin
            assign is_greater_osize_vector[idx] = ~(|osize_vector[0 +: idx]);
        end
        //Upper half
        for (genvar idx=(RISCV_V_NUM_VALID_OSIZES/2)+1; idx < RISCV_V_NUM_VALID_OSIZES; idx++) begin
            assign is_greater_osize_vector[idx] = |osize_vector[RISCV_V_NUM_VALID_OSIZES-1 -: RISCV_V_NUM_VALID_OSIZES-idx];
        end
    endgenerate

    //Generate is_less_osize
    generate
        for (genvar idx=0; idx < RISCV_V_NUM_VALID_OSIZES-1; idx++) begin
            assign is_less_osize_vector[idx] = ~is_greater_osize_vector[idx+1];
        end
        //MSB is always 1 since all osizes are less than MAX_OSIZE+1
        assign is_less_osize_vector[RISCV_V_NUM_VALID_OSIZES-1] = 1'b1;
    endgenerate

    riscv_v_bw_and bw_and(
        .is_reduct(is_reduct),
        .is_reduct_n(is_reduct_n),
        .is_and(is_and),
        .osize_vector(osize_vector),
        .is_greater_osize_vector(is_greater_osize_vector),
        .srca(srca),
        .srcb(srcb),
        .result(and_result)
    );

    riscv_v_bw_or bw_or(
        .is_reduct(is_reduct),
        .is_reduct_n(is_reduct_n),
        .is_or(is_or),
        .osize_vector(osize_vector),
        .is_greater_osize_vector(is_greater_osize_vector),
        .srca(srca),
        .srcb(srcb),
        .result(or_result)
    );

    riscv_v_bw_xor bw_xor(
        .is_reduct(is_reduct),
        .is_reduct_n(is_reduct_n),
        .is_xor(is_xor),
        .osize_vector(osize_vector),
        .is_greater_osize_vector(is_greater_osize_vector),
        .srca(srca),
        .srcb(srcb),
        .result(xor_result)
    );

    riscv_v_shifter shifter(
        .is_shift(is_shift),
        .is_left(is_left),
        .is_arith(is_arith),
        .osize_vector(osize_vector),
        .is_less_osize_vector(is_less_osize_vector),
        .is_greater_osize_vector(is_greater_osize_vector),
        .srca(srca),
        .srcb(srcb),
        .result(shifter_result)
    );



    //Final Mux result
    assign result.data  = and_result | or_result | xor_result | shifter_result;
    assign result.valid = srca.valid;

endmodule: riscv_v_logic_ALU
