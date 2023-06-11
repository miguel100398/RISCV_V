//File: riscv_v_base_trk.sv
//Author: Miguel Bucio
//Date: 10/06/23
//Description: RISC-V Vector Base Tracker

`ifndef __RISCV_V_BASE_TRK__
`define __RISCV_V_BASE_TRK__

virtual class riscv_v_base_trk #(type seq_item_in_t  = riscv_v_base_seq_item,
                                 type seq_item_out_t = seq_item_in_t,          
                                 string file_name    = "")              extends riscv_v_base_subscriber_2ports#(
                                                                                                                .seq_item_in_t(seq_item_in_t),
                                                                                                                .seq_item_out_t(seq_item_out_t));

    `uvm_component_param_utils(riscv_v_base_trk#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t),
        .file_name(file_name)));

    integer file;

    //Constructor
    function new (string name = "riscv_v_base_trk", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        open_file();
        print_header();
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask: run_phase

    function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        close_file();
    endfunction: check_phase

    virtual function void port_in_handler();
        trk_in();
    endfunction: port_in_handler

    virtual function void port_out_handler();
        trk_out();
    endfunction: port_out_handler

    virtual function string print_field(string message, int size, bit left_delimiter = 0, bit right_delimiter = 0);
        string print = "";
        
        if (left_delimiter) begin
            print = "|";    
        end
        
        print = {print, message};

        repeat(size - message.len()) begin
            print = {print, " "};
        end

        if (right_delimiter) begin
            print = {print, "|"};    
        end

        return print;
    endfunction: print_field

    virtual function string concat_field(string concat, string message, int size, bit left_delimiter = 0, bit right_delimiter = 0);
        string print = concat;
        return {print, print_field(message, size, left_delimiter, right_delimiter)};
    endfunction: concat_field

    virtual function void open_file();
        file = $fopen(file_name);
    endfunction: open_file

    virtual function void close_file();
        $fclose(file);
    endfunction: close_file

    pure virtual function void trk_in();
    pure virtual function void trk_out();
    pure virtual function void print_header();
    pure virtual function void print_data();

endclass: riscv_v_base_trk

`endif //__RISCV_V_BASE_TRK__