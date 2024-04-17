//File: riscv_v_mon
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V Vector extension register file monitor

`ifndef __RISCV_V_MON_SV___
`define __RISCV_V_MON_SV___

class riscv_v_mon extends riscv_v_base_mon#( .seq_item_in_t   (riscv_v_in_seq_item),
                                                .seq_item_out_t  (riscv_v_out_seq_item));
  `uvm_component_utils(riscv_v_mon)

  localparam int out_sem_keys = 1;
  localparam int in_sem_keys = 2;
  //Semaphore to process read transactions before write transactions
  semaphore rd_sem;

  //Delay data
  riscv_data_t        ext_data_in_delay    [RISCV_V_EXE_2_WB_LATENCY:0];
  logic               ext_wr_vsstatus_delay[RISCV_V_ID_2_WB_LATENCY:0];
  logic               ext_wr_vtype_delay   [RISCV_V_ID_2_WB_LATENCY:0];
  logic               ext_wr_vl_delay      [RISCV_V_ID_2_WB_LATENCY:0];
  logic               ext_wr_vstart_delay  [RISCV_V_ID_2_WB_LATENCY:0];
  logic               ext_wr_vxrm_delay    [RISCV_V_ID_2_WB_LATENCY:0];
  logic               ext_wr_vxsat_delay   [RISCV_V_ID_2_WB_LATENCY:0];
  riscv_instruction_t instruction_delay    [RISCV_V_ID_2_WB_LATENCY:0];
  riscv_data_t        int_rf_data_delay    [RISCV_V_ID_2_WB_LATENCY:0];
  
  //Virtual interface
  virtual riscv_v_if vif;
  // new - constructor
  function new (string name = "riscv_v_mon", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rd_sem = new(out_sem_keys);
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

  virtual function rst_mon();
    ext_data_in_delay     = '{default:'x};
    ext_wr_vsstatus_delay = '{default:'0};
    ext_wr_vtype_delay    = '{default:'0};
    ext_wr_vl_delay       = '{default:'0};
    ext_wr_vstart_delay   = '{default:'0};
    ext_wr_vxrm_delay     = '{default:'0};
    ext_wr_vxsat_delay    = '{default:'0};
    instruction_delay     = '{default:'0};
    int_rf_data_delay     = '{default:'0};
  endfunction: rst_mon

  virtual task mon_rtl_in();
    riscv_v_in_seq_item in_txn;
    //Monitor write transaction
    @(vif.cb_mon);
    //2 Keys needed, rd proccess will be executed before
    rd_sem.get(in_sem_keys);

    if (vif.cb_mon.rst) begin
      rst_mon();
    end

    delay_in_data();

    //Get data from interface
    ext_data_in_delay[0]     = vif.cb_mon.ext_data_in_exe;
    ext_wr_vsstatus_delay[0] = vif.cb_mon.ext_wr_vsstatus_id;
    ext_wr_vtype_delay[0]    = vif.cb_mon.ext_wr_vtype_id;
    ext_wr_vl_delay[0]       = vif.cb_mon.ext_wr_vl_id;
    ext_wr_vstart_delay[0]   = vif.cb_mon.ext_wr_vstart_id;
    ext_wr_vxrm_delay[0]     = vif.cb_mon.ext_wr_vxrm_id;
    ext_wr_vxsat_delay[0]    = vif.cb_mon.ext_wr_vxsat_id;
    instruction_delay[0]     = vif.cb_mon.instruction_id;
    int_rf_data_delay[0]     = vif.cb_mon.int_rf_rd_data_id;

    //`uvm_info(get_name(), "Transaction captured in Instruction Fetch port_in", UVM_HIGH);
    in_txn = riscv_v_in_seq_item::type_id::create("in_txn", this);
    
    in_txn.rst                = vif.cb_mon.rst;
    in_txn.clear_pipe         = vif.cb_mon.clear_pipe;
    in_txn.riscv_stall        = vif.cb_mon.riscv_stall;
    in_txn.instruction        = instruction_delay[RISCV_V_ID_2_WB_LATENCY];
    in_txn.int_rf_rd_data     = int_rf_data_delay[RISCV_V_ID_2_WB_LATENCY];
    in_txn.ext_data_in        = ext_data_in_delay[RISCV_V_EXE_2_WB_LATENCY];
    in_txn.ext_wr_vsstatus    = ext_wr_vsstatus_delay[RISCV_V_ID_2_WB_LATENCY];
    in_txn.ext_wr_vtype       = ext_wr_vtype_delay[RISCV_V_ID_2_WB_LATENCY];
    in_txn.ext_wr_vl          = ext_wr_vl_delay[RISCV_V_ID_2_WB_LATENCY];
    in_txn.ext_wr_vstart      = ext_wr_vstart_delay[RISCV_V_ID_2_WB_LATENCY];
    in_txn.ext_wr_vxrm        = ext_wr_vxrm_delay[RISCV_V_ID_2_WB_LATENCY];
    in_txn.ext_wr_vxsat       = ext_wr_vxsat_delay[RISCV_V_ID_2_WB_LATENCY];

    rtl_in_ap.write(in_txn);
    //Set keys to process rd taks in the next cycle
    rd_sem.put(out_sem_keys);
  endtask: mon_rtl_in

  virtual task mon_rtl_out();
    riscv_v_out_seq_item out_txn;
    out_txn = riscv_v_out_seq_item::type_id::create("out_txn", this);
    @(vif.cb_mon);
    rd_sem.get(out_sem_keys);

    `uvm_info(get_name(), "Transaction captured in RISCV-V port_out", UVM_HIGH);

    out_txn.riscv_v_stall   = vif.cb_mon.riscv_v_stall;
    out_txn.int_rf_wr_data  = vif.cb_mon.int_rf_wr_data_wb;
    out_txn.int_rf_wr_en    = vif.cb_mon.int_rf_wr_en_wb;
    out_txn.vec_rf_wr_addr  = vif.v_rf_if.cb_mon.wr_addr;
    out_txn.vec_rf_wr_en    = vif.v_rf_if.cb_mon.wr_en;
    out_txn.vec_rf_wr_data  = vif.v_rf_if.cb_mon.data_in;

    rtl_out_ap.write(out_txn);

    //Set key to unlock write taks
    rd_sem.put(in_sem_keys);
  endtask: mon_rtl_out

  virtual function delay_in_data();

  //Delay ID to WB
  for (int idx = RISCV_V_ID_2_WB_LATENCY; idx > 0; idx--) begin
    ext_wr_vsstatus_delay[idx] = ext_wr_vsstatus_delay[idx-1];
    ext_wr_vtype_delay[idx]    = ext_wr_vtype_delay[idx-1];
    ext_wr_vl_delay[idx]       = ext_wr_vl_delay[idx-1];
    ext_wr_vstart_delay[idx]   = ext_wr_vstart_delay[idx-1];
    ext_wr_vxrm_delay[idx]     = ext_wr_vxrm_delay[idx-1];
    ext_wr_vxsat_delay[idx]    = ext_wr_vxsat_delay[idx-1];
    instruction_delay[idx]     = instruction_delay[idx-1];
    int_rf_data_delay[idx]     = int_rf_data_delay[idx-1];
  end
  //Delay  EXE to WB
  for (int idx = RISCV_V_EXE_2_WB_LATENCY; idx > 0; idx--) begin
    ext_data_in_delay[idx]     = ext_data_in_delay[idx-1];
  end
 
  endfunction: delay_in_data

  //Get interface
  virtual function void get_vif();
    if (!uvm_config_db#(virtual riscv_v_if)::get(this, "*", interface_name, vif)) begin
      `uvm_fatal(get_name(), $sformatf("NO_VIF: virtual interface must be set for: %s", interface_name));
    end
  endfunction: get_vif

endclass: riscv_v_mon

`endif //__RISCV_V_MON_SV___