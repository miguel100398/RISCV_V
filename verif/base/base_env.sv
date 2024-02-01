//File: base_env.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base environment

`ifndef __BASE_ENV__
`define __BASE_ENV__

virtual class base_env#( type agent_t = base_agt,
                         type scbd_t  = base_scbd,
                         type cov_t   = base_cov  ) extends uvm_env;
    `uvm_component_param_utils(base_env#(
        .agent_t (agent_t),
        .scbd_t  (scbd_t),
        .cov_t   (cov_t)
    ));

    agent_t agt;
    scbd_t  scbd;
    cov_t   cov;

    //Constructor
    function new(string name = "base_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), $sformatf("%s: build", get_name()), UVM_NONE)
        build_components();
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_name(), $sformatf("%s: connect", get_name()), UVM_NONE)
        connect_components();
    endfunction: connect_phase

    virtual function void build_components();
        agt  = agent_t::type_id::create({get_name(), "_agent"}, this);
        cov  = cov_t::type_id::create({get_name(), "_cov"}, this);
        build_scbd();
    endfunction: build_components

    virtual function void build_scbd();
        scbd = scbd_t::type_id::create({get_name(), "_scbd"}, this);
    endfunction: build_scbd

    virtual function void connect_components();
        //SCBD
        connect_scbd();
        //COV
        agt.mon.rtl_in_ap.connect(cov.analysis_imp_in);
        agt.mon.rtl_out_ap.connect(cov.analysis_imp_out);
    endfunction: connect_components

    virtual function void connect_scbd();
        agt.mon.rtl_in_ap.connect(scbd.analysis_imp_in);
        agt.mon.rtl_out_ap.connect(scbd.analysis_imp_out);
    endfunction: connect_scbd

endclass: base_env

`endif //__BASE_ENV
