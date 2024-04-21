//File: riscv_v_cpu_vadd_osize8_v2v_test
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-V Vector CPU DOA Test

`ifndef __RISCV_V_CPU_VADD_OSIZE8_V2V_TEST_SV__
`define __RISCV_V_CPU_VADD_OSIZE8_V2V_TEST_SV__

class riscv_v_cpu_vadd_osize8_v2v_test extends riscv_v_cpu_base_test;

    `uvm_component_utils(riscv_v_cpu_vadd_osize8_v2v_test)

    function new(string name = "riscv_v_cpu_vadd_osize8_v2v_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

    endfunction : build_phase

    virtual function void specific_bfm_cfg();
        //Instruction Fetch
        if_cfg.use_specific_instr   = 1'b1;
        if_cfg.use_specific_mode    = 1'b1;
        if_cfg.use_specific_vm      = 1'b1;
        if_cfg.specific_instr       = ADD;
        if_cfg.specific_mode        = OPIVV;
        if_cfg.specific_vm          = 1'b1;
    endfunction: specific_bfm_cfg

    virtual task run_phase(uvm_phase phase);
        riscv_v_vtype_t vtype_tmp;
        super.run_phase(phase);

        vtype_tmp = RISCV_V_VTYPE_RST_VAL;

        //Wait for Initialization
        repeat(RST_CYCLES + INIT_CYCLES) begin
                @(vec_env.agt.mon.vif.cb_mon);
        end

        //For loop osizes
        for (int osize = 0; osize < RISCV_V_NUM_VALID_OSIZES; osize++) begin
            //Update osize
            vtype_tmp.vsew = osize;
            ext_csr_cfg.vtype_wr_data = vtype_tmp;
            //Not Mask
            if_cfg.specific_vm          = 1'b1;
            repeat(NUM_TXN_BLOCK) begin
                @(vec_env.agt.mon.vif.cb_mon);
            end
            //Mask
            if_cfg.specific_vm          = 1'b0;
            repeat(NUM_TXN_BLOCK) begin
                @(vec_env.agt.mon.vif.cb_mon);
            end
        end
        
    endtask: run_phase

endclass: riscv_v_cpu_vadd_osize8_v2v_test 

`endif //__RISCV_V_CPU_VADD_OSIZE8_V2V_TEST_SV__ 