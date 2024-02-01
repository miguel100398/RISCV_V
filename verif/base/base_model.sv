//File: base_model
//Author: Miguel Bucio
//Date: 10/10/23
//Description: base model

`ifndef __BASE_MODEL_SV__
`define __BASE_MODEL_SV__

virtual class base_model extends uvm_component;
`uvm_component_utils(base_model)

function new(string name = "base_model", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

pure virtual function void rst();

endclass: base_model

`endif //__BASE_MODEL_SV__