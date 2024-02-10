//File: riscv_v_alu_seq
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector alu sequence

`ifndef __RISCV_V_ALU_SEQ__
`define __RISCV_V_ALU_SEQ__ 

class riscv_v_alu_seq extends riscv_v_base_seq#(riscv_v_alu_in_seq_item);
    

    `uvm_object_utils(riscv_v_alu_seq)

  //Constructor
  function new(string name = "riscv_v_alu_seq");
    super.new(name);
  endfunction: new


endclass: riscv_v_alu_seq

`endif // __RISCV_V_ALU_SEQ__