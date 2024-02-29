//File: riscv_v_cov.sv
//Author: Miguel Bucio
//Date: 28/01/23
//Description: RISC-V RF Coverage

`ifndef __RISCV_V_COV_SV__
`define __RISCV_V_COV_SV__ 

class riscv_v_cov extends riscv_v_base_cov#(
                                                .seq_item_in_t  (riscv_v_in_seq_item),
                                                .seq_item_out_t (riscv_v_out_seq_item));

    `uvm_component_utils(riscv_v_cov)

    int num_in_sampled = 0;
    int num_out_sampled = 0;


    function new(string name = "riscv_v_cov", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    //Cover Writes
    virtual function void cov_in();
        num_in_sampled++;
    endfunction: cov_in 

    //Cover reads
    virtual function void cov_out();
        num_out_sampled++;
    endfunction: cov_out

    virtual function void check_phase(uvm_phase phase);
        `uvm_info(get_name(), $sformatf("num_in_sampled: %0d, num_rd_sampled: %0d", num_in_sampled, num_out_sampled), UVM_NONE)
    endfunction: check_phase

endclass: riscv_v_cov

`endif // __RISCV_V_COV_SV__