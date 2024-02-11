//File: riscv_v_mask_ALU.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension mask ALU

module riscv_v_mask_ALU 
import riscv_v_pkg::*, riscv_pkg::*;
(
    //Control signals
    input  logic                is_mask,
    input  logic                is_and,
    input  logic                is_or,
    input  logic                is_xor,
    input  logic                is_negate_srca,
    input  logic                is_negate_result,
    input  riscv_v_mask_t       srca,
    input  riscv_v_mask_t       srcb,
    `ifdef RISCV_V_INST 
        input riscv_v_opcode_e  opcode,
    `endif //RISCV_V_INST
    output riscv_v_mask_t       result
);

//Select between srca and ~srca with a xor gate
riscv_v_mask_t srca_sel;
//Srca gated with is_and
riscv_v_mask_t srca_and_gated;
//Srca/b gated with is_or
riscv_v_mask_t srca_or_gated;
riscv_v_mask_t srcb_or_gated;
//Srca/b gated with is_xor
riscv_v_mask_t srca_xor_gated;
riscv_v_mask_t srcb_xor_gated;
//Operations
riscv_v_mask_t and_result;
riscv_v_mask_t or_result;
riscv_v_mask_t xor_result;
//Select between result and ~result with a xor gate
riscv_v_mask_t result_op;
riscv_v_mask_t result_sel;

assign srca_sel = srca ^ {RISCV_V_NUM_ELEMENTS_REG{is_negate_srca}};

//Gating
assign srca_and_gated = srca_sel & {RISCV_V_NUM_ELEMENTS_REG{is_and}};
assign srca_or_gated  = srca_sel & {RISCV_V_NUM_ELEMENTS_REG{is_or}};
assign srcb_or_gated  = srcb     & {RISCV_V_NUM_ELEMENTS_REG{is_or}};
assign srca_xor_gated = srca_sel & {RISCV_V_NUM_ELEMENTS_REG{is_xor}};
assign srcb_xor_gated = srcb     & {RISCV_V_NUM_ELEMENTS_REG{is_xor}};

//Apply operations
assign and_result = srca_and_gated & srcb;
assign or_result  = srca_or_gated  | srcb_or_gated;
assign xor_result = srca_xor_gated ^ srcb_xor_gated;

//Negate and select result
assign  result_op  = and_result
                   | or_result
                   | xor_result;

assign  result_sel = result_op ^ {RISCV_V_NUM_ELEMENTS_REG{is_negate_result}};

assign result = result_sel & {RISCV_V_NUM_ELEMENTS_REG{is_mask}};

endmodule: riscv_v_mask_ALU