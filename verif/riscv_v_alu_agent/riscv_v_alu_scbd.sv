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

    riscv_v_logic_alu_in_seq_item      logic_in_txn;
    riscv_v_arithmetic_alu_in_seq_item arithmetic_in_txn;
    riscv_v_alu_out_seq_item           logic_out_txn;

    //Expected results
    riscv_v_wb_data_t logic_exp_result;
    riscv_v_wb_data_t arithmetic_exp_result;
    riscv_v_zf_t      zf_exp;
    riscv_v_of_t      of_exp;
    riscv_v_cf_t      cf_exp;

    function new(string name = "riscv_v_alu_scbd", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void calc_in();
        //Cast transaction
        calc_valid();
        if ($cast(logic_in_txn, txn_in)) begin
            calc_logic();
        end else if ($cast(arithmetic_in_txn, txn_in))begin
            calc_arithmetic();
        end else begin
            `uvm_fatal(get_name(), "Can't cast alu_seq_in to valid specific_alu_seq_in")
        end
    endfunction: calc_in 

    virtual function void calc_out();
        case(txn_out.ALU) 
            LOGIC_ALU: compare_logic();
            ARITHMETIC_ALU: compare_arithmetic();
            default:   `uvm_fatal(get_name(), "Invalid ALU found in txn_out")
        endcase
    endfunction: calc_out

    virtual function void calc_logic();
        case(logic_in_txn.opcode)
            BW_AND:         calc_bw_and();
            BW_AND_REDUCT:  calc_bw_and_reduct();
            BW_OR:          calc_bw_or();
            BW_OR_REDUCT:   calc_bw_or_reduct();
            BW_XOR:         calc_bw_xor();
            BW_XOR_REDUCT:  calc_bw_xor_reduct();
            SLL:            calc_sll();
            SRL:            calc_srl();
            SRA:            calc_sra();
            default:        `uvm_fatal(get_name(), "Invalid Logic ALU op")
        endcase
    endfunction: calc_logic

    virtual function void calc_arithmetic();
        case(arithmetic_in_txn.opcode)
            ADDC:           calc_addc();
            ADD:            calc_add();
            ADD_REDUCT:     calc_add_reduct();
            SUBB:           calc_subb();
            SUB:            calc_sub();
            SUB_REDUCT:     calc_sub_reduct();
            SIGN_EXT:       calc_sign_ext();
            ZERO_EXT:       calc_zero_ext();
            MINS:           calc_mins();
            MINS_REDUCT:    calc_mins_reduct();
            MINU:           calc_minu();
            MINU_REDUCT:    calc_minu_reduct();
            MAXS:           calc_maxs();
            MAXS_REDUCT:    calc_maxs_reduct();
            MAXU:           calc_maxu();
            MAXU_REDUCT:    calc_maxu_reduct();
            default:        `uvm_fatal(get_name(), "Invalid arithmetic ALU op")
        endcase
    endfunction: calc_arithmetic

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
            if (logic_exp_result.valid[i]) begin
                comp &= arithmetic_exp_result.data.Byte[i] == txn_out.result.data.Byte[i];
                //comp &= zf_exp[i]                     == txn_out.zf[i];
                //comp &= of_exp[i]                     == txn_out.of[i];
                //comp &= cf_exp[i]                     == txn_out.cf[i];
            end
        end
        if (comp) begin
            pass();
        end else begin
            `uvm_error(get_name(), $sformatf("Compare mismatch, actual.valid: 0x%0h, actual.data: 0x%0h, actual.zf: 0x%0h, actual.of: 0x%0h, actual.cf: 0x%0h, exp.valid: 0x%0h, exp.data: 0x%0h, exp.zf: 0x%0h, exp.of: 0x%0h, exp.cf: 0x%0h", txn_out.result.valid, txn_out.result.data, txn_out.zf, txn_out.of, txn_out.cf, arithmetic_exp_result.valid, arithmetic_exp_result.data, zf_exp, of_exp, cf_exp))
            fail();
        end
    endfunction: compare_arithmetic

    virtual function void calc_valid();
        logic_exp_result.valid = txn_in.srca.valid;
        arithmetic_exp_result.valid = txn_in.srca.valid;
    endfunction: calc_valid

    `include "riscv_v_alu_scbd_logic_ops.sv"
    `include "riscv_v_alu_scbd_arithmetic_ops.sv"

endclass: riscv_v_alu_scbd

`endif // __RISCV_V_ALU_SCBD_SV__