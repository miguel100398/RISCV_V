//File: riscv_v_rf_drv
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file driver

`ifndef __RISCV_V_RF_DRV_SV__
`define __RISCV_V_RF_DRV_SV__

class riscv_v_rf_drv extends riscv_v_base_drv#(.seq_item_t (riscv_v_rf_seq_item));
  `uvm_component_utils(riscv_v_rf_drv)

  //Virtual interface
  virtual riscv_v_rf_if vif;

  // Constructor
  function new (string name = "riscv_v_rf_drv", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

  virtual task drive_initial();
    vif.wr_addr      <= '0;
    vif.rd_addr_A    <= '0;
    vif.rd_addr_B    <= '0;
    vif.data_in      <= '0;
    vif.wr_en        <= '0;
  endtask: drive_initial

  // drive 
  virtual task drive();
    `uvm_info(get_name(), "Sending new rf transaction", UVM_LOW)
    req.print();
    @(vif.cb_drv);
    vif.cb_drv.wr_addr      <= req.wr_addr;
    vif.cb_drv.rd_addr_A    <= req.rd_addr_A;
    vif.cb_drv.rd_addr_B    <= req.rd_addr_B;
    vif.cb_drv.data_in      <= req.data_in;
    vif.cb_drv.wr_en        <= req.wr_en;
    if (req.reset_wr_en) begin
      @(vif.cb_drv);
    end

  endtask : drive

  //Get interface
  virtual function void get_vif();
    if (!uvm_config_db#(virtual riscv_v_rf_if)::get(this, "*", "riscv_v_rf_vif", vif)) begin
      `uvm_fatal("NO_VIF", "virtual interface must be set for: riscv_v_rf_vif");
    end
  endfunction: get_vif

endclass: riscv_v_rf_drv


`endif //__RISCV_V_RF_DRV_SV__