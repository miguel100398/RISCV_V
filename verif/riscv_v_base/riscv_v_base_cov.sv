//File: riscv_v_base_cov.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector Base Coverage

`ifndef __RISCV_V_BASE_COV_SV__
`define __RISCV_V_BASE_COV_SV__ 

virtual class riscv_v_base_cov#( type seq_item_in_t  = riscv_v_base_seq_item,
                                 type seq_item_out_t = seq_item_in_t          ) extends riscv_v_base_subscriber_2ports#(
                                                                                                                        .seq_item_in_t(seq_item_in_t),
                                                                                                                        .seq_item_out_t(seq_item_out_t));

    `uvm_component_param_utils(riscv_v_base_cov#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t)));

    function new (string name = "riscv_v_base_cov", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual function void port_in_handler();
        cov_in();
    endfunction: port_in_handler

    virtual function void port_out_handler();
        cov_out();
    endfunction: port_out_handler

    pure virtual function void cov_in();
    pure virtual function void cov_out();

endclass: riscv_v_base_cov


`endif // __RISCV_V_BASE_COV_SV__