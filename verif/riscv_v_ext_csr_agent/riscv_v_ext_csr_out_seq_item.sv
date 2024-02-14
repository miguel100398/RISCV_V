//File: riscv_v_ext_csr_out_seq_item
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V register file read sequence item

`ifndef __RISCV_V_EXT_CSR_OUT_SEQ_ITEM__
`define __RISCV_V_EXT_CSR_OUT_SEQ_ITEM__ 

class riscv_v_ext_csr_out_seq_item extends riscv_v_base_seq_item;
    riscv_data_t    ext_csr_data;
    logic           ext_wr_vsstatus;
    logic           ext_wr_vtype;
    logic           ext_wr_vl;
    logic           ext_wr_vstart;
    logic           ext_wr_vxrm;
    logic           ext_wr_vxsat;


    `uvm_object_utils_begin(riscv_v_ext_csr_out_seq_item)
        `uvm_field_int(ext_csr_data, UVM_ALL_ON)
        `uvm_field_int(ext_wr_vsstatus, UVM_ALL_ON)
        `uvm_field_int(ext_wr_vtype, UVM_ALL_ON)
        `uvm_field_int(ext_wr_vl, UVM_ALL_ON)
        `uvm_field_int(ext_wr_vstart, UVM_ALL_ON)
        `uvm_field_int(ext_wr_vxrm, UVM_ALL_ON)
        `uvm_field_int(ext_wr_vxsat, UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor
    function new(string name = "riscv_v_ext_csr_out_seq_item");
        super.new(name);
    endfunction: new


endclass: riscv_v_ext_csr_out_seq_item

`endif //__RISCV_V_EXT_CSR_OUT_SEQ_ITEM__