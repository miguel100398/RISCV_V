//File: riscv_v_base_cov.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector Base Coverage

`ifndef __RISCV_V_BASE_COV_SV__
`define __RISCV_V_BASE_COV_SV__ 

virtual class riscv_v_base_cov#( type seq_item_in_t  = riscv_v_base_seq_item,
                                 type seq_item_out_t = seq_item_in_t          ) extends base_cov#(
                                                                                                .seq_item_in_t(seq_item_in_t),
                                                                                                .seq_item_out_t(seq_item_out_t));

    `uvm_component_param_utils(riscv_v_base_cov#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t)));

    function new (string name = "riscv_v_base_cov", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    

endclass: riscv_v_base_cov


`endif // __RISCV_V_BASE_COV_SV__