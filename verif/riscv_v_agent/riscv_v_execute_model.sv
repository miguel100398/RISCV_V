//File: riscv_v_execute_model
//Author: Miguel Bucio
//Date: 16/04/24
//Description: RiscV V Execute Model

`ifndef __RISCV_V_EXECUTE_MODEL__
`define __RISCV_V_EXECUTE_MODEL__

class riscv_v_execute_model extends riscv_v_base_model;
    `uvm_component_utils(riscv_v_execute_model)

    function new(string name = "riscv_v_execute_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual function void rst();
        return;
    endfunction: rst 

    virtual function void execute_op(
        input  riscv_v_opcode_e   opcode,
        input  riscv_v_osize_e    src_osize,
        input  riscv_v_osize_e    dst_osize,
        input  riscv_v_alu_e      ALU,
        input  bit                is_scalar,
        input  riscv_v_src_type_t srca_type,
        input  riscv_v_src_type_t srcb_type,
        input  riscv_v_data_t     srca_vec,
        input  riscv_v_data_t     srcb_vec,
        input  riscv_data_t       src_int,
        input  riscv_v_imm_t      src_imm,
        output riscv_v_wb_data_t  vec_result,
        output riscv_data_t       int_result
    );
        riscv_v_data_t srca;
        riscv_v_data_t srcb;

        vec_result = 'x;
        int_result = 'x;

        //Format sources if one source is scalar
        srca = get_src(srca_type, srca_vec, src_int, src_imm, src_osize);
        srcb = get_src(srcb_type, srcb_vec, src_int, src_imm, src_osize);

        //Execute op in ALU
        unique case(ALU)
            LOGIC_ALU : begin
                
            end
            ARITHMETIC_ALU : begin
                
            end
            MASK_ALU : begin
                
            end
            PERMUTATION_ALU : begin
                
            end
            default : `uvm_fatal(get_name(), $sformatf("Invalid ALU: %s", ALU.name()))
        endcase

    endfunction: execute_op

    virtual function riscv_v_data_t get_src(riscv_v_src_type_t src_type, riscv_v_data_t src_vec, riscv_data_t src_int, riscv_v_imm_t src_imm, riscv_v_osize_e osize);
        riscv_v_data_t src;

        src = 'x;

        unique case(src_type)
            SRC_VEC : begin
                src =  src_vec;
            end
            SRC_SCALAR_VEC : begin
                unique case(osize)
                    OSIZE_8: begin
                        src.Byte[0] = src_vec.Byte[0];
                    end
                    OSIZE_16: begin
                        src.Word[0] = src_vec.Word[0];
                    end
                    OSIZE_32: begin
                        src.Dword[0] = src_vec.Dword[0];
                    end
                    OSIZE_64: begin
                        src.Qword[0] = src_vec.Qword[0];
                    end
                    OSIZE_128: begin
                        src.Dqword[0] = src_vec.Dqword[0];
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid OSIZE:%0s", osize.name()))
                endcase
            end
            SRC_SCALAR_INT : begin
                unique case(osize)
                    OSIZE_8: begin
                        src.Byte[0] = src_int[BYTE_WIDTH-1 : 0];
                    end
                    OSIZE_16: begin
                        src.Word[0] = src_int[WORD_WIDTH-1 : 0];
                    end
                    OSIZE_32: begin
                        src.Dword[0] = src_int[DWORD_WIDTH-1 : 0];
                    end
                    OSIZE_64: begin
                        src.Qword[0] = `RISCV_V_SX(src_int, 64);
                    end
                    OSIZE_128: begin
                        src.Dqword[0] = `RISCV_V_SX(src_int, 128);
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid OSIZE:%0s", osize.name()))
                endcase
            end
            SRC_SCALAR_IMM : begin
                unique case(osize)
                    OSIZE_8: begin
                        src.Byte[0] = `RISCV_V_SX(src_imm, 8);
                    end
                    OSIZE_16: begin
                        src.Word[0] = `RISCV_V_SX(src_imm, 16);
                    end
                    OSIZE_32: begin
                        src.Dword[0] = `RISCV_V_SX(src_imm, 32);
                    end
                    OSIZE_64: begin
                        src.Qword[0] = `RISCV_V_SX(src_imm, 64);
                    end
                    OSIZE_128: begin
                        src.Dqword[0] = `RISCV_V_SX(src_imm, 128);
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid OSIZE:%0s", osize.name()))
                endcase
            end
            SRC_SCALAR_FP : begin
                `uvm_fatal(get_name(), "SRC_SCALAR_FP not supported yet")
            end
            default : `uvm_fatal(get_name(), $sformatf("Invalid SRC_TYPE: %s", src_type.name()))
        endcase

        return src;

    endfunction: get_src

endclass: riscv_v_execute_model

`endif //__RISCV_V_EXECUTE_MODEL__ 