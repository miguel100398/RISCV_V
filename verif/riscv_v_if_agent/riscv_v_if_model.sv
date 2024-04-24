//File: riscv_v_if_model
//Author: Miguel Bucio
//Date: 12/02/24
//Description: RiscV V Instruction Fetch Model

`ifndef __RISCV_V_IF_MODEL_SV__
`define __RISCV_V_IF_MODEL_SV__ 

class riscv_v_if_model extends riscv_v_base_model;

    `uvm_component_utils(riscv_v_if_model)

    riscv_v_instr instruction;

    function new(string name = "riscv_v_if_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new 

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        instruction = riscv_v_instr::type_id::create({get_name(), "_instruction"}, this);
    endfunction: build_phase

    virtual function void rst();
        return;
    endfunction: rst

    virtual function riscv_instruction_t get_instruction(bit use_file = 1'b1, bit use_specific_instr = 1'b0, bit use_specific_mode = 1'b0, bit use_specific_vm = 1'b0, riscv_v_opcode_e opcode = ADD, riscv_v_funct3_e mode = OPIVV, bit vm = 1'b1);
        riscv_instruction_t instr;
        if (use_file) begin
            `uvm_fatal(get_name(), "use_file mode not supported yet")
        end else if (use_specific_instr) begin
            case(opcode)
                ADD           : instr = instruction.get_vadd_instr(use_specific_mode, mode);
                ADD_REDUCT    : instr = instruction.get_vadd_reduct_instr(use_specific_mode, mode);
                ADDC          : instr = instruction.get_vaddc_instr(use_specific_mode, mode);
                SUB           : instr = instruction.get_vsub_instr(use_specific_mode, mode);
                SUBB          : instr = instruction.get_vsubb_instr(use_specific_mode, mode);
                ZERO_EXT      : instr = instruction.get_vzext_instr(use_specific_mode, mode);
                SIGN_EXT      : instr = instruction.get_vsext_instr(use_specific_mode, mode);
                MULLS         : instr = instruction.get_vmul_instr(use_specific_mode, mode);
                MULHS         : instr = instruction.get_vmulh_instr(use_specific_mode, mode);
                MULHU         : instr = instruction.get_vmulhu_instr(use_specific_mode, mode);
                BW_AND        : instr = instruction.get_vand_instr(use_specific_mode, mode);
                BW_OR         : instr = instruction.get_vor_instr(use_specific_mode, mode);
                BW_XOR        : instr = instruction.get_vxor_instr(use_specific_mode, mode);
                SLL           : instr = instruction.get_vsll_instr(use_specific_mode, mode);
                SRL           : instr = instruction.get_vsrl_instr(use_specific_mode, mode);
                SRA           : instr = instruction.get_vsra_instr(use_specific_mode, mode);
                SEQ           : instr = instruction.get_vmseq_instr(use_specific_mode, mode);
                SNE           : instr = instruction.get_vmsne_instr(use_specific_mode, mode);
                SLE           : instr = instruction.get_vmsle_instr(use_specific_mode, mode);
                SLEU          : instr = instruction.get_vmsleu_instr(use_specific_mode, mode);
                SLT           : instr = instruction.get_vmslt_instr(use_specific_mode, mode);
                SLTU          : instr = instruction.get_vmsltu_instr(use_specific_mode, mode);
                SGT           : instr = instruction.get_vmsgt_instr(use_specific_mode, mode);
                SGTU          : instr = instruction.get_vmsgtu_instr(use_specific_mode, mode);
                MAXS          : instr = instruction.get_vmax_instr(use_specific_mode, mode);
                MAXU          : instr = instruction.get_vmaxu_instr(use_specific_mode, mode);
                MINS          : instr = instruction.get_vmin_instr(use_specific_mode, mode);
                MINU          : instr = instruction.get_vminu_instr(use_specific_mode, mode);
                MAXU_REDUCT   : instr = instruction.get_vredmaxu_instr(use_specific_mode, mode);
                MAXS_REDUCT   : instr = instruction.get_vredmax_instr(use_specific_mode, mode);
                MINU_REDUCT   : instr = instruction.get_vredminu_instr(use_specific_mode, mode);
                MINS_REDUCT   : instr = instruction.get_vredmin_instr(use_specific_mode, mode);
                BW_AND_REDUCT : instr = instruction.get_vredand_instr(use_specific_mode, mode);
                BW_OR_REDUCT  : instr = instruction.get_vredor_instr(use_specific_mode, mode);
                BW_XOR_REDUCT : instr = instruction.get_vredxor_instr(use_specific_mode, mode);
                MAND          : instr = instruction.get_vmand_instr(use_specific_mode, mode);
                MNAND         : instr = instruction.get_vmnand_instr(use_specific_mode, mode);
                MANDN         : instr = instruction.get_vmandn_instr(use_specific_mode, mode);
                MXOR          : instr = instruction.get_vmxor_instr(use_specific_mode, mode);
                MOR           : instr = instruction.get_vmor_instr(use_specific_mode, mode);
                MNOR          : instr = instruction.get_vmnor_instr(use_specific_mode, mode);
                MORN          : instr = instruction.get_vmorn_instr(use_specific_mode, mode);
                MXNOR         : instr = instruction.get_vmxnor_instr(use_specific_mode, mode);
                I2V           : instr = instruction.get_i2v_instr(use_specific_mode, mode);
                V2I           : instr = instruction.get_v2i_instr(use_specific_mode, mode);
                default     : `uvm_fatal(get_name(), $sformatf("Invalid instruction: %0s", opcode.name()))
            endcase
        end else begin
            `uvm_fatal(get_name(), "Get random instruction not supported yet")
        end
        if (use_specific_vm) begin
            if (vm == 1'b0 && opcode inside{MAND, MNAND, MANDN, MXOR, MOR, MNOR, MORN, MXNOR, I2V, V2I}) begin
                `uvm_fatal(get_name(), $sformatf("Instruction: %0s, doesn't support masking", opcode.name()))
            end
            if (vm == 1'b1 && opcode inside{ADDC, SUBB}) begin
                `uvm_fatal(get_name(), $sformatf("Instruction: %0s, is always a masked op", opcode.name()));
            end
            instr.V.vm = vm;
            //If Masking enabled destination register can't be reg 0
            if ((~vm) && (instr.V.vd == 0)) begin
                riscv_instr_rd_t tmp_dst;
                assert(std::randomize(tmp_dst) with {
                    tmp_dst != 0;
                }) else `uvm_fatal(get_name(), "Can't randomize Vector destination different from zero")
                instr.V.vd = tmp_dst;
            end
        end
        return instr;
    endfunction: get_instruction

endclass: riscv_v_if_model 

`endif //__RISCV_V_IF_MODEL_SV__