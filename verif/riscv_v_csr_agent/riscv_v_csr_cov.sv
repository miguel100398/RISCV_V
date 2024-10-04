//File: riscv_v_csr_cov.sv
//Author: Miguel Bucio
//Date: 28/01/23
//Description: RISCV V CSR Coverage

`ifndef __RISCV_V_CSR_COV_SV__
`define __RISCV_V_CSR_COV_SV__ 

class riscv_v_csr_cov extends riscv_v_base_cov#(
                                                .seq_item_in_t  (riscv_v_csr_in_seq_item),
                                                .seq_item_out_t (riscv_v_csr_out_seq_item));

    `uvm_component_utils(riscv_v_csr_cov)

    int num_wr_sampled = 0;
    int num_rd_sampled = 0;


    function new(string name = "riscv_v_csr_cov", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    //Cover Writes
    virtual function void cov_in();
        num_wr_sampled++;
    endfunction: cov_in 

    //Cover reads
    virtual function void cov_out();
        num_rd_sampled++;
    endfunction: cov_out

    virtual function void check_phase(uvm_phase phase);
        `uvm_info(get_name(), $sformatf("num_wr_sampled: %0d, num_rd_sampled: %0d", num_wr_sampled, num_rd_sampled), UVM_NONE)
    endfunction: check_phase

endclass: riscv_v_csr_cov

`endif // __RISCV_V_CSR_COV_SV__