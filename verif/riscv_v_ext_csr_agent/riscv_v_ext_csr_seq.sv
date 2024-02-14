//File: riscv_v_ext_csr_seq
//Author: Miguel Bucio
//Date: 28/01/23
//Description: RISC-V Instruction Fetch directed sequence

`ifndef __RISCV_V_EXT_CSR_SEQ__
`define __RISCV_V_EXT_CSR_SEQ__ 

class riscv_v_ext_csr_seq extends riscv_v_base_seq#(
  .seq_item_t(riscv_v_ext_csr_seq_item)
);
    rand logic           rst;
    rand riscv_data_t    ext_csr_data;
    rand logic           ext_wr_vsstatus;
    rand logic           ext_wr_vtype;
    rand logic           ext_wr_vl;
    rand logic           ext_wr_vstart;
    rand logic           ext_wr_vxrm;
    rand logic           ext_wr_vxsat;

    `uvm_object_utils(riscv_v_ext_csr_seq)

    //Constructor
  function new(string name = "riscv_v_ext_csr_seq");
    super.new(name);
  endfunction: new

  virtual task body();

    //Send wr req
    req = riscv_v_ext_csr_seq_item::type_id::create("v_ext_csr_req");
    wait_for_grant();
    //Send random transaction
    assert(
        req.randomize()
    ) else begin
      `uvm_fatal(get_name(), "Can't randomize riscv_v_ext_csr_seq_item")
    end
    req.out.ext_csr_data          = ext_csr_data;
    req.out.ext_wr_vsstatus       = ext_wr_vsstatus;
    req.out.ext_wr_vtype          = ext_wr_vtype;
    req.out.ext_wr_vl             = ext_wr_vl;
    req.out.ext_wr_vstart         = ext_wr_vstart;
    req.out.ext_wr_vxrm           = ext_wr_vxrm;
    req.out.ext_wr_vxsat          = ext_wr_vxsat;
    req.in.rst                    = rst;
    
    send_request(req);
    wait_for_item_done();

  endtask: body

endclass: riscv_v_ext_csr_seq

`endif //RISCV_V_EXT_CSR_SEQ