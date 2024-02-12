//File: riscv_v_permutation_alu_doa_test
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector Permutation ALU file DOA test

`ifndef __RISCV_V_PERMUTATION_ALU_DOA_TEST_SV__
`define __RISCV_V_PERMUTATION_ALU_DOA_TEST_SV__

class riscv_v_permutation_alu_doa_test extends riscv_alu_base_test;

  riscv_v_permutation_alu_seq    seq;

  `uvm_component_utils(riscv_v_permutation_alu_doa_test)

  function new(string name = "riscv_v_permutation_alu_doa_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    seq     = riscv_v_permutation_alu_seq::type_id::create("riscv_v_permutation_alu_seq");
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    for (int i=0; i<100; i++) begin
      seq.start(alu_env.agt.sqr);
    end
    phase.drop_objection(this);
  endtask : run_phase


endclass: riscv_v_permutation_alu_doa_test


`endif //__RISCV_V_PERMUTATION_ALU_DOA_TEST_SV__