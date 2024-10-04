//File: riscv_v_csr_bfm_cfg_obj.sv
//Author: Miguel Bucio
//Date: 27/02/24
//Description: RISCV V CSR BFM Configuration object

`ifndef __RISCV_V_CSR_BFM_CFG_OBJ_SV__
`define __RISCV_V_CSR_BFM_CFG_OBJ_SV__

class riscv_v_csr_bfm_cfg_obj extends riscv_v_base_bfm_cfg_obj;

    
    `uvm_object_utils(riscv_v_csr_bfm_cfg_obj)

    function new(string name = "riscv_v_csr_bfm_cfg_obj");
        super.new(name);
    endfunction: new

    virtual function bit check_cfg();
        return 1'b1;
    endfunction: check_cfg

endclass: riscv_v_csr_bfm_cfg_obj

`endif //__RISCV_V_CSR_BFM_CFG_OBJ_SV__