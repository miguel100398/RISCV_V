//File: riscv_v_if_mon
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V Vector extension register file monitor

`ifndef __RISCV_V_IF_MON_SV___
`define __RISCV_V_IF_MON_SV___

class riscv_v_if_mon extends riscv_v_base_mon#( .seq_item_in_t   (riscv_v_if_in_seq_item),
                                                .seq_item_out_t  (riscv_v_if_out_seq_item));
  `uvm_component_utils(riscv_v_if_mon)

  localparam int out_sem_keys = 1;
  localparam int in_sem_keys = 2;
  //Semaphore to process read transactions before write transactions
  semaphore rd_sem;
  
  //Virtual interface
  virtual riscv_v_if_if vif;
  // new - constructor
  function new (string name = "riscv_v_if_mon", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rd_sem = new(out_sem_keys);
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

  virtual task mon_rtl_in();
    riscv_v_if_in_seq_item in_txn;
    //Monitor write transaction
    @(vif.cb_mon);
    //2 Keys needed, rd proccess will be executed before
    rd_sem.get(in_sem_keys);

    //`uvm_info(get_name(), "Transaction captured in Instruction Fetch port_in", UVM_HIGH);
    in_txn = riscv_v_if_in_seq_item::type_id::create("in_txn", this);
    in_txn.rst = vif.cb_mon.rst;
    rtl_in_ap.write(in_txn);
    //Set keys to process rd taks in the next cycle
    rd_sem.put(out_sem_keys);
  endtask: mon_rtl_in

  virtual task mon_rtl_out();
    riscv_v_if_out_seq_item out_txn;
    out_txn = riscv_v_if_out_seq_item::type_id::create("out_txn", this);
    @(vif.cb_mon);
    rd_sem.get(out_sem_keys);

    `uvm_info(get_name(), "Transaction captured in Instruction Fetch port_out", UVM_HIGH);
    out_txn.instruction = vif.cb_mon.instruction;

    rtl_out_ap.write(out_txn);

    //Set key to unlock write taks
    rd_sem.put(in_sem_keys);
  endtask: mon_rtl_out

  //Get interface
  virtual function void get_vif();
    if (!uvm_config_db#(virtual riscv_v_if_if)::get(this, "*", interface_name, vif)) begin
      `uvm_fatal(get_name(), $sformatf("NO_VIF", "virtual interface must be set for: %s", interface_name));
    end
  endfunction: get_vif

endclass: riscv_v_if_mon

`endif //__RISCV_V_IF_MON_SV___