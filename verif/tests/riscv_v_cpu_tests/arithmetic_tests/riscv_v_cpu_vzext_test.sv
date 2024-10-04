//File: riscv_v_cpu_vzext_test
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-V Vector CPU Reduction ADD Test

`ifndef __RISCV_V_CPU_VZEXT_TEST_SV__
`define __RISCV_V_CPU_VZEXT_TEST_SV__

class riscv_v_cpu_vzext_test extends riscv_v_cpu_base_test;

    `uvm_component_utils(riscv_v_cpu_vzext_test)

    function new(string name = "riscv_v_cpu_vzext_test",uvm_component parent=null);
        super.new(name,parent);
        //Set Global variables
        NUM_TXN_BLOCK   = 50;
        SUPPORTS_MASK   = 1;
        SUPPORTS_UNMASK = 1;
        NUM_OSIZES      = RISCV_V_NUM_VALID_OSIZES-1;
        NUM_FORMATS     = 1;
        TOTAL_BLOCKS    = NUM_FORMATS*NUM_OSIZES*(SUPPORTS_MASK+SUPPORTS_UNMASK);
        USE_RAND_START  = 1'b1;
        USE_RAND_LEN    = 1'b1;
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    virtual function void specific_bfm_cfg();
        //Instruction Fetch
        if_cfg.use_specific_instr   = 1'b1;
        if_cfg.use_specific_mode    = 1'b1;
        if_cfg.use_specific_vm      = 1'b1;
        if_cfg.specific_instr       = ZERO_EXT;
        if_cfg.specific_mode        = OPMVV;
        if_cfg.specific_vm          = 1'b1;
        //Set Valid osizes for test
        valid_osizes = new[NUM_OSIZES];
        valid_osizes = '{OSIZE_16, OSIZE_32, OSIZE_64, OSIZE_128};
        //Set Valid formats for test
        valid_formats = new[NUM_FORMATS];
        valid_formats = '{OPMVV};

    endfunction: specific_bfm_cfg

    virtual task init_ext_csr_cfg();

        ext_csr_cfg.wr_vsstatus       = 1'b0;
        ext_csr_cfg.wr_vl             = 1'b0;
        ext_csr_cfg.wr_vtype          = 1'b1;
        ext_csr_cfg.wr_vstart         = 1'b0;
        ext_csr_cfg.wr_vxrm           = 1'b0;
        ext_csr_cfg.wr_vxsat          = 1'b0;

        ext_csr_cfg.vsstatus_wr_data   = RISCV_V_VSSTATUS_RST_VAL;
        ext_csr_cfg.vl_wr_data         = RISCV_V_VL_RST_VAL;
        ext_csr_cfg.vtype_wr_data      = RISCV_V_VTYPE_RST_VAL;
        ext_csr_cfg.vtype_wr_data.vsew = VSEW_16;
        ext_csr_cfg.vstart_wr_data     = RISCV_V_VSTART_RST_VAL;
        ext_csr_cfg.vxrm_wr_data       = RISCV_V_VXRM_RST_VAL;
        ext_csr_cfg.vxsat_wr_data      = RISCV_V_VXSAT_RST_VAL;

    endtask:init_ext_csr_cfg

endclass: riscv_v_cpu_vzext_test 

`endif //__RISCV_V_CPU_VZEXT_TEST_SV__ 