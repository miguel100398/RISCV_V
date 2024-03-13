//File: riscv_v_base_trk.sv
//Author: Miguel Bucio
//Date: 10/06/23
//Description: RISC-V Vector Base Tracker

`ifndef __RISCV_V_BASE_TRK__
`define __RISCV_V_BASE_TRK__

virtual class riscv_v_base_trk #(type seq_item_in_t  = riscv_v_base_seq_item,
                                 type seq_item_out_t = seq_item_in_t,          
                                 string file_name    = "")              extends base_trk#(
                                                                                                                .seq_item_in_t(seq_item_in_t),
                                                                                                                .seq_item_out_t(seq_item_out_t),
                                                                                                                .file_name(file_name));

    `uvm_component_param_utils(riscv_v_base_trk#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t),
        .file_name(file_name)))

    //Constructor
    function new (string name = "riscv_v_base_trk", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

endclass: riscv_v_base_trk

`endif //__RISCV_V_BASE_TRK__