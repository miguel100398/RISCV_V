//File: riscv_v_alu_scbd.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector ALU Scoreboard

`ifndef __RISCV_V_ALU_SCBD_SV__
`define __RISCV_V_ALU_SCBD_SV__ 

class riscv_v_alu_scbd extends riscv_v_base_scbd#(
                                                 .seq_item_in_t(riscv_v_alu_in_seq_item),
                                                 .seq_item_out_t(riscv_v_alu_out_seq_item),
                                                 .model_t(riscv_v_alu_model) );
    `uvm_component_utils(riscv_v_alu_scbd)

    riscv_v_logic_alu_in_seq_item       logic_in_txn;
    riscv_v_arithmetic_alu_in_seq_item  arithmetic_in_txn;
    riscv_v_mask_alu_in_seq_item        mask_in_txn;
    riscv_v_permutation_alu_in_seq_item permutation_in_txn;

    //riscv_v_arithmetic_ops     arithmetic_ops;
    //riscv_v_logic_ops          logic_ops;
    riscv_v_mask_ops           mask_ops;
    riscv_v_permutation_ops    permutation_ops;

    //Expected results
    riscv_v_wb_data_t  logic_exp_result;
    riscv_v_wb_data_t  arithmetic_exp_result;
    riscv_v_mask_t     mask_exp_result;
    riscv_v_wb_data_t  permutation_exp_vec_result;
    riscv_data_t       permutation_exp_int_result;
    riscv_v_zf_t       zf_exp;
    riscv_v_of_t       of_exp;
    riscv_v_cf_t       cf_exp;

    function new(string name = "riscv_v_alu_scbd", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function build_phase(uvm_phase phase);
        super.build_phase(phase);

        //arithmetic_ops  = riscv_v_arithmetic_ops::type_id::create("arithmetic_ops", this);
        //logic_ops       = riscv_v_logic_ops::type_id::create("logic_ops", this);
        mask_ops        = riscv_v_mask_ops::type_id::create("mask_ops", this);
        permutation_ops = riscv_v_permutation_ops::type_id::create("permutation_ops", this);

    endfunction: build_phase

    virtual function void calc_in();
        //Cast transaction
        calc_valid();
        if ($cast(logic_in_txn, txn_in)) begin
            calc_logic();
        end else if ($cast(arithmetic_in_txn, txn_in))begin
            calc_arithmetic();
        end else if ($cast(mask_in_txn, txn_in)) begin
            calc_mask();
        end else if ($cast(permutation_in_txn, txn_in)) begin 
            calc_permutation();
        end else begin
            `uvm_fatal(get_name(), "Can't cast alu_seq_in to valid specific_alu_seq_in")
        end
    endfunction: calc_in 

    virtual function void calc_out();
        case(txn_out.ALU) 
            LOGIC_ALU: compare_logic();
            ARITHMETIC_ALU: compare_arithmetic();
            MASK_ALU: compare_mask();
            PERMUTATION_ALU: compare_permutation();
            default:   `uvm_fatal(get_name(), "Invalid ALU found in txn_out")
        endcase
    endfunction: calc_out

    virtual function void calc_logic();
        case(logic_in_txn.opcode)
        /*
            BW_AND:         logic_ops.calc_bw_and(logic_in_txn,         logic_exp_result);
            BW_AND_REDUCT:  logic_ops.calc_bw_and_reduct(logic_in_txn,  logic_exp_result);
            BW_OR:          logic_ops.calc_bw_or(logic_in_txn,          logic_exp_result);
            BW_OR_REDUCT:   logic_ops.calc_bw_or_reduct(logic_in_txn,   logic_exp_result);
            BW_XOR:         logic_ops.calc_bw_xor(logic_in_txn,         logic_exp_result);
            BW_XOR_REDUCT:  logic_ops.calc_bw_xor_reduct(logic_in_txn,  logic_exp_result);
            SLL:            logic_ops.calc_sll(logic_in_txn,            logic_exp_result);
            SRL:            logic_ops.calc_srl(logic_in_txn,            logic_exp_result);
            SRA:            logic_ops.calc_sra(logic_in_txn,            logic_exp_result);
            */
            default:        `uvm_fatal(get_name(), "Invalid Logic ALU op")
        endcase
    endfunction: calc_logic

    virtual function void calc_arithmetic();
        case(arithmetic_in_txn.opcode)
        /*
            ADDC:           arithmetic_ops.calc_addc(arithmetic_in_txn,         zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            ADD:            arithmetic_ops.calc_add(arithmetic_in_txn,          zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            ADD_REDUCT:     arithmetic_ops.calc_add_reduct(arithmetic_in_txn,   zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            SUBB:           arithmetic_ops.calc_subb(arithmetic_in_txn,         zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            SUB:            arithmetic_ops.calc_sub(arithmetic_in_txn,          zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            SUB_REDUCT:     arithmetic_ops.calc_sub_reduct(arithmetic_in_txn,   zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            SIGN_EXT:       arithmetic_ops.calc_sign_ext(arithmetic_in_txn,     zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            ZERO_EXT:       arithmetic_ops.calc_zero_ext(arithmetic_in_txn,     zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            MINS:           arithmetic_ops.calc_mins(arithmetic_in_txn,         zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            MINS_REDUCT:    arithmetic_ops.calc_mins_reduct(arithmetic_in_txn,  zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            MINU:           arithmetic_ops.calc_minu(arithmetic_in_txn,         zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            MINU_REDUCT:    arithmetic_ops.calc_minu_reduct(arithmetic_in_txn,  zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            MAXS:           arithmetic_ops.calc_maxs(arithmetic_in_txn,         zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            MAXS_REDUCT:    arithmetic_ops.calc_maxs_reduct(arithmetic_in_txn,  zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            MAXU:           arithmetic_ops.calc_maxu(arithmetic_in_txn,         zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            MAXU_REDUCT:    arithmetic_ops.calc_maxu_reduct(arithmetic_in_txn,  zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            MULLU:          arithmetic_ops.calc_mullu(arithmetic_in_txn,        zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            MULLS:          arithmetic_ops.calc_mulls(arithmetic_in_txn,        zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            MULHU:          arithmetic_ops.calc_mulhu(arithmetic_in_txn,        zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            MULHS:          arithmetic_ops.calc_mulhs(arithmetic_in_txn,        zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            SEQ:            arithmetic_ops.calc_seq(arithmetic_in_txn,          zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            SNE:            arithmetic_ops.calc_sne(arithmetic_in_txn,          zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            SLE:            arithmetic_ops.calc_sle(arithmetic_in_txn,          zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            SLEU:           arithmetic_ops.calc_sleu(arithmetic_in_txn,         zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            SLT:            arithmetic_ops.calc_slt(arithmetic_in_txn,          zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            SLTU:           arithmetic_ops.calc_sltu(arithmetic_in_txn,         zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            SGT:            arithmetic_ops.calc_sgt(arithmetic_in_txn,          zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            SGTU:           arithmetic_ops.calc_sgtu(arithmetic_in_txn,         zf_exp, of_exp, cf_exp, arithmetic_exp_result);
            */
            default:        `uvm_fatal(get_name(), "Invalid arithmetic ALU op")
        endcase
    endfunction: calc_arithmetic

    virtual function void calc_mask();
        case(mask_in_txn.opcode)
            MAND:   mask_ops.calc_mand(mask_in_txn,     mask_exp_result);
            MNAND:  mask_ops.calc_mnand(mask_in_txn,    mask_exp_result);
            MANDN:  mask_ops.calc_mandn(mask_in_txn,    mask_exp_result);
            MOR:    mask_ops.calc_mor(mask_in_txn,      mask_exp_result);
            MNOR:   mask_ops.calc_mnor(mask_in_txn,     mask_exp_result);
            MORN:   mask_ops.calc_morn(mask_in_txn,     mask_exp_result);
            MXOR:   mask_ops.calc_mxor(mask_in_txn,     mask_exp_result);
            MXNOR:  mask_ops.calc_mxnor(mask_in_txn,    mask_exp_result);
            default: `uvm_fatal(get_name(), "Invalid mask ALU op")
        endcase
    endfunction: calc_mask

    virtual function void calc_permutation();
        case(permutation_in_txn.opcode)
            I2V: permutation_ops.calc_i2v(permutation_in_txn, permutation_exp_vec_result, permutation_exp_int_result);
            V2I: permutation_ops.calc_v2i(permutation_in_txn, permutation_exp_vec_result, permutation_exp_int_result);
            default: `uvm_fatal(get_name(), "Invalid permutation ALU op")
        endcase
    endfunction: calc_permutation

    virtual function void compare_logic();
        bit comp = 1;
        comp &= logic_exp_result.valid == txn_out.result.valid;
        for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
            if (logic_exp_result.valid[i]) begin
                comp &= logic_exp_result.data.Byte[i] == txn_out.result.data.Byte[i];
            end
        end
        if (comp) begin
            pass();
        end else begin
            `uvm_error(get_name(), $sformatf("Compare mismatch, actual.valid: 0x%0h, actual.data 0x%0h, exp.valid: 0x%0h, exp.data: 0x%0h", txn_out.result.valid, txn_out.result.data, logic_exp_result.valid, logic_exp_result.data))
            fail();
        end
    endfunction: compare_logic

    virtual function void compare_arithmetic();
        bit comp = 1;
        comp &= arithmetic_exp_result.valid == txn_out.result.valid;
        for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
            if (arithmetic_exp_result.valid[i]) begin
                comp &= arithmetic_exp_result.data.Byte[i] == txn_out.result.data.Byte[i];
            end
        end
        if (~arithmetic_in_txn.is_reduct) begin
            comp &= compare_flags(arithmetic_in_txn.osize, arithmetic_exp_result.valid);
        end
        if (comp) begin
            pass();
        end else begin
            `uvm_error(get_name(), $sformatf("Compare mismatch, actual.valid: 0x%0h, actual.data: 0x%0h, actual.zf: 0x%0h, actual.of: 0x%0h, actual.cf: 0x%0h, exp.valid: 0x%0h, exp.data: 0x%0h, exp.zf: 0x%0h, exp.of: 0x%0h, exp.cf: 0x%0h", txn_out.result.valid, txn_out.result.data, txn_out.zf, txn_out.of, txn_out.cf, arithmetic_exp_result.valid, arithmetic_exp_result.data, zf_exp, of_exp, cf_exp))
            fail();
        end
    endfunction: compare_arithmetic

    virtual function void compare_mask();
        riscv_v_mask_alu_out_seq_item mask_txn_out;
        bit comp = 1;

        if (!$cast(mask_txn_out, txn_out)) begin
            `uvm_fatal(get_name(), "Can't cast txn_out to mask_txn_out")
        end

        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            comp &= mask_exp_result[i]  == mask_txn_out.result_mask[i];
        end

        if (comp) begin
            pass();
        end else begin
            `uvm_error(get_name(), $sformatf("Compare mismatch, actual.data: 0x%0h, exp.data: 0x%0h", mask_txn_out.result_mask, mask_exp_result))
            fail();
        end
    endfunction: compare_mask

    virtual function void compare_permutation();
        riscv_v_permutation_alu_out_seq_item permutation_txn_out;
        bit comp = 1;
        if (!$cast(permutation_txn_out, txn_out)) begin
            `uvm_fatal(get_name(), "Can't cast txn_out to permutation_txn_out")
        end

        comp &= (permutation_exp_int_result       == permutation_txn_out.integer_data_out);
        comp &= (permutation_exp_vec_result.data  == permutation_txn_out.vector_data_out.data);
        comp &= (permutation_exp_vec_result.valid == permutation_txn_out.vector_data_out.valid);

        if (comp) begin
            pass();
        end else begin
            `uvm_error(get_name(), $sformatf("Compare mismatch, actual_int.data: 0x%0h, actual_vec.data: 0x%0h, actual_vec.valid: 0x%0h, exp_int.data: 0x%0h, exp_vec.data: 0x%0h, exp_vec.valid: 0x%0h", permutation_txn_out.integer_data_out, permutation_txn_out.vector_data_out.data, permutation_txn_out.vector_data_out.valid, permutation_exp_int_result, permutation_exp_vec_result.data, permutation_exp_vec_result.valid))
            fail();
        end

    endfunction: compare_permutation

    virtual function bit compare_flags(riscv_v_osize_e osize, riscv_v_valid_data_t valid);
        bit comp = 1;
        case (osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
                    if (valid[i]) begin
                        comp &= zf_exp[i] == txn_out.zf[i];
                        comp &= cf_exp[i] == txn_out.cf[i];
                        comp &= of_exp[i] == txn_out.of[i];
                    end
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_NUM_WORDS_DATA; i++) begin
                    if (valid[(i*2)+1]) begin
                        comp &= zf_exp[(i*2)+1] == txn_out.zf[(i*2)+1];
                        comp &= cf_exp[(i*2)+1] == txn_out.cf[(i*2)+1];
                        comp &= of_exp[(i*2)+1] == txn_out.of[(i*2)+1];
                    end
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_NUM_DWORDS_DATA; i++) begin
                    if (valid[(i*4)+3]) begin
                        comp &= zf_exp[(i*4)+3] == txn_out.zf[(i*4)+3];
                        comp &= cf_exp[(i*4)+3] == txn_out.cf[(i*4)+3];
                        comp &= of_exp[(i*4)+3] == txn_out.of[(i*4)+3];
                    end
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_NUM_QWORDS_DATA; i++) begin
                    if (valid[(i*8)+7]) begin
                        comp &= zf_exp[(i*8)+7] == txn_out.zf[(i*8)+7];
                        comp &= cf_exp[(i*8)+7] == txn_out.cf[(i*8)+7];
                        comp &= of_exp[(i*8)+7] == txn_out.of[(i*8)+7];
                    end
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_NUM_DQWORDS_DATA; i++) begin
                    if (valid[(i*16)+15]) begin
                        comp &= zf_exp[(i*16)+15] == txn_out.zf[(i*16)+15];
                        comp &= cf_exp[(i*16)+15] == txn_out.cf[(i*16)+15];
                        comp &= of_exp[(i*16)+15] == txn_out.of[(i*16)+15];
                    end
                end
            end
            default: `uvm_fatal(get_name(), "Invalid osize in compare_flags()")
        endcase
        return comp;
    endfunction: compare_flags

    virtual function void calc_valid();
        logic_exp_result.valid = txn_in.srca.valid;
        arithmetic_exp_result.valid = txn_in.srca.valid;
    endfunction: calc_valid

endclass: riscv_v_alu_scbd

`endif // __RISCV_V_ALU_SCBD_SV__