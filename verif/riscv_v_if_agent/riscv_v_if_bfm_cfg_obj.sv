//File: riscv_v_if_bfm_cfg_obj.sv
//Author: Miguel Bucio
//Date: 12/02/24
//Description: Riscv V Instruction Fetc BFM configuration object 

`ifndef __RISCV_V_IF_BFM_CFG_OBJ_SV__
`define __RISCV_V_IF_BFM_CFG_OBJ_SV__

class riscv_v_if_bfm_cfg_obj extends riscv_v_base_bfm_cfg_obj;

    `uvm_object_utils(riscv_v_if_bfm_cfg_obj)

    bit use_file           = 1'b0;
    bit use_rf_rst_seq     = 1'b1;
    bit use_specific_instr = 1'b0;
    bit use_specific_mode  = 1'b0;

    riscv_v_opcode_e specific_instr = ADD;
    riscv_v_funct3_e specific_mode  = OPIVV;

    bit rf_rst_complete = 1'b0;

    //Register File reset sequence
    riscv_v_opcode_e rf_rst_seq[RISCV_V_RF_NUM_REGS];

    function new(string name = "riscv_v_if_bfm_cfg_obj");
        riscv_v_opcode_e rf_rst_seq_tmp[RISCV_V_RF_NUM_REGS-1];
        super.new(name);

        rf_rst_seq_tmp = '{
            (RISCV_V_RF_NUM_REGS-1){BW_OR}
        };

        rf_rst_seq = {
            rf_rst_seq_tmp, BW_AND
        };

    endfunction: new
    

endclass: riscv_v_if_bfm_cfg_obj

`endif  //__RISCV_V_IF_BFM_CFG_OBJ_SV__