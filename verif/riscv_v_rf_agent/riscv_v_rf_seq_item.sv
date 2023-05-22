//File: riscv_v_rf_seq_item
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file sequence item

`ifndef __RISCV_V_RF_SEQ_ITEM_SV__
`define __RISCV_V_RF_SEQ_ITEM_SV__

class riscv_v_rf_seq_item extends riscv_v_base_seq_item;  
  rand riscv_v_rf_addr_t  wr_addr;
  rand riscv_v_rf_addr_t  rd_addr_A;
  rand riscv_v_rf_addr_t  rd_addr_B;
  rand riscv_v_data_t     data_in;
  rand riscv_v_rf_wr_en_t wr_en;
       riscv_v_data_t     data_out_A;
       riscv_v_data_t     data_out_B;
       bit                reset_wr_en = 1'b1;   //Wait one clock to set wr_en to 0 after sending transaction, set bit to 0 to send back2back transactions


  //Utility and Field macros,
  `uvm_object_utils_begin(riscv_v_rf_seq_item)
    `uvm_field_int(wr_addr,UVM_ALL_ON)
    `uvm_field_int(rd_addr_A,UVM_ALL_ON)
    `uvm_field_int(rd_addr_B,UVM_ALL_ON)
    `uvm_field_int(data_in,UVM_ALL_ON)
    `uvm_field_int(wr_en,UVM_ALL_ON)
  `uvm_object_utils_end  

  //Constructor
  function new(string name = "riscv_v_rf_seq_item");
    super.new(name);
  endfunction: new

endclass: riscv_v_rf_seq_item

`endif //__RISCV_V_RF_SEQ_ITEM_SV__