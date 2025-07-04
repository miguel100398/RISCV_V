//File: riscv_v_bfm_cfg_obj.sv
//Author: Miguel Bucio
//Date: 12/02/24
//Description: Riscv V Instruction Fetc BFM configuration object 

`ifndef __RISCV_V_BFM_CFG_OBJ_SV__
`define __RISCV_V_BFM_CFG_OBJ_SV__

class riscv_v_bfm_cfg_obj extends riscv_v_base_bfm_cfg_obj;

    `uvm_object_utils(riscv_v_bfm_cfg_obj)

    function new(string name = "riscv_v_bfm_cfg_obj");
        super.new(name);
    endfunction: new
    

endclass: riscv_v_bfm_cfg_obj

`endif  //__RISCV_V_BFM_CFG_OBJ_SV__