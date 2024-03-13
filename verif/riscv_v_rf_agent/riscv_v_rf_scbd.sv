//File: riscv_v_rf_scbd
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file Scoreboard

`ifndef __RISCV_V_RF_SCBD_SV__
`define __RISCV_V_RF_SCBD_SV__




class riscv_v_rf_scbd extends riscv_v_base_scbd#(
                                                  .seq_item_in_t  (riscv_v_rf_wr_seq_item),
                                                  .seq_item_out_t (riscv_v_rf_rd_seq_item),
                                                  .model_t        (riscv_v_rf_model));

  `uvm_component_utils(riscv_v_rf_scbd)

  typedef riscv_v_reg#(riscv_v_data_t, riscv_v_rf_wr_en_t) reg_t;

  //Array of registers
  reg_t regs [RISCV_V_RF_NUM_REGS];

  // new - constructor
  function new (string name = "riscv_v_rf_scbd", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    build_regs();
    reset_regs();
  endfunction: build_phase

  //Override run_phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

  function void build_regs();
    for (int reg_idx = 0; reg_idx < RISCV_V_RF_NUM_REGS; reg_idx++) begin
      regs[reg_idx] = new();
    end
  endfunction: build_regs

  function void reset_regs();
    for (int reg_idx = 0; reg_idx < RISCV_V_RF_NUM_REGS; reg_idx++) begin
      regs[reg_idx].reset_reg('X);  
    end
  endfunction: reset_regs

  // write wr_port 
  virtual function void calc_in();
    //Write register
    if (|txn_in.wr_en) begin
      regs[txn_in.addr].write_reg(txn_in.data, txn_in.wr_en);
      `uvm_info(get_name(), $sformatf("Register write, Addr: %0h, Data: %0s", txn_in.addr, regs[txn_in.addr].printBits), UVM_MEDIUM);
    end
  endfunction : calc_in

  // write rd_port
  virtual function void calc_out();
    riscv_v_data_t tmp_reg_data;
    reg_t read_reg;
    read_reg = new();

    if (RISCV_V_RF_USE_BYPASS) begin
      if (|txn_out.wr_en) begin
        $display("using bypass, wr_addr: %0d, wr_data: %0d, wr_en: 0x%0h", txn_out.wr_addr, txn_out.wr_data, txn_out.wr_en);
        regs[txn_out.wr_addr].write_reg(txn_out.wr_data, txn_out.wr_en);
      end
    end 

    $display("temp_reg_data: 0x%0h", tmp_reg_data);

    read_reg.write_reg(txn_out.data, '1);

    $display("Read reg: %0s", read_reg.printBits);

    `uvm_info(get_name(), $sformatf("Register Read, Port: %0s, Addr: %0h, Data: %0s", txn_out.port.name(), txn_out.addr, read_reg.printBits), UVM_MEDIUM);
    //Compare register
    if (regs[txn_out.addr].compare(read_reg)) begin
      `uvm_info(get_name(), $sformatf("Compare match!"), UVM_LOW);  
      pass();
    end else begin
      `uvm_error(get_name(), $sformatf("Compare mismatch, actual: %0s, expected: %0s", read_reg.printBits, regs[txn_out.addr].printBits));
      fail();
    end
  endfunction : calc_out


endclass: riscv_v_rf_scbd


`endif //__RISCV_V_RF_SCBD_SV__