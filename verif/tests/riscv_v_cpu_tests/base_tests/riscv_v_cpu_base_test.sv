//File: riscv_v_cpu_base_test
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-V Vector DOA Test

`ifndef __RISCV_V_CPU_BASE_TEST_SV__
`define __RISCV_V_CPU_BASE_TEST_SV__

virtual class riscv_v_cpu_base_test extends riscv_v_base_test;
    `uvm_component_utils(riscv_v_cpu_base_test)

    typedef riscv_rf_env            int_rf_env_t;
    typedef riscv_rf_bfm            int_rf_bfm_t;
    typedef riscv_rf_bfm_cfg_obj    int_rf_cfg_t;
    typedef riscv_v_rf_env          vec_rf_env_t;
    typedef riscv_v_rf_bfm          vec_rf_bfm_t;
    typedef riscv_v_alu_env         alu_env_t;
    typedef riscv_v_alu_bfm         alu_bfm_t;
    typedef riscv_v_if_env          if_env_t;
    typedef riscv_v_if_bfm          if_bfm_t;
    typedef riscv_v_if_bfm_cfg_obj  if_cfg_t;

    int_rf_env_t int_rf_env;
    int_rf_bfm_t int_rf_bfm;
    int_rf_cfg_t int_rf_cfg;
    vec_rf_env_t vec_rf_env;
    vec_rf_bfm_t vec_rf_bfm;
    alu_env_t    alu_env;
    alu_bfm_t    alu_bfm;
    if_env_t     if_env;
    if_bfm_t     if_bfm;
    if_cfg_t     if_cfg;
    riscv_v_alu_interfaces_names_t interfaces_names;

    function new(string name = "riscv_v_cpu_base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        int_rf_env = int_rf_env_t::type_id::create("int_rf_env", this);
        vec_rf_env = vec_rf_env_t::type_id::create("vec_rf_env", this);
        alu_env    = alu_env_t::type_id::create("alu_env", this);
        if_env     = if_env_t::type_id::create("if_env", this);

        int_rf_cfg = int_rf_cfg_t::type_id::create("int_rf_bfm_cfg");
        if_cfg     = if_cfg_t::type_id::create("if_bfm_cfg");

        uvm_config_db #(uvm_active_passive_enum)::set(this, "int_rf_env.*",     "is_active",                    UVM_ACTIVE);
        uvm_config_db #(bit)::set(this,                     "int_rf_env.*",     "USE_BFM",                      1'b1);
        uvm_config_db #(bit)::set(this,                     "int_rf_env.*",     "bfm_mode",                     1'b1);
        uvm_config_db #(bit)::set(this,                     "int_rf_env*",      "USE_SCBD",                     1'b0);
        uvm_config_db #(int_rf_cfg_t)::set(this,            "int_rf_env.*",     "int_rf_env_agent_bfm_cfg",     int_rf_cfg);
        uvm_config_db #(uvm_active_passive_enum)::set(this, "vec_rf_env.*",     "is_active",                    UVM_PASSIVE);
        uvm_config_db #(bit)::set(this,                     "vec_rf_env.*",     "USE_BFM",                      1'b0);
        uvm_config_db #(bit)::set(this,                     "vec_rf_env.*",     "bfm_mode",                     1'b0);
        uvm_config_db #(bit)::set(this,                     "vec_rf_env*",      "USE_SCBD",                     1'b1);
        uvm_config_db #(uvm_active_passive_enum)::set(this, "alu_env.*",        "is_active",                    UVM_PASSIVE);
        uvm_config_db #(bit)::set(this,                     "alu_env.*",        "USE_BFM",                      1'b0);
        uvm_config_db #(bit)::set(this,                     "alu_env.*",        "bfm_mode",                     1'b0);
        uvm_config_db #(bit)::set(this,                     "alu_env*",         "USE_SCBD",                     1'b1);
        uvm_config_db #(uvm_active_passive_enum)::set(this, "if_env.*",         "is_active",                    UVM_ACTIVE);
        uvm_config_db #(bit)::set(this,                     "if_env.*",         "USE_BFM",                      1'b1);
        uvm_config_db #(bit)::set(this,                     "if_env.*",         "bfm_mode",                     1'b1);
        uvm_config_db #(bit)::set(this,                     "if_env*",          "USE_SCBD",                     1'b0);
        uvm_config_db #(if_cfg_t)::set(this,                "if_env.*",         "if_env_agent_bfm_cfg",         if_cfg);
        //Set interfaces names
        uvm_config_db #(string)::set(this, "int_rf_env.*", "interface_name",  "riscv_v_int_rf_vif");
        uvm_config_db #(string)::set(this, "vec_rf_env.*", "interface_name",  "riscv_v_vec_rf_vif");
        interfaces_names[LOGIC_ALU]       = "riscv_v_vec_logic_alu_vif";
        interfaces_names[ARITHMETIC_ALU]  = "riscv_v_vec_arithmetic_alu_vif";
        interfaces_names[MASK_ALU]        = "riscv_v_vec_mask_alu_vif";
        interfaces_names[PERMUTATION_ALU] = "riscv_v_vec_permutation_alu_vif";
        uvm_config_db #(string)::set(this, "alu_env.*", "logic_vif_name",  interfaces_names[LOGIC_ALU]);
        uvm_config_db #(string)::set(this, "alu_env.*", "arithmetic_vif_name",  interfaces_names[ARITHMETIC_ALU]);
        uvm_config_db #(string)::set(this, "alu_env.*", "mask_vif_name",  interfaces_names[MASK_ALU]);
        uvm_config_db #(string)::set(this, "alu_env.*", "permutation_vif_name",  interfaces_names[PERMUTATION_ALU]);
        uvm_config_db #(string)::set(this, "if_env.*",  "interface_name",  "riscv_v_if_vif");

        configure_bfm();

    endfunction: build_phase

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        int_rf_bfm = int_rf_env.agt.bfm;
        vec_rf_bfm = vec_rf_env.agt.bfm;
        alu_bfm = alu_env.agt.bfm;
        if_bfm  = if_env.agt.bfm;
    endfunction: start_of_simulation_phase

    virtual task run_phase(uvm_phase phase);
        int_rf_bfm.start_bfm();
        if_bfm.start_bfm();
    endtask: run_phase

    virtual function void configure_bfm();
        base_bfm_cfg();
        specific_bfm_cfg();
    endfunction: configure_bfm

    virtual function void base_bfm_cfg();
        //Integer register File
        int_rf_cfg.run_forever      = 1'b1;
        //Instruction Fetch
        if_cfg.num_txn              = 100;
        if_cfg.use_file             = 1'b0;
    endfunction: base_bfm_cfg

    pure virtual function void specific_bfm_cfg();

endclass: riscv_v_cpu_base_test
`endif //__RISCV_V_CPU_BASE_TEST_SV__