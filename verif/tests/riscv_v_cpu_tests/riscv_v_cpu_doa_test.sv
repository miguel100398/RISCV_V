//File: riscv_v_cpu_doa_test
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-V Vector CPU DOA Test

`ifndef __RISCV_V_CPU_DOA_TEST_SV__
`define __RISCV_V_CPU_DOA_TEST_SV__

class riscv_v_cpu_doa_test extends riscv_v_cpu_base_test;

    `uvm_component_utils(riscv_v_cpu_doa_test)

    function new(string name = "riscv_v_cpu_doa_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

    endfunction : build_phase

    task run_phase(uvm_phase phase);
        int_rf_bfm.start_bfm();
    endtask : run_phase

endclass: riscv_v_cpu_doa_test 

`endif //__RISCV_V_CPU_DOA_TEST_SV__ 