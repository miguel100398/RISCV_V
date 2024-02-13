//File: riscv_v_if_base_seq
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V register file base sequence

`ifndef __RISCV_V_IF_BASE_SEQ_SV__
`define __RISCV_V_IF_BASE_SEQ_SV__

virtual class riscv_v_if_base_seq extends riscv_v_base_seq#(riscv_v_if_seq_item);
  
  //Constructor
  function new(string name = "riscv_v_if_base_seq");
    super.new(name);
  endfunction

endclass: riscv_v_if_base_seq

`endif //__RISCV_V_IF_BASE_SEQ_SV__