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

    //Transactions
    riscv_v_logic_alu_in_seq_item logic_txn;

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
    endtask: drive_initial

    virtual task drive_initial_logic();
        logic_vif.is_reduct     <= 1'b0;
        logic_vif.is_and        <= 1'b0;
        logic_vif.is_or         <= 1'b0;
        logic_vif.srca          <= '0;
        logic_vif.srcb          <= '0;
        logic_vif.osize_vector  <= '0;
        `ifdef RISCV_V_INST
            logic_vif.opcode    <= NOP;
            logic_vif.osize     <= OSIZE_8;
            logic_vif.len       <= '0;
        `endif// RISCV_V_INST 
    endtask: drive_initial_logic

    virtual task drive();
        //Cast transaction
        if ($cast(logic_txn, req)) begin
            drive_logic();
        end else begin
            `uvm_fatal(get_name(), "Invalid alu_seq_item type, can't cas't to any  ALU seq_item type")
        end
    endtask: drive

    virtual task drive_logic();
        `uvm_info(get_name(), "Sending new logic ALU transaction", UVM_LOW)
        logic_txn.print();
        @(logic_vif.cb_drv);
        logic_vif.cb_drv.is_reduct <= logic_txn.is_reduct;
        logic_vif.cb_drv.is_and    <= logic_txn.is_and;
        logic_vif.cb_drv.is_or     <= logic_txn.is_or;
        logic_vif.cb_drv.srca      <= logic_txn.srca;
        logic_vif.cb_drv.srcb      <= logic_txn.srcb;
        logic_vif.osize_vector     <= logic_txn.osize_vector;
        `ifdef RISCV_V_INST
            logic_vif.cb_drv.opcode    <= logic_txn.opcode;
            logic_vif.cb_drv.osize     <= logic_txn.osize;
            logic_vif.cb_drv.len       <= logic_txn.len;
        `endif //RISCV_V_INST
    endtask: drive_logic

    //Get interfaces
  virtual function void get_vif();
    if (!uvm_config_db#(virtual riscv_v_logic_ALU_if)::get(this, "*", "riscv_v_logic_alu_vif", logic_vif)) begin
      `uvm_fatal("NO_VIF", "virtual interface must be set for: riscv_v_logic_alu_vif");
    end
  endfunction: get_vif

endclass: riscv_v_alu_drv


`endif // __RISCV_V_ALU_DRV_SV__