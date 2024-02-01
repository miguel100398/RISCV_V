//File: riscv_v_base_mon.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base Monitor

`ifndef __RISCV_V_BASE_MON__
`define __RISCV_V_BASE_MON___

virtual class riscv_v_base_mon#(type seq_item_in_t          = riscv_v_base_seq_item,
                                type seq_item_out_t         = seq_item_in_t) extends base_mon#(
                                                                                                    .seq_item_in_t(seq_item_in_t),
                                                                                                    .seq_item_out_t(seq_item_out_t)
                                );

    `uvm_component_param_utils(riscv_v_base_mon#(
        .seq_item_in_t  (seq_item_in_t),
        .seq_item_out_t (seq_item_out_t)));

    //Constructor
    function new(string name = "riscv_v_base_mon", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

endclass: riscv_v_base_mon 

`endif //__RISCV_V_BASE_MON__