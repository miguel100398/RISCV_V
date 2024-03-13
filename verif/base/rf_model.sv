//File: rf_model.sv
//Author: Miguel Bucio
//Date: 09/10/23
//Description: Register File class

`ifndef __RF_MODEL_SV__
`define __RF_MODEL_SV__ 

class rf_model#(type    data_t           = logic[31:0],
                int     NUM_REGS         = 32,
                bit     PROTECT_REG_ZERO = 1           ) extends base_model;

`uvm_component_param_utils(rf_model#(
    .data_t(data_t),
    .NUM_REGS(NUM_REGS),
    .PROTECT_REG_ZERO(PROTECT_REG_ZERO)
))

data_t rst_val = 'x;

data_t rf[NUM_REGS-1:0];

function new(string name = "rf_model", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

virtual function void rst();
    for (int i=0; i < NUM_REGS; i++) begin
        rf[i] = rst_val;
    end
endfunction: rst

virtual function void rst_rand();

    for (int i=0; i < NUM_REGS; i++) begin
        data_t tmp_data;
        assert (std::randomize(tmp_data) 
        else `uvm_fatal(get_name, "Can't randomize reg")
        rf[i] = tmp_data;
    end

endfunction: rst_rand 

virtual function void write_data(int addr, data_t data);
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
    `uvm_info(get_name(), $sformatf("writing reg[%0d]=0x%0h", addr, data), UVM_MEDIUM)
    rf[addr] = data;
endfunction: write_data 

virtual function data_t read_data(int addr);
    data_t data;
    if (addr === 'x) begin
        return 'x;
    end
    if (addr >= NUM_REGS) begin
        `uvm_fatal(get_name(), $sformatf("Trying to read register out of bounds: addr: %0d", addr))
        return 'x;
    end
    data = rf[addr];
    `uvm_info(get_name(), $sformatf("Reading reg[%0d]=0x%0h", addr, data), UVM_MEDIUM)
    return data;
endfunction: read_data

virtual function void set_rst_val(data_t _rst_val);
    rst_val = _rst_val;
endfunction: set_rst_val


endclass: rf_model

`endif //__RF_MODEL_SV__