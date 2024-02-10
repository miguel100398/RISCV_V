//File: base_cfg_obj.sv
//Author: Miguel Bucio
//Date: 21/01/24
//Description: Base configuration object 

`ifndef __BASE_CFG_OBJ_SV__
`define __BASE_CFG_OBJ_SV__ 

class base_cfg_obj extends  uvm_object;

    `uvm_object_utils(base_cfg_obj)

    function new(string name = "base_cfg_obj");
        super.new(name);
    endfunction: new 

endclass: base_cfg_obj 

`endif //__BASE_CFG_OBJ_SV__ 