//File: riscv_v_alu_cov.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector ALU Coverage

`ifndef __RISCV_V_ALU_COV_SV__
`define __RISCV_V_ALU_COV_SV__ 

class riscv_v_alu_cov extends riscv_v_base_cov#(
                                                 .seq_item_in_t(riscv_v_alu_in_seq_item),
                                                 .seq_item_out_t(riscv_v_alu_out_seq_item) );
    `uvm_component_utils(riscv_v_alu_cov)

    function new(string name = "riscv_v_alu_cov", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void cov_in();

    endfunction: cov_in 

    virtual function void cov_out();

    endfunction: cov_out


endclass: riscv_v_alu_cov

`endif // __RISCV_V_ALU_COV_SV__