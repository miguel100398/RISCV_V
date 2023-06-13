//File: riscv_v_alu_trk.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector ALU Tracker

`ifndef __RISCV_V_ALU_TRK_SV__
`define __RISCV_V_ALU_TRK_SV__ 

class riscv_v_alu_trk extends riscv_v_base_trk#(
                                                 .seq_item_in_t(riscv_v_alu_in_seq_item),
                                                 .seq_item_out_t(riscv_v_alu_out_seq_item), 
                                                 .file_name("alu_trk.txt"));
    `uvm_component_utils(riscv_v_alu_trk)

    localparam print_sem_get = 2;
    localparam print_sem_put = 1;
    semaphore print_sem;

    int time_size   = 25;
    int alu_size    = 15;
    int opcode_size = 25;
    int osize_size  = 20;
    int src_size    = 50;
    int result_size = 50;

    int header_size = time_size + alu_size + opcode_size + osize_size + src_size + src_size + result_size + 6;
    

    function new(string name = "riscv_v_alu_trk", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        print_sem = new(0);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            forever begin
                //Wait for both transactions to be captured to print data
                print_sem.get(print_sem_get);
                print_data();
            end
        join_none
    endtask: run_phase

    virtual function void trk_in();
        print_sem.put(print_sem_put);
    endfunction: trk_in 

    virtual function void trk_out();
        print_sem.put(print_sem_put);
    endfunction: trk_out

    virtual function void print_header();
        string print;
        string footer;

        print = concat_field(print, "           Time", time_size,   1, 1);
        print = concat_field(print, " ALU",            alu_size,    0, 1);
        print = concat_field(print, " opcode",         opcode_size, 0, 1);
        print = concat_field(print, " osize",          osize_size,  0, 1);
        print = concat_field(print, " srca",           src_size,    0, 1);
        print = concat_field(print, " srcb",           src_size,    0, 1);
        print = concat_field(print, " result",         result_size, 0, 1);
        print = {print, "\n"};

        repeat(header_size) begin
            footer = {footer, "_"};
        end

        print = concat_field(print, footer, header_size, 1, 1);

        print = {print, "\n"};

        $fwrite(file, print);
    endfunction: print_header

    virtual function void print_data();
        string print;
        print = concat_field(print, $sformatf(" %t", $time),                     time_size,     1, 1);
        print = concat_field(print, $sformatf(" %s", txn_out.ALU.name()),        alu_size,      0, 1);
        print = concat_field(print, $sformatf(" %s", txn_in.opcode.name()),      opcode_size,   0, 1);
        print = concat_field(print, $sformatf(" %s", txn_in.osize.name()),       osize_size,    0, 1);
        print = concat_field(print, $sformatf(" 0x%0h", txn_in.srca),            src_size,      0, 1);
        print = concat_field(print, $sformatf(" 0x%0h", txn_in.srcb),            src_size,      0, 1);
        print = concat_field(print, $sformatf(" 0x%0h", txn_out.result),         result_size,   0, 1);

        print = {print, "\n"};

        $fwrite(file, print);
    endfunction: print_data

endclass: riscv_v_alu_trk

`endif // __RISCV_V_ALU_TRK_SV__