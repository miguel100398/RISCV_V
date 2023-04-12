//File: riscv_v_rf_sequence
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file sequence

`ifndef __RISCV_V_RF_SEQUENCE_SV__
`define __RISCV_V_RF_SEQUENCE_SV__

class riscv_v_rf_sequence extends uvm_sequence#(riscv_v_rf_seq_item);

  `uvm_sequence_utils(riscv_v_rf_sequence, riscv_v_rf_sequencer)
  
  //Constructor
  function new(string name = "riscv_v_rf_sequence");
    super.new(name);
  endfunction

endclass: riscv_v_rf_sequence

`endif //__RISCV_V_RF_SEQUENCE_SV__