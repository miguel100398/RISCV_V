//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISCV V CSR Agent

`ifndef __RISCV_V_CSR_AGT_SV__
`define __RISCV_V_CSR_AGT_SV__

class riscv_v_csr_agt extends riscv_v_base_agt#(
                                                .seq_item_in_t  (riscv_v_csr_in_seq_item),
                                                .seq_item_out_t (riscv_v_csr_out_seq_item),
                                                .driver_t       (riscv_v_csr_drv),
                                                .monitor_t      (riscv_v_csr_mon),
                                                .tracker_t      (riscv_v_csr_trk),
                                                .sequencer_t    (riscv_v_csr_sqr),
                                                .bfm_t          (riscv_v_csr_bfm)
);
  
  // UVM automation macros for general components
  `uvm_component_utils(riscv_v_csr_agt)

  // constructor
  function new (string name = "riscv_v_csr_agt", uvm_component parent = null);
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
      mon.rtl_out_ap.connect(bfm.analysis_imp_out);
    end

  endfunction: connect_active_components

endclass: riscv_v_csr_agt

`endif //__RISCV_V_CSR_AGT_SV__