//File: base_subscriber2.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector Base Subscriber with 2 ports

`ifndef __BASE_SUBSCRIBER_2PORTS_SV__
`define __BASE_SUBSCRIBER_2PORTS_SV__ 

virtual class base_subscriber_2ports #(type seq_item_in_t  = base_seq_item,
                                       type seq_item_out_t = seq_item_in_t          ) extends uvm_component;

    `uvm_component_param_utils(base_subscriber_2ports#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t)));

    typedef base_subscriber_2ports#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t)) this_type_t;

    `uvm_analysis_imp_decl(_port_in)
    `uvm_analysis_imp_decl(_port_out)

    uvm_analysis_imp_port_in  #(seq_item_in_t,  this_type_t) analysis_imp_in;  
    uvm_analysis_imp_port_out #(seq_item_out_t, this_type_t) analysis_imp_out;

    seq_item_in_t  txn_in;
    seq_item_out_t txn_out;

    function new (string name = "base_subscriber_2ports", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), $sformatf("%s: build", get_name()), UVM_NONE)
        build_ports();
    endfunction: build_phase

    virtual function void build_ports();
        analysis_imp_in  = new({get_name(), "_rtl_in_aimp"}, this);
        analysis_imp_out = new({get_name(), "_rtl_out_aimp"}, this);
    endfunction: build_ports

    virtual function void write_port_in(seq_item_in_t txn);
        txn_in = txn;
        port_in_handler();
    endfunction: write_port_in

    virtual function void write_port_out(seq_item_out_t txn);
        txn_out = txn;
        port_out_handler();
    endfunction: write_port_out

    pure virtual function void port_in_handler();
    pure virtual function void port_out_handler();

endclass: base_subscriber_2ports

`endif // __BASE_SUBSCRIBER_2PORTS_SV__