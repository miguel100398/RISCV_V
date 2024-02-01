//File: riscv_v_rf_if
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file interface

interface riscv_v_rf_if 
import riscv_v_pkg::*;
(
    input logic clk  
);

    riscv_v_rf_addr_t    wr_addr;
    riscv_v_rf_addr_t    rd_addr_A;
    riscv_v_rf_addr_t    rd_addr_B;  
    riscv_v_data_t       data_in;
    riscv_v_rf_wr_en_t   wr_en;
    riscv_v_data_t       data_out_A;
    riscv_v_data_t       data_out_B;

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

    clocking cb_mon @(posedge clk);
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

    clocking cb_bfm @(posedge clk);
        output data_out_A;
        output data_out_B;
    endclocking

endinterface: riscv_v_rf_if