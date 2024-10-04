//File: riscv_v_Csr_drv
//Author: Miguel Bucio
//Date: 28/01/23
//Description: RISCV V CSR driver

`ifndef __RISCV_V_CSR_DRV_SV__
`define __RISCV_V_CSR_DRV_SV__

class riscv_v_csr_drv extends riscv_v_base_drv#(.seq_item_t (riscv_v_csr_seq_item));
  `uvm_component_utils(riscv_v_csr_drv)

  //Virtual interface
  virtual riscv_v_csr_if vif;

  // Constructor
  function new (string name = "riscv_v_csr_drv", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

  virtual task drive_initial_agt();
    return;
  endtask: drive_initial_agt

  virtual task drive_initial_bfm();
    return;
  endtask: drive_initial_bfm 

  // drive 
  virtual task drive_agt();
    return;

  endtask : drive_agt

  virtual task drive_bfm();
  
    return;

  endtask: drive_bfm

  //Get interface
  virtual function void get_vif();
    if (!uvm_config_db#(virtual riscv_v_csr_if)::get(this, "*", interface_name, vif)) begin
      `uvm_fatal(get_name(), $sformatf("NO_VIF: virtual interface must be set for: %s", interface_name));
    end
  endfunction: get_vif

endclass: riscv_v_csr_drv


`endif //__RISCV_V_CSR_DRV_SV__