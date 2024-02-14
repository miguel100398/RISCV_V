//File: riscv_v_ext_csr_drv
//Author: Miguel Bucio
//Date: 28/01/23
//Description: RISC-V register file driver

`ifndef __RISCV_V_EXT_CSR_DRV_SV__
`define __RISCV_V_EXT_CSR_DRV_SV__

class riscv_v_ext_csr_drv extends riscv_v_base_drv#(.seq_item_t (riscv_v_ext_csr_seq_item));
  `uvm_component_utils(riscv_v_ext_csr_drv)

  //Virtual interface
  virtual riscv_v_ext_csr_if vif;

  // Constructor
  function new (string name = "riscv_v_ext_csr_drv", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

  virtual task drive_initial_agt();
    vif.rst = 1'b1;
    return;
  endtask: drive_initial_agt

  virtual task drive_initial_bfm();
    vif.ext_csr_data        = '0;
    vif.ext_wr_vsstatus     = 1'b0;
    vif.ext_wr_vtype        = 1'b0;
    vif.ext_wr_vl           = 1'b0;
    vif.ext_wr_vstart       = 1'b0;
    vif.ext_wr_vxrm         = 1'b0;
    vif.ext_wr_vxsat        = 1'b0;
  endtask: drive_initial_bfm 

  // drive 
  virtual task drive_agt();
    `uvm_info(get_name(), "Sending new External csr transaction", UVM_LOW)
    req.in.print();
    @(vif.cb_drv);
    vif.cb_drv.rst <= req.in.rst;

  endtask : drive_agt

  virtual task drive_bfm();
  
    `uvm_info(get_name(), "Sending new External CSR transaction", UVM_LOW)
    req.out.print();
    //@(vif.cb_bfm);
    vif.cb_bfm.ext_csr_data       <= req.out.ext_csr_data;
    vif.cb_bfm.ext_wr_vsstatus    <= req.out.ext_wr_vsstatus;
    vif.cb_bfm.ext_wr_vtype       <= req.out.ext_wr_vtype;
    vif.cb_bfm.ext_wr_vl          <= req.out.ext_wr_vl;
    vif.cb_bfm.ext_wr_vstart      <= req.out.ext_wr_vstart;
    vif.cb_bfm.ext_wr_vxrm        <= req.out.ext_wr_vxrm;
    vif.cb_bfm.ext_wr_vxsat       <= req.out.ext_wr_vxsat;

  endtask: drive_bfm

  //Get interface
  virtual function void get_vif();
    if (!uvm_config_db#(virtual riscv_v_ext_csr_if)::get(this, "*", interface_name, vif)) begin
      `uvm_fatal(get_name(), $sformatf("NO_VIF", "virtual interface must be set for: %s", interface_name));
    end
  endfunction: get_vif

endclass: riscv_v_ext_csr_drv


`endif //__RISCV_V_EXT_CSR_DRV_SV__