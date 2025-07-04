//File: riscv_v_arithmetic_alu_tb
//Author: Miguel Bucio
//Date: 30/08/23
//Description: RISC-V Vector extension Arithmetic ALU testbench

`timescale 1ns/1ps

module riscv_v_arithmetic_alu_tb;
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
    riscv_v_arithmetic_ALU_if arithmetic_vif(
        .clk(clk)
    );
    riscv_v_logic_ALU_if logic_vif(
        .clk(clk)
    );
    riscv_v_mask_ALU_if mask_vif(
        .clk(clk)
    );
    riscv_v_permutation_ALU_if permutation_vif(
        .clk(clk)
    );

    //Dut
    riscv_v_arithmetic_ALU dut(
        .is_reduct(arithmetic_vif.is_reduct),
        .is_add(arithmetic_vif.is_add),
        .is_sub(arithmetic_vif.is_sub),
        .is_mul(arithmetic_vif.is_mul),
        .is_zero_ext(arithmetic_vif.is_zero_ext),
        .is_sign_ext(arithmetic_vif.is_sign_ext),
        .is_set_equal(arithmetic_vif.is_set_equal),
        .is_set_nequal(arithmetic_vif.is_set_nequal),
        .is_set_less(arithmetic_vif.is_set_less),
        .is_set_greater(arithmetic_vif.is_set_greater),
        .is_max(arithmetic_vif.is_max),
        .is_min(arithmetic_vif.is_min),
        .is_signed(arithmetic_vif.is_signed),
        .is_high(arithmetic_vif.is_high),
        .use_carry(arithmetic_vif.use_carry),
        .srca(arithmetic_vif.srca),
        .srcb(arithmetic_vif.srcb),
        .carry_in(arithmetic_vif.carry_in),
        .result(arithmetic_vif.result),
        .zf(arithmetic_vif.zf),
        .of(arithmetic_vif.of),
        .cf(arithmetic_vif.cf),
        .dst_osize_vector(arithmetic_vif.dst_osize_vector),
        .src_osize_vector(arithmetic_vif.src_osize_vector),
        .is_greater_osize_vector(arithmetic_vif.is_greater_osize_vector),
        .is_less_osize_vector(arithmetic_vif.is_less_osize_vector)
    );

    initial begin
        //Set interface to DB
        uvm_config_db#(virtual riscv_v_logic_ALU_if)::set(uvm_root::get(),"*","riscv_v_logic_alu_vif",logic_vif);
        uvm_config_db#(virtual riscv_v_arithmetic_ALU_if)::set(uvm_root::get(),"*","riscv_v_arithmetic_alu_vif",arithmetic_vif);
        uvm_config_db#(virtual riscv_v_mask_ALU_if)::set(uvm_root::get(),"*","riscv_v_mask_alu_vif",mask_vif);
        uvm_config_db#(virtual riscv_v_permutation_ALU_if)::set(uvm_root::get(),"*","riscv_v_permutation_alu_vif",permutation_vif);
    end

    initial begin
        run_test("riscv_v_arithmetic_alu_doa_test");
    end
    

endmodule: riscv_v_arithmetic_alu_tb