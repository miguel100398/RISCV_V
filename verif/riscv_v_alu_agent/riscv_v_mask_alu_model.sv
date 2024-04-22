//File: riscv_v_mask_alu_model
//Author: Miguel Bucio
//Date: 16/04/24
//Description: RiscV V mask ALU Model

`ifndef __RISCV_V_MASK_ALU_MODEL__
`define __RISCV_V_MASK_ALU_MODEL__ 

class riscv_v_mask_alu_model extends riscv_v_alu_base_model;
    `uvm_component_utils(riscv_v_mask_alu_model)

    function new(string name = "riscv_v_mask_alu_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new 

    virtual function riscv_v_data_t execute_vec_op(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_opcode_e opcode, riscv_v_osize_e src_osize, riscv_v_osize_e dst_osize, riscv_v_vlen_t len, riscv_v_src_start_t start);
        riscv_v_data_t result = 'x;
        riscv_v_src_len_t len_op;
        
        len_op = get_len_op(len, dst_osize);
        
        unique case(opcode)
            default : `uvm_fatal(get_name(), $sformatf("Invalid opcode: %s", opcode.name()))
        endcase

        return result;
    endfunction: execute_vec_op

endclass: riscv_v_mask_alu_model

`endif //__RISCV_V_MASK_ALU_MODEL__ 