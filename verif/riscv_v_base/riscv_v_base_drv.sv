//File: riscv_v_base_drv.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base driver

`ifndef __RISCV_V_BASE_DRV__
`define __RISCV_V_BASE_DRV__

virtual class riscv_v_base_drv#(type seq_item_t = riscv_v_base_seq_item)  extends base_drv#(seq_item_t);
    `uvm_component_param_utils(riscv_v_base_drv#(
        .seq_item_t(seq_item_t)))
    
    //Constructor
    function new(string name = "riscv_v_base_drv", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

endclass: riscv_v_base_drv

`endif //__RISCV_V_BASE_DRV__