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

    int rf_rst_idx = 0;

    function new(string name = "riscv_v_if_bfm", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cfg.rf_rst_complete = ~cfg.use_rf_rst_seq;
    endfunction: build_phase

    virtual function void port_in_handler();
        if (txn_in.rst) begin
            rst_bfm();
            if (driving_rst) begin
                return;
            end
        end else begin
            if (cfg.rf_rst_complete) begin
                instruction = model.get_instruction(cfg.use_file, cfg.use_specific_instr, cfg.use_specific_mode, cfg.specific_instr, cfg.specific_mode);
                `ifdef RISCV_V_INST 
                    opcode = f_riscv_v_get_opcode(instruction);
                `endif //RISCV_V_INST
            end else begin
                instruction.V.funct6 = f_riscv_v_opcode_to_funct6(cfg.rf_rst_seq[rf_rst_idx].opcode);
                instruction.V.vm     = 1'b0;
                instruction.V.vs2    = 5'b0;
                instruction.V.vs1    = cfg.rf_rst_seq[rf_rst_idx].imm;   //Immediate value
                instruction.V.funct3 = OPIVI;
                instruction.V.vd     = rf_rst_idx[4:0];
                instruction.V.op     = RISCV_V_TYPE_OP_CODE;
                `ifdef RISCV_V_INST
                    opcode = f_riscv_v_get_opcode(instruction);
                `endif //RISCV_V_INST
                rf_rst_idx++;
                cfg.rf_rst_complete = (rf_rst_idx == RISCV_V_RF_NUM_REGS);
            end  
        end
        update_bfm_sem.put(update_bfm_sem_keys);
    endfunction: port_in_handler

    virtual function void rst_bfm();
        model.rst();
        instruction = '0;
        cfg.rf_rst_complete = ~cfg.use_rf_rst_seq;
        rf_rst_idx          = 0;
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


endclass: riscv_v_if_bfm

`endif //__RISCV_V_IF_BFM_SV__