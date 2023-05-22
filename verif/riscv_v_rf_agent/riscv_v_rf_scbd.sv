//File: riscv_v_rf_scbd
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file Scoreboard

`ifndef __RISCV_V_RF_SCBD_SV__
`define __RISCV_V_RF_SCBD_SV__




class riscv_v_rf_scbd extends riscv_v_base_scbd#(
                                                  .seq_item_in_t  (riscv_v_rf_wr_seq_item),
                                                  .seq_item_out_t (riscv_v_rf_rd_seq_item)   );

  `uvm_component_utils(riscv_v_rf_scbd);


  // new - constructor
  function new (string name = "riscv_v_rf_scbd", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction: build_phase

  // write wr_port 
  virtual function void calc_in(riscv_v_rf_wr_seq_item txn);
    txn.print();
  endfunction : calc_in

  // write rd_port_A
  virtual function void calc_out(riscv_v_rf_rd_seq_item txn);
    txn.print();
  endfunction : calc_out

  // run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask : run_phase


endclass: riscv_v_rf_scbd


`endif //__RISCV_V_RF_SCBD_SV__