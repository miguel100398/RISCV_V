//File: riscv_v_alu_scbd_permutation_ops.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector ALU Scoreboard

    virtual function void calc_i2v();
        permutation_exp_int_result               = '0;
        permutation_exp_vec_result.data          = '0;
        permutation_exp_vec_result.valid         = '0;
        permutation_exp_vec_result.data.Dword[0] = permutation_in_txn.integer_data_in;
        permutation_exp_vec_result.valid[3:0]    = 4'b1111;
    endfunction: calc_i2v

    virtual function void calc_v2i();
        permutation_exp_vec_result.data          = '0;
        permutation_exp_vec_result.valid         = '0;
        permutation_exp_int_result               = permutation_in_txn.vector_data_in.data.Dword[0];
    endfunction: calc_v2i