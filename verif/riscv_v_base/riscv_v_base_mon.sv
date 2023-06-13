//File: riscv_v_base_mon.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base Monitor

`ifndef __RISCV_V_BASE_MON__
`define __RISCV_V_BASE_MON___

virtual class riscv_v_base_mon#(type seq_item_in_t          = riscv_v_base_seq_item,
                                type seq_item_out_t         = seq_item_in_t) extends uvm_monitor;
    `uvm_component_param_utils(riscv_v_base_mon#(
        .seq_item_in_t  (seq_item_in_t),
        .seq_item_out_t (seq_item_out_t)));

    //Analysis port
    //Input ports
    uvm_analysis_port #(seq_item_in_t)  rtl_in_ap;
    uvm_analysis_port #(seq_item_out_t) rtl_out_ap;

    //Constructor
    function new(string name = "riscv_v_base_mon", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    //Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), $sformatf("%s: build", get_name()), UVM_NONE)
        //Get vif
        get_vif();
        //Build ports
        build_ports();
    endfunction: build_phase
 
    //Connect phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction: connect_phase

    //run phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            begin : fork_monitor_rtl_out
                forever begin
                    mon_rtl_out();
                end
            end 
            begin : fork_monitor_rtl_in 
                forever begin
                    mon_rtl_in();
                end
            end
        join_none
    endtask: run_phase

    //Build ports
    virtual function void build_ports();
        rtl_out_ap = new({get_name(), "_rtl_out_ap"}, this);
        rtl_in_ap  = new({get_name(), "_rtl_in_ap"}, this);
    endfunction: build_ports
    //Monitor rtl in
    pure virtual task mon_rtl_in();
    //Monitoor rtl out
    pure virtual task mon_rtl_out();
    //Get interface
    pure virtual function void get_vif();

endclass: riscv_v_base_mon 

`endif //__RISCV_V_BASE_MON__