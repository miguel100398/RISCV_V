//File: base_rotator.sv
//Author: Miguel Bucio
//Date: 13/02/24
//Description: Base rotator class

`ifndef __BASE_ROTATOR_SV__
`define __BASE_ROTATOR_SV__ 

virtual class base_rotator extends uvm_component;
    `uvm_component_utils(base_rotator)

    protected int idx         = 0;
    protected int num_entries = 2;

    function new(string name = "base_rotator", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    virtual function void rst();
        rst_idx();
    endfunction: rst

    virtual function void rst_idx();
        idx = 0;
    endfunction: rst_idx

    virtual function int get_idx();
        return idx;
    endfunction: get_idx

    virtual function int get_num_entries();
        return num_entries;
    endfunction: get_num_entries

    virtual function void set_idx(int new_idx);
        if (!check_new_idx(new_idx)) begin
            `uvm_error(get_name(), $sformatf("Can't set new_idx: %0d", new_idx))
            return;
        end
        idx = new_idx;
    endfunction: set_idx

    virtual function void set_num_entries(int new_num_entries);
        if (!check_new_num_entries(new_num_entries)) begin
            `uvm_error(get_name(), $sformatf("Can't set new_num_entries: %0d", new_num_entries))
            return;
        end
        num_entries = new_num_entries;
    endfunction: set_num_entries

    
    pure virtual function bit check_new_idx(int new_idx);
    pure virtual function bit check_new_idx_entry(int new_idx);
    pure virtual function bit check_new_num_entries(int new_num_entries);
    pure virtual function void rotate_left();
    pure virtual function void rotate_right();
    pure virtual function int get_max_num_entries();

endclass: base_rotator

`endif //__BASE_ROTATOR_SV__