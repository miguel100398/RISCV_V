//File: riscv_rf_trk.sv
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V RF tracker

`ifndef __RISCV_RF_TRK__
`define __RISCV_RF_TRK__

class riscv_rf_trk extends riscv_v_base_trk#(
                                                .seq_item_in_t(riscv_rf_wr_seq_item),
                                                .seq_item_out_t(riscv_rf_rd_seq_item),
                                                .file_name("riscv_rf_trk.txt")
);

    `uvm_component_utils(riscv_rf_trk)

    riscv_rf_trk_item txn;

    int time_size  = 25;
    int addr_size  = 10;
    int rd_wr_size = 10;
    int port_size  = 20;
    int wr_en_size = 15;
    int data_size  = 40;

    int header_size = time_size + addr_size + rd_wr_size + port_size + wr_en_size + data_size + 5;

    function new (string name = "riscv_rf_trk", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        txn = new();
    endfunction: build_phase

    virtual function void trk_in();
        txn.addr  = txn_in.addr;
        txn.wr    = 1'b1;
        txn.port  = RF_WR_PORT;
        txn.wr_en = txn_in.wr_en;
        txn.data  = txn_in.data; 
        print_data();
    endfunction: trk_in

    virtual function void trk_out();
        txn.addr  = txn_out.addr;
        txn.wr    = 1'b0;
        txn.port  = txn_out.port;
        txn.wr_en = 'x;
        txn.data  = txn_out.data;
        print_data();
    endfunction: trk_out

    virtual function void print_header();
        string print;
        string footer;

        print = concat_field(print, "           Time", time_size, 1, 1);
        print = concat_field(print, " Addr",           addr_size, 0, 1);
        print = concat_field(print, " RD/WR",          rd_wr_size, 0, 1);
        print = concat_field(print, " Port",           port_size, 0, 1);
        print = concat_field(print, " wr_en",          wr_en_size, 0, 1);
        print = concat_field(print, " data",           data_size, 0, 1);
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
        string RD_or_WR = (txn.wr) ? "WR" :  "RD";

        print = concat_field(print, $sformatf(" %t", $time),            time_size,  1, 1);
        print = concat_field(print, $sformatf(" 0x%0h", txn.addr),      addr_size,  0, 1);
        print = concat_field(print, $sformatf(" %s", RD_or_WR),         rd_wr_size, 0, 1);
        print = concat_field(print, $sformatf(" %s", txn.port.name()),  port_size,  0, 1);
        print = concat_field(print, $sformatf(" 0x%0h", txn.wr_en),     wr_en_size, 0, 1);
        print = concat_field(print, $sformatf(" 0x%0h", txn.data),      data_size,  0, 1);

        print = {print, "\n"};

        $fwrite(file, print);
    endfunction: print_data


endclass: riscv_rf_trk

`endif //__RISCV_RF_TRK__