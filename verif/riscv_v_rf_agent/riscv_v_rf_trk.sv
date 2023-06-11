//File: riscv_v_rf_trk.sv
//Author: Miguel Bucio
//Date: 10/06/23
//Description: RISC-V Vector RF tracker

`ifndef __RISCV_V_RF_TRK__
`define __RISCV_V_RF_TRK__

class riscv_v_rf_trk extends riscv_v_base_trk#(
                                                .seq_item_in_t(riscv_v_rf_wr_seq_item),
                                                .seq_item_out_t(riscv_v_rf_rd_seq_item),
                                                .file_name("rf_trk.txt")
);

    `uvm_component_utils(riscv_v_rf_trk)

    riscv_v_rf_trk_item txn;

    function new (string name = "riscv_v_rf_trk", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        txn = new();
    endfunction: build_phase

    virtual function void trk_in();
        txn.addr  = in_txn.addr;
        txn.wr    = 1'b1;
        txn.port  = RF_WR_PORT;
        txn.wr_en = in_txn.wr_en;
        txn.data  = in_txn.data; 
        print_data();
    endfunction: trk_in

    virtual function void trk_out();
        txn.addr  = out_txn.addr;
        txn.wr    = 1'b0;
        txn.port  = out_txn.port;
        txn.wr_en = 'x;
        txn.data  = out_txn.data;
        print_data();
    endfunction: trk_out

    virtual function void print_header();
        string print;
        print = $sformatf("| \t\tTime\t\t|");
        print = {print, $sformatf(" Addr\t\t|")};
        print = {print, $sformatf(" RD/WR\t\t|")};
        print = {print, $sformatf(" Port\t\t\t|")};
        print = {print, $sformatf(" wr_en\t\t\t|")};
        print = {print, $sformatf(" data\t\t\t\t\t\t|\n")};
        print = {print, "|"};
        repeat(159) begin
            print = {print, "_"};
        end
        print = {print, "|\n"};
        $fwrite(file, print);
    endfunction: print_header

    virtual function void print_data();
        string print;
        string RD_or_WR = (txn.wr) ? "WR" :  "RD";
        print = $sformatf("| %t\t\t|", $time);
        print = {print, $sformatf(" 0x%0h\t\t|", txn.addr)};
        print = {print, $sformatf(" %s\t\t|", RD_or_WR)};
        print = {print, $sformatf(" %s\t\t|", txn.port.name())};
        print = {print, $sformatf(" 0x%0h\t\t|", txn.wr_en)};
        print = {print, $sformatf(" 0x%0h\t\t|\n", txn.data)};
        $fwrite(file, print);
    endfunction: print_data


endclass: riscv_v_rf_trk

`endif //__RISCV_V_RF_TRK__