//File: riscv_v_rf_rand_wr_seq
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file random wrie sequence

`ifndef __RISCV_V_RF_RAND_WR_SEQ__
`define __RISCV_V_RF_RAND_WR_SEQ__ 

class riscv_v_rf_rand_wr_seq extends riscv_v_rf_base_seq;
   `uvm_object_utils(riscv_v_rf_rand_wr_seq)

    //Constructor
  function new(string name = "riscv_v_rf_rand_wr_seq");
    super.new(name);
  endfunction: new

  virtual task body();

    req = riscv_v_rf_seq_item::type_id::create("rf_wr_req");
    wait_for_grant();
    //Send wr transaction with at least 1 wr_en byte
    assert(
        req.randomize() with{
            req.rd_addr_A == '0;
            req.rd_addr_B == '0;
            req.wr_en     !=  0;
        }
    );
    req.reset_wr_en = reset_wr_en;
    send_request(req);
    wait_for_item_done();

  endtask: body

endclass: riscv_v_rf_rand_wr_seq

`endif //RISCV_V_RF_RAND_WR_SEQ