//File: riscv_v_csr_trk_item
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISCV-V CSR Tracker item

`ifndef __RISCV_V_CSR_TRK_ITEM__
`define __RISCV_V_CSR_TRK_ITEM__ 

class riscv_v_csr_trk_item extends riscv_v_base_seq_item;
    riscv_v_vsstatus_t     vsstatus_data_in;
    logic                  vsstatus_wr_en;
    riscv_v_vtype_t        vtype_data_in;
    logic                  vtype_wr_en;
    riscv_v_vl_t           vl_data_in;
    logic                  vl_wr_en;
    riscv_v_vstart_t       vstart_data_in;
    logic                  vstart_wr_en;
    riscv_v_vxrm_t         vxrm_data_in;
    logic                  vxrm_wr_en;
    riscv_v_vxsat_t        vxsat_data_in;
    logic                  vxsat_wr_en;

    `uvm_object_utils_begin(riscv_rf_trk_item)
        `uvm_field_int(vsstatus_data_in, UVM_ALL_ON)
        `uvm_field_int(vsstatus_wr_en, UVM_ALL_ON)
        `uvm_field_int(vtype_data_in, UVM_ALL_ON)
        `uvm_field_int(vtype_wr_en, UVM_ALL_ON)
        `uvm_field_int(vl_data_in, UVM_ALL_ON)
        `uvm_field_int(vl_wr_en, UVM_ALL_ON)
        `uvm_field_int(vstart_data_in, UVM_ALL_ON)
        `uvm_field_int(vstart_wr_en, UVM_ALL_ON)
        `uvm_field_int(vxrm_data_in, UVM_ALL_ON)
        `uvm_field_int(vxrm_wr_en, UVM_ALL_ON)
        `uvm_field_int(vxsat_data_in, UVM_ALL_ON)
        `uvm_field_int(vxsat_wr_en, UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor 
    function new(string name = "riscv_v_csr_trk_item");
        super.new(name);
    endfunction: new

endclass: riscv_v_csr_trk_item

`endif //__RISCV_V_CSR_TRK_ITEM 