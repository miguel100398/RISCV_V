//File: riscv_v_base_drv.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base driver

`ifndef __RISCV_V_BASE_DRV__
`define __RISCV_V_BASE_DRV__

virtual class riscv_v_base_drv#(type seq_item_t = riscv_v_base_seq_item)  extends uvm_driver#(seq_item_t);
    `uvm_component_utils(riscv_v_base_drv#(
        .seq_item_t(seq_item_t)));
    
    //Constructor
    function new(string name = "riscv_v_base_drv", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
                    
    //Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Get vif
        get_vif();
    endfunction: build_phase

    //Run phase
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive();
            seq_item_port.item_done();
        end
    endtask: run_phase

    //Drive stimulus
    pure virtual task drive();
    

    //Get interface
    pure virtual function void get_vif();


endclass: riscv_v_base_drv

`endif //__RISCV_V_BASE_DRV__