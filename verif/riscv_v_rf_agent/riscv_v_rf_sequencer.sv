//File: riscv_v_rf_sequencer
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file sequencer

`ifndef __RISCV_V_RF_SEQUENCER_SV__
`define __RISCV_V_RF_SEQUENCER_SV__

class riscv_v_rf_sequencer extends uvm_sequencer#(riscv_v_rf_seq_item);

  `uvm_component_utils(mem_sequencer) 

  //constructor
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunctio

endclass: riscv_v_rf_sequencer

`endif // __RISCV_V_RF_SEQUENCER_SV__