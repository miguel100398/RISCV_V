//File: riscv_v_rf_tb
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file test bench

`timescale 1ns/1ps

module riscv_v_rf_tb;
    import riscv_v_pkg::*;
    import uvm_pkg::*;

    logic clk;

    //Clock generation
    initial begin
        clk = 0;
        forever begin
            #CLK_PERIOD clk = ~clk;
        end
    end

    //Interface
    riscv_v_rf_if riscv_v_rf_if_inst(
        .clk(clk)
    );

    //Dut
    riscv_v_rf #(
        .DATA_WIDTH(32),
        .NUM_REGS(32),
        .RD_ASYNC(1'b1),
        .REG_INPUTS(1'b0)
    )dut(
        .clk        (riscv_v_rf_if_inst.clk),
        .wr_addr    (riscv_v_rf_if_inst.wr_addr),
        .rd_addr_A  (riscv_v_rf_if_inst.rd_addr_A),
        .rd_addr_B  (riscv_v_rf_if_inst.rd_addr_B),
        .data_in    (riscv_v_rf_if_inst.data_in),
        .wr_en      (riscv_v_rf_if_inst.wr_en),
        .data_out_A (riscv_v_rf_if_inst.data_out_A),
        .data_out_B (riscv_v_rf_if_inst.data_out_B)
    );

    initial begin
        //Set interface to DB
        uvm_config_db#(virtual riscv_v_rf_if)::set(uvm_root::get(),"*","riscv_v_rf_vif",riscv_v_rf_if_inst);
    end

    initial begin
        run_test("riscv_v_rf_doa_test");
    end

endmodule: riscv_v_rf_tb