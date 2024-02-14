//File: riscv_v_ext_csr_bfm_cfg_obj.sv
//Author: Miguel Bucio
//Date: 12/02/24
//Description: Riscv V Instruction Fetc BFM configuration object 

`ifndef __RISCV_V_EXT_CSR_BFM_CFG_OBJ_SV__
`define __RISCV_V_EXT_CSR_BFM_CFG_OBJ_SV__

class riscv_v_ext_csr_bfm_cfg_obj extends riscv_v_base_bfm_cfg_obj;

    `uvm_object_utils(riscv_v_ext_csr_bfm_cfg_obj)

    riscv_v_ext_csr_rotator csr_rotator;

    bit wr_vsstatus = 1'b0;
    bit wr_vtype    = 1'b0;
    bit wr_vl       = 1'b0;
    bit wr_vstart   = 1'b0;
    bit wr_vxrm     = 1'b0;
    bit wr_vxsat    = 1'b0;

    riscv_v_vsstatus_t vsstatus_wr_data = RISCV_V_VSSTATUS_RST_VAL;
    riscv_v_vtype_t    vtype_wr_data    = RISCV_V_VTYPE_RST_VAL;
    riscv_v_vl_t       vl_wr_data       = RISCV_V_VL_RST_VAL;
    riscv_v_vstart_t   vstart_wr_data   = RISCV_V_VSTART_RST_VAL;
    riscv_v_vxrm_t     vxrm_wr_data     = RISCV_V_VXRM_RST_VAL;
    riscv_v_vxsat_t    vxsat_wr_data    = RISCV_V_VXSAT_RST_VAL;

    function new(string name = "riscv_v_ext_csr_bfm_cfg_obj");
        super.new(name);
    endfunction: new

    virtual function bit check_cfg();
        if (csr_rotator == null) begin
            `uvm_fatal(get_name(), "csr_rotator is null");
            return 1'b0;
        end
        return 1'b1;
    endfunction: check_cfg

    virtual function void set_rotator(riscv_v_ext_csr_rotator new_rotator);
        csr_rotator = new_rotator;
    endfunction: set_rotator

endclass: riscv_v_ext_csr_bfm_cfg_obj

`endif  //__RISCV_V_EXT_CSR_BFM_CFG_OBJ_SV__