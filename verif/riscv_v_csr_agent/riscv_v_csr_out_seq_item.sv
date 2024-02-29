//File: riscv_v_csr_out_seq_item
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V CSR in sequence item

`ifndef __RISCV_V_CSR_OUT_SEQ_ITEM__
`define __RISCV_V_CSR_OUT_SEQ_ITEM__ 

class riscv_v_csr_out_seq_item extends riscv_v_base_seq_item;

    riscv_v_vsstatus_t     vsstatus_data_out;
    riscv_v_vtype_t        vtype_data_out;
    riscv_v_vl_t           vl_data_out;
    riscv_v_vlenb_t        vlenb_data_out;
    riscv_v_vstart_t       vstart_data_out;
    riscv_v_vxrm_t         vxrm_data_out;
    riscv_v_vxsat_t        vxsat_data_out;
    riscv_v_vcsr_t         vcsr_data_out;


    `uvm_object_utils_begin(riscv_v_csr_out_seq_item)
        `uvm_field_int(vsstatus_data_out, UVM_ALL_ON)
        `uvm_field_int(vtype_data_out, UVM_ALL_ON)
        `uvm_field_int(vl_data_out, UVM_ALL_ON)
        `uvm_field_int(vlenb_data_out, UVM_ALL_ON)
        `uvm_field_int(vstart_data_out, UVM_ALL_ON)
        `uvm_field_int(vxrm_data_out, UVM_ALL_ON)
        `uvm_field_int(vxsat_data_out, UVM_ALL_ON)
        `uvm_field_int(vcsr_data_out, UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor
    function new(string name = "riscv_v_csr_out_seq_item");
        super.new(name);
    endfunction: new


endclass: riscv_v_csr_out_seq_item

`endif //__RISCV_V_CSR_OUT_SEQ_ITEM__