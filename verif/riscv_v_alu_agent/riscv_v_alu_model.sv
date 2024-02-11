//File: riscv_v_alu_model.sv
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISCV V Extension ALU Model

`ifndef __RISCV_V_ALU_MODEL_SV__
`define __RISCV_V_ALU_MODEL_SV__ 

class riscv_v_alu_model extends riscv_v_base_model;
    
    `uvm_component_utils(riscv_v_alu_model)

    function new(string name = "riscv_v_alu_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new 

    virtual function  void rst();
        return;
    endfunction: rst 


endclass: riscv_v_alu_model

`endif //__RISCV_V_ALU_MODEL_SV__ 