//File: riscv_v_base_agt.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base Agent

`ifndef __RISCV_V_BASE_AGT__
`define __RISCV_V_BASE_AGT__

virtual class riscv_v_base_agt #(   type seq_item_in_t  = riscv_v_base_seq_item,
                                    type seq_item_out_t = seq_item_in_t,
                                    type driver_p       = riscv_v_base_drv#(
                                                                   .seq_item_t (seq_item_in_t)),
                                    type monitor_p      = riscv_v_base_mon#(
                                                                   .seq_item_in_t   (seq_item_in_t), 
                                                                   .seq_item_out_t  (seq_item_out_t)),
                                    type sequencer_p    = riscv_v_base_sqr#(
                                                                   .seq_item_t      (seq_item_in_t))) extends uvm_agent;
                                                                   
    `uvm_component_param_utils(riscv_v_base_agt#(
        .seq_item_in_t  (seq_item_in_t),
        .seq_item_out_t (seq_item_out_t),
        .driver_t       (driver_t),
        .monitor_t      (monitor_t),
        .sequencer_t     (sequencer_t)
    ));

    //VIVADO workaround
    typedef driver_p driver_t;
    typedef monitor_p monitor_t;
    typedef sequencer_p sequencer_t;

    //Agent components
    driver_t    drv;
    monitor_t   mon;
    sequencer_t sqr;
    
    //Constructor
    function new(string name = "riscv_v_base_agt", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    //Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (get_is_active == UVM_ACTIVE) begin
            build_active_components();
        end

        build_passive_components();

    endfunction: build_phase

    //Connect phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active() == UVM_ACTIVE) begin
            connect_active_components();
        end
        connect_passive_components();
    endfunction: connect_phase

    virtual function void build_active_components();
        drv = driver_t::type_id::create("driver", this);
        sqr = sequencer_t::type_id::create("sequencer", this);
    endfunction: build_active_components

    virtual function void build_passive_components();
        mon = monitor_t::type_id::create("monitor", this);
    endfunction: build_passive_components

    virtual function void connect_active_components();
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction: connect_active_components

    virtual function void connect_passive_components();
        return;
    endfunction: connect_passive_components

endclass: riscv_v_base_agt


`endif //__RISCV_V_BASE_AGT__