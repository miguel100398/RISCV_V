//File: riscv_alu_base_test.sv
//Author: Miguel Bucio
//Date: 04/02/24
//Description: riscv alu base test

`ifndef __RISCV_ALU_BASE_TEST_SV__
`define __RISCV_ALU_BASE_TEST_SV__ 

virtual class riscv_alu_base_test extends riscv_v_base_test;
    `uvm_component_utils(riscv_alu_base_test)

    typedef riscv_v_alu_env alu_env_t;
    typedef riscv_v_alu_bfm alu_bfm_t;

    alu_env_t                      alu_env;
    alu_bfm_t                      alu_bfm;
    riscv_v_alu_interfaces_names_t interfaces_names;

    function new(string name = "riscv_alu_base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        alu_env = alu_env_t::type_id::create("alu_env", this);

        uvm_config_db #(uvm_active_passive_enum)::set(this, "alu_env.*", "is_active",       UVM_ACTIVE);
        uvm_config_db #(bit)::set(this,                     "alu_env.*", "USE_BFM",         1'b0);
        uvm_config_db #(bit)::set(this,                     "alu_env.*", "bfm_mode",        1'b0);
        uvm_config_db #(bit)::set(this,                     "alu_env*",  "USE_SCBD",        1'b0);
        //Set interfaces names
        interfaces_names[LOGIC_ALU]       = "riscv_v_logic_alu_vif";
        interfaces_names[ARITHMETIC_ALU]  = "riscv_v_arithmetic_alu_vif";
        interfaces_names[MASK_ALU]        = "riscv_v_mask_alu_vif";
        interfaces_names[PERMUTATION_ALU] = "riscv_v_permutation_alu_vif";
        uvm_config_db #(string)::set(this, "alu_env.*", "logic_vif_name",  interfaces_names[LOGIC_ALU]);
        uvm_config_db #(string)::set(this, "alu_env.*", "arithmetic_vif_name",  interfaces_names[ARITHMETIC_ALU]);
        uvm_config_db #(string)::set(this, "alu_env.*", "mask_vif_name",  interfaces_names[MASK_ALU]);
        uvm_config_db #(string)::set(this, "alu_env.*", "permutation_vif_name",  interfaces_names[PERMUTATION_ALU]);

    endfunction: build_phase

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        alu_bfm = alu_env.agt.bfm;
    endfunction: start_of_simulation_phase


endclass: riscv_alu_base_test



`endif //__RISCV_ALU_BASE_TEST_SV__