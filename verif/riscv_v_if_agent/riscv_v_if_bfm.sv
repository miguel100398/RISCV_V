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

    function new(string name = "riscv_v_if_bfm", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual function void port_in_handler();
        if (txn_in.rst) begin
            rst_bfm();
            rst_seq();
            if (driving_rst) begin
                return;
            end
        end else begin
            instruction = model.get_instruction(cfg.use_file, cfg.use_specific_instr, cfg.use_specific_mode, cfg.specific_instr, cfg.specific_mode);  
        end
        update_bfm_sem.put(update_bfm_sem_keys);
    endfunction: port_in_handler

    virtual function void rst_bfm();
        model.rst();
        instruction = '0;
    endfunction: rst_bfm;

    virtual function void rst_seq();
        seq.instruction  = '0;
    endfunction: rst_seq

    virtual function void bfm_seq();
        seq.instruction  = instruction;
    endfunction: bfm_seq


endclass: riscv_v_if_bfm

`endif //__RISCV_V_IF_BFM_SV__