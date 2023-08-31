//File: riscv_v_logic_al_seq
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extension register file random read after write sequence

`ifndef __RISCV_V_LOGIC_ALU_SEQ__
`define __RISCV_V_LOGIC_ALU_SEQ__ 

class riscv_v_logic_alu_seq extends riscv_v_base_seq#(riscv_v_logic_alu_in_seq_item);
    rand riscv_v_logic_alu_in_seq_item txn;
    
    bit reset_alu = 0;
    bit is_rand = 0;

    `uvm_object_utils(riscv_v_logic_alu_seq)

  //Constructor
  function new(string name = "riscv_v_rf_rand_raw_seq");
    super.new(name);
    txn = riscv_v_logic_alu_in_seq_item::type_id::create("riscv_v_logic_alu_in_seq_item");
  endfunction: new

  function void post_randomize();
    is_rand = 1;
  endfunction: post_randomize

  virtual task body();
    riscv_v_logic_alu_in_seq_item rst_txn;

    if (!is_rand) begin
        assert (std::randomize(txn)) else begin
          `uvm_fatal(get_name(), "Can't randomize riscv_v_logic_alu_in_seq_item")
        end
    end

    wait_for_grant();
    send_request(txn);
    wait_for_item_done();

    if (reset_alu) begin
        rst_txn = riscv_v_logic_alu_in_seq_item::type_id::create("riscv_v_logic_alu_in_seq_item");
        rst_txn.srca                    = '0;
        rst_txn.srcb                    = '0;
        rst_txn.is_and                  = 1'b0;
        rst_txn.is_or                   = 1'b0;
        rst_txn.is_xor                  = 1'b0;
        rst_txn.is_shift                = 1'b0;
        rst_txn.is_left                 = 1'b0;
        rst_txn.is_arith                = 1'b0;
        rst_txn.is_reduct               = 1'b0;
        rst_txn.osize_vector            = '0;
        rst_txn.is_greater_osize_vector = '0;
        rst_txn.is_less_osize_vector    = '0;
        wait_for_grant();
        send_request(rst_txn);
        wait_for_item_done();
    end


  endtask: body

endclass: riscv_v_logic_alu_seq

`endif // __RISCV_V_LOGIC_ALU_SEQ__