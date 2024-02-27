//File: riscv_v_rf_bfm
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V register BFM

`ifndef __RISCV_RF_BFM_SV__
`define __RISCV_RF_BFM_SV__ 

class riscv_rf_bfm extends rf_bfm#(
    .model_t(rf_model#(
        .data_t(riscv_data_t),
        .NUM_REGS(RISCV_RF_NUM_REGS),
        .PROTECT_REG_ZERO(RISCV_RF_PROTECT_REG_ZERO)
    )),
    .seq_item_in_t(riscv_rf_wr_seq_item),
    .seq_item_out_t(riscv_rf_rd_seq_item),
    .sequencer_t(riscv_rf_sqr),
    .cfg_obj_t(riscv_rf_bfm_cfg_obj),
    .seq_t(riscv_rf_seq)
);

    `uvm_component_utils(riscv_rf_bfm);


    riscv_data_t srca;
    riscv_data_t srcb;

    function new(string name = "riscv_rf_bfm", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual function void update_wr_rf();

         //Write data
        if (txn_in.wr_en) begin
            rf.write_data(txn_in.addr, txn_in.data);
        end

    endfunction: update_wr_rf

    virtual function void update_rd_rf();

       //Read data
        if (txn_out.port == RF_RD_PORT_A) begin
            srca = rf.read_data(txn_out.addr);
        end else if (txn_out.port == RF_RD_PORT_B)begin
            srcb = rf.read_data(txn_out.addr);
        end

    endfunction: update_rd_rf

    virtual function void rst_seq();
        seq.rd_data_A  = 'x;
        seq.rd_data_B  = 'x;
    endfunction: rst_seq

    virtual function void bfm_seq();
        seq.rd_data_A  = srca;
        seq.rd_data_B  = srcb;
    endfunction: bfm_seq

    virtual function void rst_bfm();
        if (cfg.init_rand_rf) begin
            rf.rst_rand();
        end else begin
            rf.rst();
        end
    endfunction: rst_bfm


endclass: riscv_rf_bfm

`endif //__RISCV_RF_BFM_SV__