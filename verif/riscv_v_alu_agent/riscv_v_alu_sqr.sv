//File: riscv_v_alu_sqr
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension ALU sequencer

`ifndef __RISCV_V_ALU_SQR_SV__
`define __RISCV_V_ALU_SQR_SV__ 

class riscv_v_alu_sqr extends riscv_v_base_sqr#(riscv_v_alu_in_seq_item);
  `uvm_component_utils(riscv_v_alu_sqr) 

  //constructor
  function new(string name = "riscv_v_alu_sqr", uvm_component parent = null);
    super.new(name,parent);
  endfunction: new

endclass: riscv_v_alu_sqr

`endif //__RISCV_V_ALU_SQR_SV__