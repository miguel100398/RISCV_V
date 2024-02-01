//File: riscv_v_base_sqr.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base sequencer

`ifndef __RISCV_V_BASE_SQR__
`define __RISCV_V_BASE_SQR__

virtual class riscv_v_base_sqr#(type seq_item_t = riscv_v_base_seq_item) extends base_sqr#(seq_item_t);
    `uvm_component_param_utils(riscv_v_base_sqr#(seq_item_t))

    //Constructor
    function new(string name = "riscv_v_base_sqr", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

endclass: riscv_v_base_sqr

`endif //__RISCV_V_BASE_SQR__