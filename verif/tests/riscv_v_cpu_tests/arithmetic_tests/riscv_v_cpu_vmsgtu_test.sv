//File: riscv_v_cpu_vmsgtu_test
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-V Vector CPU DOA Test

`ifndef __RISCV_V_CPU_VMSGTU_TEST_SV__
`define __RISCV_V_CPU_VMSGTU_TEST_SV__

class riscv_v_cpu_vmsgtu_test extends riscv_v_cpu_base_test;

    `uvm_component_utils(riscv_v_cpu_vmsgtu_test)

    function new(string name = "riscv_v_cpu_vmsgtu_test",uvm_component parent=null);
        super.new(name,parent);
        //Set Global variables
        NUM_TXN_BLOCK   = 50;
        SUPPORTS_MASK   = 1;
        SUPPORTS_UNMASK = 1;
        NUM_OSIZES      = RISCV_V_NUM_VALID_OSIZES;
        NUM_FORMATS     = 2;
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
        if_cfg.specific_instr       = SGTU;
        if_cfg.specific_mode        = OPIVV;
        if_cfg.specific_vm          = 1'b1;
        //Set Valid osizes for test
        valid_osizes = new[NUM_OSIZES];
        valid_osizes = '{OSIZE_8, OSIZE_16, OSIZE_32, OSIZE_64, OSIZE_128};
        //Set Valid formats for test
        valid_formats = new[NUM_FORMATS];
        valid_formats = '{OPIVI, OPIVX};
    endfunction: specific_bfm_cfg

endclass: riscv_v_cpu_vmsgtu_test 

`endif //__RISCV_V_CPU_VMSGTU_TEST_SV__ 