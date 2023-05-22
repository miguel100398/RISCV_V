//File: riscv_v_rf_tb
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file test bench

`timescale 1ns/1ps

module riscv_v_rf_tb;
    import riscv_v_pkg::*;
    import uvm_pkg::*;
    import riscv_v_base_pkg::*;
    import riscv_v_rf_agt_pkg::*;
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
    riscv_v_rf_if vif(
        .clk(clk)
    );

    //Dut
    riscv_v_rf #(
        .RD_ASYNC(1'b1),
        .REG_INPUTS(1'b0)
    )dut(
        .clk        (vif.clk),
        .wr_addr    (vif.wr_addr),
        .rd_addr_A  (vif.rd_addr_A),
        .rd_addr_B  (vif.rd_addr_B),
        .data_in    (vif.data_in),
        .wr_en      (vif.wr_en),
        .data_out_A (vif.data_out_A),
        .data_out_B (vif.data_out_B)
    );
    
 
    initial begin
        //Set interface to DB
        uvm_config_db#(virtual riscv_v_rf_if)::set(uvm_root::get(),"*","riscv_v_rf_vif",vif);
    end

    initial begin
        run_test("riscv_v_rf_doa_test");
    end
    

endmodule: riscv_v_rf_tb