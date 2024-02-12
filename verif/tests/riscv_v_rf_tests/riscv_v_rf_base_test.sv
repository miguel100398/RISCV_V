//File: riscv_rf_base_test.sv
//Author: Miguel Bucio
//Date: 04/02/24
//Description: riscv alu base test

`ifndef __RISCV_RF_BASE_TEST_SV__
`define __RISCV_RF_BASE_TEST_SV__ 

virtual class riscv_rf_base_test extends riscv_v_base_test;
    `uvm_component_utils(riscv_rf_base_test)

    typedef riscv_v_rf_env rf_env_t;
    typedef riscv_v_rf_bfm rf_bfm_t;

    rf_env_t rf_env;
    rf_bfm_t rf_bfm;

    function new(string name = "riscv_rf_base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        rf_env = rf_env_t::type_id::create("riscv_v_rf_env", this);

        uvm_config_db #(uvm_active_passive_enum)::set(this, "riscv_v_rf_env.*", "is_active",       UVM_ACTIVE);
        uvm_config_db #(bit)::set(this,                     "riscv_v_rf_env.*", "USE_BFM",         1'b0);
        uvm_config_db #(bit)::set(this,                     "riscv_v_rf_env*",  "USE_SCBD",        1'b1);
        uvm_config_db #(string)::set(this,                  "riscv_v_rf_env.*", "interface_name",  "riscv_v_rf_vif");
        uvm_config_db #(bit)::set(this,                     "riscv_v_rf_env.*", "bfm_mode",        1'b0);

    endfunction: build_phase

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        rf_bfm = rf_env.agt.bfm;
    endfunction: start_of_simulation_phase


endclass: riscv_rf_base_test



`endif //__RISCV_RF_BASE_TEST_SV__