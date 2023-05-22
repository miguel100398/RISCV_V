//File: riscv_v_rf_base_seq
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file base sequence

`ifndef __RISCV_V_RF_BASE_SEQ_SV__
`define __RISCV_V_RF_BASE_SEQ_SV__

virtual class riscv_v_rf_base_seq extends riscv_v_base_seq#(riscv_v_rf_seq_item);

  bit reset_wr_en = 1'b1;
  
  //Constructor
  function new(string name = "riscv_v_rf_base_seq");
    super.new(name);
  endfunction

endclass: riscv_v_rf_base_seq

`endif //__RISCV_V_RF_BASE_SEQ_SV__