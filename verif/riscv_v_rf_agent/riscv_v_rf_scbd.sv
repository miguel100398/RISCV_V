//File: riscv_v_rf_scbd
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file Scoreboard

`ifndef __RISCV_V_RF_SCBD_SV__
`define __RISCV_V_RF_SCBD_SV__

class riscv_v_rf_scbd extends uvm_scoreboard;

  `uvm_component_utils(riscv_v_rf_scbd)

  // new - constructor
  function new (string name = "riscv_v_rf_scbd", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass: riscv_v_rf_scbd


`endif //__RISCV_V_RF_SCBD_SV__