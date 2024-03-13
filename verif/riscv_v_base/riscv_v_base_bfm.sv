//File: riscv_v_base_bfm.sv
//Author: Miguel Bucio
//Date: 08/10/23
//Description: RISC V Base BFM

`ifndef __RISCV_V_BASE_BFM_SV__
`define __RISCV_V_BASE_BFM_SV__ 

virtual class riscv_v_base_bfm #( type seq_item_in_t  = riscv_v_base_seq_item,
                                  type seq_item_out_t = riscv_v_base_seq_item,
                                  type sequencer_t    = riscv_v_base_sqr#(
                                                                   .seq_item_t(seq_item_in_t)),
                                  type cfg_obj_t      = riscv_v_bfm_base_cfg_obj,
                                  type seq_t          = riscv_v_base_seq,
                                  type model_t        = riscv_v_base_model
                                ) extends base_bfm#(.seq_item_in_t(seq_item_in_t),
                                                     .seq_item_out_t(seq_item_out_t),
                                                     .sequencer_t(sequencer_t),
                                                     .cfg_obj_t(cfg_obj_t),
                                                     .seq_t(seq_t),
                                                     .model_t(model_t));

  `uvm_component_param_utils(riscv_v_base_bfm#(
      .seq_item_in_t (seq_item_in_t),
      .seq_item_out_t(seq_item_out_t),
      .sequencer_t   (sequencer_t),
      .cfg_obj_t     (cfg_obj_t),
      .seq_t         (seq_t),
      .model_t       (model_t)
  ))

  function new (string name = "riscv_v_base_bfm", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

endclass: riscv_v_base_bfm

`endif //__RISCV_V_BASE_BFM_SV__