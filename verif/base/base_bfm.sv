//File: base_bfm.sv
//Author: Miguel Bucio
//Date: 08/10/23
//Description: Base BFM

`ifndef __BASE_BFM_SV__
`define __BASE_BFM_SV__ 

virtual class base_bfm #( type seq_item_in_t  = base_seq_item,
                          type seq_item_out_t = base_seq_item,
                          type sequencer_t    = base_sqr#(
                                                            .seq_item_t(seq_item_in_t)),
                          type cfg_obj_t      = base_bfm_cfg_obj,
                          type seq_t          = base_seq#(
                                                            .seq_item_t(seq_item_in_t)),
                          type model_t        = base_model                                  
                          ) extends base_subscriber_2ports#(
                              .seq_item_in_t(seq_item_in_t),
                              .seq_item_out_t(seq_item_out_t)
);

`uvm_component_param_utils(base_bfm#(
    .seq_item_in_t (seq_item_in_t),
    .seq_item_out_t(seq_item_out_t),
    .sequencer_t   (sequencer_t),
    .cfg_obj_t     (cfg_obj_t),
    .seq_t         (seq_t),
    .model_t       (model_t)
))

localparam update_bfm_sem_keys = 1;

cfg_obj_t      cfg;
sequencer_t    sqr;
semaphore      update_bfm_sem;
seq_t          seq;

bit driving_rst = 0;

//Base configuration
bit get_cfg_from_db    = 1'b1;
bit use_custom_db_name = 1'b0;
string custom_db_name  = "";

model_t model;

function new(string name = "base_bfm", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), $sformatf("%s: build", get_name()), UVM_NONE)

    if (get_cfg_from_db) begin

        string db_name;
        if (use_custom_db_name) begin
            db_name = custom_db_name;
        end else begin
            db_name = {get_name(), "_cfg"};
        end

        if (!(uvm_config_db #(cfg_obj_t)::get(this, "", db_name, cfg))) begin
            `uvm_fatal(get_name(), $sformatf("configuration object not found in uvm_db with name %s", db_name));
        end

        if (!cfg.check_cfg()) begin
            `uvm_fatal(get_name(), $sformatf("Error in cfg configuration"));
        end
        
    end else begin
        cfg = cfg_obj_t::type_id::create({get_name(), "_cfg"});
    end

    seq   = seq_t::type_id::create("testeo");
    sqr   = sequencer_t::type_id::create({get_name(), "_sequencer"}, this);
    model = model_t::type_id::create({get_name(), "_model"}, this);
    update_bfm_sem = new(0);
endfunction: build_phase 

virtual function void start_bfm();
    cfg.bfm_en = 1'b1;
endfunction: start_bfm

virtual function void stop_bfm();
    cfg.bfm_en = 1'b0;
endfunction: stop_bfm

virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    wait(cfg.bfm_en);
    if (cfg.run_forever) begin
        drive_rst();
        forever begin
            wait(cfg.bfm_en);
            drive_bfm();
        end
    end else begin 
        phase.raise_objection(this);
        drive_rst();
        repeat(cfg.num_txn) begin
            wait(cfg.bfm_en);
            drive_bfm();
        end
        phase.drop_objection(this);
    end
endtask: run_phase

virtual task drive_rst();
    driving_rst = 1;
    rst_bfm();
    rst_seq();
    seq.start(sqr);
    driving_rst = 0;
endtask: drive_rst 

virtual task drive_bfm();

    update_bfm_sem.get(update_bfm_sem_keys);
    assert (seq.randomize()) else `uvm_fatal(get_name(), "Can't randomize sequence")
    bfm_seq();
    seq.start(sqr);

endtask: drive_bfm

virtual function void port_out_handler();
    //Nothing to do here, override this function if needed
    return;
endfunction: port_out_handler

pure virtual function void port_in_handler();
pure virtual function void rst_bfm();
pure virtual function void rst_seq();
pure virtual function void bfm_seq();

endclass: base_bfm

`endif //__BASE_BFM_SV__