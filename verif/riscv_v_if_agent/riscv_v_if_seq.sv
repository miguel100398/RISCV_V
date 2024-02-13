//File: riscv_v_if_seq
//Author: Miguel Bucio
//Date: 28/01/23
//Description: RISC-V Instruction Fetch directed sequence

`ifndef __RISCV_V_IF_SEQ__
`define __RISCV_V_IF_SEQ__ 

class riscv_v_if_seq extends riscv_v_base_seq#(
  .seq_item_t(riscv_v_if_seq_item)
);
    rand riscv_instruction_t instruction;
    rand logic               rst;

    `uvm_object_utils(riscv_v_if_seq)

    //Constructor
  function new(string name = "riscv_v_if_seq");
    super.new(name);
  endfunction: new

  virtual task body();

    //Send wr req
    req = riscv_v_if_seq_item::type_id::create("v_if_req");
    wait_for_grant();
    //Send random transaction
    assert(
        req.randomize()
    ) else begin
      `uvm_fatal(get_name(), "Can't randomize riscv_v_if_seq_item")
    end
    req.out.instruction      = instruction;
    req.in.rst               = rst;
    send_request(req);
    wait_for_item_done();

  endtask: body

endclass: riscv_v_if_seq

`endif //RISCV_V_IF_SEQ