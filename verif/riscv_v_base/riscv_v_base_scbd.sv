//File: riscv_v_base_scbd.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base Scoreboard

`ifndef __RISCV_V_BASE_SCBD__
`define __RISCV_V_BASE_SCBD__

virtual class riscv_v_base_scbd#( type seq_item_in_t  = riscv_v_base_seq_item,
                                  type seq_item_out_t = seq_item_in_t          ) extends uvm_scoreboard;
    `uvm_component_utils(riscv_v_base_scbd#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t)));

    uvm_tlm_analysis_fifo#(seq_item_in_t)  rtl_in_af;
    uvm_tlm_analysis_fifo#(seq_item_out_t) rtl_out_af;

    seq_item_in_t in_txn;
    seq_item_out_t out_txn;

    //Number of analyzed vectors
    int num_vectors = 0;
    //Number of pass vectors
    int num_pass = 0;
    //Number of fail vectors
    int num_fail = 0;

    //Constructor
    function new(string name = "riscv_v_base_scbd", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Build ports
        build_ports();
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        fork
            begin : fork_scbd_in
                forever begin
                    rtl_in_af.get(in_txn);
                    calc_in(in_txn);
                end
            end 
            begin : fork_scbd_out 
                forever begin
                    rtl_out_af.get(out_txn);
                    calc_out(out_txn);
                end
            end
        join_none
    endtask: run_phase

    virtual function void build_ports();
        rtl_in_af  = new("rtl_in_af", this);
        rtl_out_af = new("rtl_out_af", this);
    endfunction: build_ports

    pure virtual function void calc_in(seq_item_in_t txn);
    pure virtual function void calc_out(seq_item_out_t txn);
    

    virtual function void pass();
        num_vectors++;
        num_pass++;
    endfunction: pass

    virtual function void fail();
        num_vectors++;
        num_fail++;
    endfunction: fail

    virtual function void check_phase(uvm_phase phase);
        if (num_fail == 0) begin
            `uvm_info("RF_SCBD", $sformatf("0 errors found in RF ScoreBoard, num_vectors: %0d, num_pass: %0d, num_fail: %0d", num_vectors, num_pass, num_fail), UVM_NONE);
        end else begin
            `uvm_error("RF_SCBD", $sformatf("Errors found in RF ScoreBoard, num_vectors: %0d, num_pass: %0d, num_fail: %0d", num_vectors, num_pass, num_fail));
        end
    endfunction: check_phase


endclass: riscv_v_base_scbd


`endif //__RISCV_V_BASE_SCBD__