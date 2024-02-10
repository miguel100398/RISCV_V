//File: riscv_v_rf_agt
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file Agent

`ifndef __RISCV_V_RF_AGT_SV__
`define __RISCV_V_RF_AGT_SV__

class riscv_v_rf_agt extends riscv_v_base_agt#(
                                                .seq_item_in_t  (riscv_v_rf_wr_seq_item),
                                                .seq_item_out_t (riscv_v_rf_rd_seq_item),
                                                .driver_t       (riscv_v_rf_drv),
                                                .monitor_t      (riscv_v_rf_mon),
                                                .tracker_t      (riscv_v_rf_trk),
                                                .sequencer_t    (riscv_v_rf_sqr),
                                                .bfm_t          (riscv_v_rf_bfm)
);
  
  // UVM automation macros for general components
  `uvm_component_utils(riscv_v_rf_agt)

  // constructor
  function new (string name = "riscv_v_rf_agt", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

  // connect_phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase

endclass: riscv_v_rf_agt

`endif //__RISCV_V_RF_AGT_SV__