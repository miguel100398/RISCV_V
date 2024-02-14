//File: base_bfm_cfg_obj.sv
//Author: Miguel Bucio
//Date: 21/01/24
//Description: Base BFM configuration object 

`ifndef __BASE_BFM_CFG_OBJ_SV__
`define __BASE_BFM_CFG_OBJ_SV__

class base_bfm_cfg_obj extends base_cfg_obj;

    `uvm_object_utils(base_bfm_cfg_obj)

    int num_txn = 100;
    bit bfm_en  = 1'b0;
    bit run_forever = 1'b0;

    function new(string name = "base_bfm_cfg_obj");
        super.new(name);
    endfunction: new

    virtual function bit check_cfg();
        return 1'b1;
    endfunction: check_cfg

endclass: base_bfm_cfg_obj

`endif //__BASE_BFM_CFG_OBJ_SV__