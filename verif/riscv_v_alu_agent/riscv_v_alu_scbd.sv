//File: riscv_v_alu_scbd.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector ALU Scoreboard

`ifndef __RISCV_V_ALU_SCBD_SV__
`define __RISCV_V_ALU_SCBD_SV__ 

class riscv_v_alu_scbd extends riscv_v_base_scbd#(
                                                 .seq_item_in_t(riscv_v_alu_in_seq_item),
                                                 .seq_item_out_t(riscv_v_alu_out_seq_item) );
    `uvm_component_utils(riscv_v_alu_scbd)

    riscv_v_logic_alu_in_seq_item logic_in_txn;
    riscv_v_alu_out_seq_item      logic_out_txn;

    //Expected results
    riscv_v_wb_data_t logic_exp_result;

    function new(string name = "riscv_v_alu_scbd", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void calc_in();
        //Cast transaction
        calc_valid();
        if ($cast(logic_in_txn, txn_in)) begin
            calc_logic();
        end else begin
            `uvm_fatal(get_name(), "Can't cast alu_seq_in to valid specific_alu_seq_in")
        end
    endfunction: calc_in 

    virtual function void calc_out();
        case(txn_out.ALU) 
            LOGIC_ALU: compare_logic();
            default:   `uvm_fatal(get_name(), "Invalid ALU found in txn_out")
        endcase
    endfunction: calc_out

    virtual function void calc_logic();
        case(logic_in_txn.opcode)
            BW_AND: calc_bw_and();
            BW_AND_REDUCT: calc_bw_and_reduct();
            default:    `uvm_fatal(get_name(), "Invalid Logic ALU op")
        endcase
    endfunction: calc_logic

    virtual function void compare_logic();
        bit comp = 1;
        comp &= logic_exp_result.valid == txn_out.result.valid;
        comp &= logic_exp_result.data  == txn_out.result.data;
        if (comp) begin
            pass();
        end else begin
            `uvm_error(get_name(), $sformatf("Compare mismatch, actual.valid: 0x%0h, actual.data 0x%0h, exp.valid: 0x%0h, exp.data: 0x%0h", txn_out.result.valid, txn_out.result.data, logic_exp_result.valid, logic_exp_result.data))
            fail();
        end
    endfunction: compare_logic

    virtual function void calc_valid();
        logic_exp_result.valid = txn_in.srca.valid;
    endfunction: calc_valid

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
        case(logic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    logic_exp_result.data.Byte[i] = &logic_in_txn.srca.data.Byte[i];
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    logic_exp_result.data.Word[i] = &logic_in_txn.srca.data.Word[i];
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dword[i] = &logic_in_txn.srca.data.Dword[i];
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    logic_exp_result.data.Qword[i] = &logic_in_txn.srca.data.Qword[i];
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    logic_exp_result.data.Dqword[i] = &logic_in_txn.srca.data.Dqword[i];
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_bw_and_reduct

endclass: riscv_v_alu_scbd

`endif // __RISCV_V_ALU_SCBD_SV__