//File: riscv_v_model
//Author: Miguel Bucio
//Date: 12/02/24
//Description: RiscV V Instruction Fetch Model

`ifndef __RISCV_V_MODEL_SV__
`define __RISCV_V_MODEL_SV__ 

class riscv_v_model extends riscv_v_base_model;

    `uvm_component_utils(riscv_v_model)

    riscv_v_decode_model decode_model;

    function new(string name = "riscv_v_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new 

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Models
        decode_model = riscv_v_decode_model::type_id::create("riscv_v_decode_model", this);
    endfunction: build_phase

    virtual function void rst();
        return;
    endfunction: rst

endclass: riscv_v_model 

`endif //__RISCV_V_MODEL_SV__