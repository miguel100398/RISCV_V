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
    typedef riscv_v_env                 vec_env_t;
    typedef riscv_v_bfm                 vec_bfm_t;
    typedef riscv_v_bfm_cfg_obj         vec_cfg_t;               

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
    vec_env_t           vec_env;
    vec_bfm_t           vec_bfm;
    vec_cfg_t           vec_cfg;
    riscv_v_alu_interfaces_names_t interfaces_names;

    int RST_CYCLES          = 6;
    int INIT_CYCLES         = 32;
    int NUM_TXN_BLOCK       = 0;
    bit SUPPORTS_MASK       = 0;
    bit SUPPORTS_UNMASK     = 1;
    int NUM_OSIZES          = 0;
    int NUM_FORMATS         = 0;
    int TOTAL_BLOCKS        = NUM_FORMATS*NUM_OSIZES*(SUPPORTS_MASK+1);

    bit USE_RAND_START      = 1'b0;
    bit USE_RAND_LEN        = 1'b0;

    riscv_v_osize_e  valid_osizes[];
    riscv_v_funct3_e valid_formats[];

    bit cfg_wr_vsstatus     = 1'b0;
    bit cfg_wr_vl           = 1'b1;
    bit cfg_wr_vtype        = 1'b1;
    bit cfg_wr_vstart       = 1'b1;
    bit cfg_wr_vxrm         = 1'b0;
    bit cfg_wr_vxsat        = 1'b0;

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
        vec_env         = vec_env_t::type_id::create("vec_env", this);

        int_rf_cfg      = int_rf_cfg_t::type_id::create("int_rf_bfm_cfg");
        if_cfg          = if_cfg_t::type_id::create("if_bfm_cfg");
        ext_csr_cfg     = ext_csr_cfg_t::type_id::create("ext_csr_bfm_cfg");
        vec_cfg         = vec_cfg_t::type_id::create("vec_cfg");

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
        //VEC
        uvm_config_db #(uvm_active_passive_enum)::set(this, "vec_env.*",        "is_active",                    UVM_PASSIVE);
        uvm_config_db #(bit)::set(this,                     "vec_env.*",        "USE_BFM",                      1'b0);
        uvm_config_db #(bit)::set(this,                     "vec_env.*",        "bfm_mode",                     1'b0);
        uvm_config_db #(bit)::set(this,                     "vec_env*",         "USE_SCBD",                     1'b1);
        uvm_config_db #(vec_cfg_t)::set(this,               "vec_env.*",        "vec_env_agent_bfm_cfg",        vec_cfg);
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
        uvm_config_db #(string)::set(this, "vec_env.*",         "interface_name",  "riscv_v_vif");

        configure_bfm();

    endfunction: build_phase

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        get_bfm();
    endfunction: start_of_simulation_phase

    virtual task run_phase(uvm_phase phase);
        riscv_v_vtype_t vtype_tmp;
        super.run_phase(phase);
        start_bfm();
   
        vtype_tmp = RISCV_V_VTYPE_RST_VAL;

        ext_csr_cfg.wr_vsstatus     = 1'b0;
        ext_csr_cfg.wr_vl           = 1'b0;
        ext_csr_cfg.wr_vtype        = 1'b0;
        ext_csr_cfg.wr_vstart       = 1'b0;
        ext_csr_cfg.wr_vxrm         = 1'b0;
        ext_csr_cfg.wr_vxsat        = 1'b0;

        //Wait for Initialization
        repeat(RST_CYCLES + INIT_CYCLES) begin
                @(vec_env.agt.mon.vif.cb_mon);
        end

        ext_csr_cfg.wr_vsstatus     = cfg_wr_vsstatus;
        ext_csr_cfg.wr_vl           = cfg_wr_vl;
        ext_csr_cfg.wr_vtype        = cfg_wr_vtype;
        ext_csr_cfg.wr_vstart       = cfg_wr_vstart;
        ext_csr_cfg.wr_vxrm         = cfg_wr_vxrm;
        ext_csr_cfg.wr_vxsat        = cfg_wr_vxsat;

        //For Format
        for (int format = 0; format < NUM_FORMATS; format++) begin
            //Update format
            if_cfg.specific_mode = valid_formats[format];
            //For loop osizes
            for (int osize = 0; osize < NUM_OSIZES; osize++) begin
                //Update osize
                vtype_tmp.vsew = riscv_v_vsew_t'(valid_osizes[osize]);
                ext_csr_cfg.vtype_wr_data = vtype_tmp;
                if (SUPPORTS_UNMASK) begin
                    //Not Mask
                    if_cfg.specific_vm          = 1'b1;
                    repeat(NUM_TXN_BLOCK) begin
                        @(vec_env.agt.mon.vif.cb_mon);

                        //Update Start
                        if (USE_RAND_START) begin

                            riscv_v_field_vstart_t tmp_vstart;
                            assert (
                                std::randomize(tmp_vstart) with{
                                    tmp_vstart dist{0 :/ 80, [0:RISCV_V_NUM_ELEMENTS_REG] :/ 15, [RISCV_V_NUM_ELEMENTS_REG:$] :/ 5};
                                }
                            ) else `uvm_fatal(get_name(), "Can't randomize vstart")
                            ext_csr_cfg.vstart_wr_data.index = tmp_vstart;

                        end
                        //Update Len 
                        if (USE_RAND_LEN) begin
                            
                            riscv_v_vlen_t tmp_len;
                            assert (
                                std::randomize(tmp_len) with{
                                    tmp_len dist{RISCV_V_NUM_ELEMENTS_REG :/ 80, [0:RISCV_V_NUM_ELEMENTS_REG-1] :/ 15, [RISCV_V_NUM_ELEMENTS_REG:$] :/ 5};
                                }
                            ) else `uvm_fatal(get_name(), "Can't randomize vlen")
                            ext_csr_cfg.vl_wr_data.len = tmp_len;

                        end

                    end
                end
                if (SUPPORTS_MASK) begin
                    //Mask
                    if_cfg.specific_vm          = 1'b0;
                    repeat(NUM_TXN_BLOCK) begin
                        @(vec_env.agt.mon.vif.cb_mon);

                         //Update Start
                        if (USE_RAND_START) begin

                            riscv_v_field_vstart_t tmp_vstart;
                            assert (
                                std::randomize(tmp_vstart) with{
                                    tmp_vstart dist{0 :/ 80, [0:RISCV_V_NUM_ELEMENTS_REG] :/ 15, [RISCV_V_NUM_ELEMENTS_REG:$] :/ 5};
                                }
                            ) else `uvm_fatal(get_name(), "Can't randomize vstart")
                            ext_csr_cfg.vstart_wr_data.index = tmp_vstart;

                        end
                        //Update Len 
                        if (USE_RAND_LEN) begin
                            
                            riscv_v_vlen_t tmp_len;
                            assert (
                                std::randomize(tmp_len) with{
                                    tmp_len dist{RISCV_V_NUM_ELEMENTS_REG :/ 80, [0:RISCV_V_NUM_ELEMENTS_REG-1] :/ 15, [RISCV_V_NUM_ELEMENTS_REG:$] :/ 5};
                                }
                            ) else `uvm_fatal(get_name(), "Can't randomize vlen")
                            ext_csr_cfg.vl_wr_data.len = tmp_len;

                        end
                        
                    end
                end
            end
        end

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
        if (valid_osizes.size() == 0) begin
            `uvm_fatal(get_name(), "Valid osizes is 0, override this parameter to start test")
        end
        if (valid_formats.size() == 0) begin
            `uvm_fatal(get_name(), "Valid formats is 0, override this parameter to start test")
        end
        if (NUM_TXN_BLOCK == 0) begin
            `uvm_fatal(get_name(), "NUM_TXN_BLOCK is 0, override this parameter to start text")
        end
        if (TOTAL_BLOCKS == 0) begin
            `uvm_fatal(get_name(), "TOTAL_BLOCKS is 0, override this parameter to start test")
        end
    endfunction: configure_bfm

    virtual function void base_bfm_cfg();
        //Instruction Fetch
        if_cfg.use_rf_rst_seq       = 1'b1;
        //Integer register File
        int_rf_cfg.run_forever      = 1'b1;
        int_rf_cfg.init_rand_rf     = 1'b1;
        //Instruction Fetch
        if_cfg.num_txn              =(RST_CYCLES + INIT_CYCLES) + (NUM_TXN_BLOCK*TOTAL_BLOCKS);
        if_cfg.use_file             = 1'b0;
        //EXT csr wr en
        ext_csr_cfg.run_forever     = 1'b1;
        ext_csr_cfg.wr_vsstatus     = cfg_wr_vsstatus;
        ext_csr_cfg.wr_vl           = cfg_wr_vl;
        ext_csr_cfg.wr_vtype        = cfg_wr_vtype;
        ext_csr_cfg.wr_vstart       = cfg_wr_vstart;
        ext_csr_cfg.wr_vxrm         = cfg_wr_vxrm;
        ext_csr_cfg.wr_vxsat        = cfg_wr_vxsat;
        //EXT csr wr data
        ext_csr_cfg.vsstatus_wr_data     = RISCV_V_VSSTATUS_RST_VAL;
        ext_csr_cfg.vtype_wr_data        = RISCV_V_VTYPE_RST_VAL;
        ext_csr_cfg.vl_wr_data           = RISCV_V_VL_RST_VAL;
        ext_csr_cfg.vstart_wr_data       = RISCV_V_VSTART_RST_VAL;
        ext_csr_cfg.vxrm_wr_data         = RISCV_V_VXRM_RST_VAL;
        ext_csr_cfg.vxsat_wr_data        = RISCV_V_VXSAT_RST_VAL;
    endfunction: base_bfm_cfg

    virtual function void base_csr_rotator_cfg();
        ext_csr_rotator.set_num_entries(3);
        ext_csr_rotator.set_entry(VTYPE_E,      0);
        ext_csr_rotator.set_entry(VL_E,         1);
        ext_csr_rotator.set_entry(VSTART_E,     2);
        ext_csr_rotator.set_entry(VSSTATUS_E,   3);
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