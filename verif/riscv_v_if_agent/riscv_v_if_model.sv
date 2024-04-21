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

    virtual function riscv_instruction_t get_instruction(bit use_file = 1'b1, bit use_specific_instr = 1'b0, bit use_specific_mode = 1'b0, bit use_specific_vm = 1'b0, riscv_v_opcode_e opcode = ADD, riscv_v_funct3_e mode = OPIVV, vm = 1'b1);
        riscv_instruction_t instr;
        if (use_file) begin
            `uvm_fatal(get_name(), "use_file mode not supported yet")
        end else if (use_specific_instr) begin
            case(opcode)
                ADD         : instr = instruction.get_vadd_instr(use_specific_mode, mode);
                default     : `uvm_fatal(get_name(), $sformatf("Invalid instruction: %0s", opcode.name()))
            endcase
        end else begin
            `uvm_fatal(get_name(), "Get random instruction not supported yet")
        end
        if (use_specific_vm) begin
            if (vm == 1'b0 && opcode inside{1'b0}) begin
                `uvm_fatal(get_name(), $sformatf("Instruction: %0s, doesn't support masking", opcode.name()))
            end
            instr.V.vm = vm;
            if (instr.V.vd == 0) begin
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