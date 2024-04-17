//File: riscv_v_arithmetic_alu_model
//Author: Miguel Bucio
//Date: 16/04/24
//Description: RiscV V arithmetic ALU Model

`ifndef __RISCV_V_ARITHMETIC_ALU_MODEL__
`define __RISCV_V_ARITHMETIC_ALU_MODEL__ 

class riscv_v_arithmetic_alu_model extends riscv_v_alu_base_model;
    `uvm_component_utils(riscv_v_arithmetic_alu_model)

    function new(string name = "riscv_v_arithmetic_alu_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new 

    virtual function riscv_v_data_t execute_vec_op(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_opcode_e opcode, riscv_v_osize_e src_osize, riscv_v_osize_e dst_osize);
        riscv_v_data_t result = 'x;
        
        unique case(opcode)
            default : `uvm_fatal(get_name(), $sformatf("Invalid opcode: %s", opcode.name()))
        endcase

        return result;
    endfunction: execute_vec_op

endclass: riscv_v_arithmetic_alu_model

`endif //__RISCV_V_ARITHMETIC_ALU_MODEL__ 