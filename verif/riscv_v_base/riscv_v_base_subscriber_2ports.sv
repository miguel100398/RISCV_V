//File: riscv_v_base_subscriber_2ports.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Vector Base Subscriber with 2 ports

`ifndef __RISCV_V_BASE_SUBSCRIBER_2_PORTS_SV__
`define __RISCV_V_BASE_SUBSCRIBER_2_PORTS_SV__

virtual class riscv_v_base_subscriber_2ports #(type seq_item_in_t  = riscv_v_base_seq_item,
                                               type seq_item_out_t = seq_item_in_t)         extends base_subscriber_2ports#(
                                                                                                                            .seq_item_in_t(seq_item_in_t),
                                                                                                                            .seq_item_out_t(seq_item_out_t)
                                               );


`uvm_component_param_utils(riscv_v_base_subscriber_2ports#(
        .seq_item_in_t (seq_item_in_t),
        .seq_item_out_t(seq_item_out_t)));


endclass: riscv_v_base_subscriber_2ports

`endif //__RISCV_V_BASE_SUBSCRIBER_2_PORTS_SV__