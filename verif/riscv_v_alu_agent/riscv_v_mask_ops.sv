//File: riscv_v_mask_ops.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector ALU Scoreboard

`ifndef __RISCV_V_MASK_OPS_SV__
`define __RISCV_V_MASK_OPS_SV__

class riscv_v_mask_ops extends uvm_component;

    `uvm_component_utils(riscv_v_mask_ops)

    function new(string name = "riscv_v_mask_ops", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void calc_mand(input riscv_v_mask_alu_in_seq_item mask_in_txn, ref riscv_v_mask_t mask_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = (mask_in_txn.srca_mask[i] && mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mand

    virtual function void calc_mnand(input riscv_v_mask_alu_in_seq_item mask_in_txn, ref riscv_v_mask_t mask_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = !(mask_in_txn.srca_mask[i] && mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mnand

    virtual function void calc_mandn(input riscv_v_mask_alu_in_seq_item mask_in_txn, ref riscv_v_mask_t mask_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = (!mask_in_txn.srca_mask[i] && mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mandn

    virtual function void calc_mor(input riscv_v_mask_alu_in_seq_item mask_in_txn, ref riscv_v_mask_t mask_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = (mask_in_txn.srca_mask[i] || mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mor

    virtual function void calc_mnor(input riscv_v_mask_alu_in_seq_item mask_in_txn, ref riscv_v_mask_t mask_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = !(mask_in_txn.srca_mask[i] || mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mnor

    virtual function void calc_morn(input riscv_v_mask_alu_in_seq_item mask_in_txn, ref riscv_v_mask_t mask_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = (!mask_in_txn.srca_mask[i] || mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_morn

    virtual function void calc_mxor(input riscv_v_mask_alu_in_seq_item mask_in_txn, ref riscv_v_mask_t mask_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = (mask_in_txn.srca_mask[i] ^^ mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mxor

    virtual function void calc_mxnor(input riscv_v_mask_alu_in_seq_item mask_in_txn, ref riscv_v_mask_t mask_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = !(mask_in_txn.srca_mask[i] ^^ mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mxnor

endclass: riscv_v_mask_ops

`endif //__RISCV_V_MASK_OPS_SV__