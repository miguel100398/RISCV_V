//File: riscv_rf__seq
//Author: Miguel Bucio
//Date: 28/01/23
//Description: RISC-V register file directed sequence

`ifndef __RISCV_RF_SEQ__
`define __RISCV_RF_SEQ__ 

class riscv_rf_seq extends riscv_v_base_seq#(
  .seq_item_t(riscv_rf_seq_item)
);
    rand riscv_rf_addr_t  wr_addr   = '0;
    rand riscv_rf_addr_t  rd_addr_A = '0;
    rand riscv_rf_addr_t  rd_addr_B = '0;
    rand riscv_data_t     data_in   = '0;
    rand riscv_data_t     rd_data_A = '0;
    rand riscv_data_t     rd_data_B = '0;
    rand logic            wr_en     = '0;
         logic            reset_wr_en;


    `uvm_object_utils(riscv_rf_seq)

    //Constructor
  function new(string name = "riscv_rf_seq");
    super.new(name);
  endfunction: new

  virtual task body();

    //Send wr req
    req = riscv_rf_seq_item::type_id::create("rf_req");
    wait_for_grant();
    //Send random transaction
    assert(
        req.randomize()
    ) else begin
      `uvm_fatal(get_name(), "Can't randomize riscv_rf_seq_item")
    end
    req.in.addr      = wr_addr;
    req.out.addr     = rd_addr_A;
    req.out2.addr    = rd_addr_B;
    req.in.wr_en     = wr_en;
    req.in.data      = data_in;
    req.out.data     = rd_data_A;
    req.out2.data    = rd_data_B;
    req.in.reset_wr_en = reset_wr_en;
    send_request(req);
    wait_for_item_done();

  endtask: body

endclass: riscv_rf_seq

`endif //RISCV_RF_SEQ