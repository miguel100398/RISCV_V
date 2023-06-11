//File: riscv_v_base_scbd.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base Scoreboard

`ifndef __RISCV_V_BASE_SCBD__
`define __RISCV_V_BASE_SCBD__

virtual class riscv_v_base_scbd#( type seq_item_in_t  = riscv_v_base_seq_item,
                                  type seq_item_out_t = seq_item_in_t          ) extends riscv_v_base_subscriber_2ports#(
                                                                                                                        .seq_item_in_t(seq_item_in_t),
                                                                                                                        .seq_item_out_t(seq_item_out_t));
                                  
    `uvm_component_param_utils(riscv_v_base_scbd#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t)));

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
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask: run_phase

    virtual function void port_in_handler();
        calc_in();
    endfunction: port_in_handler

    virtual function void port_out_handler();
        calc_out();
    endfunction: port_out_handler

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

    pure virtual function void calc_in();
    pure virtual function void calc_out();
    

endclass: riscv_v_base_scbd


`endif //__RISCV_V_BASE_SCBD__