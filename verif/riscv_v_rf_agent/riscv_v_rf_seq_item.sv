//File: riscv_v_rf_seq_item.sv
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V Vector Base seq item

`ifndef __RISCV_V_RF_SEQ_ITEM__
`define __RISCV_V_RF_SEQ_ITEM__

class riscv_v_rf_seq_item extends riscv_v_base_in_out_seq_item#(
    .in_seq_item_t(riscv_v_rf_wr_seq_item),
    .out_seq_item_t(riscv_v_rf_rd_seq_item)
);

    `uvm_object_utils(riscv_v_rf_seq_item)

    rand riscv_v_rf_rd_seq_item  out2;

    //Constructor
    function new(string name = "riscv_v_rf_seq_item");
        super.new(name);
        out2 = riscv_v_rf_rd_seq_item::type_id::create("out2_seq_item");
    endfunction: new

endclass: riscv_v_rf_seq_item


`endif //__RISCV_V_RF_SEQ_ITEM__