//File: riscv_v_alu_scbd_logic_ops.sv
//Author: Miguel Bucio
//Date: 17/08/23
//Description: RISC-V Vector ALU Scoreboard

    virtual function void calc_bw_and();
        case(logic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    logic_exp_result.data.Byte[i] = (logic_in_txn.srca.data.Byte[i] & logic_in_txn.srcb.data.Byte[i]);
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    logic_exp_result.data.Word[i] = (logic_in_txn.srca.data.Word[i] & logic_in_txn.srcb.data.Word[i]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dword[i] = (logic_in_txn.srca.data.Dword[i] & logic_in_txn.srcb.data.Dword[i]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    logic_exp_result.data.Qword[i] = (logic_in_txn.srca.data.Qword[i] & logic_in_txn.srcb.data.Qword[i]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dqword[i] = (logic_in_txn.srca.data.Dqword[i] & logic_in_txn.srcb.data.Dqword[i]);
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_bw_and

    virtual function void calc_bw_and_reduct();
        logic_exp_result.data = '0;
        case(logic_in_txn.osize)
            OSIZE_8: begin
                logic_exp_result.data.Byte[0] = logic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1] & logic_in_txn.srcb.data.Byte[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Byte[0] &= logic_in_txn.srcb.data.Byte[i];
                end
            end
            OSIZE_16: begin
                logic_exp_result.data.Word[0] = logic_in_txn.srca.data.Word[RISCV_V_NUM_WORDS_DATA-1] & logic_in_txn.srcb.data.Word[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Word[0] &= logic_in_txn.srcb.data.Word[i];
                end
            end
            OSIZE_32: begin
                logic_exp_result.data.Dword[0] = logic_in_txn.srca.data.Dword[RISCV_V_NUM_DWORDS_DATA-1] & logic_in_txn.srcb.data.Dword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Dword[0] &= logic_in_txn.srcb.data.Dword[i];
                end
            end
            OSIZE_64: begin
                logic_exp_result.data.Qword[0] = logic_in_txn.srca.data.Qword[RISCV_V_NUM_QWORDS_DATA-1] & logic_in_txn.srcb.data.Qword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Qword[0] &= logic_in_txn.srcb.data.Qword[i];
                end
            end
            OSIZE_128: begin
                logic_exp_result.data.Dqword[0] = logic_in_txn.srca.data.Dqword[RISCV_V_NUM_DQWORDS_DATA-1] & logic_in_txn.srcb.data.Dqword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Dqword[0] &= logic_in_txn.srcb.data.Dqword[i];
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_bw_and_reduct

    virtual function void calc_bw_or();
        case(logic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    logic_exp_result.data.Byte[i] = (logic_in_txn.srca.data.Byte[i] | logic_in_txn.srcb.data.Byte[i]);
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    logic_exp_result.data.Word[i] = (logic_in_txn.srca.data.Word[i] | logic_in_txn.srcb.data.Word[i]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dword[i] = (logic_in_txn.srca.data.Dword[i] | logic_in_txn.srcb.data.Dword[i]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    logic_exp_result.data.Qword[i] = (logic_in_txn.srca.data.Qword[i] | logic_in_txn.srcb.data.Qword[i]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dqword[i] = (logic_in_txn.srca.data.Dqword[i] | logic_in_txn.srcb.data.Dqword[i]);
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_bw_or

    virtual function void calc_bw_or_reduct();
        logic_exp_result.data = '0;
        case(logic_in_txn.osize)
            OSIZE_8: begin
                logic_exp_result.data.Byte[0] = logic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1] | logic_in_txn.srcb.data.Byte[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Byte[0] |= logic_in_txn.srcb.data.Byte[i];
                end
            end
            OSIZE_16: begin
                logic_exp_result.data.Word[0] = logic_in_txn.srca.data.Word[RISCV_V_NUM_WORDS_DATA-1] | logic_in_txn.srcb.data.Word[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Word[0] |= logic_in_txn.srcb.data.Word[i];
                end
            end
            OSIZE_32: begin
                logic_exp_result.data.Dword[0] = logic_in_txn.srca.data.Dword[RISCV_V_NUM_DWORDS_DATA-1] | logic_in_txn.srcb.data.Dword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Dword[0] |= logic_in_txn.srcb.data.Dword[i];
                end
            end
            OSIZE_64: begin
                logic_exp_result.data.Qword[0] = logic_in_txn.srca.data.Qword[RISCV_V_NUM_QWORDS_DATA-1] | logic_in_txn.srcb.data.Qword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Qword[0] |= logic_in_txn.srcb.data.Qword[i];
                end
            end
            OSIZE_128: begin
                logic_exp_result.data.Dqword[0] = logic_in_txn.srca.data.Dqword[RISCV_V_NUM_DQWORDS_DATA-1] | logic_in_txn.srcb.data.Dqword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Dqword[0] |= logic_in_txn.srcb.data.Dqword[i];
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_bw_or_reduct

    virtual function void calc_bw_xor();
        case(logic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    logic_exp_result.data.Byte[i] = (logic_in_txn.srca.data.Byte[i] ^ logic_in_txn.srcb.data.Byte[i]);
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    logic_exp_result.data.Word[i] = (logic_in_txn.srca.data.Word[i] ^ logic_in_txn.srcb.data.Word[i]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dword[i] = (logic_in_txn.srca.data.Dword[i] ^ logic_in_txn.srcb.data.Dword[i]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    logic_exp_result.data.Qword[i] = (logic_in_txn.srca.data.Qword[i] ^ logic_in_txn.srcb.data.Qword[i]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dqword[i] = (logic_in_txn.srca.data.Dqword[i] ^ logic_in_txn.srcb.data.Dqword[i]);
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_bw_xor

    virtual function void calc_bw_xor_reduct();
        logic_exp_result.data = '0;
        case(logic_in_txn.osize)
            OSIZE_8: begin
                logic_exp_result.data.Byte[0] = logic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1] ^ logic_in_txn.srcb.data.Byte[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Byte[0] ^= logic_in_txn.srcb.data.Byte[i];
                end
            end
            OSIZE_16: begin
                logic_exp_result.data.Word[0] = logic_in_txn.srca.data.Word[RISCV_V_NUM_WORDS_DATA-1] ^ logic_in_txn.srcb.data.Word[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Word[0] ^= logic_in_txn.srcb.data.Word[i];
                end
            end
            OSIZE_32: begin
                logic_exp_result.data.Dword[0] = logic_in_txn.srca.data.Dword[RISCV_V_NUM_DWORDS_DATA-1] ^ logic_in_txn.srcb.data.Dword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Dword[0] ^= logic_in_txn.srcb.data.Dword[i];
                end
            end
            OSIZE_64: begin
                logic_exp_result.data.Qword[0] = logic_in_txn.srca.data.Qword[RISCV_V_NUM_QWORDS_DATA-1] ^ logic_in_txn.srcb.data.Qword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Qword[0] ^= logic_in_txn.srcb.data.Qword[i];
                end
            end
            OSIZE_128: begin
                logic_exp_result.data.Dqword[0] = logic_in_txn.srca.data.Dqword[RISCV_V_NUM_DQWORDS_DATA-1] ^ logic_in_txn.srcb.data.Dqword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Dqword[0] ^= logic_in_txn.srcb.data.Dqword[i];
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_bw_xor_reduct

    virtual function void calc_sll();
        logic_exp_result.data = '0;
        case(logic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    logic_exp_result.data.Byte[i] = (logic_in_txn.srca.data.Byte[i] << logic_in_txn.srcb.data.Byte[i][$clog2(BYTE_WIDTH):0]);
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    logic_exp_result.data.Word[i] = (logic_in_txn.srca.data.Word[i] << logic_in_txn.srcb.data.Word[i][$clog2(WORD_WIDTH):0]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dword[i] = (logic_in_txn.srca.data.Dword[i] << logic_in_txn.srcb.data.Dword[i][$clog2(DWORD_WIDTH):0]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    logic_exp_result.data.Qword[i] = (logic_in_txn.srca.data.Qword[i] << logic_in_txn.srcb.data.Qword[i][$clog2(QWORD_WIDTH):0]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dqword[i] = (logic_in_txn.srca.data.Dqword[i] << logic_in_txn.srcb.data.Dqword[i][$clog2(DQWORD_WIDTH):0]);
                end
            end
        endcase
    endfunction: calc_sll

    virtual function void calc_srl();
        logic_exp_result.data = '0;
        case(logic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    logic_exp_result.data.Byte[i] = (logic_in_txn.srca.data.Byte[i] >> logic_in_txn.srcb.data.Byte[i][$clog2(BYTE_WIDTH):0]);
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    logic_exp_result.data.Word[i] = (logic_in_txn.srca.data.Word[i] >> logic_in_txn.srcb.data.Word[i][$clog2(WORD_WIDTH):0]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dword[i] = (logic_in_txn.srca.data.Dword[i] >> logic_in_txn.srcb.data.Dword[i][$clog2(DWORD_WIDTH):0]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    logic_exp_result.data.Qword[i] = (logic_in_txn.srca.data.Qword[i] >> logic_in_txn.srcb.data.Qword[i][$clog2(QWORD_WIDTH):0]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dqword[i] = (logic_in_txn.srca.data.Dqword[i] >> logic_in_txn.srcb.data.Dqword[i][$clog2(DQWORD_WIDTH):0]);
                end
            end
        endcase
    endfunction: calc_srl

    virtual function void calc_sra();
        logic_exp_result.data = '0;
        case(logic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    logic_exp_result.data.Byte[i] = (logic_in_txn.srca.data.Byte[i] >>> logic_in_txn.srcb.data.Byte[i][$clog2(BYTE_WIDTH):0]);
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    logic_exp_result.data.Word[i] = (logic_in_txn.srca.data.Word[i] >>> logic_in_txn.srcb.data.Word[i][$clog2(WORD_WIDTH):0]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dword[i] = (logic_in_txn.srca.data.Dword[i] >>> logic_in_txn.srcb.data.Dword[i][$clog2(DWORD_WIDTH):0]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    logic_exp_result.data.Qword[i] = (logic_in_txn.srca.data.Qword[i] >>> logic_in_txn.srcb.data.Qword[i][$clog2(QWORD_WIDTH):0]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dqword[i] = (logic_in_txn.srca.data.Dqword[i] >>> logic_in_txn.srcb.data.Dqword[i][$clog2(DQWORD_WIDTH):0]);
                end
            end
        endcase
    endfunction: calc_sra
