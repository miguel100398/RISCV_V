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

  virtual task drive_initial_agt();
    vif.wr_addr      <= '0;
    vif.rd_addr_A    <= '0;
    vif.rd_addr_B    <= '0;
    vif.data_in      <= '0;
    vif.wr_en        <= '0;
  endtask: drive_initial_agt

  virtual task drive_initial_bfm();
    vif.data_out_A   <= '0;
    vif.data_out_B   <= '0;
    vif.mask         <= '0;
  endtask: drive_initial_bfm

  // drive 
  virtual task drive_agt();
    `uvm_info(get_name(), "Sending new rf transaction", UVM_LOW)
    req.print();
    @(vif.cb_drv);
    vif.cb_drv.wr_addr      <= req.in.addr;
    vif.cb_drv.rd_addr_A    <= req.out.addr;
    vif.cb_drv.rd_addr_B    <= req.out2.addr;
    vif.cb_drv.data_in      <= req.in.data;
    vif.cb_drv.wr_en        <= req.in.wr_en;
    if (req.in.reset_wr_en) begin
      @(vif.cb_drv);
      vif.cb_drv.wr_en      <= '0;
    end

  endtask : drive_agt

   // drive 
  virtual task drive_bfm();
    `uvm_info(get_name(), "Sending new rf transaction", UVM_LOW)
    req.out.print();
    req.out2.print();
    @(vif.cb_bfm);
    vif.cb_bfm.data_out_A <= req.out.data;
    vif.cb_bfm.data_out_B <= req.out2.data;
    vif.cb_bfm.mask       <= req.out.mask;

  endtask: drive_bfm

  //Get interface
  virtual function void get_vif();
    if (!uvm_config_db#(virtual riscv_v_rf_if)::get(this, "*", interface_name, vif)) begin
      `uvm_fatal(get_name(), $sformatf("NO_VIF: virtual interface must be set for: %s", interface_name));
    end
  endfunction: get_vif

endclass: riscv_v_rf_drv


`endif //__RISCV_V_RF_DRV_SV__