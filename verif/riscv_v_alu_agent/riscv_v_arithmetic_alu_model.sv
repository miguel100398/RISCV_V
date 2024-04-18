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
            ADD : result = calc_add(srca, srcb, is_scalar, dst_osize);
            default : `uvm_fatal(get_name(), $sformatf("Invalid opcode: %s", opcode.name()))
        endcase

        return result;
    endfunction: execute_vec_op

    virtual function riscv_v_data_t calc_add(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize);

        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case(osize)

                OSIZE_8 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_BYTES_DATA; idx++) begin
                        result.Byte[idx] = signed'(srca.Byte[idx]) + signed'(srcb.Byte[idx]);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_WORDS_DATA; idx++) begin
                        result.Word[idx] = signed'(srca.Word[idx]) + signed'(srcb.Word[idx]);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_DWORDS_DATA; idx++) begin
                        result.Dword[idx] = signed'(srca.Dword[idx]) + signed'(srcb.Dword[idx]);
                    end
                end
                OSIZE_64 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_QWORDS_DATA; idx++) begin
                        result.Qword[idx] = signed'(srca.Qword[idx]) + signed'(srcb.Qword[idx]);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_DQWORDS_DATA; idx++) begin
                        result.Dqword[idx] = signed'(srca.Dqword[idx]) + signed'(srcb.Dqword[idx]);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: ", osize.name()))

            endcase

        end else begin

            unique case(osize)

                OSIZE_8 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_BYTES_DATA; idx++) begin
                        result.Byte[idx] = signed'(srca.Byte[0]) + signed'(srcb.Byte[idx]);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_WORDS_DATA; idx++) begin
                        result.Word[idx] = signed'(srca.Word[0]) + signed'(srcb.Word[idx]);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_DWORDS_DATA; idx++) begin
                        result.Dword[idx] = signed'(srca.Dword[0]) + signed'(srcb.Dword[idx]);
                    end
                end
                OSIZE_64 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_QWORDS_DATA; idx++) begin
                        result.Qword[idx] = signed'(srca.Qword[0]) + signed'(srcb.Qword[idx]);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = 0; idx < RISCV_V_NUM_DQWORDS_DATA; idx++) begin
                        result.Dqword[idx] = signed'(srca.Dqword[0]) + signed'(srcb.Dqword[idx]);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: ", osize.name()))

            endcase

        end

        return result;

    endfunction: calc_add

endclass: riscv_v_arithmetic_alu_model

`endif //__RISCV_V_ARITHMETIC_ALU_MODEL__ 