//File: riscv_v_alu_bfm.sv
//Author: Miguel Bucio
//Date: 04/02/23
//Description: RISC V ALU BFM

`ifndef __RISCV_V_ALU_BFM_SV__
`define __RISCV_V_ALU_BFM_SV__ 

class riscv_v_alu_bfm extends riscv_v_base_bfm#(
    .seq_item_in_t(riscv_v_alu_in_seq_item),
    .seq_item_out_t(riscv_v_alu_out_seq_item),
    .sequencer_t(riscv_v_alu_sqr),
    .cfg_obj_t(riscv_v_alu_bfm_cfg_obj),
    .seq_t(riscv_v_alu_seq),
    .model_t(riscv_v_alu_base_model)
);

`uvm_component_utils(riscv_v_alu_bfm)

    function new (string name = "riscv_v_alu_bfm", uvm_component  parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void port_in_handler();
        return;
    endfunction: port_in_handler

    virtual function void rst_bfm();

    endfunction: rst_bfm 

    virtual function void rst_seq();

    endfunction: rst_seq 

    virtual function void bfm_seq();

    endfunction: bfm_seq

endclass: riscv_v_alu_bfm

`endif //__RISCV_V_ALU_BFM_SV__