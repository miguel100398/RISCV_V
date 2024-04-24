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

    virtual function riscv_v_src_len_t get_len_op(riscv_v_vlen_t len, riscv_v_osize_e osize);

        riscv_v_src_len_t len_op;

        unique case(osize)

                OSIZE_8 : begin
                    len_op = (len > RISCV_V_NUM_BYTES_DATA) ? RISCV_V_NUM_BYTES_DATA : len;
                end
                OSIZE_16 : begin
                    len_op = (len > RISCV_V_NUM_WORDS_DATA) ? RISCV_V_NUM_WORDS_DATA : len;
                end
                OSIZE_32 : begin
                    len_op = (len > RISCV_V_NUM_DWORDS_DATA) ? RISCV_V_NUM_DWORDS_DATA : len;
                end
                OSIZE_64 : begin
                    len_op = (len > RISCV_V_NUM_QWORDS_DATA) ? RISCV_V_NUM_QWORDS_DATA : len;
                end
                OSIZE_128 : begin
                    len_op = (len > RISCV_V_NUM_DQWORDS_DATA) ? RISCV_V_NUM_DQWORDS_DATA : len;
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: %0s", osize.name()))

            endcase

            return len_op;

    endfunction: get_len_op

    pure virtual function riscv_v_data_t execute_vec_op(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_opcode_e opcode, riscv_v_osize_e src_osize, riscv_v_osize_e dst_osize, riscv_v_vlen_t len, riscv_v_src_start_t start, riscv_v_mask_t mask, riscv_v_mask_t dst_mask_merge, bit use_mask);



endclass: riscv_v_alu_base_model

`endif //__RISCV_V_ALU_BASE_MODEL_SV__ 