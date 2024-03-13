//File: riscv_v_base_env.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base environment

`ifndef __RISCV_V_BASE_ENV__
`define __RISCV_V_BASE_ENV__

virtual class riscv_v_base_env#( type agent_t = riscv_v_base_agt,
                                 type scbd_t  = riscv_v_base_scbd,
                                 type cov_t   = riscv_v_base_cov  ) extends base_env#(
                                                                                      .agent_t(agent_t),
                                                                                      .scbd_t(scbd_t),
                                                                                      .cov_t(cov_t)
                                 );
    `uvm_component_param_utils(riscv_v_base_env#(
        .agent_t (agent_t),
        .scbd_t  (scbd_t),
        .cov_t   (cov_t)
    ))

    //Constructor
    function new(string name = "riscv_v_base_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

endclass: riscv_v_base_env

`endif //__RISCV_V_BASE_ENV
