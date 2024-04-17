//File: riscv_v_if_in_seq_item
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V register file write sequence item

`ifndef __RISCV_V_IN_SEQ_ITEM__
`define __RISCV_V_IN_SEQ_ITEM__ 

class riscv_v_in_seq_item extends riscv_v_base_seq_item;


    rand logic rst;
    rand logic clear_pipe;
    rand logic riscv_stall;
    rand riscv_instruction_t instruction;
    rand riscv_data_t int_rf_rd_data;
    rand riscv_data_t ext_data_in;
    rand logic ext_wr_vsstatus;
    rand logic ext_wr_vtype;
    rand logic ext_wr_vl;
    rand logic ext_wr_vstart;
    rand logic ext_wr_vxrm;
    rand logic ext_wr_vxsat;

    `uvm_object_utils_begin(riscv_v_in_seq_item)
        
    `uvm_object_utils_end

    //Constructor
    function new(string name = "riscv_v_in_seq_item");
        super.new(name);
    endfunction: new


endclass: riscv_v_in_seq_item

`endif //__RISCV_V_IN_SEQ_ITEM__