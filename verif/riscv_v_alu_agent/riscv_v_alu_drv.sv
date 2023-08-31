//File: riscv_v_alu_drv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extension ALU driver

`ifndef __RISCV_V_ALU_DRV_SV__
`define __RISCV_V_ALU_DRV_SV__ 

class riscv_v_alu_drv extends riscv_v_base_drv#(.seq_item_t(riscv_v_alu_in_seq_item));
    `uvm_component_utils(riscv_v_alu_drv)

    //Virtual interfaces
    virtual riscv_v_logic_ALU_if logic_vif;
    virtual riscv_v_arithmetic_ALU_if arithmetic_vif;

    //Transactions
    riscv_v_logic_alu_in_seq_item logic_txn;
    riscv_v_arithmetic_alu_in_seq_item arithmetic_txn;

    //Constructor
    function new(string name = "riscv_v_alu_drv", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask: run_phase

    virtual task drive_initial();
        drive_initial_logic();
        drive_initial_arithmetic();
    endtask: drive_initial

    virtual task drive_initial_logic();
        logic_vif.is_reduct                 <= 1'b0;
        logic_vif.is_and                    <= 1'b0;
        logic_vif.is_or                     <= 1'b0;
        logic_vif.is_xor                    <= 1'b0;
        logic_vif.is_shift                  <= 1'b0;
        logic_vif.is_left                   <= 1'b0;
        logic_vif.is_arith                  <= 1'b0;
        logic_vif.srca                      <= '0;
        logic_vif.srcb                      <= '0;
        logic_vif.osize_vector              <= '0;
        logic_vif.is_greater_osize_vector   <= '0;
        logic_vif.is_less_osize_vector      <= '0;
        `ifdef RISCV_V_INST
            logic_vif.opcode                <= NOP;
            logic_vif.osize                 <= OSIZE_8;
            logic_vif.len                   <= '0;
        `endif// RISCV_V_INST 
    endtask: drive_initial_logic

    virtual task drive_initial_arithmetic();
        arithmetic_vif.is_reduct               <= 1'b0;
        arithmetic_vif.is_add                  <= 1'b0;
        arithmetic_vif.is_sub                  <= 1'b0;
        arithmetic_vif.is_zero_ext             <= 1'b0;
        arithmetic_vif.is_sign_ext             <= 1'b0;
        arithmetic_vif.is_max                  <= 1'b0;
        arithmetic_vif.is_min                  <= 1'b0;
        arithmetic_vif.is_signed               <= 1'b0;
        arithmetic_vif.use_carry               <= 1'b0;
        arithmetic_vif.srca                    <= '0;
        arithmetic_vif.srcb                    <= '0;
        arithmetic_vif.carry_in                <= '0;
        arithmetic_vif.osize_vector            <= '0;
        arithmetic_vif.is_greater_osize_vector <= '0;
        arithmetic_vif.is_less_osize_vector    <= '0;
        `ifdef RISCV_V_INST
            logic_vif.opcode                   <= NOP;
            logic_vif.osize                    <= OSIZE_8;
            logic_vif.len                      <= '0;
        `endif// RISCV_V_INST 
    endtask: drive_initial_arithmetic

    virtual task drive();
        //Cast transaction
        if ($cast(logic_txn, req)) begin
            drive_logic();
        end else if ($cast(arithmetic_txn, req))begin
            drive_arithmetic();
        end else begin
            `uvm_fatal(get_name(), "Invalid alu_seq_item type, can't cas't to any  ALU seq_item type")
        end
    endtask: drive

    virtual task drive_logic();
        `uvm_info(get_name(), "Sending new logic ALU transaction", UVM_LOW)
        logic_txn.print();
        @(logic_vif.cb_drv);
        logic_vif.cb_drv.is_reduct        <= logic_txn.is_reduct;
        logic_vif.cb_drv.is_and           <= logic_txn.is_and;
        logic_vif.cb_drv.is_or            <= logic_txn.is_or;
        logic_vif.cb_drv.is_xor           <= logic_txn.is_xor;
        logic_vif.cb_drv.is_shift         <= logic_txn.is_shift;
        logic_vif.cb_drv.is_left          <= logic_txn.is_left;
        logic_vif.cb_drv.is_arith         <= logic_txn.is_arith;
        logic_vif.cb_drv.srca             <= logic_txn.srca;
        logic_vif.cb_drv.srcb             <= logic_txn.srcb;
        logic_vif.osize_vector            <= logic_txn.osize_vector;
        logic_vif.is_greater_osize_vector <= logic_txn.is_greater_osize_vector;
        logic_vif.is_less_osize_vector    <= logic_txn.is_less_osize_vector;
        `ifdef RISCV_V_INST
            logic_vif.cb_drv.opcode       <= logic_txn.opcode;
            logic_vif.cb_drv.osize        <= logic_txn.osize;
            logic_vif.cb_drv.len          <= logic_txn.len;
        `endif //RISCV_V_INST
    endtask: drive_logic

    virtual task drive_arithmetic();
        `uvm_info(get_name(), "Sending new arithmetic ALU transaction", UVM_LOW)
        arithmetic_txn.print();
        @(arithmetic_vif.cb_drv);
        arithmetic_vif.cb_drv.is_reduct        <= arithmetic_txn.is_reduct;
        arithmetic_vif.cb_drv.is_add           <= arithmetic_txn.is_add;
        arithmetic_vif.cb_drv.is_sub           <= arithmetic_txn.is_sub;
        arithmetic_vif.cb_drv.is_zero_ext      <= arithmetic_txn.is_zero_ext;
        arithmetic_vif.cb_drv.is_sign_ext      <= arithmetic_txn.is_sign_ext;
        arithmetic_vif.cb_drv.is_max           <= arithmetic_txn.is_max;
        arithmetic_vif.cb_drv.is_min           <= arithmetic_txn.is_min;
        arithmetic_vif.cb_drv.is_signed        <= arithmetic_txn.is_signed;
        arithmetic_vif.cb_drv.use_carry        <= arithmetic_txn.use_carry;
        arithmetic_vif.cb_drv.srca             <= arithmetic_txn.srca;
        arithmetic_vif.cb_drv.srcb             <= arithmetic_txn.srcb;
        arithmetic_vif.cb_drv.carry_in         <= arithmetic_txn.carry_in;
        arithmetic_vif.cb_drv.osize_vector     <= arithmetic_txn.osize_vector;
        arithmetic_vif.is_greater_osize_vector <= arithmetic_txn.is_greater_osize_vector;
        arithmetic_vif.is_less_osize_vector    <= arithmetic_txn.is_less_osize_vector;
        `ifdef RISCV_V_INST
            arithmetic_vif.cb_drv.opcode       <= arithmetic_txn.opcode;
            arithmetic_vif.cb_drv.osize        <= arithmetic_txn.osize;
            arithmetic_vif.cb_drv.len          <= arithmetic_txn.len;
        `endif //RISCV_V_INST
    endtask: drive_arithmetic

    //Get interfaces
  virtual function void get_vif();
    if (!uvm_config_db#(virtual riscv_v_logic_ALU_if)::get(this, "*", "riscv_v_logic_alu_vif", logic_vif)) begin
      `uvm_fatal("NO_VIF", "virtual interface must be set for: riscv_v_logic_alu_vif");
    end
    if (!uvm_config_db#(virtual riscv_v_arithmetic_ALU_if)::get(this, "*", "riscv_v_arithmetic_alu_vif", arithmetic_vif)) begin
      `uvm_fatal("NO_VIF", "virtual interface must be set for: riscv_v_arithmetic_alu_vif");
    end
  endfunction: get_vif

endclass: riscv_v_alu_drv


`endif // __RISCV_V_ALU_DRV_SV__