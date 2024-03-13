//File: riscv_v_permutation_ops.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector ALU Scoreboard

class riscv_v_permutation_ops extends uvm_component;

    `uvm_component_utils(riscv_v_permutation_ops)

    function new(string name = "riscv_v_permutation_ops", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void calc_i2v(input riscv_v_permutation_alu_in_seq_item permutation_in_txn, output riscv_v_wb_data_t permutation_exp_vec_result);
        permutation_exp_int_result               = '0;
        permutation_exp_vec_result.data          = '0;
        permutation_exp_vec_result.valid         = '0;
        permutation_exp_vec_result.data.Dword[0] = permutation_in_txn.integer_data_in;
        permutation_exp_vec_result.valid[3:0]    = 4'b1111;
    endfunction: calc_i2v

    virtual function void calc_v2i(input riscv_v_permutation_alu_in_seq_item permutation_in_txn, output riscv_data_t permutation_exp_int_result);
        permutation_exp_vec_result.data          = '0;
        permutation_exp_vec_result.valid         = '0;
        permutation_exp_int_result               = permutation_in_txn.vector_data_in.data.Dword[0];
    endfunction: calc_v2i

endclass: riscv_v_permutation_ops