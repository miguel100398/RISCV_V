//File: riscv_v_rf_trk_item
//Author: Miguel Bucio
//Date: 10/06/23
//Description: RISC-V Vector extension register file tracker item

`ifndef __RISCV_V_RF_TRK_ITEM__
`define __RISCV_V_RF_TRK_ITEM__ 

class riscv_v_rf_trk_item extends riscv_v_base_seq_item;
    riscv_v_rf_addr_t   addr;
    riscv_v_rf_wr_en_t  wr_en;
    riscv_v_data_t      data;
    rf_port_e           port;
    bit                 wr;

    `uvm_object_utils_begin(riscv_v_rf_trk_item)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(wr_en, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_enum(rf_port_e, port, UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor
    function new(string name = "riscv_v_rf_trk_item");
        super.new(name);
    endfunction: new


endclass: riscv_v_rf_trk_item

`endif //__RISCV_V_RF_TRK_ITEM__