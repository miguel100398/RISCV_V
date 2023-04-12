//File: riscv_v_rf_agt
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file Agent

`ifndef __RISCV_V_RF_AGT_SV__
`define __RISCV_V_RF_AGT_SV__

class riscv_v_rf_agt extends uvm_agent;

   //declaring agent components
  riscv_v_rf_driver    driver;
  riscv_v_rf_sequencer sequencer;
  riscv_v_rf_mon       monitor;
  
  // UVM automation macros for general components
  `uvm_component_utils(riscv_v_rf_agt)

  // constructor
  function new (string name = "riscv_v_rf_agt", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass: riscv_v_rf_agt

`endif //__RISCV_V_RF_AGT_SV__