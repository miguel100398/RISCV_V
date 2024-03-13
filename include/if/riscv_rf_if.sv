//File: riscv_v_rf_if
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-V register file interface
`timescale 1ns/1ps

interface riscv_rf_if 
import riscv_pkg::*;
(
    input logic clk  
);

    wire[RISCV_RF_ADDR_WIDTH-1:0]    wr_addr;
    riscv_rf_addr_t    rd_addr_A;
    riscv_rf_addr_t    rd_addr_B;  
    riscv_data_t       data_in;
    logic              wr_en;
    riscv_data_t       data_out_A;
    riscv_data_t       data_out_B;

    modport rf(
        input  wr_addr,
        input  rd_addr_A,
        input  rd_addr_B,
        input  data_in,
        input  wr_en,
        output data_out_A,
        output data_out_B
    );

    modport system(
        output wr_addr,
        output rd_addr_A,
        output rd_addr_B,
        output data_in,
        output wr_en,
        input  data_out_A,
        input  data_out_B
    );

    clocking cb_mon @(negedge clk);
        input  wr_addr;
        input  rd_addr_A;
        input  rd_addr_B;
        input  data_in;
        input  wr_en;
        input  data_out_A;
        input  data_out_B;
    endclocking

    clocking cb_drv @(posedge clk);
        output  wr_addr;
        output  rd_addr_A;
        output  rd_addr_B;
        output  data_in;
        output  wr_en;
    endclocking

    clocking cb_bfm @(negedge clk);
        output data_out_A;
        output data_out_B;
    endclocking

endinterface: riscv_rf_if