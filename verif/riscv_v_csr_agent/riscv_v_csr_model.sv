//File: riscv_v_csr_model
//Author: Miguel Bucio
//Date: 16/04/24
//Description: RiscV V CSR Model

`ifndef __RISCV_V_CSR_MODEL__
`define __RISCV_V_CSR_MODEL__ 

class riscv_v_csr_model extends riscv_v_base_model;
    `uvm_component_utils(riscv_v_csr_model)

    riscv_v_vsstatus_t vsstatus;
    riscv_v_vtype_t    vtype;
    riscv_v_vl_t       vl;
    riscv_v_vlenb_t    vlenb;
    riscv_v_vstart_t   vstart;
    riscv_v_vxrm_t     vxrm;
    riscv_v_vxsat_t    vxsat;
    riscv_v_vcsr_t     vcsr;

    function new(string name = "riscv_v_csr_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual function void rst();
        vsstatus               = RISCV_V_VSSTATUS_RST_VAL;
        vtype                  = RISCV_V_VTYPE_RST_VAL;
        vl                     = RISCV_V_VL_RST_VAL;
        vlenb                  = vl.len >> 3;
        vstart                 = RISCV_V_VSTART_RST_VAL;
        vxrm                   = RISCV_V_VXRM_RST_VAL;
        vxsat                  = RISCV_V_VXSAT_RST_VAL;
        vcsr.rounding_mode     = vxrm.rounding_mode;
        vcsr.saturate          = vxsat.saturate;
    endfunction: rst

    ///////////////////////////////////////WRITE CSR/////////////////////////////////////////////////////////////
    
    virtual function void write_vsstatus(riscv_v_vsstatus_t _vsstatus);
        vsstatus = _vsstatus;
    endfunction: write_vsstatus

    virtual function void write_vtype(riscv_v_vtype_t _vtype);
        vtype = _vtype;
    endfunction: write_vtype

    virtual function void write_vl(riscv_v_vl_t _vl);
        vl    = _vl;
        vlenb = vl.len >> 3;
    endfunction: write_vl

    virtual function void write_vstart(riscv_v_vstart_t _vstart);
        vstart = _vstart;
    endfunction: write_vstart

    virtual function void write_vxrm(riscv_v_vxrm_t _vxrm);
        vxrm                = _vxrm;
        vcsr.rounding_mode  = vxrm.rounding_mode;
    endfunction: write_vxrm

    virtual function void write_vxsat(riscv_v_vxsat_t _vxsat);
        vxsat           = _vxsat;
        vcsr.saturate   = vxsat.saturate;
    endfunction: write_vxsat

    ///////////////////////////////////////READ CSR//////////////////////////////////////////////////////////////

    virtual function riscv_v_vsstatus_t read_vsstatus();
        return vsstatus;
    endfunction: read_vsstatus

    virtual function riscv_v_vtype_t read_vtype();
        return vtype;
    endfunction: read_vtype

    virtual function riscv_v_vl_t read_vl();
        return vl;
    endfunction: read_vl 

    virtual function riscv_v_vlenb_t read_vlenb();
        return vlenb;
    endfunction: read_vlenb

    virtual function riscv_v_vstart_t read_vstart();
        return vstart;
    endfunction: read_vstart

    virtual function riscv_v_vxrm_t read_vxrm();
        return vxrm;
    endfunction: read_vxrm

    virtual function riscv_v_vxsat_t read_vxsat();
        return vxsat;
    endfunction: read_vxsat

    virtual function riscv_v_vcsr_t read_vcsr();
        return vcsr;
    endfunction: read_vcsr

endclass: riscv_v_csr_model

`endif //__RISCV_V_CSR_MODEL__  