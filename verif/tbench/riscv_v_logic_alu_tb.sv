//File: riscv_v_logic_alu_tb
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension rLogical ALU testbench

`timescale 1ns/1ps

module riscv_v_logic_alu_tb;
    import riscv_v_pkg::*;
    import uvm_pkg::*;
    import riscv_v_base_pkg::*;
    import riscv_v_alu_agt_pkg::*;
    import riscv_v_test_pkg::*;

    //Check parameters
    riscv_v_check_params chk_param();

    logic clk;

    //Clock generation
    initial begin
        clk = 0;
        forever begin
            #25 clk = ~clk;
        end
    end

    //Interface
    riscv_v_logic_ALU_if logic_vif(
        .clk(clk)
    );
    riscv_v_arithmetic_ALU_if arithmetic_vif(
        .clk(clk)
    );

    //Dut
    riscv_v_logic_ALU dut(
        .is_reduct(logic_vif.is_reduct),
        .is_and(logic_vif.is_and),
        .is_or(logic_vif.is_or),
        .is_xor(logic_vif.is_xor),
        .is_shift(logic_vif.is_shift),
        .is_left(logic_vif.is_left),
        .is_arith(logic_vif.is_arith),
        .srca(logic_vif.srca),
        .srcb(logic_vif.srcb),
        .result(logic_vif.result),
        .dst_osize_vector(logic_vif.dst_osize_vector),
        .is_greater_osize_vector(logic_vif.is_greater_osize_vector),
        .is_less_osize_vector(logic_vif.is_less_osize_vector)
    );

    initial begin
        //Set interface to DB
        uvm_config_db#(virtual riscv_v_logic_ALU_if)::set(uvm_root::get(),"*","riscv_v_logic_alu_vif",logic_vif);
        uvm_config_db#(virtual riscv_v_arithmetic_ALU_if)::set(uvm_root::get(),"*","riscv_v_arithmetic_alu_vif",arithmetic_vif);
    end

    initial begin
        run_test("riscv_v_logic_alu_doa_test");
    end
    

endmodule: riscv_v_logic_alu_tb