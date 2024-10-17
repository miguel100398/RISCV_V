//File: riscv_v_rf_cov.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector RF Coverage

`ifndef __RISCV_V_RF_COV_SV__
`define __RISCV_V_RF_COV_SV__ 

class riscv_v_rf_cov extends riscv_v_base_cov#(
                                                .seq_item_in_t  (riscv_v_rf_wr_seq_item),
                                                .seq_item_out_t (riscv_v_rf_rd_seq_item));

    `uvm_component_utils(riscv_v_rf_cov)

    int num_wr_sampled = 0;
    int num_rd_sampled = 0;

    //Cover groups
    covergroup cg_wr_rf;
        option.per_instance = 1;
        option.name = "cg_wr_rf";
        //Wr address cover point
        cp_wr_addr : coverpoint  txn_in.addr {
            //1 bin per each value
            bins cb_wr_addr[] = {[0:$]};
        }
        //Wr en cover point
        cp_wr_en : coverpoint txn_in.wr_en{
            wildcard bins cb_wr_en0  = {16'b????_????_????_???1};
            wildcard bins cb_wr_en1  = {16'b????_????_????_??1?};
            wildcard bins cb_wr_en2  = {16'b????_????_????_?1??};
            wildcard bins cb_wr_en3  = {16'b????_????_????_1???};
            wildcard bins cb_wr_en4  = {16'b????_????_???1_????};
            wildcard bins cb_wr_en5  = {16'b????_????_??1?_????};
            wildcard bins cb_wr_en6  = {16'b????_????_?1??_????};
            wildcard bins cb_wr_en7  = {16'b????_????_1???_????};
            wildcard bins cb_wr_en8  = {16'b????_???1_????_????};
            wildcard bins cb_wr_en9  = {16'b????_??1?_????_????};
            wildcard bins cb_wr_en10 = {16'b????_?1??_????_????};
            wildcard bins cb_wr_en11 = {16'b????_1???_????_????};
            wildcard bins cb_wr_en12 = {16'b???1_????_????_????};
            wildcard bins cb_wr_en13 = {16'b??1?_????_????_????};
            wildcard bins cb_wr_en14 = {16'b?1??_????_????_????};
            wildcard bins cb_wr_en15 = {16'b1???_????_????_????};
        }
        //Wr data cover point
        cp_wr_data_0 : coverpoint txn_in.data.Bit[0 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_1 : coverpoint txn_in.data.Bit[8 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_2 : coverpoint txn_in.data.Bit[16 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_3 : coverpoint txn_in.data.Bit[24 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_4 : coverpoint txn_in.data.Bit[32 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_5 : coverpoint txn_in.data.Bit[40 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_6 : coverpoint txn_in.data.Bit[48 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_7 : coverpoint txn_in.data.Bit[56 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_8 : coverpoint txn_in.data.Bit[64 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_9 : coverpoint txn_in.data.Bit[72 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_10 : coverpoint txn_in.data.Bit[80 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_11 : coverpoint txn_in.data.Bit[88 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_12 : coverpoint txn_in.data.Bit[96 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_13 : coverpoint txn_in.data.Bit[104 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_14 : coverpoint txn_in.data.Bit[112 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_15 : coverpoint txn_in.data.Bit[120 +: 8] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        //Cross cover point between address and wr_en
        cp_addr_x_wr_en  : cross cp_wr_addr, cp_wr_en;

    endgroup: cg_wr_rf

    covergroup cg_rd_a_rf;
        option.per_instance = 1;
        option.name = "cg_rd_a_rf";
        //RD address cover point
        cp_rd_addr : coverpoint  txn_out.addr {
            //1 bin per each value
            bins cb_rd_addr[] = {[0:$]};
        }
        //RD data cover point
        cp_rd_data_0 : coverpoint txn_out.data.Bit[0 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_1 : coverpoint txn_out.data.Bit[8 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_2 : coverpoint txn_out.data.Bit[16 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_3 : coverpoint txn_out.data.Bit[24 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_4 : coverpoint txn_out.data.Bit[32 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_5 : coverpoint txn_out.data.Bit[40 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_6 : coverpoint txn_out.data.Bit[48 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_7 : coverpoint txn_out.data.Bit[56 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_8 : coverpoint txn_out.data.Bit[64 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_9 : coverpoint txn_out.data.Bit[72 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_10 : coverpoint txn_out.data.Bit[80 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_11 : coverpoint txn_out.data.Bit[88 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_12 : coverpoint txn_out.data.Bit[96 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_13 : coverpoint txn_out.data.Bit[104 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_14 : coverpoint txn_out.data.Bit[112 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_15 : coverpoint txn_out.data.Bit[120 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }

        //Cross between rd_addr and rd_data
        cp_addr_x_rd_data_0 : cross cp_rd_addr, cp_rd_data_0;
        cp_addr_x_rd_data_1 : cross cp_rd_addr, cp_rd_data_1;
        cp_addr_x_rd_data_2 : cross cp_rd_addr, cp_rd_data_2;
        cp_addr_x_rd_data_3 : cross cp_rd_addr, cp_rd_data_3;
        cp_addr_x_rd_data_4 : cross cp_rd_addr, cp_rd_data_4;
        cp_addr_x_rd_data_5 : cross cp_rd_addr, cp_rd_data_5;
        cp_addr_x_rd_data_6 : cross cp_rd_addr, cp_rd_data_6;
        cp_addr_x_rd_data_7 : cross cp_rd_addr, cp_rd_data_7;
        cp_addr_x_rd_data_8 : cross cp_rd_addr, cp_rd_data_8;
        cp_addr_x_rd_data_9 : cross cp_rd_addr, cp_rd_data_9;
        cp_addr_x_rd_data_10 : cross cp_rd_addr, cp_rd_data_10;
        cp_addr_x_rd_data_11 : cross cp_rd_addr, cp_rd_data_10;
        cp_addr_x_rd_data_12 : cross cp_rd_addr, cp_rd_data_12;
        cp_addr_x_rd_data_13 : cross cp_rd_addr, cp_rd_data_13;
        cp_addr_x_rd_data_14 : cross cp_rd_addr, cp_rd_data_14;
        cp_addr_x_rd_data_15 : cross cp_rd_addr, cp_rd_data_15;
    endgroup: cg_rd_a_rf

    covergroup cg_rd_b_rf;
        option.per_instance = 1;
        option.name = "cg_rd_b_rf";
        //RD address cover point
        cp_rd_addr : coverpoint  txn_out.addr {
            //1 bin per each value
            bins cb_rd_addr[] = {[0:$]};
        }
        //RD data cover point
        cp_rd_data_0 : coverpoint txn_out.data.Bit[0 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_1 : coverpoint txn_out.data.Bit[8 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_2 : coverpoint txn_out.data.Bit[16 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_3 : coverpoint txn_out.data.Bit[24 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_4 : coverpoint txn_out.data.Bit[32 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_5 : coverpoint txn_out.data.Bit[40 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_6 : coverpoint txn_out.data.Bit[48 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_7 : coverpoint txn_out.data.Bit[56 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_8 : coverpoint txn_out.data.Bit[64 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_9 : coverpoint txn_out.data.Bit[72 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_10 : coverpoint txn_out.data.Bit[80 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_11 : coverpoint txn_out.data.Bit[88 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_12 : coverpoint txn_out.data.Bit[96 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_13 : coverpoint txn_out.data.Bit[104 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_14 : coverpoint txn_out.data.Bit[112 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }
        cp_rd_data_15 : coverpoint txn_out.data.Bit[120 +: 8] {
            //Bins for rd_data
            bins cb_rd_data[1] = {[0:$]};
        }

        //Cross between rd_addr and rd_data
        cp_addr_x_rd_data_0 : cross cp_rd_addr, cp_rd_data_0;
        cp_addr_x_rd_data_1 : cross cp_rd_addr, cp_rd_data_1;
        cp_addr_x_rd_data_2 : cross cp_rd_addr, cp_rd_data_2;
        cp_addr_x_rd_data_3 : cross cp_rd_addr, cp_rd_data_3;
        cp_addr_x_rd_data_4 : cross cp_rd_addr, cp_rd_data_4;
        cp_addr_x_rd_data_5 : cross cp_rd_addr, cp_rd_data_5;
        cp_addr_x_rd_data_6 : cross cp_rd_addr, cp_rd_data_6;
        cp_addr_x_rd_data_7 : cross cp_rd_addr, cp_rd_data_7;
        cp_addr_x_rd_data_8 : cross cp_rd_addr, cp_rd_data_8;
        cp_addr_x_rd_data_9 : cross cp_rd_addr, cp_rd_data_9;
        cp_addr_x_rd_data_10 : cross cp_rd_addr, cp_rd_data_10;
        cp_addr_x_rd_data_11 : cross cp_rd_addr, cp_rd_data_10;
        cp_addr_x_rd_data_12 : cross cp_rd_addr, cp_rd_data_12;
        cp_addr_x_rd_data_13 : cross cp_rd_addr, cp_rd_data_13;
        cp_addr_x_rd_data_14 : cross cp_rd_addr, cp_rd_data_14;
        cp_addr_x_rd_data_15 : cross cp_rd_addr, cp_rd_data_15;
    endgroup: cg_rd_b_rf

    covergroup cg_mask;
        rd_mask : coverpoint txn_out.mask {
            wildcard bins mask_set_0  = {16'b????_????_????_???1};
            wildcard bins mask_set_1  = {16'b????_????_????_??1?};
            wildcard bins mask_set_2  = {16'b????_????_????_?1??};
            wildcard bins mask_set_3  = {16'b????_????_????_1???};
            wildcard bins mask_set_4  = {16'b????_????_???1_????};
            wildcard bins mask_set_5  = {16'b????_????_??1?_????};
            wildcard bins mask_set_6  = {16'b????_????_?1??_????};
            wildcard bins mask_set_7  = {16'b????_????_1???_????};
            wildcard bins mask_set_8  = {16'b????_???1_????_????};
            wildcard bins mask_set_9  = {16'b????_??1?_????_????};
            wildcard bins mask_set_10 = {16'b????_?1??_????_????};
            wildcard bins mask_set_11 = {16'b????_1???_????_????};
            wildcard bins mask_set_12 = {16'b???1_????_????_????};
            wildcard bins mask_set_13 = {16'b??1?_????_????_????};
            wildcard bins mask_set_14 = {16'b?1??_????_????_????};
            wildcard bins mask_set_15 = {16'b1???_????_????_????};

            wildcard bins mask_unset_0  = {16'b????_????_????_???0};
            wildcard bins mask_unset_1  = {16'b????_????_????_??0?};
            wildcard bins mask_unset_2  = {16'b????_????_????_?0??};
            wildcard bins mask_unset_3  = {16'b????_????_????_0???};
            wildcard bins mask_unset_4  = {16'b????_????_???0_????};
            wildcard bins mask_unset_5  = {16'b????_????_??0?_????};
            wildcard bins mask_unset_6  = {16'b????_????_?0??_????};
            wildcard bins mask_unset_7  = {16'b????_????_0???_????};
            wildcard bins mask_unset_8  = {16'b????_???0_????_????};
            wildcard bins mask_unset_9  = {16'b????_??0?_????_????};
            wildcard bins mask_unset_10 = {16'b????_?0??_????_????};
            wildcard bins mask_unset_11 = {16'b????_0???_????_????};
            wildcard bins mask_unset_12 = {16'b???0_????_????_????};
            wildcard bins mask_unset_13 = {16'b??0?_????_????_????};
            wildcard bins mask_unset_14 = {16'b?0??_????_????_????};
            wildcard bins mask_unset_15 = {16'b0???_????_????_????};
         }
    endgroup: cg_mask

    function new(string name = "riscv_v_rf_cov", uvm_component parent = null);
        super.new(name, parent);
        cg_wr_rf   = new();
        cg_rd_a_rf = new();
        cg_rd_b_rf = new();
        cg_mask    = new();
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    //Cover Writes
    virtual function void cov_in();
        num_wr_sampled++;
        cg_wr_rf.sample();
    endfunction: cov_in 

    //Cover reads
    virtual function void cov_out();
        num_rd_sampled++;
        if (txn_out.port == RF_RD_PORT_A) begin
            cg_rd_a_rf.sample();
            cg_mask.sample();
        end else begin
            cg_rd_b_rf.sample();
        end
    endfunction: cov_out

    virtual function void check_phase(uvm_phase phase);
        `uvm_info(get_name(), $sformatf("num_wr_sampled: %0d, num_rd_sampled: %0d", num_wr_sampled, num_rd_sampled), UVM_NONE)
    endfunction: check_phase

endclass: riscv_v_rf_cov

`endif // __RISCV_V_RF_COV_SV__