//File: riscv_v_base_cov.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector Base Coverage

`ifndef __RISCV_V_BASE_COV_SV__
`define __RISCV_V_BASE_COV_SV__ 

virtual class riscv_v_base_cov#( type seq_item_in_t  = riscv_v_base_seq_item,
                         type seq_item_out_t = seq_item_in_t          ) extends uvm_component;

    `uvm_component_param_utils(riscv_v_base_cov#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t)));

    typedef riscv_v_base_trk#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t)) this_type_t;

    `uvm_analysis_imp_decl(_port_in)
    `uvm_analysis_imp_decl(_port_out)

    uvm_analysis_imp_port_in  #(seq_item_in_t,  this_type_t) analysis_imp_in;  
    uvm_analysis_imp_port_out #(seq_item_out_t, this_type_t) analysis_imp_out;

    seq_item_in_t txn_in;
    seq_item_in_t txn_out;

    function new (string name = "riscv_v_base_cov", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        analysis_imp_in  = new({get_name(), "_rtl_in_aimp"}, this);
        analysis_imp_out = new({get_name(), "_rtl_out_aimp"}, this);
    endfunction: build_phase

    virtual function void write_port_in(seq_item_in_t txn);
        txn_in = txn;
        cov_in();
    endfunction: write_port_in

    virtual function void write_port_out(seq_item_out_t txn);
        txn_out = txn;
        cov_out();
    endfunction: write_port_out

    pure virtual function void cov_in();
    pure virtual function void cov_out();

endclass: riscv_v_base_cov


`endif // __RISCV_V_BASE_COV_SV__