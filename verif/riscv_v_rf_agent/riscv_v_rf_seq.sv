//File: riscv_v_rf__seq
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file directed sequence

`ifndef __RISCV_V_RF_SEQ__
`define __RISCV_V_RF_SEQ__ 

class riscv_v_rf_seq extends riscv_v_rf_base_seq;
    rand riscv_v_rf_addr_t  wr_addr   = '0;
    rand riscv_v_rf_addr_t  rd_addr_A = '0;
    rand riscv_v_rf_addr_t  rd_addr_B = '0;
    rand riscv_v_data_t     data_in   = '0;
    rand riscv_v_rf_wr_en_t wr_en     = '0;


    `uvm_object_utils(riscv_v_rf_seq)

    //Constructor
  function new(string name = "riscv_v_rf_seq");
    super.new(name);
  endfunction: new

  virtual task body();

    //Send wr req
    req = riscv_v_rf_seq_item::type_id::create("rf_req");
    wait_for_grant();
    //Send random transaction
    assert(
        req.randomize() with{
            req.wr_addr   == wr_addr;
            req.rd_addr_A == rd_addr_A;
            req.rd_addr_B == rd_addr_B;
            req.wr_en     == wr_en;
            req.data_in   == data_in;
        }
    );
    req.reset_wr_en = reset_wr_en;
    send_request(req);
    wait_for_item_done();

  endtask: body

endclass: riscv_v_rf_seq

`endif //RISCV_V_RF_SEQ