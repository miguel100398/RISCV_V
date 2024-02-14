//File: riscv_v_ext_csr_env
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-V Vector extension External csr environment

`ifndef __RISCV_V_EXT_CSR_ENV_SV__
`define __RISCV_V_EXT_CSR_ENV_SV__

class riscv_v_ext_csr_env extends riscv_v_base_env#(
                                                .agent_t (riscv_v_ext_csr_agt),
                                                .scbd_t  (riscv_v_ext_csr_scbd),
                                                .cov_t   (riscv_v_ext_csr_cov)
);

  `uvm_component_utils(riscv_v_ext_csr_env)
    
  // new - constructor
  function new(string name = "riscv_v_ext_csr_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase

endclass: riscv_v_ext_csr_env


`endif ///__RISCV_V_EXT_CSR_ENV_SV__