//File: riscv_v_cpu_base_test
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-V Vector DOA Test

`ifndef __RISCV_V_CPU_BASE_TEST_SV__
`define __RISCV_V_CPU_BASE_TEST_SV__

virtual class riscv_v_cpu_base_test extends riscv_v_base_test;
    `uvm_component_utils(riscv_v_cpu_base_test)

    typedef riscv_rf_env                int_rf_env_t;
    typedef riscv_rf_bfm                int_rf_bfm_t;
    typedef riscv_rf_bfm_cfg_obj        int_rf_cfg_t;
    typedef riscv_v_rf_env              vec_rf_env_t;
    typedef riscv_v_rf_bfm              vec_rf_bfm_t;
    typedef riscv_v_alu_env             alu_env_t;
    typedef riscv_v_alu_bfm             alu_bfm_t;
    typedef riscv_v_if_env              if_env_t;
    typedef riscv_v_if_bfm              if_bfm_t;
    typedef riscv_v_if_bfm_cfg_obj      if_cfg_t;
    typedef riscv_v_ext_csr_env         ext_csr_env_t;
    typedef riscv_v_ext_csr_bfm         ext_csr_bfm_t;
    typedef riscv_v_ext_csr_bfm_cfg_obj ext_csr_cfg_t;
    typedef riscv_v_ext_csr_rotator     ext_csr_rotator_t;

    int_rf_env_t        int_rf_env;
    int_rf_bfm_t        int_rf_bfm;
    int_rf_cfg_t        int_rf_cfg;
    vec_rf_env_t        vec_rf_env;
    vec_rf_bfm_t        vec_rf_bfm;
    alu_env_t           alu_env;
    alu_bfm_t           alu_bfm;
    if_env_t            if_env;
    if_bfm_t            if_bfm;
    if_cfg_t            if_cfg;
    ext_csr_env_t       ext_csr_env;
    ext_csr_bfm_t       ext_csr_bfm;
    ext_csr_cfg_t       ext_csr_cfg;
    ext_csr_rotator_t   ext_csr_rotator;
    riscv_v_alu_interfaces_names_t interfaces_names;

    function new(string name = "riscv_v_cpu_base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        int_rf_env      = int_rf_env_t::type_id::create("int_rf_env", this);
        vec_rf_env      = vec_rf_env_t::type_id::create("vec_rf_env", this);
        alu_env         = alu_env_t::type_id::create("alu_env", this);
        if_env          = if_env_t::type_id::create("if_env", this);
        ext_csr_env     = ext_csr_env_t::type_id::create("ext_csr_env", this);

        int_rf_cfg      = int_rf_cfg_t::type_id::create("int_rf_bfm_cfg");
        if_cfg          = if_cfg_t::type_id::create("if_bfm_cfg");
        ext_csr_cfg     = ext_csr_cfg_t::type_id::create("ext_csr_bfm_cfg");

        ext_csr_rotator = ext_csr_rotator_t::type_id::create("ext_csr_rotator", this);

        //INT RF
        uvm_config_db #(uvm_active_passive_enum)::set(this, "int_rf_env.*",     "is_active",                    UVM_ACTIVE);
        uvm_config_db #(bit)::set(this,                     "int_rf_env.*",     "USE_BFM",                      1'b1);
        uvm_config_db #(bit)::set(this,                     "int_rf_env.*",     "bfm_mode",                     1'b1);
        uvm_config_db #(bit)::set(this,                     "int_rf_env*",      "USE_SCBD",                     1'b0);
        uvm_config_db #(int_rf_cfg_t)::set(this,            "int_rf_env.*",     "int_rf_env_agent_bfm_cfg",     int_rf_cfg);
        //VEC RF
        uvm_config_db #(uvm_active_passive_enum)::set(this, "vec_rf_env.*",     "is_active",                    UVM_PASSIVE);
        uvm_config_db #(bit)::set(this,                     "vec_rf_env.*",     "USE_BFM",                      1'b0);
        uvm_config_db #(bit)::set(this,                     "vec_rf_env.*",     "bfm_mode",                     1'b0);
        uvm_config_db #(bit)::set(this,                     "vec_rf_env*",      "USE_SCBD",                     1'b1);
        //ALU
        uvm_config_db #(uvm_active_passive_enum)::set(this, "alu_env.*",        "is_active",                    UVM_PASSIVE);
        uvm_config_db #(bit)::set(this,                     "alu_env.*",        "USE_BFM",                      1'b0);
        uvm_config_db #(bit)::set(this,                     "alu_env.*",        "bfm_mode",                     1'b0);
        uvm_config_db #(bit)::set(this,                     "alu_env*",         "USE_SCBD",                     1'b1);
        //IF
        uvm_config_db #(uvm_active_passive_enum)::set(this, "if_env.*",         "is_active",                    UVM_ACTIVE);
        uvm_config_db #(bit)::set(this,                     "if_env.*",         "USE_BFM",                      1'b1);
        uvm_config_db #(bit)::set(this,                     "if_env.*",         "bfm_mode",                     1'b1);
        uvm_config_db #(bit)::set(this,                     "if_env*",          "USE_SCBD",                     1'b0);
        uvm_config_db #(if_cfg_t)::set(this,                "if_env.*",         "if_env_agent_bfm_cfg",         if_cfg);
        //EXT CSR
        uvm_config_db #(uvm_active_passive_enum)::set(this, "ext_csr_env.*",    "is_active",                    UVM_ACTIVE);
        uvm_config_db #(bit)::set(this,                     "ext_csr_env.*",    "USE_BFM",                      1'b1);
        uvm_config_db #(bit)::set(this,                     "ext_csr_env.*",    "bfm_mode",                     1'b1);
        uvm_config_db #(bit)::set(this,                     "ext_csr_env*",     "USE_SCBD",                     1'b0);
        uvm_config_db #(ext_csr_cfg_t)::set(this,           "ext_csr_env.*",    "ext_csr_env_agent_bfm_cfg",    ext_csr_cfg);
        //ALU Interfaces names
        interfaces_names[LOGIC_ALU]       = "riscv_v_vec_logic_alu_vif";
        interfaces_names[ARITHMETIC_ALU]  = "riscv_v_vec_arithmetic_alu_vif";
        interfaces_names[MASK_ALU]        = "riscv_v_vec_mask_alu_vif";
        interfaces_names[PERMUTATION_ALU] = "riscv_v_vec_permutation_alu_vif";
        //Set interfaces names
        uvm_config_db #(string)::set(this, "int_rf_env.*", "interface_name",  "riscv_v_int_rf_vif");
        uvm_config_db #(string)::set(this, "vec_rf_env.*", "interface_name",  "riscv_v_vec_rf_vif");
        uvm_config_db #(string)::set(this, "alu_env.*",         "logic_vif_name",  interfaces_names[LOGIC_ALU]);
        uvm_config_db #(string)::set(this, "alu_env.*",         "arithmetic_vif_name",  interfaces_names[ARITHMETIC_ALU]);
        uvm_config_db #(string)::set(this, "alu_env.*",         "mask_vif_name",  interfaces_names[MASK_ALU]);
        uvm_config_db #(string)::set(this, "alu_env.*",         "permutation_vif_name",  interfaces_names[PERMUTATION_ALU]);
        uvm_config_db #(string)::set(this, "if_env.*",          "interface_name",  "riscv_v_if_vif");
        uvm_config_db #(string)::set(this, "ext_csr_env.*",     "interface_name",  "riscv_v_ext_csr_vif");

        configure_bfm();

    endfunction: build_phase

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        get_bfm();
    endfunction: start_of_simulation_phase

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        start_bfm();
    endtask: run_phase

    virtual function void get_bfm();
        int_rf_bfm = int_rf_env.agt.bfm;
        vec_rf_bfm = vec_rf_env.agt.bfm;
        alu_bfm = alu_env.agt.bfm;
        if_bfm  = if_env.agt.bfm;
        ext_csr_bfm = ext_csr_env.agt.bfm;
    endfunction: get_bfm

    virtual function void start_bfm();
        int_rf_bfm.start_bfm();
        if_bfm.start_bfm();
        ext_csr_bfm.start_bfm();
    endfunction: start_bfm

    virtual function void configure_bfm();
        configure_csr_rotator();
        base_bfm_cfg();
        specific_bfm_cfg();
    endfunction: configure_bfm

    virtual function void base_bfm_cfg();
        //Instruction Fetch
        if_cfg.use_rf_rst_seq       = 1'b1;
        //Integer register File
        int_rf_cfg.run_forever      = 1'b1;
        int_rf_cfg.init_rand_rf     = 1'b1;
        //Instruction Fetch
        if_cfg.num_txn              = 100;
        if_cfg.use_file             = 1'b0;
        //EXT csr wr en
        ext_csr_cfg.wr_vsstatus          = 1'b0;
        ext_csr_cfg.wr_vl                = 1'b1;
        ext_csr_cfg.wr_vtype             = 1'b1;
        ext_csr_cfg.wr_vstart            = 1'b0;
        ext_csr_cfg.wr_vxrm              = 1'b0;
        ext_csr_cfg.wr_vxsat             = 1'b0;
        //EXT csr wr data
        ext_csr_cfg.vsstatus_wr_data     = RISCV_V_VSSTATUS_RST_VAL;
        ext_csr_cfg.vtype_wr_data        = RISCV_V_VTYPE_RST_VAL;
        ext_csr_cfg.vl_wr_data           = RISCV_V_VL_RST_VAL;
        ext_csr_cfg.vstart_wr_data       = RISCV_V_VSTART_RST_VAL;
        ext_csr_cfg.vxrm_wr_data         = RISCV_V_VXRM_RST_VAL;
        ext_csr_cfg.vxsat_wr_data        = RISCV_V_VXSAT_RST_VAL;
    endfunction: base_bfm_cfg

    virtual function void base_csr_rotator_cfg();
        ext_csr_rotator.set_num_entries(2);
        ext_csr_rotator.set_entry(VTYPE_E,      0);
        ext_csr_rotator.set_entry(VL_E,         1);
        ext_csr_rotator.set_entry(VSSTATUS_E,   2);
        ext_csr_rotator.set_entry(VSTART_E,     3);
        ext_csr_rotator.set_entry(VXRM_E,       4);
        ext_csr_rotator.set_entry(VXSAT_E,      5);
    endfunction: base_csr_rotator_cfg

    virtual function void configure_csr_rotator();
        base_csr_rotator_cfg();
        specific_csr_rotator_cfg();
        ext_csr_cfg.set_rotator(ext_csr_rotator);
    endfunction: configure_csr_rotator

    virtual function void specific_csr_rotator_cfg();
        //Override this function if needed
        return;
    endfunction: specific_csr_rotator_cfg

    pure virtual function void specific_bfm_cfg();

endclass: riscv_v_cpu_base_test
`endif //__RISCV_V_CPU_BASE_TEST_SV__