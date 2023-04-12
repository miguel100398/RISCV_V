//File: riscv_v_rf_seq_item
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file sequence item

`ifndef __RISCV_V_RF_SEQ_ITEM_SV__
`define __RISCV_V_RF_SEQ_ITEM_SV__

class riscv_v_rf_seq_item extends uvm_sequence_item;

  //Utility macro
  `uvm_object_utils(mem_seq_item)  

  //Constructor
  function new(string name = "riscv_v_rf_seq_item");
    super.new(name);
  endfunction

endclass: riscv_v_rf_seq_item

`endif //__RISCV_V_RF_SEQ_ITEM_SV__