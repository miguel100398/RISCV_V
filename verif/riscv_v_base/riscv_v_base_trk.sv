//File: riscv_v_base_trk.sv
//Author: Miguel Bucio
//Date: 10/06/23
//Description: RISC-V Vector Base Tracker

`ifndef __RISCV_V_BASE_TRK__
`define __RISCV_V_BASE_TRK__

virtual class riscv_v_base_trk #(type seq_item_in_t  = riscv_v_base_seq_item,
                                 type seq_item_out_t = seq_item_in_t,          
                                 string file_name    = "")              extends uvm_component;

    `uvm_component_param_utils(riscv_v_base_trk#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t),
        .file_name(file_name)));


    uvm_tlm_analysis_fifo#(seq_item_in_t)  rtl_in_af;
    uvm_tlm_analysis_fifo#(seq_item_out_t) rtl_out_af;

    seq_item_in_t in_txn;
    seq_item_out_t out_txn;

    uvm_table_printer printer;
    integer file;

    //Constructor
    function new (string name = "riscv_v_base_trk", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        printer = new();
        build_ports();
        open_file();
        print_header();
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        fork
            begin : fork_trk_in
                forever begin
                    rtl_in_af.get(in_txn);
                    trk_in();
                end
            end 
            begin : fork_trk_out 
                forever begin
                    rtl_out_af.get(out_txn);
                    trk_out();
                end
            end
        join_none
    endtask: run_phase

    function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        close_file();
    endfunction: check_phase
    
    virtual function void build_ports();
        rtl_in_af  = new({get_name(), "_rtl_in_af"}, this);
        rtl_out_af = new({get_name(), "_rtl_out_af"}, this);
    endfunction: build_ports

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