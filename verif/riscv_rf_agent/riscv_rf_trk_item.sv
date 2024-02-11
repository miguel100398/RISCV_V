//File: riscv_rf_trk_item
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V register file tracker item

`ifndef __RISCV_RF_TRK_ITEM__
`define __RISCV_RF_TRK_ITEM__ 

class riscv_rf_trk_item extends riscv_v_base_seq_item;
    riscv_rf_addr_t   addr;
    logic             wr_en;
    riscv_data_t      data;
    rf_port_e         port;
    logic             wr;

    `uvm_object_utils_begin(riscv_rf_trk_item)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(wr_en, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_enum(rf_port_e, port, UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor
    function new(string name = "riscv_rf_trk_item");
        super.new(name);
    endfunction: new


endclass: riscv_rf_trk_item

`endif //__RISCV_RF_TRK_ITEM__