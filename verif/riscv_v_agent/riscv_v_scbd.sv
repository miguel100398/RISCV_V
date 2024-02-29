//File: riscv_v_scbd
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-Vregister file Scoreboard

`ifndef __RISCV_V_SCBD_SV__
`define __RISCV_V_SCBD_SV__ 

class riscv_v_scbd extends riscv_v_base_scbd#(
    .seq_item_in_t(riscv_v_in_seq_item),
    .seq_item_out_t(riscv_v_out_seq_item),
    .model_t(rf_model)
);

    `uvm_component_utils(riscv_v_scbd)

    function new(string name = "riscv_v_scbd", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new    

    //Write port
    virtual function void calc_in();
        return;
    endfunction: calc_in 

    //Read port
    virtual function void calc_out();
        return;
    endfunction: calc_out

    virtual function void check_data();
        return;
    endfunction: check_data 

endclass: riscv_v_scbd

`endif //__RISCV_V_SCBD_SV__ 