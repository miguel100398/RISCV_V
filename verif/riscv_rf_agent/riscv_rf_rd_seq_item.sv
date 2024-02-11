//File: riscv_rf_rd_seq_item
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V register file read sequence item

`ifndef __RISCV_RF_RD_SEQ_ITEM__
`define __RISCV_RF_RD_SEQ_ITEM__ 

class riscv_rf_rd_seq_item extends riscv_v_base_seq_item;
    riscv_rf_addr_t   addr;
    riscv_data_t      data;
    rf_port_e         port;


    `uvm_object_utils_begin(riscv_rf_rd_seq_item)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_enum(rf_port_e, port, UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor
    function new(string name = "riscv_rf_rd_seq_item");
        super.new(name);
    endfunction: new


endclass: riscv_rf_rd_seq_item

`endif //__RISCV_RF_RD_SEQ_ITEM__