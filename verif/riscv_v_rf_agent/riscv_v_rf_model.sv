//File: riscv_v_rf_model
//Author: Miguel Bucio
//Date: 21/01/24
//Description: RISC-V Vector extension register Model

`ifndef __RISCV_V_RF_MODEL__ 
`define __RISCV_V_RF_MODEL__

class riscv_v_rf_model extends rf_model#(
    .data_t(riscv_v_data_t),
    .NUM_REGS(RISCV_V_RF_NUM_REGS),
    .PROTECT_REG_ZERO(1'b0)
);

function new(string name = "riscv_v_rf_model", uvm_component parent = null);
    super.new(name, parent);
endfunction: new 

virtual function void write_data_en(int addr, data_t wr_data, wr_en_t wr_en);

    if (addr === 'x) begin
        `uvm_fatal(get_name(), "trying to write register with address x")
    end
    if (addr >= NUM_REGS) begin
        `uvm_fatal(get_name(), $sformatf("Trying to write register out of bounds: addr: %0d", addr))
        return;
    end
    if (PROTECT_REG_ZERO && (addr == 0)) begin
        `uvm_info(get_name(), $sformatf("trying to write reg0 protected"), UVM_HIGH)
        return;
    end
    `uvm_info(get_name(), $sformatf("writing reg[%0d]=0x%0h", addr, wr_data), UVM_MEDIUM)

    for (int byte_idx = 0; byte_idx < NUM_BYTES; byte_idx++) begin
        if (wr_en[byte_idx] == 1'b1) begin
            rf[addr].Byte[byte_idx] = wr_data.Byte[byte_idx];
        end
    end
endfunction: write_data 

endclass riscv_v_rf_model

`endif //__RISCV_V_RF_MODEL__ 