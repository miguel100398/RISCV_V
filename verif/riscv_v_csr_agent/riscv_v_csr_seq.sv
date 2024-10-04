//File: riscv_v_csr_seq
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V register file base sequence

`ifndef __RISCV_V_CSR_SEQ_SV__
`define __RISCV_V_CSR_SEQ_SV__

class riscv_v_csr_seq extends riscv_v_base_seq#(riscv_v_csr_seq_item);
  
    `uvm_object_utils(riscv_v_csr_seq)

  //Constructor
  function new(string name = "riscv_v_csr_seq");
    super.new(name);
  endfunction

endclass: riscv_v_csr_seq

`endif //__RISCV_V_CSR_SEQ_SV__