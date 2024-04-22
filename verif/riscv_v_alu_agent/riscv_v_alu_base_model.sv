//File: riscv_v_alu_model.sv
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISCV V Extension ALU Model

`ifndef __RISCV_V_ALU_BASE_MODEL_SV__
`define __RISCV_V_ALU_BASE_MODEL_SV__ 

virtual class riscv_v_alu_base_model extends riscv_v_base_model;
    
    `uvm_component_utils(riscv_v_alu_base_model)

    function new(string name = "riscv_v_alu_base_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new 

    virtual function  void rst();
        return;
    endfunction: rst 

    pure virtual function riscv_v_data_t execute_vec_op(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_opcode_e opcode, riscv_v_osize_e src_osize, riscv_v_osize_e dst_osize, riscv_v_src_len_t len, riscv_v_src_start_t start);



endclass: riscv_v_alu_base_model

`endif //__RISCV_V_ALU_BASE_MODEL_SV__ 