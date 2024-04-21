//File: riscv_v_mask_alu_tb
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Mask ALU testbench

`timescale 1ns/1ps

module riscv_v_mask_alu_tb;
    import riscv_pkg::*;
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
    riscv_v_mask_ALU_if mask_vif(
        .clk(clk)
    );
    riscv_v_permutation_ALU_if permutation_vif(
        .clk(clk)
    );

    //Dut
    riscv_v_mask_ALU dut(
        .is_mask(mask_vif.is_mask),
        .is_and(mask_vif.is_and),
        .is_or(mask_vif.is_or),
        .is_xor(mask_vif.is_xor),
        .is_negate_srca(mask_vif.is_negate_srca),
        .is_negate_result(mask_vif.is_negate_result),
        .srca(mask_vif.srca),
        .srcb(mask_vif.srcb),
        .result(mask_vif.result)
    );

    initial begin
        //Set interface to DB
        uvm_config_db#(virtual riscv_v_logic_ALU_if)::set(uvm_root::get(),"*","riscv_v_logic_alu_vif",logic_vif);
        uvm_config_db#(virtual riscv_v_arithmetic_ALU_if)::set(uvm_root::get(),"*","riscv_v_arithmetic_alu_vif",arithmetic_vif);
        uvm_config_db#(virtual riscv_v_mask_ALU_if)::set(uvm_root::get(),"*","riscv_v_mask_alu_vif",mask_vif);
        uvm_config_db#(virtual riscv_v_permutation_ALU_if)::set(uvm_root::get(),"*","riscv_v_permutation_alu_vif",permutation_vif);
    end

    initial begin
        run_test("riscv_v_mask_alu_doa_test");
    end

endmodule: riscv_v_mask_alu_tb