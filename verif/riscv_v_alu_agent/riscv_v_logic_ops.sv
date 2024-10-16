//File: riscv_v_logic_ops.sv
//Author: Miguel Bucio
//Date: 17/08/23
//Description: RISC-V Vector ALU Scoreboard

`ifndef __RISCV_V_LOGIC_OPS_SV__
`define __RISCV_V_LOGIC_OPS_SV__

class riscv_v_logic_ops extends uvm_component;

    `uvm_component_utils(riscv_v_logic_ops)

    function new(string name = "riscv_v_logic_ops", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void calc_bw_and(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
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

    virtual function void calc_bw_and_reduct(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        logic_exp_result.data = '0;
        case(logic_in_txn.osize)
            OSIZE_8: begin
                logic_exp_result.data.Byte[0] = logic_in_txn.srca.data.Byte[0] & logic_in_txn.srcb.data.Byte[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Byte[i] = logic_in_txn.srcb.data.Byte[i] & logic_exp_result.data.Byte[i-1];
                end
            end
            OSIZE_16: begin
                logic_exp_result.data.Word[0] = logic_in_txn.srca.data.Word[0] & logic_in_txn.srcb.data.Word[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Word[i] = logic_in_txn.srcb.data.Word[i] & logic_exp_result.data.Word[i-1];
                end
            end
            OSIZE_32: begin
                logic_exp_result.data.Dword[0] = logic_in_txn.srca.data.Dword[0] & logic_in_txn.srcb.data.Dword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Dword[i] = logic_in_txn.srcb.data.Dword[i] & logic_exp_result.data.Dword[i-1];
                end
            end
            OSIZE_64: begin
                logic_exp_result.data.Qword[0] = logic_in_txn.srca.data.Qword[0] & logic_in_txn.srcb.data.Qword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Qword[i] = logic_in_txn.srcb.data.Qword[i] & logic_exp_result.data.Qword[i-1];
                end
            end
            OSIZE_128: begin
                logic_exp_result.data.Dqword[0] = logic_in_txn.srca.data.Dqword[0] & logic_in_txn.srcb.data.Dqword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Dqword[i] = logic_in_txn.srcb.data.Dqword[i] & logic_exp_result.data.Dqword[i-1];
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_bw_and_reduct

    virtual function void calc_bw_or(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
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

    virtual function void calc_bw_or_reduct(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        logic_exp_result.data = '0;
        case(logic_in_txn.osize)
            OSIZE_8: begin
                logic_exp_result.data.Byte[0] = logic_in_txn.srca.data.Byte[0] | logic_in_txn.srcb.data.Byte[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Byte[i] = logic_in_txn.srcb.data.Byte[i] | logic_exp_result.data.Byte[i-1] ;
                end
            end
            OSIZE_16: begin
                logic_exp_result.data.Word[0] = logic_in_txn.srca.data.Word[0] | logic_in_txn.srcb.data.Word[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Word[i] = logic_in_txn.srcb.data.Word[i] | logic_exp_result.data.Word[i-1];
                end
            end
            OSIZE_32: begin
                logic_exp_result.data.Dword[0] = logic_in_txn.srca.data.Dword[0] | logic_in_txn.srcb.data.Dword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Dword[i] = logic_in_txn.srcb.data.Dword[i] | logic_exp_result.data.Dword[i-1];
                end
            end
            OSIZE_64: begin
                logic_exp_result.data.Qword[0] = logic_in_txn.srca.data.Qword[0] | logic_in_txn.srcb.data.Qword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Qword[i] = logic_in_txn.srcb.data.Qword[i] | logic_exp_result.data.Qword[i-1];
                end
            end
            OSIZE_128: begin
                logic_exp_result.data.Dqword[0] = logic_in_txn.srca.data.Dqword[0] | logic_in_txn.srcb.data.Dqword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Dqword[i] = logic_in_txn.srcb.data.Dqword[i] | logic_exp_result.data.Dqword[i-1];
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_bw_or_reduct

    virtual function void calc_bw_xor(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
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

    virtual function void calc_bw_xor_reduct(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        logic_exp_result.data = '0;
        case(logic_in_txn.osize)
            OSIZE_8: begin
                logic_exp_result.data.Byte[0] = logic_in_txn.srca.data.Byte[0] ^ logic_in_txn.srcb.data.Byte[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Byte[i] = logic_in_txn.srcb.data.Byte[i] ^ logic_exp_result.data.Byte[i-1];
                end
            end
            OSIZE_16: begin
                logic_exp_result.data.Word[0] = logic_in_txn.srca.data.Word[0] ^ logic_in_txn.srcb.data.Word[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Word[i] = logic_in_txn.srcb.data.Word[i] ^ logic_exp_result.data.Word[i-1];
                end
            end
            OSIZE_32: begin
                logic_exp_result.data.Dword[0] = logic_in_txn.srca.data.Dword[0] ^ logic_in_txn.srcb.data.Dword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Dword[i] = logic_in_txn.srcb.data.Dword[i] ^ logic_exp_result.data.Dword[i-1];
                end
            end
            OSIZE_64: begin
                logic_exp_result.data.Qword[0] = logic_in_txn.srca.data.Qword[0] ^ logic_in_txn.srcb.data.Qword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Qword[i] = logic_in_txn.srcb.data.Qword[i] ^ logic_exp_result.data.Qword[i-1];
                end
            end
            OSIZE_128: begin
                logic_exp_result.data.Dqword[0] = logic_in_txn.srca.data.Dqword[0] ^ logic_in_txn.srcb.data.Dqword[0];
                for (int i=1; i<logic_in_txn.len; i++) begin
                    logic_exp_result.data.Dqword[i] = logic_in_txn.srcb.data.Dqword[i] ^ logic_exp_result.data.Dqword[i-1];
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_bw_xor_reduct

    virtual function void calc_sll(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        logic_exp_result.data = '0;
        case(logic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    logic_exp_result.data.Byte[i] = (logic_in_txn.srcb.data.Byte[i] << logic_in_txn.srca.data.Byte[i][$clog2(BYTE_WIDTH)-1:0]);
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    logic_exp_result.data.Word[i] = (logic_in_txn.srcb.data.Word[i] << logic_in_txn.srca.data.Word[i][$clog2(WORD_WIDTH)-1:0]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dword[i] = (logic_in_txn.srcb.data.Dword[i] << logic_in_txn.srca.data.Dword[i][$clog2(DWORD_WIDTH)-1:0]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    logic_exp_result.data.Qword[i] = (logic_in_txn.srcb.data.Qword[i] << logic_in_txn.srca.data.Qword[i][$clog2(QWORD_WIDTH)-1:0]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dqword[i] = (logic_in_txn.srcb.data.Dqword[i] << logic_in_txn.srca.data.Dqword[i][$clog2(DQWORD_WIDTH)-1:0]);
                end
            end
        endcase
    endfunction: calc_sll

    virtual function void calc_srl(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        logic_exp_result.data = '0;
        case(logic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    logic_exp_result.data.Byte[i] = (logic_in_txn.srcb.data.Byte[i] >> logic_in_txn.srca.data.Byte[i][$clog2(BYTE_WIDTH)-1:0]);
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    logic_exp_result.data.Word[i] = (logic_in_txn.srcb.data.Word[i] >> logic_in_txn.srca.data.Word[i][$clog2(WORD_WIDTH)-1:0]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dword[i] = (logic_in_txn.srcb.data.Dword[i] >> logic_in_txn.srca.data.Dword[i][$clog2(DWORD_WIDTH)-1:0]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    logic_exp_result.data.Qword[i] = (logic_in_txn.srcb.data.Qword[i] >> logic_in_txn.srca.data.Qword[i][$clog2(QWORD_WIDTH)-1:0]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dqword[i] = (logic_in_txn.srcb.data.Dqword[i] >> logic_in_txn.srca.data.Dqword[i][$clog2(DQWORD_WIDTH)-1:0]);
                end
            end
        endcase
    endfunction: calc_srl

    virtual function void calc_sra(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        logic_exp_result.data = '0;
        case(logic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    logic_exp_result.data.Byte[i] = ($signed(logic_in_txn.srcb.data.Byte[i]) >>> logic_in_txn.srca.data.Byte[i][$clog2(BYTE_WIDTH)-1:0]);
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    logic_exp_result.data.Word[i] = ($signed(logic_in_txn.srcb.data.Word[i]) >>> logic_in_txn.srca.data.Word[i][$clog2(WORD_WIDTH)-1:0]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dword[i] = ($signed(logic_in_txn.srcb.data.Dword[i]) >>> logic_in_txn.srca.data.Dword[i][$clog2(DWORD_WIDTH)-1:0]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    logic_exp_result.data.Qword[i] = ($signed(logic_in_txn.srcb.data.Qword[i]) >>> logic_in_txn.srca.data.Qword[i][$clog2(QWORD_WIDTH)-1:0]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dqword[i] = ($signed(logic_in_txn.srcb.data.Dqword[i]) >>> logic_in_txn.srca.data.Dqword[i][$clog2(DQWORD_WIDTH)-1:0]);
                end
            end
        endcase
    endfunction: calc_sra

    virtual function void calc_mand(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            logic_exp_result.data.Bit[i] = ((logic_in_txn.srca.data.Bit[i] && logic_in_txn.srcb.data.Bit[i]) & logic_in_txn.mask_result_valid[i]);
        end
    endfunction: calc_mand

    virtual function void calc_mnand(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            logic_exp_result.data.Bit[i] = (!(logic_in_txn.srca.data.Bit[i] && logic_in_txn.srcb.data.Bit[i]) & logic_in_txn.mask_result_valid[i]);
        end
    endfunction: calc_mnand

    virtual function void calc_mandn(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            logic_exp_result.data.Bit[i] = ((!logic_in_txn.srca.data.Bit[i] && logic_in_txn.srcb.data.Bit[i]) & logic_in_txn.mask_result_valid[i]);
        end
    endfunction: calc_mandn

    virtual function void calc_mor(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            logic_exp_result.data.Bit[i] = ((logic_in_txn.srca.data.Bit[i] || logic_in_txn.srcb.data.Bit[i]) & logic_in_txn.mask_result_valid[i]);
        end
    endfunction: calc_mor

    virtual function void calc_mnor(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            logic_exp_result.data.Bit[i] = (!(logic_in_txn.srca.data.Bit[i] || logic_in_txn.srcb.data.Bit[i]) & logic_in_txn.mask_result_valid[i]);
        end
    endfunction: calc_mnor

    virtual function void calc_morn(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            logic_exp_result.data.Bit[i] = ((!logic_in_txn.srca.data.Bit[i] || logic_in_txn.srcb.data.Bit[i]) & logic_in_txn.mask_result_valid[i]);
        end
    endfunction: calc_morn

    virtual function void calc_mxor(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            logic_exp_result.data.Bit[i] = ((logic_in_txn.srca.data.Bit[i] ^^ logic_in_txn.srcb.data.Bit[i]) & logic_in_txn.mask_result_valid[i]);
        end
    endfunction: calc_mxor

    virtual function void calc_mxnor(input riscv_v_logic_alu_in_seq_item logic_in_txn, ref riscv_v_wb_data_t logic_exp_result);
        for (int i=0; i < RISCV_V_NUM_ELEMENTS_REG; i++) begin
            logic_exp_result.data.Bit[i] = (!(logic_in_txn.srca.data.Bit[i] ^^ logic_in_txn.srcb.data.Bit[i]) & logic_in_txn.mask_result_valid[i]);
        end
    endfunction: calc_mxnor

endclass: riscv_v_logic_ops

`endif //__RISCV_V_LOGIC_OPS_SV__