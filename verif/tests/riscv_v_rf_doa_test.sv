//File: riscv_v_rf_doa_test
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file DOA test

`ifndef __RISCV_V_RF_DOA_TEST_SV__
`define __RISCV_V_RF_DOA_TEST_SV__

class riscv_v_rf_doa_test extends uvm_test;

  riscv_v_rf_env          rf_env;
  riscv_v_rf_rand_raw_seq seq_raw;

  `uvm_component_utils(riscv_v_rf_doa_test)

  function new(string name = "riscv_v_rf_doa_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    rf_env = riscv_v_rf_env::type_id::create("riscv_v_rf_env", this);
    seq_raw = riscv_v_rf_rand_raw_seq::type_id::create("riscv_v_rf_rand_raw_seq");
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    for (int i=0; i<100; i++) begin
      seq_raw.start(rf_env.agt.sqr);
    end
    phase.drop_objection(this);
  endtask : run_phase


endclass: riscv_v_rf_doa_test


`endif //__RISCV_V_RF_DOA_TEST_SV__