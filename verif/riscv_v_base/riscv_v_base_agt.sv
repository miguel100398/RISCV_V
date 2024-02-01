//File: riscv_v_base_agt.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC Vector Base Agent

`ifndef __RISCV_V_BASE_AGT_SV__
`define __RISCV_V_BASE_AGT_SV__ 

virtual class riscv_v_base_agt #(   type seq_item_in_t  = riscv_v_base_seq_item,
                                    type seq_item_out_t = seq_item_in_t,
                                    type driver_t       = riscv_v_base_drv#(
                                                                   .seq_item_t (seq_item_in_t)),
                                    type monitor_t      = riscv_v_base_mon#(
                                                                   .seq_item_in_t   (seq_item_in_t), 
                                                                   .seq_item_out_t  (seq_item_out_t)),
                                    type tracker_t      = riscv_v_base_trk#(
                                                                   .seq_item_in_t   (seq_item_in_t), 
                                                                   .seq_item_out_t  (seq_item_out_t),
                                                                   .file_name("riscv_v_base_trkr.txt")),
                                    type sequencer_t    = riscv_v_base_sqr#(
                                                                   .seq_item_t      (seq_item_in_t)),
                                    type bfm_t          = riscv_v_base_bfm#(
                                                                   .seq_item_in_t   (seq_item_in_t),
                                                                   .seq_item_out_t  (seq_item_out_t),
                                                                   .sequencer_t     (sequencer_t)
                                    )) extends base_agt#(
                                        .seq_item_in_t(seq_item_in_t),
                                        .seq_item_out_t(seq_item_out_t),
                                        .driver_t(driver_t),
                                        .monitor_t(monitor_t),
                                        .tracker_t(tracker_t),
                                        .sequencer_t(sequencer_t),
                                        .bfm_t(bfm_t)
                                    );

    `uvm_component_param_utils(riscv_v_base_agt#(
            .seq_item_in_t  (seq_item_in_t),
            .seq_item_out_t (seq_item_out_t),
            .driver_t       (driver_t),
            .monitor_t      (monitor_t),
            .tracker_t      (tracker_t),
            .sequencer_t    (sequencer_t),
            .bfm_t          (bfm_t)
    ));

    //Constructor
    function new(string name = "base_agt", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new


endclass: riscv_v_base_agt

`endif //__RISCV_V_BASE_AGT_SV__