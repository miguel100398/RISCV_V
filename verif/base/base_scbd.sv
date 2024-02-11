//File: base_scbd.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base Scoreboard

`ifndef __BASE_SCBD__
`define __BASE_SCBD__

virtual class base_scbd#( type seq_item_in_t  = base_seq_item,
                          type seq_item_out_t = seq_item_in_t,
                          type model_t        = base_model          ) extends base_subscriber_2ports#(
                                                                                                                        .seq_item_in_t(seq_item_in_t),
                                                                                                                        .seq_item_out_t(seq_item_out_t));
                                  
    `uvm_component_param_utils(base_scbd#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t),
        .model_t(base_model)));

    //Number of analyzed vectors
    int num_vectors = 0;
    //Number of pass vectors
    int num_pass = 0;
    //Number of fail vectors
    int num_fail = 0;

    //Stop simulation when error is detected
    int stop_at_error = 1;

    //Model to predict Results
    model_t model;

    //Constructor
    function new(string name = "base_scbd", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        model = model_t::type_id::create({get_name(), "_model"}, this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        model.rst();
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
        if (stop_at_error) begin
            $stop();
        end
    endfunction: fail

    virtual function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        if (num_fail == 0) begin
            `uvm_info(get_name(), $sformatf("0 errors found in %s ScoreBoard, num_vectors: %0d, num_pass: %0d, num_fail: %0d", get_name(), num_vectors, num_pass, num_fail), UVM_NONE);
        end else begin
            `uvm_error(get_name(), $sformatf("Errors found in %s ScoreBoard, num_vectors: %0d, num_pass: %0d, num_fail: %0d", get_name(), num_vectors, num_pass, num_fail));
        end
    endfunction: check_phase

    pure virtual function void calc_in();
    pure virtual function void calc_out();
    

endclass: base_scbd


`endif //__BASE_SCBD__