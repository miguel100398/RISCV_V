//File: riscv_v_v_if_bfm
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V register BFM

`ifndef __RISCV_V_IF_BFM_SV__
`define __RISCV_V_IF_BFM_SV__ 

class riscv_v_if_bfm extends riscv_v_base_bfm#(
    .model_t(riscv_v_if_model),
    .seq_item_in_t(riscv_v_if_in_seq_item),
    .seq_item_out_t(riscv_v_if_out_seq_item),
    .sequencer_t(riscv_v_if_sqr),
    .cfg_obj_t(riscv_v_if_bfm_cfg_obj),
    .seq_t(riscv_v_if_seq)
);

    `uvm_component_utils(riscv_v_if_bfm);

    riscv_instruction_t instruction;
    `ifdef RISCV_V_INST
        riscv_v_opcode_e    opcode;
    `endif //RISCV_V_INST

    function new(string name = "riscv_v_if_bfm", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual function void port_in_handler();
        if (txn_in.rst) begin
            rst_bfm();
            if (driving_rst) begin
                return;
            end
        end else begin
            instruction = model.get_instruction(cfg.use_file, cfg.use_specific_instr, cfg.use_specific_mode, cfg.specific_instr, cfg.specific_mode);
            `ifdef RISCV_V_INST 
                opcode = get_opcode(instruction);
            `endif //RISCV_V_INST  
        end
        update_bfm_sem.put(update_bfm_sem_keys);
    endfunction: port_in_handler

    virtual function void rst_bfm();
        model.rst();
        instruction = '0;
        `ifdef RISCV_V_INST 
            opcode = NOP;
        `endif //RISCV_V_INST
    endfunction: rst_bfm;

    virtual function void rst_seq();
        seq.instruction  = '0;
        `ifdef RISCV_V_INST
            seq.opcode   = NOP;
        `endif //RISCV_V_INST
    endfunction: rst_seq

    virtual function void bfm_seq();
        seq.instruction  = instruction;
        `ifdef RISCV_V_INST
            seq.opcode   = opcode;
        `endif //RISCV_V_INST
    endfunction: bfm_seq

    virtual function riscv_v_opcode_e get_opcode(riscv_instruction_t instr);
        bit found = 0;
        riscv_v_opcode_e op;


        unique case(instr.V.funct6)
            //VADD VREDSUM VFADD
            RISCV_V_FUNCT6_VADD : begin
                //VADD
                if (instr.V.funct3 inside {OPIVV, OPIVX, OPIVI}) begin
                    op    = ADD;
                    found = 1;
                //VREDSUM
                end else if (instr.V.funct3 inside{OPMVV, OPMVX}) begin
                    op    = ADD_REDUCT;
                    found = 1;
                end
                //VFADD Not supported
            end
        endcase

        if (~found) begin
            riscv_v_funct3_e funct3_enum;
            funct3_enum = riscv_v_funct3_e'(instr.V.funct3);
            `uvm_fatal(get_name(), $sformatf("Not supported op, funct6: 0x%0h, funct3: %s", instr.V.funct6, funct3_enum.name()))
        end

        return op;
    endfunction: get_opcode  


endclass: riscv_v_if_bfm

`endif //__RISCV_V_IF_BFM_SV__