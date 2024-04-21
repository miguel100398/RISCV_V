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
            }) else `uvm_fatal(get_name(), "Can't randomize vadd instruction");
        end
        return instr;
    endfunction: get_vadd_instr




    constraint op{
        instr.V.op == RISCV_V_TYPE_OP_CODE;
    }

    constraint funct3{
        if (instr.V.funct6 == RISCV_V_FUNCT6_VADD){
            instr.V.funct3 inside{OPIVV, OPIVX, OPIVI};
        } else {
            instr.V.funct3 inside{OPIVV, OPMVV, OPIVI, OPIVX, OPMVX, OPCFG};
        }
    }

    constraint funct7{
        
        instr.V.funct6 inside{
            RISCV_V_FUNCT6_VADD, RISCV_V_FUNCT6_VREDSUM, RISCV_V_FUNCT6_VREDAND, RISCV_V_FUNCT6_VSUB, RISCV_V_FUNCT6_VREDOR,
            RISCV_V_FUNCT6_VRSUB, RISCV_V_FUNCT6_VREDXOR, RISCV_V_FUNCT6_VMINU, RISCV_V_FUNCT6_VREDMINU, RISCV_V_FUNCT6_VMIN,
            RISCV_V_FUNCT6_VREDMIN, RISCV_V_FUNCT6_VMAXU, RISCV_V_FUNCT6_VREDMAXU, RISCV_V_FUNCT6_VMAX, RISCV_V_FUNCT6_VREDMAX,
            RISCV_V_FUNCT6_VAND, RISCV_V_FUNCT6_VOR, RISCV_V_FUNCT6_VXOR, RISCV_V_FUNCT6_VADC, RISCV_V_FUNCT6_VXUNARY0, RISCV_V_FUNCT6_VSBC,
            RISCV_V_FUNCT6_VMV, RISCV_V_FUNCT6_VMSEQ, RISCV_V_FUNCT6_VMANDN, RISCV_V_FUNCT6_VMSNE, RISCV_V_FUNCT6_VMAND, RISCV_V_FUNCT6_VMSLTU,
            RISCV_V_FUNCT6_VMOR, RISCV_V_FUNCT6_VMSLT, RISCV_V_FUNCT6_VMXOR, RISCV_V_FUNCT6_VMSLEU, RISCV_V_FUNCT6_VMORN, RISCV_V_FUNCT6_VMSLE,
            RISCV_V_FUNCT6_VMNAND, RISCV_V_FUNCT6_VMSGTU, RISCV_V_FUNCT6_VMNOR, RISCV_V_FUNCT6_VMSGT, RISCV_V_FUNCT6_VMXNOR, RISCV_V_FUNCT6_VMULHU,
            RISCV_V_FUNCT6_VSLL, RISCV_V_FUNCT6_VMUL, RISCV_V_FUNCT6_VMULHSU, RISCV_V_FUNCT6_VSMUL, RISCV_V_FUNCT6_VMULH, RISCV_V_FUNCT6_VSRL, RISCV_V_FUNCT6_VSRA
        };
    }

    constraint vd{
        if (~instr.V.vm){
            instr.V.vd != 0;
        }
    }

    constraint vm{
        if (instr.V.funct6 inside{1'b0}){
            instr.V.vm == 1'b1;
        }
    }

endclass: riscv_v_instr

`endif //__RISCV_V_INSTR_SV__