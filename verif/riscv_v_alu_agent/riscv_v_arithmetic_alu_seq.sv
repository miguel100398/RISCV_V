//File: riscv_v_arithmetic_alu_seq
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector arithmetic alu sequence

`ifndef __RISCV_V_ARITHMETIC_ALU_SEQ__
`define __RISCV_V_ARITHMETIC_ALU_SEQ__ 

class riscv_v_arithmetic_alu_seq extends riscv_v_base_seq#(riscv_v_alu_seq_item);
    rand riscv_v_arithmetic_alu_in_seq_item arith_txn;
    riscv_v_alu_seq_item txn;
    
    bit reset_alu = 0;
    bit is_rand = 0;

    `uvm_object_utils(riscv_v_arithmetic_alu_seq)

  //Constructor
  function new(string name = "riscv_v_arithmetic_alu_seq");
    super.new(name);
    arith_txn = riscv_v_arithmetic_alu_in_seq_item::type_id::create("riscv_v_arithmetic_alu_in_seq_item");
    txn       = riscv_v_alu_seq_item::type_id::create("riscv_v_arithmetic_alu_seq_item");
  endfunction: new

  function void post_randomize();
    is_rand = 1;
  endfunction: post_randomize

  virtual task body();
    riscv_v_arithmetic_alu_in_seq_item rst_txn_tmp;
    riscv_v_alu_seq_item               rst_txn;

    if (!is_rand) begin
        assert (std::randomize(arith_txn)) else begin
          `uvm_fatal(get_name(), "Can't randomize riscv_v_arithmetic_alu_in_seq_item")
        end
    end

    wait_for_grant();
    txn.in = arith_txn;
    send_request(txn);
    wait_for_item_done();

    if (reset_alu) begin
        rst_txn_tmp = riscv_v_arithmetic_alu_in_seq_item::type_id::create("riscv_v_arithmetic_alu_in_seq_item");
        rst_txn     = riscv_v_alu_seq_item::type_id::create("riscv_v_arithmetic_rst_txn");
        rst_txn_tmp.srca                    = '0;
        rst_txn_tmp.srcb                    = '0;
        rst_txn_tmp.is_reduct               = 1'b0;
        rst_txn_tmp.is_add                  = 1'b0;
        rst_txn_tmp.is_sub                  = 1'b0;
        rst_txn_tmp.is_mul                  = 1'b0;
        rst_txn_tmp.is_zero_ext             = 1'b0;
        rst_txn_tmp.is_sign_ext             = 1'b0;
        rst_txn_tmp.is_set_equal            = 1'b0;
        rst_txn_tmp.is_set_nequal           = 1'b0;
        rst_txn_tmp.is_set_less             = 1'b0;
        rst_txn_tmp.is_set_greater          = 1'b0;
        rst_txn_tmp.is_max                  = 1'b0;
        rst_txn_tmp.is_min                  = 1'b0;
        rst_txn_tmp.is_high                 = 1'b0;
        rst_txn_tmp.is_signed               = 1'b0;
        rst_txn_tmp.use_carry               = 1'b0;
        rst_txn_tmp.carry_in                = '0;
        rst_txn_tmp.dst_osize_vector        = '0;
        rst_txn_tmp.src_osize_vector        = '0;
        rst_txn_tmp.is_greater_osize_vector = '0;
        rst_txn_tmp.is_less_osize_vector    = '0;
        rst_txn.in = rst_txn_tmp;
        wait_for_grant();
        send_request(rst_txn);
        wait_for_item_done();
    end


  endtask: body

endclass: riscv_v_arithmetic_alu_seq

`endif // __RISCV_V_ARITHMETIC_ALU_SEQ__