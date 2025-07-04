//File: riscv_v_trk.sv
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V RF tracker

`ifndef __RISCV_V_TRK__
`define __RISCV_V_TRK__

class riscv_v_trk extends riscv_v_base_trk#(
                                                .seq_item_in_t(riscv_v_in_seq_item),
                                                .seq_item_out_t(riscv_v_out_seq_item),
                                                .file_name("riscv_v_trk.txt")
);

    `uvm_component_utils(riscv_v_trk)

    riscv_v_trk_item txn;

    int time_size         = 25;
    int header_size = time_size + 0;

    

    function new (string name = "riscv_v_trk", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        txn = new();
    endfunction: build_phase

    virtual function void trk_in();
        return;
    endfunction: trk_in

    virtual function void trk_out();

        print_data();
    endfunction: trk_out

    virtual function void print_header();
        string print;
        string footer;

        print = concat_field(print, "           Time", time_size,        1, 1);

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

        print = concat_field(print, $sformatf(" %t", $time),                   time_size,         1, 1);

        print = {print, "\n"};

        $fwrite(file, print);
    endfunction: print_data


endclass: riscv_v_trk

`endif //__RISCV_V_TRK__