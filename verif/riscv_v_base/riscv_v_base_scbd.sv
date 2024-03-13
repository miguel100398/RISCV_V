//File: riscv_v_base_scbd.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base Scoreboard

`ifndef __RISCV_V_BASE_SCBD__
`define __RISCV_V_BASE_SCBD__

virtual class riscv_v_base_scbd#( type seq_item_in_t  = riscv_v_base_seq_item,
                                  type seq_item_out_t = seq_item_in_t,
                                  type model_t        = riscv_v_base_model          ) extends base_scbd#(
                                                                                                    .seq_item_in_t(seq_item_in_t),
                                                                                                    .seq_item_out_t(seq_item_out_t),
                                                                                                    .model_t(model_t));
                                  
    `uvm_component_param_utils(riscv_v_base_scbd#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t),
        .model_t(model_t)))

    //Constructor
    function new(string name = "riscv_v_base_scbd", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

endclass: riscv_v_base_scbd


`endif //__RISCV_V_BASE_SCBD__