//File: riscv_v_rf_rand_raw_seq
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file random read after write sequence

`ifndef __RISCV_V_RF_RAND_RAW_SEQ__
`define __RISCV_V_RF_RAND_RAW_SEQ__ 

class riscv_v_rf_rand_raw_seq extends riscv_v_rf_base_seq;
    rand riscv_v_rf_addr_t addr;


    `uvm_object_utils(riscv_v_rf_rand_raw_seq)

    //Constructor
  function new(string name = "riscv_v_rf_rand_raw_seq");
    super.new(name);
  endfunction: new

  virtual task body();
    
    //randomize addr
    assert (std::randomize(addr));

    //Send wr req
    req = riscv_v_rf_seq_item::type_id::create("rf_wr_req");
    wait_for_grant();
    //Send random transaction
    assert(
        req.randomize() with{
            req.wr_addr   == addr;
            req.rd_addr_A == '0;
            req.rd_addr_B == '0;
            req.wr_en     !=  0;
        }
    );
    req.reset_wr_en = 1'b0;
    send_request(req);
    wait_for_item_done();

    //Send rd req
    req = riscv_v_rf_seq_item::type_id::create("rf_rd_req");
    wait_for_grant();
    //Send random transaction
    assert(
        req.randomize() with{
            req.rd_addr_A == addr;
            req.rd_addr_B == addr;
            req.wr_en     == '0;
        }
    );
    req.reset_wr_en = reset_wr_en;
    send_request(req);
    wait_for_item_done();

  endtask: body

endclass: riscv_v_rf_rand_raw_seq

`endif //RISCV_V_RF_RAND_raw_SEQ