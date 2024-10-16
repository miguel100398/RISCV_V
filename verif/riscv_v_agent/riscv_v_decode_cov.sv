//File: riscv_v_decode_cov
//Author: Miguel Bucio
//Date: 15/01/23
//Description: RISC-V Vector extension decode Coverage

module riscv_v_decode_cov
import riscv_pkg::*, riscv_v_pkg::*;
`include "riscv_v_macros.svh"
(
    input  logic                clk,
    input  logic                rst,
    input  logic                stall,
    input  logic                flush,
    input  riscv_instruction_t  instruction_id,
    input  riscv_v_vtype_t      vtype_exe,          //Output
    input  riscv_v_vl_t         vl_exe,             //Output
    input  riscv_v_vstart_t     vstart_exe          //Output
);

logic en_stage;
riscv_instruction_t instruction_exe;

assign en_stage = ~stall;


riscv_v_stage#(.DATA_T(riscv_instruction_t),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  instruction_stage (.clk(clk), .rst(rst), .en(en_stage), .flush(flush), .rst_val('0), .flush_val('0), .data_in(instruction_id),       .data_out(instruction_exe));


covergroup instruction_cg @(posedge clk);
    option.per_instance = 1;
    option.name = "instruction_cg";

    cp_vec_opcode: coverpoint instruction_exe.V.op{
        bins VECTOR_OP    = {RISCV_V_TYPE_OP_CODE};
    }

    cp_vec_funct3: coverpoint instruction_exe.V.funct3 iff (instruction_exe.V.op == RISCV_V_TYPE_OP_CODE){
        bins OPIVV = {OPIVV};
        //<Exclude Coverage>bins OPFVV = {OPFVV};
        bins OPMVV = {OPMVV};
        bins OPIVI = {OPIVI};
        bins OPIVX = {OPIVX};
        //<Exclude Coverage>bins OPFVF = {OPFVF};
        bins OPMVX = {OPMVX};
        //<Exclude Coverage>bins OPCFG = {OPCFG};
    }

    cp_vec_mask: coverpoint instruction_exe.V.vm iff (instruction_exe.V.op == RISCV_V_TYPE_OP_CODE){
        bins masked = {1'b0};
        bins unmasked = {1'b1};
    }

    cp_vec_funct6: coverpoint instruction_exe.V.funct6 iff (instruction_exe.V.op == RISCV_V_TYPE_OP_CODE){
        bins VADD       = {RISCV_V_FUNCT6_VADD};
        bins VREDSUM    = {RISCV_V_FUNCT6_VREDSUM};
        bins VREDAND    = {RISCV_V_FUNCT6_VREDAND};
        bins VSUB       = {RISCV_V_FUNCT6_VSUB};
        bins VREDOR     = {RISCV_V_FUNCT6_VREDOR};
        bins VREDXOR    = {RISCV_V_FUNCT6_VREDXOR};
        bins VMINU      = {RISCV_V_FUNCT6_VMINU};
        bins VREDMINU   = {RISCV_V_FUNCT6_VREDMINU};
        bins VMIN       = {RISCV_V_FUNCT6_VMIN};
        bins VREDMIN    = {RISCV_V_FUNCT6_VREDMIN};
        bins VMAXU      = {RISCV_V_FUNCT6_VMAXU};
        bins VREDMAXU   = {RISCV_V_FUNCT6_VREDMAXU};
        bins VMAX       = {RISCV_V_FUNCT6_VMAX};
        bins VREDMAX    = {RISCV_V_FUNCT6_VREDMAX};
        bins VAND       = {RISCV_V_FUNCT6_VAND};
        bins VOR        = {RISCV_V_FUNCT6_VOR};
        bins VXOR       = {RISCV_V_FUNCT6_VXOR};
        bins VADC       = {RISCV_V_FUNCT6_VADC};
        bins VWXUNARY0  = {RISCV_V_FUNCT6_VWXUNARY0};
        bins VMVXS      = {RISCV_V_FUNCT6_VWXUNARY0} iff (instruction_exe.V.vs1 == 5'b00000);
        bins VRXUNARY0  = {RISCV_V_FUNCT6_VRXUNARY0};
        bins VMVSX      = {RISCV_V_FUNCT6_VRXUNARY0} iff (instruction_exe.V.vs2 == 5'b00000);
        bins VXUNARY0   = {RISCV_V_FUNCT6_VXUNARY0};
        bins ZEXT2      = {RISCV_V_FUNCT6_VXUNARY0} iff (instruction_exe.V.vs1 == RISCV_V_ZEXT_VF2);
        bins ZEXT4      = {RISCV_V_FUNCT6_VXUNARY0} iff (instruction_exe.V.vs1 == RISCV_V_ZEXT_VF4);
        bins ZEXT8      = {RISCV_V_FUNCT6_VXUNARY0} iff (instruction_exe.V.vs1 == RISCV_V_ZEXT_VF8);
        bins SEXT2      = {RISCV_V_FUNCT6_VXUNARY0} iff (instruction_exe.V.vs1 == RISCV_V_SEXT_VF2);
        bins SEXT4      = {RISCV_V_FUNCT6_VXUNARY0} iff (instruction_exe.V.vs1 == RISCV_V_SEXT_VF4);
        bins SEXT8      = {RISCV_V_FUNCT6_VXUNARY0} iff (instruction_exe.V.vs1 == RISCV_V_SEXT_VF8);
        bins VSBC       = {RISCV_V_FUNCT6_VSBC};
        bins VMSEQ      = {RISCV_V_FUNCT6_VMSEQ};
        bins VMANDN     = {RISCV_V_FUNCT6_VMANDN};
        bins VMSNE      = {RISCV_V_FUNCT6_VMSNE};
        bins VMAND      = {RISCV_V_FUNCT6_VMAND};
        bins VMSLTU     = {RISCV_V_FUNCT6_VMSLTU};
        bins VMOR       = {RISCV_V_FUNCT6_VMOR};
        bins VMSLT      = {RISCV_V_FUNCT6_VMSLT};
        bins VMXOR      = {RISCV_V_FUNCT6_VMXOR};
        bins VMSLEU     = {RISCV_V_FUNCT6_VMSLEU};
        bins VMORN      = {RISCV_V_FUNCT6_VMORN};
        bins VMSLE      = {RISCV_V_FUNCT6_VMSLE};
        bins VMNAND     = {RISCV_V_FUNCT6_VMNAND};
        bins VMSGTU     = {RISCV_V_FUNCT6_VMSGTU};
        bins VMNOR      = {RISCV_V_FUNCT6_VMNOR};
        bins VMSGT      = {RISCV_V_FUNCT6_VMSGT};
        bins VMXNOR     = {RISCV_V_FUNCT6_VMXNOR};
        bins VMULHU     = {RISCV_V_FUNCT6_VMULHU};
        bins VSLL       = {RISCV_V_FUNCT6_VSLL};
        bins VMUL       = {RISCV_V_FUNCT6_VMUL};
        bins VSMUL      = {RISCV_V_FUNCT6_VSMUL};
        bins VMULH      = {RISCV_V_FUNCT6_VMULH};
        bins VSRL       = {RISCV_V_FUNCT6_VSRL};
        bins VSRA       = {RISCV_V_FUNCT6_VSRA};
    }

    cp_osize: coverpoint vtype_exe.vsew{
        bins OSIZE_8   = {VSEW_8};
        bins OSIZE_16  = {VSEW_16};
        bins OSIZE_32  = {VSEW_32};
        bins OSIZE_64  = {VSEW_64};
        bins OSIZE_128 = {VSEW_128};
    }

    cp_len: coverpoint vl_exe.len{
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
        bins len_less_start = {[0:$]} iff (vl_exe.len < vstart_exe.index);
    }

    cp_start: coverpoint vstart_exe.index{
        bins start_0  = {0};
        bins start_1  = {1};
        bins start_2  = {2};
        bins start_3  = {3};
        bins start_4  = {4};
        bins start_5  = {5};
        bins start_6  = {6};
        bins start_7  = {7};
        bins start_8  = {8};
        bins start_9  = {9};
        bins start_10 = {10};
        bins start_11 = {11};
        bins start_12 = {12};
        bins start_13 = {13};
        bins start_14 = {14};
        bins start_15 = {15};
        bins start_16 = {16};
        bins start_greater_16 = {[17:$]};
    }

    cp_vec_ops_mask_osize: cross cp_vec_funct6, cp_vec_funct3, cp_vec_mask, cp_osize{
        //bins VADD                       = binsof(cp_vec_funct6.VADD)        &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        ignore_bins VADD_ignore         = binsof(cp_vec_funct6.VADD)        && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        //bins VADC                       = binsof(cp_vec_funct6.VADC)        &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI))          && binsof(cp_vec_mask.masked);
        ignore_bins VADC_ignore         = binsof(cp_vec_funct6.VADC)        && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        illegal_bins VADC_illegal       = binsof(cp_vec_funct6.VADC)        &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI))          && !binsof(cp_vec_mask.masked);
        //bins VSUB                       = binsof(cp_vec_funct6.VSUB)        &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        ignore_bins VSUB_ignore         = binsof(cp_vec_funct6.VSUB)        && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        //bins VSBC                       = binsof(cp_vec_funct6.VSBC)        &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX))                                         && binsof(cp_vec_mask.masked);
        ignore_bins VSBC_ignore         = binsof(cp_vec_funct6.VSBC)        && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        illegal_bins VSBC_illegal       = binsof(cp_vec_funct6.VSBC)        &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX))                                         && !binsof(cp_vec_mask.masked);
        //bins VMUL                       = binsof(cp_vec_funct6.VMUL)        &&  (binsof(cp_vec_funct3.OPMVV) || binsof(cp_vec_funct3.OPMVX));
        ignore_bins VMUL_ignore         = binsof(cp_vec_funct6.VMUL)        && !(binsof(cp_vec_funct3.OPMVV) || binsof(cp_vec_funct3.OPMVX));
        //bins VSMUL                      = binsof(cp_vec_funct6.VSMUL)       &&  (binsof(cp_vec_funct3.OPMVV) || binsof(cp_vec_funct3.OPMVX));
        ignore_bins VSMUL_ignore        = binsof(cp_vec_funct6.VSMUL)       && !(binsof(cp_vec_funct3.OPMVV) || binsof(cp_vec_funct3.OPMVX));
        //bins VMULH                      = binsof(cp_vec_funct6.VMULH)       &&  (binsof(cp_vec_funct3.OPMVV) || binsof(cp_vec_funct3.OPMVX));
        ignore_bins VMULH_ignore        = binsof(cp_vec_funct6.VMULH)       && !(binsof(cp_vec_funct3.OPMVV) || binsof(cp_vec_funct3.OPMVX));
        //bins VMULHU                     = binsof(cp_vec_funct6.VMULHU)      &&  (binsof(cp_vec_funct3.OPMVV) || binsof(cp_vec_funct3.OPMVX));
        ignore_bins VMULHU_ignore       = binsof(cp_vec_funct6.VMULHU)      && !(binsof(cp_vec_funct3.OPMVV) || binsof(cp_vec_funct3.OPMVX));
        //bins VAND                       = binsof(cp_vec_funct6.VAND)        &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        ignore_bins VAND_ignore         = binsof(cp_vec_funct6.VAND)        && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        //bins VOR                        = binsof(cp_vec_funct6.VOR)         &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        ignore_bins VOR_ignore          = binsof(cp_vec_funct6.VOR)         && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        //bins VXOR                       = binsof(cp_vec_funct6.VXOR)        &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        ignore_bins VXOR_ignore         = binsof(cp_vec_funct6.VXOR)        && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        //bins VSLL                       = binsof(cp_vec_funct6.VSLL)        &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        ignore_bins VSLL_ignore         = binsof(cp_vec_funct6.VSLL)        && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        //bins VSRL                       = binsof(cp_vec_funct6.VSRL)        &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        ignore_bins VSRL_ignore         = binsof(cp_vec_funct6.VSRL)        && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        //bins VSRA                       = binsof(cp_vec_funct6.VSRA)        &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        ignore_bins VSRA_ignore         = binsof(cp_vec_funct6.VSRA)        && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        //bins VMSEQ                      = binsof(cp_vec_funct6.VMSEQ)       &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        ignore_bins VMSEQ_ignore        = binsof(cp_vec_funct6.VMSEQ)       && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        //bins VMSNE                      = binsof(cp_vec_funct6.VMSNE)       &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        ignore_bins VMSNE_ignore        = binsof(cp_vec_funct6.VMSNE)       && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        //bins VMSLTU                     = binsof(cp_vec_funct6.VMSLTU)      &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        ignore_bins VMSLTU_ignore       = binsof(cp_vec_funct6.VMSLTU)      && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        //bins VMSLT                      = binsof(cp_vec_funct6.VMSLT)       &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        ignore_bins VMSLT_ignore        = binsof(cp_vec_funct6.VMSLT)       && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        //bins VMSLEU                     = binsof(cp_vec_funct6.VMSLEU)      &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        ignore_bins VMSLEU_ignore       = binsof(cp_vec_funct6.VMSLEU)      && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        //bins VMSLE                      = binsof(cp_vec_funct6.VMSLE)       &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        ignore_bins VMSLE_ignore        = binsof(cp_vec_funct6.VMSLE)       && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX) || binsof(cp_vec_funct3.OPIVI));
        //bins VMSGTU                     = binsof(cp_vec_funct6.VMSGTU)      &&  (binsof(cp_vec_funct3.OPIVI) || binsof(cp_vec_funct3.OPIVX));
        ignore_bins VMSGTU_ignore       = binsof(cp_vec_funct6.VMSGTU)      && !(binsof(cp_vec_funct3.OPIVI) || binsof(cp_vec_funct3.OPIVX));
        //bins VMSGT                      = binsof(cp_vec_funct6.VMSGT)       &&  (binsof(cp_vec_funct3.OPIVI) || binsof(cp_vec_funct3.OPIVX));
        ignore_bins VMSGT_ignore        = binsof(cp_vec_funct6.VMSGT)       && !(binsof(cp_vec_funct3.OPIVI) || binsof(cp_vec_funct3.OPIVX));
        //bins VMINU                      = binsof(cp_vec_funct6.VMINU)       &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        ignore_bins VMINU_ignore        = binsof(cp_vec_funct6.VMINU)       && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        //bins VMIN                       = binsof(cp_vec_funct6.VMIN)        &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        ignore_bins VMIN_ignore         = binsof(cp_vec_funct6.VMIN)        && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        //bins VMAXU                      = binsof(cp_vec_funct6.VMAXU)       &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        ignore_bins VMAXU_ignore        = binsof(cp_vec_funct6.VMAXU)       && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        //bins VMAX                       = binsof(cp_vec_funct6.VMAX)        &&  (binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        ignore_bins VMAX_ignore         = binsof(cp_vec_funct6.VMAX)        && !(binsof(cp_vec_funct3.OPIVV) || binsof(cp_vec_funct3.OPIVX));
        //bins VREDSUM                    = binsof(cp_vec_funct6.VREDSUM)     &&  (binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDSUM_ignore      = binsof(cp_vec_funct6.VREDSUM)     && !(binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDSUM_ignore_size = binsof(cp_vec_funct6.VREDSUM)     &&  (binsof(cp_vec_funct3.OPMVV)) && binsof(cp_osize.OSIZE_128);
        //bins VREDMAXU                   = binsof(cp_vec_funct6.VREDMAXU)    &&  (binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDMAXU_ignore     = binsof(cp_vec_funct6.VREDMAXU)    && !(binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDMAXU_ignore_size = binsof(cp_vec_funct6.VREDMAXU)   &&  (binsof(cp_vec_funct3.OPMVV)) && binsof(cp_osize.OSIZE_128);
        //bins VREDMAX                    = binsof(cp_vec_funct6.VREDMAX)     &&  (binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDMAX_ignore      = binsof(cp_vec_funct6.VREDMAX)     && !(binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDMAX_ignore_size = binsof(cp_vec_funct6.VREDMAX)     &&  (binsof(cp_vec_funct3.OPMVV)) && binsof(cp_osize.OSIZE_128);
        //bins VREDMINU                   = binsof(cp_vec_funct6.VREDMINU)    &&  (binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDMINU_ignore     = binsof(cp_vec_funct6.VREDMINU)    && !(binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDMINU_ignore_size = binsof(cp_vec_funct6.VREDMINU)   &&  (binsof(cp_vec_funct3.OPMVV)) && binsof(cp_osize.OSIZE_128);
        //bins VREDMIN                    = binsof(cp_vec_funct6.VREDMIN)     &&  (binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDMIN_ignore      = binsof(cp_vec_funct6.VREDMIN)     && !(binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDMIN_ignore_size = binsof(cp_vec_funct6.VREDMIN)     &&  (binsof(cp_vec_funct3.OPMVV)) && binsof(cp_osize.OSIZE_128);
        //bins VREDAND                    = binsof(cp_vec_funct6.VREDAND)     &&  (binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDAND_ignore      = binsof(cp_vec_funct6.VREDAND)     && !(binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDAND_ignore_size = binsof(cp_vec_funct6.VREDAND)     &&  (binsof(cp_vec_funct3.OPMVV)) && binsof(cp_osize.OSIZE_128);
        //bins VREDOR                     = binsof(cp_vec_funct6.VREDOR)      &&  (binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDOR_ignore       = binsof(cp_vec_funct6.VREDOR)      && !(binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDOR_ignore_size  = binsof(cp_vec_funct6.VREDOR)      &&  (binsof(cp_vec_funct3.OPMVV)) && binsof(cp_osize.OSIZE_128);
        //bins VREDXOR                    = binsof(cp_vec_funct6.VREDXOR)     &&  (binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDXOR_ignore      = binsof(cp_vec_funct6.VREDXOR)     && !(binsof(cp_vec_funct3.OPMVV));
        ignore_bins VREDXOR_ignore_size = binsof(cp_vec_funct6.VREDXOR)     &&  (binsof(cp_vec_funct3.OPMVV)) && binsof(cp_osize.OSIZE_128);
        //bins VMAND                      = binsof(cp_vec_funct6.VMAND)       &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && binsof(cp_vec_mask.unmasked);
        ignore_bins VMAND_ignore        = binsof(cp_vec_funct6.VMAND)       && !(binsof(cp_vec_funct3.OPMVV));
        illegal_bins VMAND_illegal      = binsof(cp_vec_funct6.VMAND)       &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && !binsof(cp_vec_mask.unmasked);
        //bins VMNAND                     = binsof(cp_vec_funct6.VMNAND)      &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && binsof(cp_vec_mask.unmasked);
        ignore_bins VMNAND_ignore       = binsof(cp_vec_funct6.VMNAND)      && !(binsof(cp_vec_funct3.OPMVV));
        illegal_bins VMNAND_illegal     = binsof(cp_vec_funct6.VMNAND)      &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && !binsof(cp_vec_mask.unmasked);
        //bins VMANDN                     = binsof(cp_vec_funct6.VMANDN)      &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && binsof(cp_vec_mask.unmasked);
        ignore_bins VMANDN_ignore       = binsof(cp_vec_funct6.VMANDN)      && !(binsof(cp_vec_funct3.OPMVV));
        illegal_bins VMANDN_illegal     = binsof(cp_vec_funct6.VMANDN)      &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && !binsof(cp_vec_mask.unmasked);
        //bins VMXOR                      = binsof(cp_vec_funct6.VMXOR)       &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && binsof(cp_vec_mask.unmasked);
        ignore_bins VMXOR_ignore        = binsof(cp_vec_funct6.VMXOR)       && !(binsof(cp_vec_funct3.OPMVV));
        illegal_bins VMXOR_illegal      = binsof(cp_vec_funct6.VMXOR)       &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && !binsof(cp_vec_mask.unmasked);
        //bins VMXNOR                     = binsof(cp_vec_funct6.VMXNOR)      &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && binsof(cp_vec_mask.unmasked);
        ignore_bins VMXNOR_ignore       = binsof(cp_vec_funct6.VMXNOR)      && !(binsof(cp_vec_funct3.OPMVV));
        illegal_bins VMXNOR_illegal     = binsof(cp_vec_funct6.VMXNOR)      &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && !binsof(cp_vec_mask.unmasked);
        //bins VMOR                       = binsof(cp_vec_funct6.VMOR)        &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && binsof(cp_vec_mask.unmasked);
        ignore_bins VMOR_ignore         = binsof(cp_vec_funct6.VMOR)        && !(binsof(cp_vec_funct3.OPMVV));
        illegal_bins VMOR_illegal       = binsof(cp_vec_funct6.VMOR)        &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && !binsof(cp_vec_mask.unmasked);
        //bins VMNOR                      = binsof(cp_vec_funct6.VMNOR)       &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && binsof(cp_vec_mask.unmasked);
        ignore_bins VMNOR_ignore        = binsof(cp_vec_funct6.VMNOR)       && !(binsof(cp_vec_funct3.OPMVV));
        illegal_bins VMNOR_illegal      = binsof(cp_vec_funct6.VMNOR)       &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && !binsof(cp_vec_mask.unmasked);
        //bins VMORN                      = binsof(cp_vec_funct6.VMORN)       &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && binsof(cp_vec_mask.unmasked);
        ignore_bins VMORN_ignore        = binsof(cp_vec_funct6.VMORN)       && !(binsof(cp_vec_funct3.OPMVV));
        illegal_bins VMORN_illegal      = binsof(cp_vec_funct6.VMORN)       &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && !binsof(cp_vec_mask.unmasked);
        //bins VMVSX                      = binsof(cp_vec_funct6.VMVSX)       &&  (binsof(cp_vec_funct3.OPMVX))                                                                        && binsof(cp_vec_mask.unmasked);
        ignore_bins VMVSX_ignore        = binsof(cp_vec_funct6.VMVSX)       && !(binsof(cp_vec_funct3.OPMVX));
        illegal_bins VMVSX_illegal      = binsof(cp_vec_funct6.VMVSX)       &&  (binsof(cp_vec_funct3.OPMVX))                                                                        && !binsof(cp_vec_mask.unmasked);
        //bins VMVXS                      = binsof(cp_vec_funct6.VMVXS)       &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && binsof(cp_vec_mask.unmasked);
        ignore_bins VMVXS_ignore        = binsof(cp_vec_funct6.VMVXS)       && !(binsof(cp_vec_funct3.OPMVV));
        illegal_bins VMVXS_illegal      = binsof(cp_vec_funct6.VMVXS)       &&  (binsof(cp_vec_funct3.OPMVV))                                                                        && !binsof(cp_vec_mask.unmasked);
        //bins VZEXT                      = (binsof(cp_vec_funct6.ZEXT2) || binsof(cp_vec_funct6.ZEXT4) || binsof(cp_vec_funct6.ZEXT8))    && (binsof(cp_vec_funct3.OPMVV));
        ignore_bins VZEXT_ignore        = (binsof(cp_vec_funct6.ZEXT2) || binsof(cp_vec_funct6.ZEXT4) || binsof(cp_vec_funct6.ZEXT8))    && (!(binsof(cp_vec_funct3.OPMVV)) || binsof(cp_osize.OSIZE_8));
        //bins VSEXT                      = (binsof(cp_vec_funct6.SEXT2) || binsof(cp_vec_funct6.SEXT4) || binsof(cp_vec_funct6.SEXT8))    && (binsof(cp_vec_funct3.OPMVV));
        ignore_bins VSEXT_ignore        = (binsof(cp_vec_funct6.SEXT2) || binsof(cp_vec_funct6.SEXT4) || binsof(cp_vec_funct6.SEXT8))    && (!(binsof(cp_vec_funct3.OPMVV)) || binsof(cp_osize.OSIZE_8));

        ignore_bins VWXUNARY0_ignore = binsof(cp_vec_funct6.VWXUNARY0);
        ignore_bins VRXUNARY0_ignore = binsof(cp_vec_funct6.VRXUNARY0);
        ignore_bins VXUNARY0_ignore  = binsof(cp_vec_funct6.VXUNARY0);
    }


    cp_vec_ops_len: cross cp_vec_funct6, cp_len;


    cp_vec_ops_start: cross cp_vec_funct6, cp_start;


endgroup: instruction_cg

instruction_cg inst_instruction_cg;

initial begin
    inst_instruction_cg = new();
end


endmodule: riscv_v_decode_cov