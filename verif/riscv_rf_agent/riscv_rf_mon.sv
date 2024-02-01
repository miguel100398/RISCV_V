//File: riscv_rf_mon
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V Vector extension register file monitor

`ifndef __RISCV_RF_MON_SV___
`define __RISCV_RF_MON_SV___

class riscv_rf_mon extends riscv_base_mon#( .seq_item_in_t   (riscv_rf_wr_seq_item),
                                            .seq_item_out_t  (riscv_rf_rd_seq_item));
  `uvm_component_utils(riscv_v_rf_mon)

  localparam int rd_sem_keys = 1;
  localparam int wr_sem_keys = 2;
  //Semaphore to process read transactions before write transactions
  semaphore rd_sem;
  
  //Virtual interface
  virtual riscv_rf_if vif;
  // new - constructor
  function new (string name = "riscv_rf_mon", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rd_sem = new(rd_sem_keys);
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

  virtual task mon_rtl_in();
    riscv_rf_wr_seq_item wr_txn;
    //Monitor write transaction
    @(vif.cb_mon);
    //2 Keys needed, rd proccess will be executed before
    rd_sem.get(wr_sem_keys);
    if (vif.cb_mon.wr_en) begin
      `uvm_info(get_name(), "Transaction captured in wr port", UVM_HIGH);
      wr_txn = riscv_rf_wr_seq_item::type_id::create("wr_txn", this);
      wr_txn.addr  = vif.cb_mon.wr_addr;
      wr_txn.wr_en = vif.cb_mon.wr_en;
      wr_txn.data  = vif.cb_mon.data_in;
      //#0;//First send read transactions
      rtl_in_ap.write(wr_txn);
    end
    //Set keys to process rd taks in the next cycle
    rd_sem.put(rd_sem_keys);
  endtask: mon_rtl_in

  virtual task mon_rtl_out();
    riscv_rf_rd_seq_item rd_txn_A;
    riscv_rf_rd_seq_item rd_txn_B;
    rd_txn_A = riscv_rf_rd_seq_item::type_id::create("rd_txn_A", this);
    rd_txn_B = riscv_rf_rd_seq_item::type_id::create("rd_txn_B", this);
    @(vif.cb_mon);
    rd_sem.get(rd_sem_keys);
    //Monitor rd_port_A
    `uvm_info(get_name(), "Transaction captured in rd port A", UVM_HIGH);
    rd_txn_A.addr = vif.cb_mon.rd_addr_A;
    rd_txn_A.data = vif.cb_mon.data_out_A;
    rd_txn_A.port = RF_RD_PORT_A;
    rtl_out_ap.write(rd_txn_A);

    //Monitor rd_port_B
    `uvm_info(get_name(), "Transaction captured in rd port B", UVM_HIGH);
    rd_txn_B.addr = vif.cb_mon.rd_addr_B;
    rd_txn_B.data = vif.cb_mon.data_out_B;
    rd_txn_B.port = RF_RD_PORT_B;
    rtl_out_ap.write(rd_txn_B);

    //Set key to unlock write taks
    rd_sem.put(wr_sem_keys);
  endtask: mon_rtl_out

  //Get interface
  virtual function void get_vif();
    if (!uvm_config_db#(virtual riscv_rf_if)::get(this, "*", "riscv_rf_vif", vif)) begin
      `uvm_fatal("NO_VIF", "virtual interface must be set for: riscv_rf_vif");
    end
  endfunction: get_vif

endclass: riscv_rf_mon

`endif //__RISCV_RF_MON_SV___