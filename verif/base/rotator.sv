//File: rotator.sv
//Author: Miguel Bucio
//Date: 13/02/24
//Description: Rotator class

`ifndef __ROTATOR_SV__
`define __ROTATOR_SV__

class rotator#(
    type object_t         = uvm_component,
    int  MAX_NUM_ENTRIES  = 2
) extends base_rotator;

    `uvm_component_param_utils(
        rotator#(
            .object_t(object_t),
            .MAX_NUM_ENTRIES(MAX_NUM_ENTRIES)
        )
    )

    object_t array[MAX_NUM_ENTRIES];

    function new(string name = "rotator", uvm_component parent = null);
        super.new(name, parent);
        if (MAX_NUM_ENTRIES < 1) begin
            `uvm_fatal(get_name(), $sformatf("Rotator should have 1 or more entires, MAX_NUM_ENTRIES: %0d", MAX_NUM_ENTRIES));
        end
        num_entries = MAX_NUM_ENTRIES;
    endfunction: new

    virtual function bit check_new_idx(int new_idx);
        if (new_idx < 0) begin
            `uvm_error(get_name(), $sformatf("new_idx can't be less than 0, new_idx: %0d", new_idx));
            return 1'b0;
        end
        if (new_idx >= num_entries) begin
            `uvm_error(get_name(), $sformatf("new_idx should be less than num_entries: %0d, new_idx: %0d", num_entries, new_idx));
            return 1'b0;
        end
        return 1'b1;
    endfunction: check_new_idx

    virtual function bit check_new_idx_entry(int new_idx);
        if (new_idx < 0) begin
            `uvm_error(get_name(), $sformatf("new_idx can't be less than 0, new_idx: %0d", new_idx));
            return 1'b0;
        end
        if (new_idx >= MAX_NUM_ENTRIES) begin
            `uvm_error(get_name(), $sformatf("new_idx should be less than MAX_NUM_ENTRIES: %0d, new_idx: %0d", MAX_NUM_ENTRIES, new_idx));
            return 1'b0;
        end
        return 1'b1;
    endfunction: check_new_idx_entry

    virtual function bit check_new_num_entries(int new_num_entries);
        if (new_num_entries < 1) begin
            `uvm_error(get_name(), $sformatf("Num_entries should be greater or equal than 1, new_num_entries: %0d", new_num_entries));
            return 1'b0;
        end
        if (new_num_entries > MAX_NUM_ENTRIES) begin
            `uvm_error(get_name(), $sformatf("Num_entries can't be greater than MAX_NUM_ENTRIES: %0d, new_num_entries: %0d", MAX_NUM_ENTRIES, new_num_entries));
            return 1'b0;
        end
        return 1'b1;
    endfunction: check_new_num_entries

    virtual function void rotate_left();
        idx++;
        if (idx == num_entries) begin
            idx = 0;
        end
    endfunction: rotate_left

    virtual function void rotate_right();
        if (idx == 0) begin
            idx = num_entries-1;
            return;
        end
        idx--;
    endfunction: rotate_right

    virtual function int get_max_num_entries();
        return MAX_NUM_ENTRIES;
    endfunction: get_max_num_entries

    virtual function void set_entry(object_t new_entry, int new_idx);
        if (!check_new_idx_entry(new_idx)) begin
            `uvm_error(get_name(), $sformatf("Can't set new entry, new_idx: %0d", new_idx));
            return;
        end
        array[new_idx] = new_entry;
    endfunction: set_entry

    virtual function object_t get_current_entry();
        return array[idx];
    endfunction: get_current_entry

    virtual function object_t get_entry(int new_idx);
        if (!check_new_idx_entry(new_idx)) begin
            `uvm_error(get_name(), $sformatf("can't get entry, new_idx: %0d", new_idx))
            return null;
        end
        return array[new_idx];
    endfunction: get_entry

endclass: rotator

`endif //__ROTATOR_SV__