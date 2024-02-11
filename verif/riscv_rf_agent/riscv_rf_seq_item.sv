//File: riscv_rf_seq_item.sv
//Author: Miguel Bucio
//Date: 28/01/24
//Description: RISC-V RF seq item

`ifndef __RISCV_RF_SEQ_ITEM__
`define __RISCV_RF_SEQ_ITEM__

class riscv_rf_seq_item extends riscv_v_base_in_out_seq_item#(
    .in_seq_item_t(riscv_rf_wr_seq_item),
    .out_seq_item_t(riscv_rf_rd_seq_item)
);

    `uvm_object_utils(riscv_rf_seq_item)

    riscv_rf_rd_seq_item  out2;

    //Constructor
    function new(string name = "riscv_rf_seq_item");
        super.new(name);
        out2 = riscv_rf_rd_seq_item::type_id::create({get_name(), "_out2"});
    endfunction: new

endclass: riscv_rf_seq_item


`endif //__RISCV_RF_SEQ_ITEM__