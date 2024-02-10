//File: base_agt.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: Base Agent

`ifndef __BASE_AGT__
`define __BASE_AGT__

virtual class base_agt #(           type seq_item_in_t  = base_seq_item,
                                    type seq_item_out_t = seq_item_in_t,
                                    type driver_t       = base_drv#(
                                                                   .seq_item_t (seq_item_in_t)),
                                    type monitor_t      = base_mon#(
                                                                   .seq_item_in_t   (seq_item_in_t), 
                                                                   .seq_item_out_t  (seq_item_out_t)),
                                    type tracker_t      = base_trk#(
                                                                   .seq_item_in_t   (seq_item_in_t), 
                                                                   .seq_item_out_t  (seq_item_out_t),
                                                                   .file_name("base_trkr.txt")),
                                    type sequencer_t    = base_sqr#(
                                                                   .seq_item_t      (seq_item_in_t)),
                                    type bfm_t          = base_bfm#(
                                                                   .seq_item_in_t   (seq_item_in_t),
                                                                   .seq_item_out_t  (seq_item_out_t),
                                                                   .sequencer_t     (sequencer_t),
                                                                   .cfg_obj_t       (base_bfm_cfg_obj)
                                    )) extends uvm_agent;
                                                                   
    `uvm_component_param_utils(base_agt#(
        .seq_item_in_t  (seq_item_in_t),
        .seq_item_out_t (seq_item_out_t),
        .driver_t       (driver_t),
        .monitor_t      (monitor_t),
        .tracker_t      (tracker_t),
        .sequencer_t    (sequencer_t),
        .bfm_t          (bfm_t)
    ));

    //Agent components
    driver_t    drv;
    monitor_t   mon;
    sequencer_t sqr;
    tracker_t   trk;
    bfm_t       bfm;

    uvm_active_passive_enum is_active = UVM_ACTIVE;
    bit                     USE_BFM   = 1'b0;
    
    //Constructor
    function new(string name = "base_agt", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    //Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), $sformatf("%s: build", get_name()), UVM_NONE)

        if (!(uvm_config_db #(uvm_active_passive_enum)::get(this, "", "is_active", is_active))) begin
            `uvm_fatal(get_name(), "is_active configuration not found in uvm_db");
        end

        if (!(uvm_config_db #(bit)::get(this, "", "USE_BFM", USE_BFM))) begin
            USE_BFM = 1'b0;
            `uvm_warning(get_name(), "USE_BFM is not configured, default valuse is 1'b0")
        end
        
        if (is_active == UVM_ACTIVE) begin
            build_active_components();
        end

        build_passive_components();

    endfunction: build_phase

    //Connect phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_name(), $sformatf("%s: connect", get_name()), UVM_NONE)
        if (is_active == UVM_ACTIVE) begin
            connect_active_components();
        end
        connect_passive_components();
    endfunction: connect_phase

    virtual function void build_active_components();
        drv = driver_t::type_id::create({get_name(), "_driver"}, this);
        if (USE_BFM) begin
            bfm = bfm_t::type_id::create({get_name(), "_bfm"}, this);
        end else begin
            sqr = sequencer_t::type_id::create({get_name(), "_sequencer"}, this);
        end
    endfunction: build_active_components

    virtual function void build_passive_components();
        mon = monitor_t::type_id::create({get_name(), "_monitor"}, this);
        trk = tracker_t::type_id::create({get_name(), "_tracker"}, this);
    endfunction: build_passive_components

    virtual function void connect_active_components();
        if (USE_BFM) begin
            drv.seq_item_port.connect(bfm.sqr.seq_item_export);
            mon.rtl_out_ap.connect(bfm.analysis_imp_out);
        end else begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction: connect_active_components

    virtual function void connect_passive_components();
        mon.rtl_in_ap.connect(trk.analysis_imp_in);
        mon.rtl_out_ap.connect(trk.analysis_imp_out);
    endfunction: connect_passive_components

endclass: base_agt


`endif //__BASE_AGT__