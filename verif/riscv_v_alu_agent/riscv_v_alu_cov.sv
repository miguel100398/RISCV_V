//File: riscv_v_alu_cov.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector ALU Coverage

`ifndef __RISCV_V_ALU_COV_SV__
`define __RISCV_V_ALU_COV_SV__ 

class riscv_v_alu_cov extends riscv_v_base_cov#(
                                                 .seq_item_in_t(riscv_v_alu_in_seq_item),
                                                 .seq_item_out_t(riscv_v_alu_out_seq_item) );
    `uvm_component_utils(riscv_v_alu_cov)

    riscv_v_logic_alu_in_seq_item       logic_in_txn;
    riscv_v_arithmetic_alu_in_seq_item  arithmetic_in_txn;
    riscv_v_permutation_alu_in_seq_item permutation_in_txn;

    covergroup cg_logic;
        option.per_instance = 1;
        option.name = "cg_logic";

        `ifndef VIVADO 
            cp_srca: coverpoint logic_in_txn.srca{
                bins srca[8] = {[0:$]};
            }
            cp_srcb: coverpoint logic_in_txn.srcb{
                bins srcb[8] = {[0:$]};
            }
        `else 
            cp_srca_0: coverpoint logic_in_txn.srca[0 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_1: coverpoint logic_in_txn.srca[16 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_2: coverpoint logic_in_txn.srca[32 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_3: coverpoint logic_in_txn.srca[48 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_4: coverpoint logic_in_txn.srca[64 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_5: coverpoint logic_in_txn.srca[80 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_6: coverpoint logic_in_txn.srca[96 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_7: coverpoint logic_in_txn.srca[112 +: 16]{
                bins srca[1] = {[0:$]};
            }

            cp_srcb_0: coverpoint logic_in_txn.srcb[0 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_1: coverpoint logic_in_txn.srcb[16 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_2: coverpoint logic_in_txn.srcb[32 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_3: coverpoint logic_in_txn.srcb[48 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_4: coverpoint logic_in_txn.srcb[64 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_5: coverpoint logic_in_txn.srcb[80 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_6: coverpoint logic_in_txn.srcb[96 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_7: coverpoint logic_in_txn.srcb[112 +: 16]{
                bins srcb[1] = {[0:$]};
            }
        `endif //VIVADO

        cp_osize: coverpoint logic_in_txn.osize{
            bins OSIZE_8   = {OSIZE_8};
            bins OSIZE_16  = {OSIZE_16};
            bins OSIZE_32  = {OSIZE_32};
            bins OSIZE_64  = {OSIZE_64};
            bins OSIZE_128 = {OSIZE_128};
        }

        cp_len: coverpoint logic_in_txn.len{
            bins len_0  = {0};
            bins len_1  = {1};
            bins len_2  = {2};
            bins len_3  = {3};
            bins len_4  = {4};
            bins len_5  = {5};
            bins len_6  = {6};
            bins len_7  = {7};
            bins len_8  = {8};
            bins len_9  = {9};
            bins len_10 = {10};
            bins len_11 = {11};
            bins len_12 = {12};
            bins len_13 = {13};
            bins len_14 = {14};
            bins len_15 = {15};
            bins len_16 = {16};
            bins len_greater_16 = {[17:$]};
        }

        cp_is_reduct: coverpoint logic_in_txn.is_reduct{
            bins is_reduct = {1'b1};
        }

        cp_is_and: coverpoint logic_in_txn.is_and{
            bins is_and = {1'b1};
        }

        cp_is_or: coverpoint logic_in_txn.is_or{
            bins is_or = {1'b1};
        }

        cp_is_xor: coverpoint logic_in_txn.is_xor{
            bins is_xor = {1'b1};
        }

        cp_is_mask: coverpoint logic_in_txn.is_mask{
            bins is_mask = {1'b1};
        }

        cp_is_shift: coverpoint logic_in_txn.is_shift{
            bins is_shift = {1'b1};
        }

        cp_is_left: coverpoint logic_in_txn.is_left{
            bins is_left = {1'b1};
        }

        cp_is_arith: coverpoint logic_in_txn.is_arith{
            bins is_arith = {1'b1};
        }

        cp_op_VAND: coverpoint logic_in_txn.is_and{
            bins op_VAND = {1'b1};
        }

        cp_op_VREDAND: coverpoint (logic_in_txn.is_and && logic_in_txn.is_reduct){
            bins op_VREDAND = {1'b1};
        }

        cp_op_VOR: coverpoint logic_in_txn.is_or{
            bins op_VOR = {1'b1};
        }

        cp_op_VREDOR: coverpoint (logic_in_txn.is_or && logic_in_txn.is_reduct){
            bins op_VREDOR = {1'b1};
        }

        cp_op_VXOR: coverpoint logic_in_txn.is_xor{
            bins op_VXOR = {1'b1};
        }

        cp_op_VREDXOR: coverpoint (logic_in_txn.is_xor && logic_in_txn.is_reduct){
            bins op_VREDXOR = {1'b1};
        }

        cp_op_VSLL: coverpoint(logic_in_txn.is_shift && logic_in_txn.is_left){
            bins op_VSLL = {1'b1};
        }

        cp_op_VSRL: coverpoint(logic_in_txn.is_shift){
            bins op_VSRL = {1'b1};
        }

        cp_op_VSRA: coverpoint(logic_in_txn.is_shift && logic_in_txn.is_arith){
            bins op_VSRA = {1'b1};
        }

        cp_VAND_osize_len:      cross cp_op_VAND, cp_osize, cp_len;
        cp_VREDAND_osize_len:   cross cp_op_VREDAND, cp_osize, cp_len;
        cp_VOR_osize_len:       cross cp_op_VOR, cp_osize, cp_len;
        cp_VREDOR_osize_len:    cross cp_op_VREDOR, cp_osize, cp_len;
        cp_VXOR_osize_len:      cross cp_op_VXOR, cp_osize, cp_len;
        cp_VREDXOR_osize_len:   cross cp_op_VREDXOR, cp_osize, cp_len;
        cp_VSLL_osize_len:      cross cp_op_VSLL, cp_osize, cp_len;
        cp_VSRL_osize_len:      cross cp_op_VSRL, cp_osize, cp_len;
        cp_VSRA_osize_len:      cross cp_op_VSRA, cp_osize, cp_len;

    endgroup: cg_logic

    covergroup cg_arithmetic;
        option.per_instance = 1;
        option.name = "cg_arithmetic";

        `ifndef VIVADO 
            cp_srca: coverpoint arithmetic_in_txn.srca{
                bins srca[8] = {[0:$]};
            }
            cp_srcb: coverpoint arithmetic_in_txn.srcb{
                bins srcb[8] = {[0:$]};
            }
        `else 
            cp_srca_0: coverpoint arithmetic_in_txn.srca[0 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_1: coverpoint arithmetic_in_txn.srca[16 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_2: coverpoint arithmetic_in_txn.srca[32 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_3: coverpoint arithmetic_in_txn.srca[48 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_4: coverpoint arithmetic_in_txn.srca[64 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_5: coverpoint arithmetic_in_txn.srca[80 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_6: coverpoint arithmetic_in_txn.srca[96 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_7: coverpoint arithmetic_in_txn.srca[112 +: 16]{
                bins srca[1] = {[0:$]};
            }

            cp_srcb_0: coverpoint arithmetic_in_txn.srcb[0 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_1: coverpoint arithmetic_in_txn.srcb[16 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_2: coverpoint arithmetic_in_txn.srcb[32 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_3: coverpoint arithmetic_in_txn.srcb[48 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_4: coverpoint arithmetic_in_txn.srcb[64 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_5: coverpoint arithmetic_in_txn.srcb[80 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_6: coverpoint arithmetic_in_txn.srcb[96 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_7: coverpoint arithmetic_in_txn.srcb[112 +: 16]{
                bins srcb[1] = {[0:$]};
            }
        `endif //VIVADO

        cp_osize: coverpoint arithmetic_in_txn.osize{
            bins OSIZE_8   = {OSIZE_8};
            bins OSIZE_16  = {OSIZE_16};
            bins OSIZE_32  = {OSIZE_32};
            bins OSIZE_64  = {OSIZE_64};
            bins OSIZE_128 = {OSIZE_128};
        }

        cp_src_osize: coverpoint arithmetic_in_txn.src_osize_vector iff(arithmetic_in_txn.is_zero_ext || arithmetic_in_txn.is_sign_ext){
            bins OSIZE_8   = {5'b00001};
            bins OSIZE_16  = {5'b00010};
            bins OSIZE_32  = {5'b00100};
            bins OSIZE_64  = {5'b01000};
            bins OSIZE_128 = {5'b10000};
        }

        cp_dst_osize: coverpoint arithmetic_in_txn.dst_osize_vector iff(arithmetic_in_txn.is_zero_ext || arithmetic_in_txn.is_sign_ext){
            bins OSIZE_8   = {5'b00001};
            bins OSIZE_16  = {5'b00010};
            bins OSIZE_32  = {5'b00100};
            bins OSIZE_64  = {5'b01000};
            bins OSIZE_128 = {5'b10000};
        }

        cp_len: coverpoint arithmetic_in_txn.len{
            bins len_0  = {0};
            bins len_1  = {1};
            bins len_2  = {2};
            bins len_3  = {3};
            bins len_4  = {4};
            bins len_5  = {5};
            bins len_6  = {6};
            bins len_7  = {7};
            bins len_8  = {8};
            bins len_9  = {9};
            bins len_10 = {10};
            bins len_11 = {11};
            bins len_12 = {12};
            bins len_13 = {13};
            bins len_14 = {14};
            bins len_15 = {15};
            bins len_16 = {16};
            bins len_greater_16 = {[17:$]};
        }

        cp_is_reduct: coverpoint arithmetic_in_txn.is_reduct{
            bins is_reduct = {1'b1};
        }

        cp_is_add: coverpoint arithmetic_in_txn.is_add{
            bins is_add = {1'b1};
        }

        cp_is_sub: coverpoint arithmetic_in_txn.is_sub{
            bins is_sub = {1'b1};
        }

        cp_is_mul: coverpoint arithmetic_in_txn.is_mul{
            bins is_mul = {1'b1};
        }

        cp_is_zero_ext: coverpoint arithmetic_in_txn.is_zero_ext{
            bins is_zero_ext = {1'b1};
        }

        cp_is_sign_ext: coverpoint arithmetic_in_txn.is_sign_ext{
            bins is_sign_ext = {1'b1};
        }

        cp_is_set_equal: coverpoint arithmetic_in_txn.is_set_equal{
            bins is_set_equal = {1'b1};
        }

        cp_is_set_nequal: coverpoint arithmetic_in_txn.is_set_nequal{
            bins is_set_nequal = {1'b1};
        }

        cp_is_set_less: coverpoint arithmetic_in_txn.is_set_less{
            bins is_set_less = {1'b1};
        }

        cp_is_set_greater: coverpoint arithmetic_in_txn.is_set_greater{
            bins is_set_greater = {1'b1};
        }

        cp_is_max: coverpoint arithmetic_in_txn.is_max{
            bins is_max = {1'b1};
        }

        cp_is_min: coverpoint arithmetic_in_txn.is_min{
            bins is_min = {1'b1};
        }

        cp_is_high: coverpoint arithmetic_in_txn.is_high{
            bins is_high = {1'b1};
        }

        cp_is_signed: coverpoint arithmetic_in_txn.is_signed{
            bins is_signed = {1'b1};
        }

        cp_use_carry: coverpoint arithmetic_in_txn.use_carry{
            bins use_carry = {1'b1};
        }

        cp_carry_in: coverpoint arithmetic_in_txn.carry_in iff (arithmetic_in_txn.use_carry){
            wildcard bins carry_in_0  = {16'b????_????_????_???1};
            wildcard bins carry_in_1  = {16'b????_????_????_??1?};
            wildcard bins carry_in_2  = {16'b????_????_????_?1??};
            wildcard bins carry_in_3  = {16'b????_????_????_1???};
            wildcard bins carry_in_4  = {16'b????_????_???1_????};
            wildcard bins carry_in_5  = {16'b????_????_??1?_????};
            wildcard bins carry_in_6  = {16'b????_????_?1??_????};
            wildcard bins carry_in_7  = {16'b????_????_1???_????};
            wildcard bins carry_in_8  = {16'b????_???1_????_????};
            wildcard bins carry_in_9  = {16'b????_??1?_????_????};
            wildcard bins carry_in_10 = {16'b????_?1??_????_????};
            wildcard bins carry_in_11 = {16'b????_1???_????_????};
            wildcard bins carry_in_12 = {16'b???1_????_????_????};
            wildcard bins carry_in_13 = {16'b??1?_????_????_????};
            wildcard bins carry_in_14 = {16'b?1??_????_????_????};
            wildcard bins carry_in_15 = {16'b1???_????_????_????};
        }

        cp_op_VADC: coverpoint (arithmetic_in_txn.is_add && arithmetic_in_txn.is_signed && arithmetic_in_txn.use_carry){
            bins op_VADC = {1'b1};
        }

        cp_op_VADD: coverpoint(arithmetic_in_txn.is_add && arithmetic_in_txn.is_signed && ~arithmetic_in_txn.is_reduct){
            bins op_VADD = {1'b1};
        }

        cp_op_VREDADD: coverpoint(arithmetic_in_txn.is_add && arithmetic_in_txn.is_signed && arithmetic_in_txn.is_reduct){
            bins op_VREDADD = {1'b1};
        }

        cp_op_VSUBB: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_signed && arithmetic_in_txn.use_carry){
            bins op_VSUBB = {1'b1};
        }

        cp_op_VSUB: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_signed && ~arithmetic_in_txn.is_reduct){
            bins op_VSUB = {1'b1};
        }

        cp_op_VREDSUB: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_signed && arithmetic_in_txn.is_reduct){
            bins op_VREDSUB = {1'b1};
        }

        cp_op_VMINS: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_signed && arithmetic_in_txn.is_min && ~arithmetic_in_txn.is_reduct){
            bins op_VMINS = {1'b1};
        }

        cp_op_VREDMINS: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_signed && arithmetic_in_txn.is_min && arithmetic_in_txn.is_reduct){
            bins op_VREDMINS = {1'b1};
        }

        cp_op_VMINU: coverpoint(arithmetic_in_txn.is_sub && ~arithmetic_in_txn.is_signed && arithmetic_in_txn.is_min && ~arithmetic_in_txn.is_reduct){
            bins op_VMINU = {1'b1};
        }

        cp_op_VREDMINU: coverpoint(arithmetic_in_txn.is_sub && ~arithmetic_in_txn.is_signed && arithmetic_in_txn.is_min && arithmetic_in_txn.is_reduct){
            bins op_VREDMINU = {1'b1};
        }

        cp_op_VMAXS: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_signed && arithmetic_in_txn.is_max && ~arithmetic_in_txn.is_reduct){
            bins op_VMAXS = {1'b1};
        }

        cp_op_VREDMAXS: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_signed && arithmetic_in_txn.is_max && arithmetic_in_txn.is_reduct){
            bins op_VREDMAXS = {1'b1};
        }

        cp_op_VMAXU: coverpoint(arithmetic_in_txn.is_sub && ~arithmetic_in_txn.is_signed && arithmetic_in_txn.is_max && ~arithmetic_in_txn.is_reduct){
            bins op_VMAXU = {1'b1};
        }

        cp_op_VREDMAXU: coverpoint(arithmetic_in_txn.is_sub && ~arithmetic_in_txn.is_signed && arithmetic_in_txn.is_max && arithmetic_in_txn.is_reduct){
            bins op_VREDMAXU = {1'b1};
        }

        cp_op_VSEQ: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_set_equal){
            bins op_VSEQ = {1'b1};
        }

        cp_op_VSNEQ: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_set_nequal){
            bins op_VNSEQ = {1'b1};
        }

        cp_op_VSLE: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_set_equal && arithmetic_in_txn.is_set_less && arithmetic_in_txn.is_signed){
            bins op_VSLE = {1'b1};
        }

        cp_op_VSLEU: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_set_equal && arithmetic_in_txn.is_set_less && ~arithmetic_in_txn.is_signed){
            bins op_VSLEU = {1'b1};
        }

        cp_op_VSLT: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_set_less && arithmetic_in_txn.is_signed){
            bins op_VSLT = {1'b1};
        }

        cp_op_VSLTU: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_set_less && ~arithmetic_in_txn.is_signed){
            bins op_VSLTU = {1'b1};
        }

        cp_op_VSGT: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_set_greater && arithmetic_in_txn.is_signed){
            bins op_VSGT = {1'b1};
        }

        cp_op_VSGTU: coverpoint(arithmetic_in_txn.is_sub && arithmetic_in_txn.is_set_greater && ~arithmetic_in_txn.is_signed){
            bins op_VSGTU = {1'b1};
        }

        cp_op_VMULLS: coverpoint(arithmetic_in_txn.is_mul && arithmetic_in_txn.is_signed && ~arithmetic_in_txn.is_high){
            bins op_VMULLS = {1'b1};
        }

        cp_op_VMULHS: coverpoint(arithmetic_in_txn.is_mul && arithmetic_in_txn.is_signed && arithmetic_in_txn.is_high){
            bins op_VMULHS = {1'b1};
        }

        cp_op_VMULLU: coverpoint(arithmetic_in_txn.is_mul && ~arithmetic_in_txn.is_signed && ~arithmetic_in_txn.is_high){
            bins op_VMULLU = {1'b1};
        }

        cp_op_VMULHU: coverpoint(arithmetic_in_txn.is_mul && ~arithmetic_in_txn.is_signed && arithmetic_in_txn.is_high){
            bins op_VMULHU = {1'b1};
        }

        cp_op_VZEXT: coverpoint(arithmetic_in_txn.is_zero_ext){
            bins op_VZEXT = {1'b1};
        }

        cp_op_VSEXT: coverpoint(arithmetic_in_txn.is_sign_ext){
            bins op_VSEXT = {1'b1};
        }

        cp_VADC_osize_len:      cross cp_op_VADC, cp_osize, cp_len;
        cp_VADD_osize_len:      cross cp_op_VADD, cp_osize, cp_len;
        cp_VREDADD_osize_len:   cross cp_op_VREDADD, cp_osize, cp_len;
        cp_VSUBB_osize_len:     cross cp_op_VSUBB, cp_osize, cp_len;
        cp_VSUB_osize_len:      cross cp_op_VSUB, cp_osize, cp_len;
        cp_VREDSUB_osize_len:   cross cp_op_VREDSUB, cp_osize, cp_len;
        cp_VMINS_osize_len:     cross cp_op_VMINS, cp_osize, cp_len;
        cp_VMINU_osize_len:     cross cp_op_VMINU, cp_osize, cp_len;
        cp_VREDMINS_osize_len:  cross cp_op_VREDMINS, cp_osize, cp_len;
        cp_VREDMINU_osize_len:  cross cp_op_VREDMINU, cp_osize, cp_len;
        cp_VMAXS_osize_len:     cross cp_op_VMAXS, cp_osize, cp_len;
        cp_VMAXU_osize_len:     cross cp_op_VMAXU, cp_osize, cp_len;
        cp_VREDMAXS_osize_len:  cross cp_op_VREDMAXS, cp_osize, cp_len;
        cp_VREDMAXU_osize_len:  cross cp_op_VREDMAXU, cp_osize, cp_len;
        cp_VSEQ_osize_len:      cross cp_op_VSEQ, cp_osize, cp_len;
        cp_VSNEQ_osize_len:     cross cp_op_VSNEQ, cp_osize, cp_len;
        cp_VSLE_osize_len:      cross cp_op_VSLE, cp_osize, cp_len;
        cp_VSLEU_osize_len:     cross cp_op_VSLEU, cp_osize, cp_len;
        cp_VSGT_osize_len:      cross cp_op_VSGT, cp_osize, cp_len;
        cp_VSGTU_osize_len:     cross cp_op_VSGTU, cp_osize, cp_len;
        cp_VMULLS_osize_len:    cross cp_op_VMULLS, cp_osize, cp_len;
        cp_VMULHS_osize_len:    cross cp_op_VMULHS, cp_osize, cp_len;
        cp_VMULLU_osize_len:    cross cp_op_VMULLU, cp_osize, cp_len;
        cp_VMULHU_osize_len:    cross cp_op_VMULHU, cp_osize, cp_len;
        cp_VZEXT_osize_len:     cross cp_op_VZEXT, cp_src_osize, cp_dst_osize, cp_len{
            illegal_bins cross_VZEXT_illegal_dst0 = binsof(cp_src_osize.OSIZE_8)   && binsof(cp_dst_osize.OSIZE_128);
            illegal_bins cross_VZEXT_illegal_dst1 = binsof(cp_dst_osize.OSIZE_8);
            illegal_bins cross_VZEXT_illegal_src0 = binsof(cp_dst_osize.OSIZE_16)  && (binsof(cp_src_osize.OSIZE_16) ||  binsof(cp_src_osize.OSIZE_32) ||  binsof(cp_src_osize.OSIZE_64) ||  binsof(cp_src_osize.OSIZE_128));
            illegal_bins cross_VZEXT_illegal_src1 = binsof(cp_dst_osize.OSIZE_32)  && (binsof(cp_src_osize.OSIZE_32) ||  binsof(cp_src_osize.OSIZE_64) ||  binsof(cp_src_osize.OSIZE_128));
            illegal_bins cross_VZEXT_illegal_src2 = binsof(cp_dst_osize.OSIZE_64)  && (binsof(cp_src_osize.OSIZE_64) ||  binsof(cp_src_osize.OSIZE_128));
            illegal_bins cross_VZEXT_illegal_src3 = binsof(cp_dst_osize.OSIZE_128) && (binsof(cp_src_osize.OSIZE_128));
        }
        cp_VSEXT_osize_len: cross cp_op_VSEXT, cp_src_osize, cp_dst_osize, cp_len{
            illegal_bins cross_VZEXT_illegal_dst0 = binsof(cp_src_osize.OSIZE_8)   && binsof(cp_dst_osize.OSIZE_128);
            illegal_bins cross_VZEXT_illegal_dst1 = binsof(cp_dst_osize.OSIZE_8);
            illegal_bins cross_VZEXT_illegal_src0 = binsof(cp_dst_osize.OSIZE_16)  && (binsof(cp_src_osize.OSIZE_16) ||  binsof(cp_src_osize.OSIZE_32) ||  binsof(cp_src_osize.OSIZE_64) ||  binsof(cp_src_osize.OSIZE_128));
            illegal_bins cross_VZEXT_illegal_src1 = binsof(cp_dst_osize.OSIZE_32)  && (binsof(cp_src_osize.OSIZE_32) ||  binsof(cp_src_osize.OSIZE_64) ||  binsof(cp_src_osize.OSIZE_128));
            illegal_bins cross_VZEXT_illegal_src2 = binsof(cp_dst_osize.OSIZE_64)  && (binsof(cp_src_osize.OSIZE_64) ||  binsof(cp_src_osize.OSIZE_128));
            illegal_bins cross_VZEXT_illegal_src3 = binsof(cp_dst_osize.OSIZE_128) && (binsof(cp_src_osize.OSIZE_128));
        }

    endgroup: cg_arithmetic

    covergroup cg_permutation;
        option.per_instance = 1;
        option.name = "cg_permutation";

        `ifndef VIVADO 
            cp_srca: coverpoint permutation_in_txn.srca{
                bins srca[8] = {[0:$]};
            }
            cp_srcb: coverpoint permutation_in_txn.srcb{
                bins srcb[8] = {[0:$]};
            }
        `else 
            cp_srca_0: coverpoint permutation_in_txn.srca[0 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_1: coverpoint permutation_in_txn.srca[16 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_2: coverpoint permutation_in_txn.srca[32 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_3: coverpoint permutation_in_txn.srca[48 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_4: coverpoint permutation_in_txn.srca[64 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_5: coverpoint permutation_in_txn.srca[80 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_6: coverpoint permutation_in_txn.srca[96 +: 16]{
                bins srca[1] = {[0:$]};
            }
            cp_srca_7: coverpoint permutation_in_txn.srca[112 +: 16]{
                bins srca[1] = {[0:$]};
            }

            cp_srcb_0: coverpoint permutation_in_txn.srcb[0 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_1: coverpoint permutation_in_txn.srcb[16 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_2: coverpoint permutation_in_txn.srcb[32 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_3: coverpoint permutation_in_txn.srcb[48 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_4: coverpoint permutation_in_txn.srcb[64 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_5: coverpoint permutation_in_txn.srcb[80 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_6: coverpoint permutation_in_txn.srcb[96 +: 16]{
                bins srcb[1] = {[0:$]};
            }
            cp_srcb_7: coverpoint permutation_in_txn.srcb[112 +: 16]{
                bins srcb[1] = {[0:$]};
            }
        `endif //VIVADO

        cp_osize: coverpoint permutation_in_txn.osize{
            bins OSIZE_8   = {OSIZE_8};
            bins OSIZE_16  = {OSIZE_16};
            bins OSIZE_32  = {OSIZE_32};
            bins OSIZE_64  = {OSIZE_64};
            bins OSIZE_128 = {OSIZE_128};
        }

        cp_len: coverpoint permutation_in_txn.len{
            bins len_0  = {0};
            illegal_bins len_1  = {1};
            illegal_bins len_2  = {2};
            illegal_bins len_3  = {3};
            illegal_bins len_4  = {4};
            illegal_bins len_5  = {5};
            illegal_bins len_6  = {6};
            illegal_bins len_7  = {7};
            illegal_bins len_8  = {8};
            illegal_bins len_9  = {9};
            illegal_bins len_10 = {10};
            illegal_bins len_11 = {11};
            illegal_bins len_12 = {12};
            illegal_bins len_13 = {13};
            illegal_bins len_14 = {14};
            illegal_bins len_15 = {15};
            illegal_bins len_16 = {16};
            illegal_bins len_greater_16 = {[17:$]};
        }

        cp_is_i2v: coverpoint permutation_in_txn.is_i2v{
            bins is_i2v = {1'b1};
        }

        cp_is_v2i: coverpoint permutation_in_txn.is_v2i{
            bins is_v2i = {1'b1};
        }

        cp_op_I2V: coverpoint permutation_in_txn.is_i2v{
            bins op_I2V = {1'b1};
        }

        cp_op_V2I: coverpoint permutation_in_txn.is_v2i{
            bins op_V2I = {1'b1};
        }

        vp_I2V_osize: cross cp_op_I2V, cp_osize;
        vp_V2I_osize: cross cp_op_V2I, cp_osize;

    endgroup: cg_permutation

    function new(string name = "riscv_v_alu_cov", uvm_component parent = null);
        super.new(name, parent);
        cg_logic = new();
        cg_arithmetic = new();
        cg_permutation = new();
    endfunction: new

    virtual function void cov_in();
        if ($cast(logic_in_txn, txn_in)) begin
            cg_logic.sample();
        end else if ($cast(arithmetic_in_txn, txn_in))begin
            cg_arithmetic.sample();
        end else if ($cast(permutation_in_txn, txn_in)) begin 
            cg_permutation.sample();
        end else begin
            `uvm_fatal(get_name(), "Can't cast alu_seq_in to valid specific_alu_seq_in")
        end
    endfunction: cov_in 

    virtual function void cov_out();
        return;
    endfunction: cov_out


endclass: riscv_v_alu_cov

`endif // __RISCV_V_ALU_COV_SV__