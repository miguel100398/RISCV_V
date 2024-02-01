//File: riscv_v_base_seq.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base sequence

`ifndef __RISCV_V_BASE_SEQ__
`define __RISCV_V_BASE_SEQ__

virtual class riscv_v_base_seq#(type seq_item_t = riscv_v_base_seq_item) extends base_seq#(seq_item_t);

    //Constructor
    function new(string name = "riscv_v_base_seq");
        super.new(name);
    endfunction: new

endclass: riscv_v_base_seq
`endif //__RISCV_V_BASE_SEQ__