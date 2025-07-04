//File: riscv_v_alu_drv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extension ALU driver

`ifndef __RISCV_V_ALU_DRV_SV__
`define __RISCV_V_ALU_DRV_SV__ 

class riscv_v_alu_drv extends riscv_v_base_drv#(.seq_item_t(riscv_v_alu_seq_item));
    `uvm_component_utils(riscv_v_alu_drv)

    //Virtual interfaces
    riscv_v_alu_interfaces_names_t  interfaces_names;
    virtual riscv_v_logic_ALU_if logic_vif;
    virtual riscv_v_arithmetic_ALU_if arithmetic_vif;
    virtual riscv_v_mask_ALU_if mask_vif;
    virtual riscv_v_permutation_ALU_if permutation_vif;

    //Transactions
    riscv_v_logic_alu_in_seq_item logic_txn;
    riscv_v_arithmetic_alu_in_seq_item arithmetic_txn;
    riscv_v_mask_alu_in_seq_item mask_txn;
    riscv_v_permutation_alu_in_seq_item permutation_txn;

    riscv_v_alu_out_seq_item logic_txn_bfm;
    riscv_v_alu_out_seq_item arithmetic_txn_bfm;
    riscv_v_mask_alu_out_seq_item mask_txn_bfm;
    riscv_v_permutation_alu_out_seq_item permutation_txn_bfm;

    //Constructor
    function new(string name = "riscv_v_alu_drv", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual function void check_interface_name();
        if (!(uvm_config_db #(string)::get(this, "", "logic_vif_name", interfaces_names[LOGIC_ALU]))) begin
            `uvm_fatal(get_name(), "logic_vif_name configuration not found in uvm_db");
        end
        if (!(uvm_config_db #(string)::get(this, "", "arithmetic_vif_name", interfaces_names[ARITHMETIC_ALU]))) begin
            `uvm_fatal(get_name(), "arithmetic_vif_name configuration not found in uvm_db");
        end
        if (!(uvm_config_db #(string)::get(this, "", "mask_vif_name", interfaces_names[MASK_ALU]))) begin
            `uvm_fatal(get_name(), "mask_vif_name configuration not found in uvm_db");
        end
        if (!(uvm_config_db #(string)::get(this, "", "permutation_vif_name", interfaces_names[PERMUTATION_ALU]))) begin
            `uvm_fatal(get_name(), "permutation_vif_name configuration not found in uvm_db");
        end
    endfunction: check_interface_name

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask: run_phase

    virtual task drive_initial_agt();
        drive_initial_logic_agt();
        drive_initial_arithmetic_agt();
        drive_initial_mask_agt();
        drive_initial_permutation_agt();
    endtask: drive_initial_agt

    virtual task drive_initial_bfm();
        drive_initial_logic_bfm();
        drive_initial_arithmetic_bfm();
        drive_initial_mask_bfm();
        drive_initial_permutation_bfm();
    endtask: drive_initial_bfm

    virtual task drive_initial_logic_agt();
        logic_vif.is_reduct                 <= 1'b0;
        logic_vif.is_and                    <= 1'b0;
        logic_vif.is_mask                   <= 1'b0;
        logic_vif.is_or                     <= 1'b0;
        logic_vif.is_xor                    <= 1'b0;
        logic_vif.is_shift                  <= 1'b0;
        logic_vif.is_left                   <= 1'b0;
        logic_vif.is_arith                  <= 1'b0;
        logic_vif.srca                      <= '0;
        logic_vif.srcb                      <= '0;
        logic_vif.dst_osize_vector          <= '0;
        logic_vif.is_greater_osize_vector   <= '0;
        `ifdef RISCV_V_INST
            logic_vif.opcode                <= NOP;
            logic_vif.osize                 <= OSIZE_8;
            logic_vif.len                   <= '0;
        `endif// RISCV_V_INST 
    endtask: drive_initial_logic_agt

    virtual task drive_initial_logic_bfm();
        logic_vif.result                    <= '0;
    endtask: drive_initial_logic_bfm

    virtual task drive_initial_arithmetic_agt();
        arithmetic_vif.is_reduct               <= 1'b0;
        arithmetic_vif.is_add                  <= 1'b0;
        arithmetic_vif.is_sub                  <= 1'b0;
        arithmetic_vif.is_mul                  <= 1'b0;
        arithmetic_vif.is_zero_ext             <= 1'b0;
        arithmetic_vif.is_sign_ext             <= 1'b0;
        arithmetic_vif.is_set_equal            <= 1'b0;
        arithmetic_vif.is_set_nequal           <= 1'b0;
        arithmetic_vif.is_set_less             <= 1'b0;
        arithmetic_vif.is_set_greater          <= 1'b0;
        arithmetic_vif.is_max                  <= 1'b0;
        arithmetic_vif.is_min                  <= 1'b0;
        arithmetic_vif.is_signed               <= 1'b0;
        arithmetic_vif.is_high                 <= 1'b0;
        arithmetic_vif.use_carry               <= 1'b0;
        arithmetic_vif.srca                    <= '0;
        arithmetic_vif.srcb                    <= '0;
        arithmetic_vif.carry_in                <= '0;
        arithmetic_vif.dst_osize_vector        <= '0;
        arithmetic_vif.src_osize_vector        <= '0;
        arithmetic_vif.is_greater_osize_vector <= '0;
        arithmetic_vif.is_less_osize_vector    <= '0;
        `ifdef RISCV_V_INST
            logic_vif.opcode                   <= NOP;
            logic_vif.osize                    <= OSIZE_8;
            logic_vif.len                      <= '0;
        `endif// RISCV_V_INST 
    endtask: drive_initial_arithmetic_agt

    virtual task drive_initial_arithmetic_bfm();
        arithmetic_vif.result                  <= '0;
        arithmetic_vif.cf                      <= '0;
        arithmetic_vif.zf                      <= '0;
        arithmetic_vif.of                      <= '0;
    endtask: drive_initial_arithmetic_bfm

    virtual task drive_initial_mask_agt();
        mask_vif.is_mask            <= 1'b0;
        mask_vif.is_and             <= 1'b0;
        mask_vif.is_or              <= 1'b0;
        mask_vif.is_xor             <= 1'b0;
        mask_vif.is_negate_srca     <= 1'b0;
        mask_vif.is_negate_result   <= 1'b0;
        mask_vif.srca               <= '0;
        mask_vif.srcb               <= '0;
        `ifdef RISCV_V_INST 
            mask_vif.opcode         <= NOP;
        `endif //RISCV_V_INST
    endtask: drive_initial_mask_agt

    virtual task drive_initial_mask_bfm();
        mask_vif.result            <= '0;
    endtask: drive_initial_mask_bfm

    virtual task drive_initial_permutation_agt();
        permutation_vif.is_i2v              <= 1'b0;
        permutation_vif.is_v2i              <= 1'b0;
        permutation_vif.srca                <= '0;
        permutation_vif.srcb                <= '0;
        `ifdef RISCV_V_INST 
            permutation_vif.opcode          <= NOP;
        `endif //RISCV_V_INST
    endtask: drive_initial_permutation_agt

    virtual task drive_initial_permutation_bfm();
        permutation_vif.vector_data_out      <= '0;
        permutation_vif.integer_data_out     <= '0;
    endtask: drive_initial_permutation_bfm

    virtual task drive_agt();
        //Cast transaction
        if ($cast(logic_txn, req.in)) begin
            drive_logic_agt();
        end else if ($cast(arithmetic_txn, req.in))begin
            drive_arithmetic_agt();
        end else if ($cast(mask_txn, req.in)) begin
            drive_mask_agt();
        end else if ($cast(permutation_txn, req.in))  begin  
            drive_permutation_agt();
        end else begin
            `uvm_fatal(get_name(), "Invalid alu_seq_item type, can't cas't to any  ALU seq_item type")
        end
    endtask: drive_agt

    virtual task drive_bfm();
        //Cast transaction
        if ($cast(logic_txn_bfm, req.out)) begin
            drive_logic_bfm();
        end else if ($cast(arithmetic_txn_bfm, req.out))begin
            drive_arithmetic_bfm();
        end else if ($cast(mask_txn_bfm, req.out)) begin
            drive_mask_bfm();
        end else if ($cast(permutation_txn_bfm, req.out))  begin  
            drive_permutation_bfm();
        end else begin
            `uvm_fatal(get_name(), "Invalid alu_seq_item type, can't cas't to any  ALU seq_item type")
        end
    endtask: drive_bfm

    virtual task drive_logic_agt();
        `uvm_info(get_name(), "Sending new logic ALU transaction", UVM_LOW)
        logic_txn.print();
        @(logic_vif.cb_drv);
        logic_vif.cb_drv.is_reduct        <= logic_txn.is_reduct;
        logic_vif.cb_drv.is_and           <= logic_txn.is_and;
        logic_vif.cb_drv.is_mask          <= logic_txn.is_mask;
        logic_vif.cb_drv.is_or            <= logic_txn.is_or;
        logic_vif.cb_drv.is_xor           <= logic_txn.is_xor;
        logic_vif.cb_drv.is_shift         <= logic_txn.is_shift;
        logic_vif.cb_drv.is_left          <= logic_txn.is_left;
        logic_vif.cb_drv.is_arith         <= logic_txn.is_arith;
        logic_vif.cb_drv.srca             <= logic_txn.srca;
        logic_vif.cb_drv.srcb             <= logic_txn.srcb;
        logic_vif.dst_osize_vector        <= logic_txn.dst_osize_vector;
        logic_vif.is_greater_osize_vector <= logic_txn.is_greater_osize_vector;
        `ifdef RISCV_V_INST
            logic_vif.cb_drv.opcode       <= logic_txn.opcode;
            logic_vif.cb_drv.osize        <= logic_txn.osize;
            logic_vif.cb_drv.len          <= logic_txn.len;
        `endif //RISCV_V_INST
    endtask: drive_logic_agt

    virtual task drive_logic_bfm();
        `uvm_info(get_name(), "Sending new logic ALU transaction", UVM_LOW)
        logic_txn_bfm.print();
        @(logic_vif.cb_bfm);
        logic_vif.cb_bfm.result          <= logic_txn_bfm.result;

    endtask: drive_logic_bfm

    virtual task drive_arithmetic_agt();
        `uvm_info(get_name(), "Sending new arithmetic ALU transaction", UVM_LOW)
        arithmetic_txn.print();
        @(arithmetic_vif.cb_drv);
        arithmetic_vif.cb_drv.is_reduct        <= arithmetic_txn.is_reduct;
        arithmetic_vif.cb_drv.is_add           <= arithmetic_txn.is_add;
        arithmetic_vif.cb_drv.is_sub           <= arithmetic_txn.is_sub;
        arithmetic_vif.cb_drv.is_mul           <= arithmetic_txn.is_mul;
        arithmetic_vif.cb_drv.is_zero_ext      <= arithmetic_txn.is_zero_ext;
        arithmetic_vif.cb_drv.is_set_equal     <= arithmetic_txn.is_set_equal;
        arithmetic_vif.cb_drv.is_set_nequal    <= arithmetic_txn.is_set_nequal;
        arithmetic_vif.cb_drv.is_set_less      <= arithmetic_txn.is_set_less;
        arithmetic_vif.cb_drv.is_set_greater   <= arithmetic_txn.is_set_greater;
        arithmetic_vif.cb_drv.is_max           <= arithmetic_txn.is_max;
        arithmetic_vif.cb_drv.is_min           <= arithmetic_txn.is_min;
        arithmetic_vif.cb_drv.is_signed        <= arithmetic_txn.is_signed;
        arithmetic_vif.cb_drv.is_high          <= arithmetic_txn.is_high;
        arithmetic_vif.cb_drv.use_carry        <= arithmetic_txn.use_carry;
        arithmetic_vif.cb_drv.srca             <= arithmetic_txn.srca;
        arithmetic_vif.cb_drv.srcb             <= arithmetic_txn.srcb;
        arithmetic_vif.cb_drv.carry_in         <= arithmetic_txn.carry_in;
        arithmetic_vif.cb_drv.dst_osize_vector <= arithmetic_txn.dst_osize_vector;
        arithmetic_vif.cb_drv.src_osize_vector <= arithmetic_txn.src_osize_vector;
        arithmetic_vif.is_greater_osize_vector <= arithmetic_txn.is_greater_osize_vector;
        arithmetic_vif.is_less_osize_vector    <= arithmetic_txn.is_less_osize_vector;
        `ifdef RISCV_V_INST
            arithmetic_vif.cb_drv.opcode       <= arithmetic_txn.opcode;
            arithmetic_vif.cb_drv.osize        <= arithmetic_txn.osize;
            arithmetic_vif.cb_drv.len          <= arithmetic_txn.len;
        `endif //RISCV_V_INST
    endtask: drive_arithmetic_agt

    virtual task drive_arithmetic_bfm();
        `uvm_info(get_name(), "Sending new arithmetic ALU transaction", UVM_LOW)
        arithmetic_txn_bfm.print();
        @(arithmetic_vif.cb_bfm);
        arithmetic_vif.cb_bfm.result          <= arithmetic_txn_bfm.result;
        arithmetic_vif.cb_bfm.zf              <= arithmetic_txn_bfm.zf;
        arithmetic_vif.cb_bfm.of              <= arithmetic_txn_bfm.of;
        arithmetic_vif.cb_bfm.cf              <= arithmetic_txn_bfm.cf;

    endtask: drive_arithmetic_bfm

    virtual task drive_mask_agt();
        `uvm_info(get_name(), "Sending new mask ALU transaction", UVM_LOW)
        mask_txn.print();
        @(mask_vif.cb_drv);
        mask_vif.cb_drv.is_mask             <= mask_txn.is_mask;
        mask_vif.cb_drv.is_and              <= mask_txn.is_and;
        mask_vif.cb_drv.is_or               <= mask_txn.is_or;
        mask_vif.cb_drv.is_xor              <= mask_txn.is_xor;
        mask_vif.cb_drv.is_negate_srca      <= mask_txn.is_negate_srca;
        mask_vif.cb_drv.is_negate_result    <= mask_txn.is_negate_result;
        mask_vif.cb_drv.srca                <= mask_txn.srca_mask;
        mask_vif.cb_drv.srcb                <= mask_txn.srcb_mask;
        `ifdef RISCV_V_INST  
            mask_vif.cb_drv.opcode          <= mask_txn.opcode;
        `endif //RISCV_V_INST
    endtask: drive_mask_agt

    virtual task drive_mask_bfm();
        `uvm_info(get_name(), "Sending new mask ALU transaction", UVM_LOW)
        mask_txn_bfm.print();
        @(mask_vif.cb_bfm);
        mask_vif.cb_bfm.result              <=  mask_txn_bfm.result;

    endtask: drive_mask_bfm

    virtual task drive_permutation_agt();
        `uvm_info(get_name(), "Sending new permutation ALU transaction", UVM_LOW)
        permutation_txn.print();
        @(permutation_vif.cb_drv);
        permutation_vif.cb_drv.is_i2v           <= permutation_txn.is_i2v;
        permutation_vif.cb_drv.is_v2i           <= permutation_txn.is_v2i;
        permutation_vif.cb_drv.srca             <= permutation_txn.srca;
        permutation_vif.cb_drv.srcb             <= permutation_txn.srcb;
        `ifdef RISCV_V_INST
            permutation_vif.cb_drv.opcode       <= permutation_txn.opcode;
        `endif //RISCV_V_INST
    endtask: drive_permutation_agt

    virtual task drive_permutation_bfm();
        `uvm_info(get_name(), "Sending new permutation ALU transaction", UVM_LOW)
        permutation_txn_bfm.print();
        @(permutation_vif.cb_bfm);
        permutation_vif.cb_bfm.vector_data_out      <= permutation_txn_bfm.vector_data_out;
        permutation_vif.cb_bfm.integer_data_out     <= permutation_txn_bfm.integer_data_out;

    endtask: drive_permutation_bfm

    //Get interfaces
  virtual function void get_vif();
    if (!uvm_config_db#(virtual riscv_v_logic_ALU_if)::get(this, "*", interfaces_names[LOGIC_ALU], logic_vif)) begin
      `uvm_fatal(get_name(), $sformatf("NO_VIF: virtual interface must be set for: %s", interfaces_names[LOGIC_ALU]));
    end
    if (!uvm_config_db#(virtual riscv_v_arithmetic_ALU_if)::get(this, "*", interfaces_names[ARITHMETIC_ALU], arithmetic_vif)) begin
      `uvm_fatal(get_name(), $sformatf("NO_VIF: virtual interface must be set for: %s", interfaces_names[ARITHMETIC_ALU]));
    end
    if (!uvm_config_db#(virtual riscv_v_mask_ALU_if)::get(this, "*", interfaces_names[MASK_ALU], mask_vif)) begin
      `uvm_fatal(get_name(), $sformatf("NO_VIF: virtual interface must be set for: %s", interfaces_names[MASK_ALU]));
    end
    if (!uvm_config_db#(virtual riscv_v_permutation_ALU_if)::get(this, "*", interfaces_names[PERMUTATION_ALU], permutation_vif)) begin
      `uvm_fatal(get_name(), $sformatf("NO_VIF: virtual interface must be set for: %s", interfaces_names[PERMUTATION_ALU]));
    end
  endfunction: get_vif

endclass: riscv_v_alu_drv


`endif // __RISCV_V_ALU_DRV_SV__