//File: riscv_v_v_ext_csr_bfm
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V External CSR BFM

`ifndef __RISCV_V_EXT_CSR_BFM_SV__
`define __RISCV_V_EXT_CSR_BFM_SV__ 

class riscv_v_ext_csr_bfm extends riscv_v_base_bfm#(
    .model_t(riscv_v_ext_csr_model),
    .seq_item_in_t(riscv_v_ext_csr_in_seq_item),
    .seq_item_out_t(riscv_v_ext_csr_out_seq_item),
    .sequencer_t(riscv_v_ext_csr_sqr),
    .cfg_obj_t(riscv_v_ext_csr_bfm_cfg_obj),
    .seq_t(riscv_v_ext_csr_seq)
);

    `uvm_component_utils(riscv_v_ext_csr_bfm)

    riscv_data_t    ext_csr_data;
    logic           ext_wr_vsstatus;
    logic           ext_wr_vtype;
    logic           ext_wr_vl;
    logic           ext_wr_vstart;
    logic           ext_wr_vxrm;
    logic           ext_wr_vxsat;

    function new(string name = "riscv_v_ext_csr_bfm", uvm_component parent = null);
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
            case (cfg.csr_rotator.get_current_entry())
                VSSTATUS_E : write_vsstatus();
                VTYPE_E    : write_vtype();
                VL_E       : write_vl();
                VSTART_E   : write_vstart();
                VXRM_E     : write_vxrm();
                VXSAT_E    : write_vxsat();
                default    : `uvm_error(get_name(), $sformatf("Invalid CSR enum: %0s", cfg.csr_rotator.get_current_entry()))
            endcase
            cfg.csr_rotator.rotate_left(); 
        end
        update_bfm_sem.put(update_bfm_sem_keys);
    endfunction: port_in_handler

    virtual function void rst_bfm();
        model.rst();
        cfg.csr_rotator.rst();
        ext_csr_data    = '0;
        ext_wr_vsstatus = 1'b0;
        ext_wr_vtype    = 1'b0;
        ext_wr_vl       = 1'b0;
        ext_wr_vstart   = 1'b0;
        ext_wr_vxrm     = 1'b0;
        ext_wr_vxsat    = 1'b0;
    endfunction: rst_bfm;

    virtual function void rst_seq();
        seq.ext_csr_data    = '0;
        seq.ext_wr_vsstatus = 1'b0;
        seq.ext_wr_vtype    = 1'b0;
        seq.ext_wr_vl       = 1'b0;
        seq.ext_wr_vstart   = 1'b0;
        seq.ext_wr_vxrm     = 1'b0;
        seq.ext_wr_vxsat    = 1'b0;
    endfunction: rst_seq

    virtual function void bfm_seq();
        seq.ext_csr_data    = ext_csr_data;
        seq.ext_wr_vsstatus = ext_wr_vsstatus;
        seq.ext_wr_vtype    = ext_wr_vtype;
        seq.ext_wr_vl       = ext_wr_vl;
        seq.ext_wr_vstart   = ext_wr_vstart;
        seq.ext_wr_vxrm     = ext_wr_vxrm;
        seq.ext_wr_vxsat    = ext_wr_vxsat;
    endfunction: bfm_seq
 
    virtual function void write_vsstatus();
        ext_wr_vsstatus = cfg.wr_vsstatus;
        ext_wr_vtype    = 1'b0;
        ext_wr_vl       = 1'b0;
        ext_wr_vstart   = 1'b0;
        ext_wr_vxrm     = 1'b0;
        ext_wr_vxsat    = 1'b0;
        ext_csr_data    = `RISCV_V_ZX(cfg.vsstatus_wr_data, $bits(ext_csr_data));
    endfunction: write_vsstatus

    virtual function void write_vtype();
        ext_wr_vsstatus = 1'b0;
        ext_wr_vtype    = cfg.wr_vtype;
        ext_wr_vl       = 1'b0;
        ext_wr_vstart   = 1'b0;
        ext_wr_vxrm     = 1'b0;
        ext_wr_vxsat    = 1'b0;
        ext_csr_data    = `RISCV_V_ZX(cfg.vtype_wr_data, $bits(ext_csr_data));
    endfunction: write_vtype

    virtual function void write_vl();
        ext_wr_vsstatus = 1'b0;
        ext_wr_vtype    = 1'b0;
        ext_wr_vl       = cfg.wr_vl;
        ext_wr_vstart   = 1'b0;
        ext_wr_vxrm     = 1'b0;
        ext_wr_vxsat    = 1'b0;
        ext_csr_data    = `RISCV_V_ZX(cfg.vl_wr_data, $bits(ext_csr_data));
    endfunction: write_vl

    virtual function void write_vstart();
        ext_wr_vsstatus = 1'b0;
        ext_wr_vtype    = 1'b0;
        ext_wr_vl       = 1'b0;
        ext_wr_vstart   = cfg.wr_vstart;
        ext_wr_vxrm     = 1'b0;
        ext_wr_vxsat    = 1'b0;
        ext_csr_data    = `RISCV_V_ZX(cfg.vstart_wr_data, $bits(ext_csr_data));
    endfunction: write_vstart

    virtual function void write_vxrm();
        ext_wr_vsstatus = 1'b0;
        ext_wr_vtype    = 1'b0;
        ext_wr_vl       = 1'b0;
        ext_wr_vstart   = 1'b0;
        ext_wr_vxrm     = cfg.wr_vxrm;
        ext_wr_vxsat    = 1'b0;
        ext_csr_data    = `RISCV_V_ZX(cfg.vxrm_wr_data, $bits(ext_csr_data));
    endfunction: write_vxrm

    virtual function void write_vxsat();
        ext_wr_vsstatus = 1'b0;
        ext_wr_vtype    = 1'b0;
        ext_wr_vl       = 1'b0;
        ext_wr_vstart   = 1'b0;
        ext_wr_vxrm     = 1'b0;
        ext_wr_vxsat    = cfg.wr_vxsat;
        ext_csr_data    = `RISCV_V_ZX(cfg.vxsat_wr_data, $bits(ext_csr_data));
    endfunction: write_vxsat

endclass: riscv_v_ext_csr_bfm

`endif //__RISCV_V_EXT_CSR_BFM_SV__