//File: riscv_rf_cov.sv
//Author: Miguel Bucio
//Date: 28/01/23
//Description: RISC-V RF Coverage

`ifndef __RISCV_V_RF_COV_SV__
`define __RISCV_V_RF_COV_SV__ 

class riscv_rf_cov extends riscv_base_cov#(
                                                .seq_item_in_t  (riscv_rf_wr_seq_item),
                                                .seq_item_out_t (riscv_rf_rd_seq_item));

    `uvm_component_utils(riscv_rf_cov)

    int num_wr_sampled = 0;
    int num_rd_sampled = 0;

    //Cover groups
    covergroup cg_wr_rf;
        //Wr address cover point
        cp_wr_addr : coverpoint  txn_in.addr {
            //1 bin per each value
            bins cb_wr_addr[] = {[0:$]};
        }
        //Wr en cover point
        cp_wr_en_0  : coverpoint txn_in.wr_en[0] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_1  : coverpoint txn_in.wr_en[1] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_2  : coverpoint txn_in.wr_en[2] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_3  : coverpoint txn_in.wr_en[3] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_4  : coverpoint txn_in.wr_en[4] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_5  : coverpoint txn_in.wr_en[5] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_6  : coverpoint txn_in.wr_en[6] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_7  : coverpoint txn_in.wr_en[7] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_8  : coverpoint txn_in.wr_en[8] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_9  : coverpoint txn_in.wr_en[9] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_10  : coverpoint txn_in.wr_en[10] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_11  : coverpoint txn_in.wr_en[11] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_12  : coverpoint txn_in.wr_en[12] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_13  : coverpoint txn_in.wr_en[13] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_14  : coverpoint txn_in.wr_en[14] {
            bins cb_wr_en = {1};
        }
        cp_wr_en_15  : coverpoint txn_in.wr_en[15] {
            bins cb_wr_en = {1};
        }
        //Wr data cover point
        cp_wr_data_0 : coverpoint txn_in.data.Bit[0 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_1 : coverpoint txn_in.data.Bit[16 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_2 : coverpoint txn_in.data.Bit[32 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_3 : coverpoint txn_in.data.Bit[48 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_4 : coverpoint txn_in.data.Bit[64 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_5 : coverpoint txn_in.data.Bit[80 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_6 : coverpoint txn_in.data.Bit[96 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_wr_data_7 : coverpoint txn_in.data.Bit[112 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        //Cross cover point between address and wr_en
        cp_addr_x_wr_en_0  : cross cp_wr_addr, cp_wr_en_0;
        cp_addr_x_wr_en_1  : cross cp_wr_addr, cp_wr_en_1;
        cp_addr_x_wr_en_2  : cross cp_wr_addr, cp_wr_en_2;
        cp_addr_x_wr_en_3  : cross cp_wr_addr, cp_wr_en_3;
        cp_addr_x_wr_en_4  : cross cp_wr_addr, cp_wr_en_4;
        cp_addr_x_wr_en_5  : cross cp_wr_addr, cp_wr_en_5;
        cp_addr_x_wr_en_6  : cross cp_wr_addr, cp_wr_en_6;
        cp_addr_x_wr_en_7  : cross cp_wr_addr, cp_wr_en_7;
        cp_addr_x_wr_en_8  : cross cp_wr_addr, cp_wr_en_8;
        cp_addr_x_wr_en_9  : cross cp_wr_addr, cp_wr_en_9;
        cp_addr_x_wr_en_10 : cross cp_wr_addr, cp_wr_en_10;
        cp_addr_x_wr_en_11 : cross cp_wr_addr, cp_wr_en_11;
        cp_addr_x_wr_en_12 : cross cp_wr_addr, cp_wr_en_12;
        cp_addr_x_wr_en_13 : cross cp_wr_addr, cp_wr_en_13;
        cp_addr_x_wr_en_14 : cross cp_wr_addr, cp_wr_en_14;
        cp_addr_x_wr_en_15 : cross cp_wr_addr, cp_wr_en_15;
    endgroup: cg_wr_rf

    covergroup cg_rd_a_rf;
        //RD address cover point
        cp_rf_addr : coverpoint  txn_out.addr {
            //1 bin per each value
            bins cb_rd_addr[] = {[0:$]};
        }
        //RD data cover point
        cp_rd_data_0 : coverpoint txn_out.data.Bit[0 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_1 : coverpoint txn_out.data.Bit[16 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_2 : coverpoint txn_out.data.Bit[32 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_3 : coverpoint txn_out.data.Bit[48 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_4 : coverpoint txn_out.data.Bit[64 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_5 : coverpoint txn_out.data.Bit[80 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_6 : coverpoint txn_out.data.Bit[96 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_7 : coverpoint txn_out.data.Bit[112 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
    endgroup: cg_rd_a_rf

    covergroup cg_rd_b_rf;
        //RD address cover point
        cp_rf_addr : coverpoint  txn_out.addr {
            //1 bin per each value
            bins cb_rd_addr[] = {[0:$]};
        }
        //RD data cover point
        cp_rd_data_0 : coverpoint txn_out.data.Bit[0 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_1 : coverpoint txn_out.data.Bit[16 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_2 : coverpoint txn_out.data.Bit[32 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_3 : coverpoint txn_out.data.Bit[48 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_4 : coverpoint txn_out.data.Bit[64 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_5 : coverpoint txn_out.data.Bit[80 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_6 : coverpoint txn_out.data.Bit[96 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
        cp_rd_data_7 : coverpoint txn_out.data.Bit[112 +: 16] {
            //Bins for wr_data
            bins cb_wr_data[1] = {[0:$]};
        }
    endgroup: cg_rd_b_rf

    function new(string name = "riscv_rf_cov", uvm_component parent = null);
        super.new(name, parent);
        cg_wr_rf   = new();
        cg_rd_a_rf = new();
        cg_rd_b_rf = new();
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
        end else begin
            cg_rd_b_rf.sample();
        end
    endfunction: cov_out

    virtual function void check_phase(uvm_phase phase);
        `uvm_info(get_name(), $sformatf("num_wr_sampled: %0d, num_rd_sampled: %0d", num_wr_sampled, num_rd_sampled), UVM_NONE)
    endfunction: check_phase

endclass: riscv_rf_cov

`endif // __RISCV_RF_COV_SV__