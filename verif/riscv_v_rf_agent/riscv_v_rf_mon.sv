//File: riscv_v_rf_mon
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file monitor

`ifndef __RISCV_V_RF_MON_SV___
`define __RISCV_V_RF_MON_SV___

class riscv_v_rf_mon extends uvm_monitor;

  `uvm_component_utils(riscv_v_rf_mon)

  // new - constructor
  function new (string name = "riscv_v_rf_mon", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass: riscv_v_rf_mon

`endif //__RISCV_V_RF_MON_SV___