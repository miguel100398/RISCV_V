//File: riscv_v_permutation_ops.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector ALU Scoreboard

`ifndef __RISCV_V_PERMUTATION_OPS_SV__
`define __RISCV_V_PERMUTATION_OPS_SV__

class riscv_v_permutation_ops extends uvm_component;

    `uvm_component_utils(riscv_v_permutation_ops)

    function new(string name = "riscv_v_permutation_ops", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void calc_i2v(input riscv_v_permutation_alu_in_seq_item permutation_in_txn, ref riscv_v_wb_data_t permutation_exp_vec_result, ref riscv_data_t permutation_exp_int_result);
        permutation_exp_int_result               = '0;
        permutation_exp_vec_result.data          = '0;
        permutation_exp_vec_result.valid         = permutation_in_txn.srca.valid;


        unique case (permutation_in_txn.osize)
            OSIZE_8: begin
                permutation_exp_vec_result.data.Byte   =  permutation_in_txn.srca.data[BYTE_WIDTH-1:0];
            end
            OSIZE_16: begin
                permutation_exp_vec_result.data.Word   =  permutation_in_txn.srca.data[WORD_WIDTH-1:0];
            end
            OSIZE_32: begin
                permutation_exp_vec_result.data.Dword  =  permutation_in_txn.srca.data[DWORD_WIDTH-1:0];
            end
            OSIZE_64: begin
                permutation_exp_vec_result.data.Qword  =  `RISCV_V_SX(permutation_in_txn.srca.data.Dword[0], QWORD_WIDTH);
            end
            OSIZE_128: begin
                permutation_exp_vec_result.data.Dqword =  `RISCV_V_SX(permutation_in_txn.srca.data.Dword[0], DQWORD_WIDTH);
            end
        endcase

    endfunction: calc_i2v

    virtual function void calc_v2i(input riscv_v_permutation_alu_in_seq_item permutation_in_txn, ref riscv_v_wb_data_t permutation_exp_vec_result, ref riscv_data_t permutation_exp_int_result);
        permutation_exp_int_result               = '0;
        permutation_exp_vec_result.data          = '0;
        permutation_exp_vec_result.valid         = '0;
        unique case (permutation_in_txn.osize)
            OSIZE_8: begin
                permutation_exp_int_result = `RISCV_V_SX(permutation_in_txn.srcb.data.Byte[0], RISCV_DATA_WIDTH);
            end
            OSIZE_16: begin
                permutation_exp_int_result = `RISCV_V_SX(permutation_in_txn.srcb.data.Word[0], RISCV_DATA_WIDTH);
            end
            OSIZE_32: begin
                permutation_exp_int_result = `RISCV_V_SX(permutation_in_txn.srcb.data.Dword[0], RISCV_DATA_WIDTH);
            end
            OSIZE_64: begin
                permutation_exp_int_result = permutation_in_txn.srcb.data.Qword[0][RISCV_DATA_WIDTH-1:0];
            end
            OSIZE_128: begin
                permutation_exp_int_result = permutation_in_txn.srcb.data.Dqword[0][RISCV_DATA_WIDTH-1:0];
            end
            default:  `uvm_fatal(get_name(), $sformatf("Invalid Osize : %0s", permutation_in_txn.osize.name()))
        endcase
    endfunction: calc_v2i

endclass: riscv_v_permutation_ops

`endif //__RISCV_V_PERMUTATION_OPS_SV__