//File: riscv_rf_cov.sv
//Author: Miguel Bucio
//Date: 28/01/23
//Description: RISC-V RF Coverage

`ifndef __RISCV_RF_COV_SV__
`define __RISCV_RF_COV_SV__ 

class riscv_rf_cov extends riscv_v_base_cov#(
                                                .seq_item_in_t  (riscv_rf_wr_seq_item),
                                                .seq_item_out_t (riscv_rf_rd_seq_item));

    `uvm_component_utils(riscv_rf_cov)

    int num_wr_sampled = 0;
    int num_rd_sampled = 0;

    //Cover groups
    covergroup cg_wr_rf;
        option.per_instance = 1;
        option.name = "cg_wr_rf";

        cp_wr_addr: coverpoint txn_in.addr {
            bins addr[] = {[0:$]};
        }

        cp_wr_en: coverpoint txn_in.wr_en {
            bins wr_enable = {1'b1};
        }

        cp_wr_addr_en: coverpoint txn_in.addr {
            bins wr_en_addr[] = {[0:$]} iff (txn_in.wr_en);
        }
        
        `ifndef VIVADO

            cp_wr_data: coverpoint txn_in.data {
                bins data[4] = {[0:$]};
            }

            cp_wr_addr_wr_data_cross: cross cp_wr_addr_en, cp_wr_data;
        `else 

            cp_wr_data_0: coverpoint txn_in.data[0 +: 8] {
                bins data[1] = {[0:$]};
            }
            cp_wr_data_1: coverpoint txn_in.data[8 +: 8] {
                bins data[1] = {[0:$]};
            }
            cp_wr_data_2: coverpoint txn_in.data[16 +: 8] {
                bins data[1] = {[0:$]};
            }
            cp_wr_data_3: coverpoint txn_in.data[24 +: 8] {
                bins data[1] = {[0:$]};
            }

            

            cp_wr_addr_wr_data_cross_0: cross cp_wr_addr_en, cp_wr_data_0;
            cp_wr_addr_wr_data_cross_1: cross cp_wr_addr_en, cp_wr_data_1;
            cp_wr_addr_wr_data_cross_2: cross cp_wr_addr_en, cp_wr_data_2;
            cp_wr_addr_wr_data_cross_3: cross cp_wr_addr_en, cp_wr_data_3;

        `endif //VIVADO

    endgroup: cg_wr_rf

    covergroup cg_rd_a_rf;
        option.per_instance = 1;
        option.name = "cg_rd_a_rf";

        cp_rd_addr: coverpoint txn_out.addr{
            bins addr[] = {[0:$]};
        }

        `ifndef VIVADO

            cp_rd_data: coverpoint txn_out.data{
                bins data[4] = {[0:$]};
            }

            cp_rd_addr_x_data: cross cp_rd_addr, cp_rd_data;

        `else 

            cp_rd_data_0: coverpoint txn_out.data[0 +: 8]{
                bins data[1] = {[0:$]};
            }
            cp_rd_data_1: coverpoint txn_out.data[8 +: 8]{
                bins data[1] = {[0:$]};
            }
            cp_rd_data_2: coverpoint txn_out.data[16 +: 8]{
                bins data[1] = {[0:$]};
            }
            cp_rd_data_3: coverpoint txn_out.data[24 +: 8]{
                bins data[1] = {[0:$]};
            }

            cp_rd_addr_x_data_0: cross cp_rd_addr, cp_rd_data_0;
            cp_rd_addr_x_data_1: cross cp_rd_addr, cp_rd_data_1;
            cp_rd_addr_x_data_2: cross cp_rd_addr, cp_rd_data_2;
            cp_rd_addr_x_data_3: cross cp_rd_addr, cp_rd_data_3;

        `endif //VIVADO

    endgroup: cg_rd_a_rf

    covergroup cg_rd_b_rf;
        option.per_instance = 1;
        option.name = "cg_rd_b_rf";

        cp_rd_addr: coverpoint txn_out.addr{
            bins addr[] = {[0:$]};
        }

        `ifndef VIVADO

            cp_rd_data: coverpoint txn_out.data{
                bins data[4] = {[0:$]};
            }

            cp_rd_addr_x_data: cross cp_rd_addr, cp_rd_data;

        `else 

            cp_rd_data_0: coverpoint txn_out.data[0 +: 8]{
                bins data[1] = {[0:$]};
            }
            cp_rd_data_1: coverpoint txn_out.data[8 +: 8]{
                bins data[1] = {[0:$]};
            }
            cp_rd_data_2: coverpoint txn_out.data[16 +: 8]{
                bins data[1] = {[0:$]};
            }
            cp_rd_data_3: coverpoint txn_out.data[24 +: 8]{
                bins data[1] = {[0:$]};
            }

            cp_rd_addr_x_data_0: cross cp_rd_addr, cp_rd_data_0;
            cp_rd_addr_x_data_1: cross cp_rd_addr, cp_rd_data_1;
            cp_rd_addr_x_data_2: cross cp_rd_addr, cp_rd_data_2;
            cp_rd_addr_x_data_3: cross cp_rd_addr, cp_rd_data_3;

        `endif //VIVADO

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

`endif // __RISCV_COV_SV__