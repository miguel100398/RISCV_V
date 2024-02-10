//File: riscv_v_rf_rand_seq
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file random sequence

`ifndef __RISCV_V_RF_RAND_SEQ__
`define __RISCV_V_RF_RAND_SEQ__ 

class riscv_v_rf_rand_seq extends riscv_v_rf_base_seq;
   `uvm_object_utils(riscv_v_rf_rand_seq)

    //Constructor
  function new(string name = "riscv_v_rf_rand_seq");
    super.new(name);
  endfunction: new

  virtual task body();

    req = riscv_v_rf_seq_item::type_id::create("rf_rand_req");
    wait_for_grant();
    //Send random transaction
    assert(
        req.randomize()
    );
    req.in.reset_wr_en = reset_wr_en;
    send_request(req);
    wait_for_item_done();

  endtask: body

endclass: riscv_v_rf_rand_seq

`endif //RISCV_V_RF_RAND_SEQ