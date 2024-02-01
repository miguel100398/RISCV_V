//File: riscv_rf_base_seq
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V register file base sequence

`ifndef __RISCV_RF_BASE_SEQ_SV__
`define __RISCV_RF_BASE_SEQ_SV__

virtual class riscv_rf_base_seq extends riscv_base_seq#(riscv_rf_seq_item);

  bit reset_wr_en = 1'b1;
  
  //Constructor
  function new(string name = "riscv_rf_base_seq");
    super.new(name);
  endfunction

endclass: riscv_rf_base_seq

`endif //__RISCV_RF_BASE_SEQ_SV__