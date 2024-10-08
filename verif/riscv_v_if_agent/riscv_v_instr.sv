//File: riscv_v_instr.sv
//Author: Miguel Bucio
//Date: 12/02/24
//Description: RiscV V Instruction

`ifndef __RISCV_V_INSTR_SV__
`define __RISCV_V_INSTR_SV__ 

class riscv_v_instr extends riscv_instr;

    `uvm_component_utils(riscv_v_instr)

    function new(string name = "riscv_v_instr", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new 

    virtual function riscv_instruction_t get_vadd_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VADD;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vadd instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VADD;
                instr.V.funct3 inside {OPIVV, OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vadd instruction");
        end
        return instr;
    endfunction: get_vadd_instr

    virtual function riscv_instruction_t get_vadd_reduct_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDSUM;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vadd reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDSUM;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vadd reduction instruction");
        end
        return instr;
    endfunction: get_vadd_reduct_instr

    virtual function riscv_instruction_t get_vaddc_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VADC;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vaddc instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VADC;
                instr.V.funct3 inside {OPIVV, OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vaddc instruction");
        end
        return instr;
    endfunction: get_vaddc_instr

    virtual function riscv_instruction_t get_vsub_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VSUB;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vsub instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VSUB;
                instr.V.funct3 inside {OPIVV, OPIVX};
            }) else `uvm_fatal(get_name(), "Can't randomize vsub instruction");
        end
        return instr;
    endfunction: get_vsub_instr

    virtual function riscv_instruction_t get_vsubb_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VSBC;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vsubb instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VSBC;
                instr.V.funct3 inside {OPIVV, OPIVX};
            }) else `uvm_fatal(get_name(), "Can't randomize vsubb instruction");
        end
        return instr;
    endfunction: get_vsubb_instr

    virtual function riscv_instruction_t get_vzext_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VXUNARY0;
                instr.V.funct3 == instr_mode;
                instr.V.vs1    inside {RISCV_V_ZEXT_VF8, RISCV_V_ZEXT_VF4, RISCV_V_ZEXT_VF2};
            }) else `uvm_fatal(get_name(), "Can't randomize vzext instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VXUNARY0;
                instr.V.funct3 inside {OPMVV};
                instr.V.vs1    inside {RISCV_V_ZEXT_VF8, RISCV_V_ZEXT_VF4, RISCV_V_ZEXT_VF2};
            }) else `uvm_fatal(get_name(), "Can't randomize vzext instruction");
        end
        return instr;
    endfunction: get_vzext_instr

    virtual function riscv_instruction_t get_vsext_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VXUNARY0;
                instr.V.funct3 == instr_mode;
                instr.V.vs1    inside {RISCV_V_SEXT_VF8, RISCV_V_SEXT_VF4, RISCV_V_SEXT_VF2};
            }) else `uvm_fatal(get_name(), "Can't randomize vsext instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VXUNARY0;
                instr.V.funct3 inside {OPMVV};
                instr.V.vs1    inside {RISCV_V_SEXT_VF8, RISCV_V_SEXT_VF4, RISCV_V_SEXT_VF2};
            }) else `uvm_fatal(get_name(), "Can't randomize vsext instruction");
        end
        return instr;
    endfunction: get_vsext_instr

    virtual function riscv_instruction_t get_vmul_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMUL;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmul instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMUL;
                instr.V.funct3 inside {OPMVV, OPMVX};
            }) else `uvm_fatal(get_name(), "Can't randomize vmul instruction");
        end
        return instr;
    endfunction: get_vmul_instr

    virtual function riscv_instruction_t get_vmulh_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMULH;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmulh instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMULH;
                instr.V.funct3 inside {OPMVV, OPMVX};
            }) else `uvm_fatal(get_name(), "Can't randomize vmulh instruction");
        end
        return instr;
    endfunction: get_vmulh_instr

    virtual function riscv_instruction_t get_vmulhu_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMULHU;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmulhu instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMULHU;
                instr.V.funct3 inside {OPMVV, OPMVX};
            }) else `uvm_fatal(get_name(), "Can't randomize vmulhu instruction");
        end
        return instr;
    endfunction: get_vmulhu_instr

    virtual function riscv_instruction_t get_vand_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VAND;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vand instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VAND;
                instr.V.funct3 inside {OPIVV, OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vand instruction");
        end
        return instr;
    endfunction: get_vand_instr

    virtual function riscv_instruction_t get_vor_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VOR;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vor instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VOR;
                instr.V.funct3 inside {OPIVV, OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vor instruction");
        end
        return instr;
    endfunction: get_vor_instr

    virtual function riscv_instruction_t get_vxor_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VXOR;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vxor instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VXOR;
                instr.V.funct3 inside {OPIVV, OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vxor instruction");
        end
        return instr;
    endfunction: get_vxor_instr

    virtual function riscv_instruction_t get_vsll_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VSLL;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vsll instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VSLL;
                instr.V.funct3 inside {OPIVV, OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vsll instruction");
        end
        return instr;
    endfunction: get_vsll_instr

    virtual function riscv_instruction_t get_vsrl_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VSRL;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vsrl instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VSRL;
                instr.V.funct3 inside {OPIVV, OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vsrl instruction");
        end
        return instr;
    endfunction: get_vsrl_instr

    virtual function riscv_instruction_t get_vsra_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VSRA;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vsra instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VSRA;
                instr.V.funct3 inside {OPIVV, OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vsra instruction");
        end
        return instr;
    endfunction: get_vsra_instr

    virtual function riscv_instruction_t get_vmseq_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSEQ;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmseq instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSEQ;
                instr.V.funct3 inside {OPIVV, OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vmseq instruction");
        end
        return instr;
    endfunction: get_vmseq_instr

    virtual function riscv_instruction_t get_vmsne_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSNE;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmsne instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSNE;
                instr.V.funct3 inside {OPIVV, OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vmsne instruction");
        end
        return instr;
    endfunction: get_vmsne_instr

    virtual function riscv_instruction_t get_vmsle_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSLE;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmsle instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSLE;
                instr.V.funct3 inside {OPIVV, OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vmsle instruction");
        end
        return instr;
    endfunction: get_vmsle_instr


    virtual function riscv_instruction_t get_vmsleu_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSLEU;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmsleu instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSLEU;
                instr.V.funct3 inside {OPIVV, OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vmsleu instruction");
        end
        return instr;
    endfunction: get_vmsleu_instr

    virtual function riscv_instruction_t get_vmslt_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSLT;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmslt instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSLT;
                instr.V.funct3 inside {OPIVV, OPIVX};
            }) else `uvm_fatal(get_name(), "Can't randomize vmslt instruction");
        end
        return instr;
    endfunction: get_vmslt_instr

    virtual function riscv_instruction_t get_vmsltu_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSLTU;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmsltu instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSLTU;
                instr.V.funct3 inside {OPIVV, OPIVX};
            }) else `uvm_fatal(get_name(), "Can't randomize vmsltu instruction");
        end
        return instr;
    endfunction: get_vmsltu_instr

    virtual function riscv_instruction_t get_vmsgt_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVX);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSGT;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmsgt instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSGT;
                instr.V.funct3 inside {OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vmsgt instruction");
        end
        return instr;
    endfunction: get_vmsgt_instr

    virtual function riscv_instruction_t get_vmsgtu_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVX);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSGTU;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmsgtu instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMSGTU;
                instr.V.funct3 inside {OPIVX, OPIVI};
            }) else `uvm_fatal(get_name(), "Can't randomize vmsgtu instruction");
        end
        return instr;
    endfunction: get_vmsgtu_instr

    virtual function riscv_instruction_t get_vmax_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMAX;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmax instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMAX;
                instr.V.funct3 inside {OPIVV, OPIVX};
            }) else `uvm_fatal(get_name(), "Can't randomize vmax instruction");
        end
        return instr;
    endfunction: get_vmax_instr

    virtual function riscv_instruction_t get_vmaxu_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMAXU;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmaxu instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMAXU;
                instr.V.funct3 inside {OPIVV, OPIVX};
            }) else `uvm_fatal(get_name(), "Can't randomize vmaxu instruction");
        end
        return instr;
    endfunction: get_vmaxu_instr

    virtual function riscv_instruction_t get_vmin_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMIN;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmin instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMIN;
                instr.V.funct3 inside {OPIVV, OPIVX};
            }) else `uvm_fatal(get_name(), "Can't randomize vmin instruction");
        end
        return instr;
    endfunction: get_vmin_instr

    virtual function riscv_instruction_t get_vminu_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPIVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMINU;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vminu instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMINU;
                instr.V.funct3 inside {OPIVV, OPIVX};
            }) else `uvm_fatal(get_name(), "Can't randomize vminu instruction");
        end
        return instr;
    endfunction: get_vminu_instr

    virtual function riscv_instruction_t get_vredmax_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDMAX;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vredmax reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDMAX;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vredmax reduction instruction");
        end
        return instr;
    endfunction: get_vredmax_instr

    virtual function riscv_instruction_t get_vredmaxu_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDMAXU;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vredmaxu reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDMAXU;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vredmaxu reduction instruction");
        end
        return instr;
    endfunction: get_vredmaxu_instr

    virtual function riscv_instruction_t get_vredmin_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDMIN;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vredmin reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDMIN;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vredmin reduction instruction");
        end
        return instr;
    endfunction: get_vredmin_instr

    virtual function riscv_instruction_t get_vredminu_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDMINU;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vredminu reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDMINU;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vredminu reduction instruction");
        end
        return instr;
    endfunction: get_vredminu_instr

    virtual function riscv_instruction_t get_vredand_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDAND;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vredand reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDAND;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vredand reduction instruction");
        end
        return instr;
    endfunction: get_vredand_instr

    virtual function riscv_instruction_t get_vredor_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDOR;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vredor reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDOR;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vredor reduction instruction");
        end
        return instr;
    endfunction: get_vredor_instr

    virtual function riscv_instruction_t get_vredxor_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDXOR;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vredxor reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VREDXOR;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vredxor reduction instruction");
        end
        return instr;
    endfunction: get_vredxor_instr

    virtual function riscv_instruction_t get_vmand_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMAND;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmand reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMAND;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vmand reduction instruction");
        end
        return instr;
    endfunction: get_vmand_instr

    virtual function riscv_instruction_t get_vmnand_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMNAND;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmnand reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMNAND;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vmnand reduction instruction");
        end
        return instr;
    endfunction: get_vmnand_instr

    virtual function riscv_instruction_t get_vmandn_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMANDN;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmandn reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMANDN;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vmandn reduction instruction");
        end
        return instr;
    endfunction: get_vmandn_instr

    virtual function riscv_instruction_t get_vmxor_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMXOR;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmxor reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMXOR;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vmxor reduction instruction");
        end
        return instr;
    endfunction: get_vmxor_instr

    virtual function riscv_instruction_t get_vmor_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMOR;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmor reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMOR;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vmor reduction instruction");
        end
        return instr;
    endfunction: get_vmor_instr

    virtual function riscv_instruction_t get_vmnor_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMNOR;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmnor reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMNOR;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vmnor reduction instruction");
        end
        return instr;
    endfunction: get_vmnor_instr

    virtual function riscv_instruction_t get_vmorn_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMORN;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmorn reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMORN;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vmorn reduction instruction");
        end
        return instr;
    endfunction: get_vmorn_instr

    virtual function riscv_instruction_t get_vmxnor_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMXNOR;
                instr.V.funct3 == instr_mode;
            }) else `uvm_fatal(get_name(), "Can't randomize vmxnor reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VMXNOR;
                instr.V.funct3 inside {OPMVV};
            }) else `uvm_fatal(get_name(), "Can't randomize vmxnor reduction instruction");
        end
        return instr;
    endfunction: get_vmxnor_instr

    virtual function riscv_instruction_t get_i2v_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVX);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VRXUNARY0;
                instr.V.funct3 == instr_mode;
                instr.V.vs2    == 0;
            }) else `uvm_fatal(get_name(), "Can't randomize i2v reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VRXUNARY0;
                instr.V.funct3 inside {OPMVX};
                instr.V.vs2    == 0;
            }) else `uvm_fatal(get_name(), "Can't randomize i2v reduction instruction");
        end
        return instr;
    endfunction: get_i2v_instr


    virtual function riscv_instruction_t get_v2i_instr(bit set_instr_mode = 1'b0, riscv_v_funct3_e instr_mode = OPMVV);
        if (set_instr_mode) begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VWXUNARY0;
                instr.V.funct3 == instr_mode;
                instr.V.vs1    == 0;
            }) else `uvm_fatal(get_name(), "Can't randomize v2i reduction instruction");
        end else begin
            assert (this.randomize() with{
                instr.V.funct6 == RISCV_V_FUNCT6_VWXUNARY0;
                instr.V.funct3 inside {OPMVV};
                instr.V.vs1    == 0;
            }) else `uvm_fatal(get_name(), "Can't randomize v2i reduction instruction");
        end
        return instr;
    endfunction: get_v2i_instr


    constraint op{
        instr.V.op == RISCV_V_TYPE_OP_CODE;
    }

    constraint funct6{
        
        instr.V.funct6 inside{
            RISCV_V_FUNCT6_VADD, RISCV_V_FUNCT6_VREDSUM, RISCV_V_FUNCT6_VREDAND, RISCV_V_FUNCT6_VSUB, RISCV_V_FUNCT6_VREDOR,
            RISCV_V_FUNCT6_VRSUB, RISCV_V_FUNCT6_VREDXOR, RISCV_V_FUNCT6_VMINU, RISCV_V_FUNCT6_VREDMINU, RISCV_V_FUNCT6_VMIN,
            RISCV_V_FUNCT6_VREDMIN, RISCV_V_FUNCT6_VMAXU, RISCV_V_FUNCT6_VREDMAXU, RISCV_V_FUNCT6_VMAX, RISCV_V_FUNCT6_VREDMAX,
            RISCV_V_FUNCT6_VAND, RISCV_V_FUNCT6_VOR, RISCV_V_FUNCT6_VXOR, RISCV_V_FUNCT6_VADC, RISCV_V_FUNCT6_VXUNARY0, RISCV_V_FUNCT6_VSBC,
            RISCV_V_FUNCT6_VMV, RISCV_V_FUNCT6_VMSEQ, RISCV_V_FUNCT6_VMANDN, RISCV_V_FUNCT6_VMSNE, RISCV_V_FUNCT6_VMAND, RISCV_V_FUNCT6_VMSLTU,
            RISCV_V_FUNCT6_VMOR, RISCV_V_FUNCT6_VMSLT, RISCV_V_FUNCT6_VMXOR, RISCV_V_FUNCT6_VMSLEU, RISCV_V_FUNCT6_VMORN, RISCV_V_FUNCT6_VMSLE,
            RISCV_V_FUNCT6_VMNAND, RISCV_V_FUNCT6_VMSGTU, RISCV_V_FUNCT6_VMNOR, RISCV_V_FUNCT6_VMSGT, RISCV_V_FUNCT6_VMXNOR, RISCV_V_FUNCT6_VMULHU,
            RISCV_V_FUNCT6_VSLL, RISCV_V_FUNCT6_VMUL, RISCV_V_FUNCT6_VMULHSU, RISCV_V_FUNCT6_VSMUL, RISCV_V_FUNCT6_VMULH, RISCV_V_FUNCT6_VSRL, RISCV_V_FUNCT6_VSRA,
            RISCV_V_FUNCT6_VWXUNARY0, RISCV_V_FUNCT6_VRXUNARY0
        };
    }
    
    `ifndef VIVADO

        constraint funct3{
            if (instr.V.funct6 inside {RISCV_V_FUNCT6_VREDSUM, RISCV_V_FUNCT6_VREDMAX, RISCV_V_FUNCT6_VREDMAXU, RISCV_V_FUNCT6_VREDMIN, RISCV_V_FUNCT6_VREDMINU, RISCV_V_FUNCT6_VREDAND, RISCV_V_FUNCT6_VREDOR, RISCV_V_FUNCT6_VREDXOR,
                                    RISCV_V_FUNCT6_VMAND, RISCV_V_FUNCT6_VMNAND, RISCV_V_FUNCT6_VMANDN, RISCV_V_FUNCT6_VMXOR, RISCV_V_FUNCT6_VMOR, RISCV_V_FUNCT6_VMNOR, RISCV_V_FUNCT6_VMORN, RISCV_V_FUNCT6_VMXNOR}){
                !(instr.V.funct3 inside {OPMVX});
            } else if (instr.V.funct6 inside {RISCV_V_FUNCT6_VSUB, RISCV_V_FUNCT6_VMSLT, RISCV_V_FUNCT6_VMSLTU, RISCV_V_FUNCT6_VMAX, RISCV_V_FUNCT6_VMAXU, RISCV_V_FUNCT6_VMIN, RISCV_V_FUNCT6_VMINU}){
                !(instr.V.funct3 inside {OPIVI});
            } else if (instr.V.funct6 inside {RISCV_V_FUNCT6_VMSGT, RISCV_V_FUNCT6_VMSGTU}){
                !(instr.V.funct3 inside {OPIVV});
            }
        }

        constraint vd{
            if (~instr.V.vm){
                instr.V.vd != 0;
            }
        }

        constraint vm{
            if (instr.V.funct6 inside{RISCV_V_FUNCT6_VMAND, RISCV_V_FUNCT6_VMNAND, RISCV_V_FUNCT6_VMANDN, RISCV_V_FUNCT6_VMXOR, RISCV_V_FUNCT6_VMOR, RISCV_V_FUNCT6_VMNOR, RISCV_V_FUNCT6_VMORN, RISCV_V_FUNCT6_VMXNOR}){
                instr.V.vm == 1'b1;
            } else if (( (instr.V.funct6 == RISCV_V_FUNCT6_VADC)      && (instr.V.funct3 inside{OPIVV, OPIVX, OPIVI}))
                ||    (  (instr.V.funct6 == RISCV_V_FUNCT6_VSBC)      && (instr.V.funct3 inside{OPIVV, OPIVX}))
                ||    (  (instr.V.funct6 == RISCV_V_FUNCT6_VWXUNARY0) && (instr.V.funct3 inside{OPMVV}))
                ||    (  (instr.V.funct6 == RISCV_V_FUNCT6_VRXUNARY0) && (instr.V.funct3 inside{OPMVX}))){
                instr.V.vm == 1'b0;
            }
        }

        constraint vs1{
            if ((instr.V.funct6 == RISCV_V_FUNCT6_VXUNARY0) && (instr.V.funct3 == OPMVV)){       //Zero and Sign extend
                instr.V.vs1 inside {5'b00010, 5'b00011, 5'b00100, 5'b00101, 5'b00110, 5'b00111};
            }
        }

    `else 

        function void post_randomize();
            super.post_randomize();
            constraint_funct3();
            constraint_vd();
            constraint_vm();
            constraint_vs1();
        endfunction: post_randomize

        virtual function void constraint_funct3();
            riscv_instr_funct3_t tmp_funct3;
            if (instr.V.funct6 inside {RISCV_V_FUNCT6_VREDSUM, RISCV_V_FUNCT6_VREDMAX, RISCV_V_FUNCT6_VREDMAXU, RISCV_V_FUNCT6_VREDMIN, RISCV_V_FUNCT6_VREDMINU, RISCV_V_FUNCT6_VREDAND, RISCV_V_FUNCT6_VREDOR, RISCV_V_FUNCT6_VREDXOR,
                                    RISCV_V_FUNCT6_VMAND, RISCV_V_FUNCT6_VMNAND, RISCV_V_FUNCT6_VMANDN, RISCV_V_FUNCT6_VMXOR, RISCV_V_FUNCT6_VMOR, RISCV_V_FUNCT6_VMNOR, RISCV_V_FUNCT6_VMORN, RISCV_V_FUNCT6_VMXNOR}) begin
                if (instr.V.funct3 inside {OPMVX}) begin
                    assert(std::randomize(tmp_funct3) with {
                        !(tmp_funct3 inside {OPMVX});
                    }) else `uvm_fatal(get_name(), "'Cant randomize funct3")
                    instr.V.funct3 = tmp_funct3;
                end
            end else if (instr.V.funct6 inside {RISCV_V_FUNCT6_VSUB, RISCV_V_FUNCT6_VMSLT, RISCV_V_FUNCT6_VMSLTU, RISCV_V_FUNCT6_VMAX, RISCV_V_FUNCT6_VMAXU, RISCV_V_FUNCT6_VMIN, RISCV_V_FUNCT6_VMINU}) begin
                if (instr.V.funct3 inside {OPIVI}) begin
                    assert(std::randomize(tmp_funct3) with {
                        !(tmp_funct3 inside {OPIVI});
                    }) else `uvm_fatal(get_name(), "'Cant randomize funct3")
                    instr.V.funct3 = tmp_funct3;
                end                
            end else if (instr.V.funct6 inside {RISCV_V_FUNCT6_VMSGT, RISCV_V_FUNCT6_VMSGTU}) begin
                if (instr.V.funct3 inside {OPIVV}) begin
                    assert(std::randomize(tmp_funct3) with {
                        !(tmp_funct3 inside {OPIVV});
                    }) else `uvm_fatal(get_name(), "'Cant randomize funct3")
                    instr.V.funct3 = tmp_funct3;
                end                 
            end
        endfunction: constraint_funct3

        virtual function void constraint_vd();
            riscv_instr_rd_t tmp_vd;
            if ((~instr.V.vm) && (instr.V.vd == 0)) begin
                assert(std::randomize(tmp_vd ) with {
                    tmp_vd != 0;
                }) else `uvm_fatal(get_name(), "'Cant randomize Vd")
                instr.V.vd = tmp_vd;
            end
        endfunction: constraint_vd

        virtual function void constraint_vm();
            if (instr.V.funct6 inside{RISCV_V_FUNCT6_VMAND, RISCV_V_FUNCT6_VMNAND, RISCV_V_FUNCT6_VMANDN, RISCV_V_FUNCT6_VMXOR, RISCV_V_FUNCT6_VMOR, RISCV_V_FUNCT6_VMNOR, RISCV_V_FUNCT6_VMORN, RISCV_V_FUNCT6_VMXNOR}) begin
                instr.V.vm = 1'b1;
            end else if (( (instr.V.funct6 == RISCV_V_FUNCT6_VADC)      && (instr.V.funct3 inside{OPIVV, OPIVX, OPIVI}))
                ||    (  (instr.V.funct6 == RISCV_V_FUNCT6_VSBC)      && (instr.V.funct3 inside{OPIVV, OPIVX}))
                ||    (  (instr.V.funct6 == RISCV_V_FUNCT6_VWXUNARY0) && (instr.V.funct3 inside{OPMVV}))
                ||    (  (instr.V.funct6 == RISCV_V_FUNCT6_VRXUNARY0) && (instr.V.funct3 inside{OPMVX}))) begin
                instr.V.vm = 1'b0;
            end
        endfunction: constraint_vm

        virtual function void constraint_vs1();
            riscv_instr_rs_t tmp_vs1;
            if ((instr.V.funct6 == RISCV_V_FUNCT6_VXUNARY0) && (instr.V.funct3 == OPMVV)) begin       //Zero and Sign extend
                if (!(instr.V.vs1 inside {5'b00010, 5'b00011, 5'b00100, 5'b00101, 5'b00110, 5'b00111})) begin
                    assert(std::randomize(tmp_vs1 ) with {
                        tmp_vs1 inside {5'b00010, 5'b00011, 5'b00100, 5'b00101, 5'b00110, 5'b00111};
                    }) else `uvm_fatal(get_name(), "'Cant randomize Vs1")
                    instr.V.vs1 = tmp_vs1;
                end
            end
        endfunction: constraint_vs1

    `endif //VIVADO

endclass: riscv_v_instr

`endif //__RISCV_V_INSTR_SV__