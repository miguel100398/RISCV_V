//File: base_drv.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base driver

`ifndef __BASE_DRV__
`define __BASE_DRV__

virtual class base_drv#(type seq_item_t = base_seq_item)  extends uvm_driver#(seq_item_t);
    `uvm_component_param_utils(base_drv#(
        .seq_item_t(seq_item_t)))

    string interface_name = "";
    bit    bfm_mode       = 1'b0;
    
    //Constructor
    function new(string name = "base_drv", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
                    
    //Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), $sformatf("%s: build", get_name()), UVM_NONE)

        check_interface_name();
        check_bfm_mode();
        
        //Get vif
        get_vif();
    endfunction: build_phase

    virtual function void check_interface_name();
        if (!(uvm_config_db #(string)::get(this, "", "interface_name", interface_name))) begin
            `uvm_fatal(get_name(), "interface_name configuration not found in uvm_db");
        end
    endfunction: check_interface_name

    virtual function void check_bfm_mode();
        if (!(uvm_config_db #(bit)::get(this, "", "bfm_mode", bfm_mode))) begin
            `uvm_fatal(get_name(), "bfm_mode configuration not found in uvm_db");
        end
    endfunction: check_bfm_mode

    //Run phase
    virtual task run_phase(uvm_phase phase);
        drive_initial();
        forever begin
            seq_item_port.get_next_item(req);
            drive();
            seq_item_port.item_done();
        end
    endtask: run_phase


    //Set reset status
    virtual task drive_initial();
        if (bfm_mode) begin
            drive_initial_bfm();
        end else begin
            drive_initial_agt();
        end
    endtask: drive_initial
    pure virtual task drive_initial_bfm();
    pure virtual task drive_initial_agt();

    //Drive stimulus
    virtual task drive();
        if (bfm_mode) begin
            drive_bfm();
        end else begin
            drive_agt();
        end
    endtask: drive
    pure virtual task drive_bfm();
    pure virtual task drive_agt();
    

    //Get interface
    pure virtual function void get_vif();


endclass: base_drv

`endif //__BASE_DRV__