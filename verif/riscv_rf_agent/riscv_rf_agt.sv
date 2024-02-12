//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-V register file Agent

`ifndef __RISCV_RF_AGT_SV__
`define __RISCV_RF_AGT_SV__

class riscv_rf_agt extends riscv_v_base_agt#(
                                                .seq_item_in_t  (riscv_rf_wr_seq_item),
                                                .seq_item_out_t (riscv_rf_rd_seq_item),
                                                .driver_t       (riscv_rf_drv),
                                                .monitor_t      (riscv_rf_mon),
                                                .tracker_t      (riscv_rf_trk),
                                                .sequencer_t    (riscv_rf_sqr),
                                                .bfm_t          (riscv_rf_bfm)
);
  
  // UVM automation macros for general components
  `uvm_component_utils(riscv_rf_agt)

  // constructor
  function new (string name = "riscv_rf_agt", uvm_component parent = null);
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

  virtual function void connect_active_components();

    super.connect_active_components();
    if (USE_BFM) begin
      mon.rtl_in_ap.connect(bfm.analysis_imp_in);
    end

  endfunction: connect_active_components

endclass: riscv_rf_agt

`endif //__RISCV_RF_AGT_SV__