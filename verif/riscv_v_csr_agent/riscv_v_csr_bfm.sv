//File: riscv_v_v_csr_bfm
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V register BFM

`ifndef __RISCV_V_CSR_BFM_SV__
`define __RISCV_V_CSR_BFM_SV__ 

class riscv_v_csr_bfm extends riscv_v_base_bfm#(
    .model_t(riscv_v_csr_model),
    .seq_item_in_t(riscv_v_csr_in_seq_item),
    .seq_item_out_t(riscv_v_csr_out_seq_item),
    .sequencer_t(riscv_v_csr_sqr),
    .cfg_obj_t(riscv_v_csr_bfm_cfg_obj),
    .seq_t(riscv_v_csr_seq)
);

    `uvm_component_utils(riscv_v_csr_bfm)

    function new(string name = "riscv_v_csr_bfm", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual function void port_in_handler();
        return;
    endfunction: port_in_handler

    virtual function void rst_seq();
        return;
    endfunction: rst_seq

    virtual function void bfm_seq();
        return;
    endfunction: bfm_seq

    virtual function void rst_bfm();
        return;
    endfunction: rst_bfm


endclass: riscv_v_csr_bfm

`endif //__RISCV_V_CSR_BFM_SV__