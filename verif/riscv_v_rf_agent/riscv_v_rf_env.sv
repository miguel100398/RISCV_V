//File: riscv_v_rf_env
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file environment

`ifndef __RISCV_V_RF_ENV_SV__
`define __RISCV_V_RF_ENV_SV__

class riscv_v_rf_env extends uvm_env;

  `uvm_component_utils(riscv_v_rf_env)
    
  // new - constructor
  function new(string name = "riscv_v_rf_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass: riscv_v_rf_env


`endif ///__RISCV_V_RF_ENV_SV__