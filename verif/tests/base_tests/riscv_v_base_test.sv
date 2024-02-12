//File: riscv_v_base_test
//Author: Miguel Bucio
//Date: 23/07/23
//Description: RISC-V Vector extension Base test

`ifndef __RISCV_V_BASE_TEST_SV__
`define __RISCV_V_BASE_TEST_SV__

class riscv_v_base_test extends uvm_test;

  `uvm_component_utils(riscv_v_base_test)

  int log_file;
  uvm_report_server serv;

  function new(string name = "riscv_v_base_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    serv = uvm_report_server::get_server();
  endfunction: build_phase

  virtual function void open_log();
    log_file = $fopen({this.get_name(), ".log"});
    uvm_top.set_report_default_file_hier (log_file);
    uvm_top.set_report_severity_action_hier (UVM_INFO,    UVM_DISPLAY | UVM_LOG);
    uvm_top.set_report_severity_action_hier (UVM_WARNING, UVM_DISPLAY | UVM_LOG);
    uvm_top.set_report_severity_action_hier (UVM_ERROR,   UVM_DISPLAY | UVM_LOG);
    uvm_top.set_report_severity_action_hier (UVM_FATAL,   UVM_DISPLAY | UVM_LOG);
  endfunction: open_log

  virtual function void close_log();
    $fclose(log_file);
  endfunction: close_log

  virtual function void report_phase(uvm_phase phase);
    int num_info;
    int num_warning;
    int num_error;
    int num_fatal;
    super.report_phase(phase);

    num_info     = serv.get_severity_count(UVM_INFO);
    num_warning  = serv.get_severity_count(UVM_WARNING);
    num_error    = serv.get_severity_count(UVM_ERROR);
    num_fatal    = serv.get_severity_count(UVM_FATAL);

    `uvm_info(get_name(), $sformatf("RISCV-V TEST FINAL RESULT: NUM_INFO=%0d", num_info),       UVM_NONE)
    `uvm_info(get_name(), $sformatf("RISCV-V TEST FINAL RESULT: NUM_WARNING=%0d", num_warning), UVM_NONE)
    `uvm_info(get_name(), $sformatf("RISCV-V TEST FINAL RESULT: NUM_ERROR=%0d", num_error),     UVM_NONE)
    `uvm_info(get_name(), $sformatf("RISCV-V TEST FINAL RESULT: NUM_FATAL=%0d", num_fatal),     UVM_NONE)

    if ((num_error == 0) && (num_fatal == 0)) begin
        `uvm_info(get_name(), $sformatf("RISCV-V TEST FINAL RESULT: TEST PASS", num_info),       UVM_NONE)
    end else begin
        `uvm_info(get_name(), $sformatf("RISCV-V TEST FINAL RESULT: TEST FAIL", num_info),       UVM_NONE)
    end

  endfunction: report_phase


endclass: riscv_v_base_test


`endif //__RISCV_V_BASE_TEST_SV__