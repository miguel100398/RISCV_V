//File: riscv_v_csr_mon
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISCV Vector extension CSR monitor

`ifndef __RISCV_V_CSR_MON_SV___
`define __RISCV_V_CSR_MON_SV___

class riscv_v_csr_mon extends riscv_v_base_mon#( .seq_item_in_t   (riscv_v_csr_in_seq_item),
                                            .seq_item_out_t  (riscv_v_csr_out_seq_item));
  `uvm_component_utils(riscv_v_csr_mon)

  localparam int in_sem_keys = 1;
  localparam int out_sem_keys = 2;
  //Semaphore to process read transactions before write transactions
  semaphore rd_sem;
  
  //Virtual interface
  virtual riscv_v_csr_if vif;
  // new - constructor
  function new (string name = "riscv_v_csr_mon", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rd_sem = new(in_sem_keys);
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

  virtual task mon_rtl_in();
    riscv_v_csr_in_seq_item in_txn;
    @(vif.cb_mon);
    //2 Keys needed, rd proccess will be executed before
    rd_sem.get(in_sem_keys);

    in_txn = riscv_v_csr_in_seq_item::type_id::create("in_txn", this);

    in_txn.rst                      = vif.cb_mon.rst;
    in_txn.vsstatus_data_in         = vif.cb_mon.vsstatus_data_in;
    in_txn.vsstatus_wr_en           = vif.cb_mon.vsstatus_wr_en;
    in_txn.vtype_data_in            = vif.cb_mon.vtype_data_in;
    in_txn.vtype_wr_en              = vif.cb_mon.vtype_wr_en;
    in_txn.vl_data_in               = vif.cb_mon.vl_data_in;
    in_txn.vl_wr_en                 = vif.cb_mon.vl_wr_en;
    in_txn.vstart_data_in           = vif.cb_mon.vstart_data_in;
    in_txn.vstart_wr_en             = vif.cb_mon.vstart_wr_en;
    in_txn.vxrm_data_in             = vif.cb_mon.vxrm_data_in;
    in_txn.vxrm_wr_en               = vif.cb_mon.vxrm_wr_en;
    in_txn.vxsat_data_in            = vif.cb_mon.vxsat_data_in;
    in_txn.vxsat_wr_en              = vif.cb_mon.vxsat_wr_en;

    rtl_in_ap.write(in_txn);
    rd_sem.put(out_sem_keys);

  endtask: mon_rtl_in

  virtual task mon_rtl_out();
    riscv_v_csr_out_seq_item out_txn;
    out_txn = riscv_v_csr_out_seq_item::type_id::create("out_txn", this);
    @(vif.cb_mon);
    rd_sem.get(out_sem_keys);


    out_txn.vsstatus_data_out       = vif.cb_mon.vsstatus_data_out;
    out_txn.vtype_data_out          = vif.cb_mon.vtype_data_out;
    out_txn.vl_data_out             = vif.cb_mon.vl_data_out;
    out_txn.vlenb_data_out          = vif.cb_mon.vlenb_data_out;
    out_txn.vstart_data_out         = vif.cb_mon.vstart_data_out;
    out_txn.vxrm_data_out           = vif.cb_mon.vxrm_data_out;
    out_txn.vxsat_data_out          = vif.cb_mon.vxsat_data_out;
    out_txn.vcsr_data_out           = vif.cb_mon.vcsr_data_out;

    rtl_out_ap.write(out_txn);

    //Set key to unlock write taks
    rd_sem.put(in_sem_keys);
  endtask: mon_rtl_out

  //Get interface
  virtual function void get_vif();
    if (!uvm_config_db#(virtual riscv_v_csr_if)::get(this, "*", interface_name, vif)) begin
      `uvm_fatal(get_name(), $sformatf("NO_VIF: virtual interface must be set for: %s", interface_name));
    end
  endfunction: get_vif

endclass: riscv_v_csr_mon

`endif //__RISCV_V_CSR_MON_SV___