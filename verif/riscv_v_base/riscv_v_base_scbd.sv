//File: riscv_v_base_scbd.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base Scoreboard

`ifndef __RISCV_V_BASE_SCBD__
`define __RISCV_V_BASE_SCBD__

virtual class riscv_v_base_scbd#( type seq_item_in_t  = riscv_v_base_seq_item,
                                  type seq_item_out_t = seq_item_in_t          ) extends uvm_scoreboard;
    `uvm_component_param_utils(riscv_v_base_scbd#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t)));

    typedef riscv_v_base_scbd#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t)) this_type_t;
    
    `uvm_analysis_imp_decl(_port_in)
    `uvm_analysis_imp_decl(_port_out)

    uvm_analysis_imp_port_in  #(seq_item_in_t,  this_type_t) analysis_imp_in;  
    uvm_analysis_imp_port_out #(seq_item_out_t, this_type_t) analysis_imp_out; 

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
        super.run_phase(phase);
    endtask: run_phase

    virtual function void build_ports();
        analysis_imp_in  = new({get_name(), "_imp_in"}, this);
        analysis_imp_out = new({get_name(), "_imp_out"}, this);
    endfunction: build_ports

    virtual function void write_port_in(seq_item_in_t txn);
        calc_in(txn);
    endfunction: write_port_in

    virtual function void write_port_out(seq_item_out_t txn);
        calc_out(txn);
    endfunction: write_port_out

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
        super.check_phase(phase);
        if (num_fail == 0) begin
            `uvm_info("RF_SCBD", $sformatf("0 errors found in RF ScoreBoard, num_vectors: %0d, num_pass: %0d, num_fail: %0d", num_vectors, num_pass, num_fail), UVM_NONE);
        end else begin
            `uvm_error("RF_SCBD", $sformatf("Errors found in RF ScoreBoard, num_vectors: %0d, num_pass: %0d, num_fail: %0d", num_vectors, num_pass, num_fail));
        end
    endfunction: check_phase


endclass: riscv_v_base_scbd


`endif //__RISCV_V_BASE_SCBD__