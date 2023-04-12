//File: riscv_v_rf_doa_test
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file DOA test

`ifndef __RISCV_V_RF_DOA_TEST_SV__
`define __RISCV_V_RF_DOA_TEST_SV__

class riscv_v_rf_doa_test extends uvm_test;

  riscv_v_rf_env      env;
  riscv_v_rf_sequence seq;

  `uvm_component_utils(riscv_v_rf_doa_test)

  function new(string name = "riscv_v_rf_doa_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = riscv_v_rf_env::type_id::create("riscv_v_rf_env", this);
    seq = riscv_v_rf_sequence::type_id::create("riscv_v_rf_sequence");
  endfunction : build_phase


endclass: riscv_v_rf_doa_test


`endif //__RISCV_V_RF_DOA_TEST_SV__