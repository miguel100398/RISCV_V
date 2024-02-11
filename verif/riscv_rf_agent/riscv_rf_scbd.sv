//File: riscv_rf_scbd
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-Vregister file Scoreboard

`ifndef __RISCV_RF_SCBD_SV__
`define __RISCV_RF_SCBD_SV__ 

class riscv_rf_scbd extends riscv_v_base_scbd#(
    .seq_item_in_t(riscv_rf_wr_seq_item),
    .seq_item_out_t(riscv_rf_rd_seq_item),
    .model_t(rf_model)
);

    `uvm_component_utils(riscv_rf_scbd)

    rf_port_e       rd_port;
    riscv_data_t    rd_data;
    riscv_rf_addr_t rd_addr;

    function new(string name = "riscv_rf_scbd", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new    

    //Write port
    virtual function void calc_in();
        //Write register
        if (txn_in.wr_en) begin
            model.write_data(txn_in.addr, txn_in.data);
            `uvm_info(get_name(), $sformatf("Register write, Addr: %0h, Data: 0x%0h", txn_in.addr, txn_in.data), UVM_MEDIUM);
        end 
    endfunction: calc_in 

    //Read port
    virtual function void calc_out();
        //Read register
        rd_addr = txn_out.addr;
        rd_data = model.read_data(rd_addr);
        rd_port = txn_out.port;
        `uvm_info(get_name(), $sformatf("Register Read, Port: %0s, Addr: %0h, Data: 0x%0h", rd_port.name(), rd_addr, rd_data), UVM_MEDIUM);
        check_data();
    endfunction: calc_out

    virtual function void check_data();
        if (rd_data === txn_out.data) begin
            `uvm_info(get_name(), $sformatf("Compare match!"), UVM_LOW);  
            pass();
        end else begin
            `uvm_error(get_name(), $sformatf("Compare mismatch, port: %s, addr: 0x%0h, actual: 0x%0h, expected: 0x%0h", rd_port.name(), rd_addr, txn_out.data, rd_data));
            fail();
        end
    endfunction: check_data 

endclass: riscv_rf_scbd

`endif //__RISCV_RF_SCBD_SV__ 