//File: riscv_v_rf_rd_seq_item
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file read sequence item

`ifndef __RISCV_V_RF_RD_SEQ_ITEM__
`define __RISCV_V_RF_RD_SEQ_ITEM__ 

class riscv_v_rf_rd_seq_item extends riscv_v_base_seq_item;
    rand riscv_v_rf_addr_t   addr;
    rand riscv_v_data_t      data;
    rand rf_port_e           port;
    //Needed for Bypass
    riscv_v_rf_wr_en_t       wr_en;
    riscv_v_data_t           wr_data;
    riscv_v_rf_addr_t        wr_addr;

    riscv_v_mask_t           mask;


    `uvm_object_utils_begin(riscv_v_rf_rd_seq_item)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_enum(rf_port_e, port, UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor
    function new(string name = "riscv_v_rf_rd_seq_item");
        super.new(name);
    endfunction: new


endclass: riscv_v_rf_rd_seq_item

`endif //__RISCV_V_RF_RD_SEQ_ITEM__