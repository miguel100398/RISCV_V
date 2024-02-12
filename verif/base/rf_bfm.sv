//File: rf_bfm.sv
//Author: Miguel Bucio
//Date: 21/01/24
//Description: RF BFM

`ifndef __RF_BFM_SV__
`define __RF_BFM_SV__ 

virtual class rf_bfm#(
    type model_t        = rf_model,
    type seq_item_in_t  = base_seq_item,
    type seq_item_out_t = base_seq_item,
    type sequencer_t    = base_sqr#(
                                    .seq_item_t(seq_item_in_t)),
    type cfg_obj_t      = base_bfm_cfg_obj,
    type seq_t          = base_seq  
) extends base_bfm #(
    .seq_item_in_t(seq_item_in_t),
    .seq_item_out_t(seq_item_out_t),
    .sequencer_t(sequencer_t),
    .cfg_obj_t(cfg_obj_t),
    .seq_t(seq_t),
    .model_t(model_t)
);

    localparam NUM_RD_PORTS = 2;
    int num_reads = 0;

    `uvm_component_param_utils(rf_bfm#(
        .model_t(model_t),
        .seq_item_in_t(seq_item_in_t),
        .seq_item_out_t(seq_item_out_t),
        .sequencer_t(sequencer_t),
        .cfg_obj_t(cfg_obj_t),
        .seq_t(seq_t)
    ));

    model_t rf;

    function new (string name = "rf_bfm", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        rf = model;
    endfunction: build_phase

    virtual function void port_in_handler();

        //Update Functions
        $display("here1");
        update_wr_rf();

        //update_bfm_sem.put(update_bfm_sem_keys);
    endfunction: port_in_handler

    virtual function void port_out_handler();
        //Update  functions
        $display("here2");
        update_rd_rf();
        num_reads++;
        if (num_reads == NUM_RD_PORTS) begin
            num_reads = 0;
            update_bfm_sem.put(update_bfm_sem_keys);
        end
    endfunction: port_out_handler

    virtual function void rst_bfm();
        rf.rst();
    endfunction: rst_bfm

    pure virtual function void update_wr_rf();
    pure virtual function void update_rd_rf();
    pure virtual function void rst_seq();
    pure virtual function void bfm_seq();

endclass: rf_bfm

`endif //__RF_BFM_SV__ 