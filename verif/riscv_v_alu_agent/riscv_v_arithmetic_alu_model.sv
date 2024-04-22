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

    virtual function riscv_v_data_t execute_vec_op(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_opcode_e opcode, riscv_v_osize_e src_osize, riscv_v_osize_e dst_osize, riscv_v_vlen_t len, riscv_v_src_start_t start);
        riscv_v_data_t result = 'x;
        riscv_v_src_len_t len_op;

        len_op = get_len_op(len, dst_osize);
        
        unique case(opcode)
            ADD        : result = calc_add(srca, srcb, is_scalar, dst_osize, len_op, start);
            ADD_REDUCT : result = calc_add_reduct(srca, srcb, dst_osize, len_op, start);
            default : `uvm_fatal(get_name(), $sformatf("Invalid opcode: %s", opcode.name()))
        endcase

        return result;
    endfunction: execute_vec_op

    virtual function riscv_v_data_t calc_add(riscv_v_data_t srca, riscv_v_data_t srcb, bit is_scalar, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start);

        riscv_v_data_t result;
        result = 'x;

        if (~is_scalar) begin

            unique case(osize)

                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = signed'(srca.Byte[idx]) + signed'(srcb.Byte[idx]);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = signed'(srca.Word[idx]) + signed'(srcb.Word[idx]);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = signed'(srca.Dword[idx]) + signed'(srcb.Dword[idx]);
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = signed'(srca.Qword[idx]) + signed'(srcb.Qword[idx]);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = signed'(srca.Dqword[idx]) + signed'(srcb.Dqword[idx]);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: ", osize.name()))

            endcase

        end else begin

            unique case(osize)

                OSIZE_8 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Byte[idx] = signed'(srca.Byte[0]) + signed'(srcb.Byte[idx]);
                    end
                end
                OSIZE_16 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Word[idx] = signed'(srca.Word[0]) + signed'(srcb.Word[idx]);
                    end
                end
                OSIZE_32 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dword[idx] = signed'(srca.Dword[0]) + signed'(srcb.Dword[idx]);
                    end
                end
                OSIZE_64 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Qword[idx] = signed'(srca.Qword[0]) + signed'(srcb.Qword[idx]);
                    end
                end
                OSIZE_128 : begin
                    for (int idx = start; idx < len; idx++) begin
                        result.Dqword[idx] = signed'(srca.Dqword[0]) + signed'(srcb.Dqword[idx]);
                    end
                end
                default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: ", osize.name()))

            endcase

        end

        return result;

    endfunction: calc_add

    virtual function riscv_v_data_t calc_add_reduct(riscv_v_data_t srca, riscv_v_data_t srcb, riscv_v_osize_e osize, riscv_v_src_len_t len, riscv_v_src_start_t start);
        riscv_v_data_t result;
        result = 'x;

        if(start != 0) begin
            `uvm_fatal(get_name(), "Start different from 0 not supported for this op, VREDSUM")
        end

        if (len == 0) begin
            return result;
        end

        unique case(osize)
            OSIZE_8 : begin
                result.Byte[0] = signed'(srcb.Byte[0]) + signed'(srca.Byte[0]);
                for (int idx = 1; idx <len; idx++) begin
                    result.Byte[0] = signed'(srcb.Byte[idx]) + signed'(result.Byte[0]);
                end
            end
            OSIZE_16 : begin
                result.Word[0] = signed'(srcb.Word[0]) + signed'(srca.Word[0]);
                for (int idx = 1; idx <len; idx++) begin
                    result.Word[0] = signed'(srcb.Word[idx]) + signed'(result.Word[0]);
                end
            end
            OSIZE_32 : begin
                result.Dword[0] = signed'(srcb.Dword[0]) + signed'(srca.Dword[0]);
                for (int idx = 1; idx < len; idx++) begin
                    result.Dword[0] = signed'(srcb.Dword[idx]) + signed'(result.Dword[0]);
                end
            end
            OSIZE_64 : begin
                result.Qword[0] = signed'(srcb.Qword[0]) + signed'(srca.Qword[0]);
                for (int idx = 1; idx < len; idx++) begin
                    result.Qword[0] = signed'(srcb.Qword[idx]) + signed'(result.Qword[0]);
                end
            end
            default : `uvm_fatal(get_name(), $sformatf("invalid OSIZE: ", osize.name()))
        endcase 

        return result;
    endfunction: calc_add_reduct

endclass: riscv_v_arithmetic_alu_model

`endif //__RISCV_V_ARITHMETIC_ALU_MODEL__ 