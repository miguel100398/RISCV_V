//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-V V Instruction Fetch Agent

`ifndef __RISCV_V_AGT_SV__
`define __RISCV_V_AGT_SV__

class riscv_v_agt extends riscv_v_base_agt#(
                                                .seq_item_in_t  (riscv_v_in_seq_item),
                                                .seq_item_out_t (riscv_v_out_seq_item),
                                                .driver_t       (riscv_v_drv),
                                                .monitor_t      (riscv_v_mon),
                                                .tracker_t      (riscv_v_trk),
                                                .sequencer_t    (riscv_v_sqr),
                                                .bfm_t          (riscv_v_bfm)
);
  
  // UVM automation macros for general components
  `uvm_component_utils(riscv_v_agt)

  // constructor
  function new (string name = "riscv_v_agt", uvm_component parent = null);
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

endclass: riscv_v_agt

`endif //__RISCV_V_AGT_SV__