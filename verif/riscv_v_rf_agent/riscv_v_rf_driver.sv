//File: riscv_v_rf_driver
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file driver

`ifndef __RISCV_V_RF_DRIVER_SV__
`define __RISCV_V_RF_DRIVER_SV__

class riscv_v_rf_driver extends uvm_driver#(riscv_v_rf_seq_item);

  `uvm_component_utils(riscv_v_rf_driver)

  // Constructor
  function new (string name = riscv_v_rf_driver, uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass: riscv_v_rf_driver


`endif //__RISCV_V_RF_DRIVER_SV__