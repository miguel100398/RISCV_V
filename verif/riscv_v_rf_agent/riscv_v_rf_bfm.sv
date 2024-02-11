//File: riscv_v_rf_bfm.sv
//Author: Miguel Bucio
//Date: 04/02/23
//Description: RISC V RF BFM

`ifndef __RISCV_V_RF_BFM_SV__
`define __RISCV_V_RF_BFM_SV__ 

class riscv_v_rf_bfm extends rf_bfm#(
    .model_t(riscv_v_rf_model),
    .seq_item_in_t(riscv_v_rf_wr_seq_item),
    .seq_item_out_t(riscv_v_rf_rd_seq_item),
    .sequencer_t(riscv_v_rf_sqr),
    .cfg_obj_t(riscv_v_rf_bfm_cfg_obj),
    .seq_t(riscv_v_rf_seq)
);

    `uvm_component_utils(riscv_v_rf_bfm)

    riscv_v_data_t srca;
    riscv_v_data_t srcb;

    function new (string name = "riscv_v_rf_bfm", uvm_component  parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void update_wr_rf();

        //Write data
        rf.write_data_en(txn_in.addr, txn_in.data, txn_in.wr_en);

    endfunction: update_wr_rf

    virtual function void update_rd_rf();

        //Read data
        if (txn_out.port == RF_RD_PORT_A) begin
            srca = rf.read_data(txn_out.addr);
        end else if (txn_out.port == RF_RD_PORT_B) begin
            srcb = rf.read_data(txn_out.addr);
        end

    endfunction: update_rd_rf

    virtual function void rst_seq();
        seq.rd_data_A = 'x;
        seq.rd_data_B = 'x;
    endfunction: rst_seq 

    virtual function void bfm_seq();
        seq.rd_data_A = srca;
        seq.rd_data_B = srcb;
    endfunction: bfm_seq

endclass: riscv_v_rf_bfm

`endif //__RISCV_V_RF_BFM_SV__