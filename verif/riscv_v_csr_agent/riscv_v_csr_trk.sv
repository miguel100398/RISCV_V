//File: riscv_v_csr_trk.sv
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISCV-V CSR Tracker

`ifndef __RISCV_V_CSR_TRK__
`define __RISCV_V_CSR_TRK__ 

class riscv_v_csr_trk extends riscv_v_base_trk#(
    .seq_item_in_t(riscv_v_csr_in_seq_item),
    .seq_item_out_t(riscv_v_csr_out_seq_item),
    .file_name("riscv_v_csr_trk.txt")
);

    `uvm_component_utils(riscv_v_csr_trk)

    riscv_v_csr_trk_item txn;

    int time_size = 25;
    int csr_write_en_size = 25;
    int csr_data_size = 25;

    int header_size = time_size + csr_write_en_size + csr_data_size + 2;

    string csr_written;
    logic[31:0] csr_data;

    function new(string name = "riscv_v_csr_trk", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        txn = new();
    endfunction: build_phase

    virtual function void trk_in();
        txn.vsstatus_data_in = txn_in.vsstatus_data_in;
        txn.vsstatus_wr_en = txn_in.vsstatus_wr_en;
        txn.vtype_data_in = txn_in.vtype_data_in;
        txn.vtype_wr_en = txn_in.vtype_wr_en;
        txn.vl_data_in = txn_in.vl_data_in;
        txn.vl_wr_en = txn_in.vl_wr_en;
        txn.vstart_data_in = txn_in.vstart_data_in;
        txn.vstart_wr_en = txn_in.vstart_wr_en;
        txn.vxrm_data_in = txn_in.vxrm_data_in;
        txn.vxrm_wr_en = txn_in.vxrm_wr_en;
        txn.vxsat_data_in = txn_in.vxsat_data_in;
        txn.vxsat_wr_en = txn_in.vxsat_wr_en;

        if (txn.vsstatus_wr_en) begin
            csr_written = "vsstatus";
            csr_data = txn.vsstatus_data_in;
            print_data();
        end

        if (txn.vtype_wr_en) begin
            csr_written = "vtyype";
            csr_data = txn.vtype_data_in;
            print_data();
        end

        if (txn.vl_wr_en) begin
            csr_written = "vl";
            csr_data = txn.vl_data_in;
            print_data();
        end

        if (txn.vstart_wr_en) begin
            csr_written = "vstart";
            csr_data = txn.vstart_data_in;
            print_data();
        end

        if (txn.vxrm_wr_en) begin
            csr_written = "vxrm";
            csr_data = txn.vxrm_data_in;
            print_data();
        end

        if (txn.vxsat_wr_en) begin
            csr_written = "vxsat";
            csr_data = txn.vxsat_data_in;
            print_data();
        end

    endfunction: trk_in  

    virtual function void trk_out();
        //Nothing to do here
        return;
    endfunction: trk_out 

    virtual function void print_header();
        string print;
        string footer;

        print = concat_field(print, "           Time", time_size, 1, 1);
        print = concat_field(print, " CSR Written",           csr_write_en_size, 0, 1);
        print = concat_field(print, " CSR Data",           csr_data_size, 0, 1);
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
        
        print = concat_field(print, $sformatf(" %t", $time),            time_size,  1, 1);
        print = concat_field(print, $sformatf(" %s", csr_written),      csr_write_en_size,  0, 1);
        print = concat_field(print, $sformatf(" 0x%0h", csr_data),         csr_data_size, 0, 1);

        print = {print, "\n"};

        $fwrite(file, print);

    endfunction: print_data 



endclass: riscv_v_csr_trk


`endif //__RISCV_V_CSR_TRK__