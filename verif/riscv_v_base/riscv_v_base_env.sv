//File: riscv_v_base_env.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base environment

`ifndef __RISCV_V_BASE_ENV__
`define __RISCV_V_BASE_ENV__

virtual class riscv_v_base_env#( type agent_t = riscv_v_base_agt,
                                 type scbd_t  = riscv_v_base_scbd) extends uvm_env;
    `uvm_component_param_utils(riscv_v_base_env#(
        .agent_t (agent_t),
        .scbd_t  (scbd_t)
    ));

    agent_t agt;
    scbd_t  scbd;

    //Constructor
    function new(string name = "riscv_v_base_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        build_components();
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        connect_components();
    endfunction: connect_phase

    virtual function void build_components();
        agt  = agent_t::type_id::create("agent", this);
        scbd = scbd_t::type_id::create("scbd", this);
    endfunction: build_components

    virtual function void connect_components();
        agt.mon.rtl_in_ap.connect(scbd.rtl_in_af.analysis_export);
        agt.mon.rtl_out_ap.connect(scbd.rtl_out_af.analysis_export);
    endfunction: connect_components

endclass: riscv_v_base_env

`endif //__RISCV_V_BASE_ENV
