//File: riscv_v_rf_rand_rd_seq
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file random read sequence

`ifndef __RISCV_V_RF_RAND_RD_SEQ__
`define __RISCV_V_RF_RAND_RD_SEQ__ 

class riscv_v_rf_rand_rd_seq extends riscv_v_rf_base_seq;
  `uvm_object_utils(riscv_v_rf_rand_rd_seq)

    //Constructor
  function new(string name = "riscv_v_rf_rand_rd_seq");
    super.new(name);
  endfunction: new

  virtual task body();

    req = riscv_v_rf_seq_item::type_id::create("rf_rd_req");
    wait_for_grant();
    //Send rd transaction
    assert(
        req.randomize() with{
            req.wr_en     == '0;
        }
    );
    req.reset_wr_en = reset_wr_en;
    send_request(req);
    wait_for_item_done();

  endtask: body

endclass: riscv_v_rf_rand_rd_seq

`endif //RISCV_V_RF_RAND_RD_SEQ