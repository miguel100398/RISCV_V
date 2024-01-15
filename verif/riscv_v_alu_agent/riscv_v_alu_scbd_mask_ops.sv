//File: riscv_v_alu_scbd_mask_ops.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector ALU Scoreboard

    virtual function void calc_mand();
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = (mask_in_txn.srca_mask[i] && mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mand

    virtual function void calc_mnand();
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = !(mask_in_txn.srca_mask[i] && mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mnand

    virtual function void calc_mandn();
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = (!mask_in_txn.srca_mask[i] && mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mandn

    virtual function void calc_mor();
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = (mask_in_txn.srca_mask[i] || mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mor

    virtual function void calc_mnor();
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = !(mask_in_txn.srca_mask[i] || mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mnor

    virtual function void calc_morn();
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = (!mask_in_txn.srca_mask[i] || mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_morn

    virtual function void calc_mxor();
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = (mask_in_txn.srca_mask[i] ^^ mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mxor

    virtual function void calc_mxnor();
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            mask_exp_result[i] = !(mask_in_txn.srca_mask[i] ^^ mask_in_txn.srcb_mask[i]);
        end
    endfunction: calc_mxnor