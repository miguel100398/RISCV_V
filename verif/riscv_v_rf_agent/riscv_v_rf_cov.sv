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

    int num_cb_wr_data = 10;

    //Cover groups
    covergroup cg_wr_rf;
        //Wr address cover point
        cp_wr_addr : coverpoint  txn_in.addr {
            //1 bin per each value
            bins cb_wr_addr[] = {[0:$]};
        }
        //Wr en cover point
        cp_wr_en  : coverpoint txn_in.wr_en {
            //1 bin per each wr_en byte
            bins cb_wr_en[] = {[0:$]};
        }
        //Wr data cover point
        cp_wr_data : coverpoint txn_in.data {
            //Bins for wr_data
            bins cb_wr_data[num_cb_wr_data] = {[0:$]};
        }
        //Cross cover point between address and wr_en
        cp_addr_x_wr_en : cross cp_wr_addr, cp_wr_en;
    endgroup: cg_wr_rf

    covergroup cg_rd_a_rf;
        //Wr address cover point
        cp_rf_addr : coverpoint  txn_out.addr {
            //1 bin per each value
            bins cb_rd_addr[] = {[0:$]};
        }
        //Wr data cover point
        cp_rd_data : coverpoint txn_out.data {
            //Bins for wr_data
            bins cb_rd_data[num_cb_wr_data] = {[0:$]};
        }
    endgroup: cg_rd_a_rf

    covergroup cg_rd_b_rf;
        //Wr address cover point
        cp_rf_addr : coverpoint  txn_out.addr {
            //1 bin per each value
            bins cb_rd_addr[] = {[0:$]};
        }
        //Wr data cover point
        cp_rd_data : coverpoint txn_out.data {
            //Bins for wr_data
            bins cb_rd_data[num_cb_wr_data] = {[0:$]};
        }
    endgroup: cg_rd_b_rf

    function new(string name = "riscv_v_rf_cov", uvm_component parent = null);
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

endclass: riscv_v_rf_cov

`endif // __RISCV_V_RF_COV_SV__