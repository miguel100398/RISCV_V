//File: base_seq.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base sequence

`ifndef __BASE_SEQ__
`define __BASE_SEQ__

virtual class base_seq#(type seq_item_t = base_seq_item) extends uvm_sequence#(seq_item_t);

    bit is_randomized = 1'b0;
    bit randomize_seq = 1'b1;

    //Constructor
    function new(string name = "base_seq");
        super.new(name);
    endfunction: new

    function void post_randomize();
        is_randomized = 1'b1;
    endfunction: post_randomize

    task pre_body();
        if (~is_randomized && randomize_seq) begin
            assert(this.randomize()) else `uvm_fatal(get_name(), "Can't randomize sequence")
        end
    endtask: pre_body

    task post_body();
        is_randomized = 1'b0;
    endtask: post_body

endclass: base_seq
`endif //__BASE_SEQ__