//File: riscv_v_rf_if
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file interface

interface riscv_v_rf_if #(
    parameter int DATA_WIDTH            = 32,
    parameter int NUM_REGS              = 32,
    parameter int ADDR_WIDTH            = $clog2(NUM_REGS),
    parameter int NUM_BYTES_REGISTER    = DATA_WIDTH/8
)(
    input logic clk  
);

    logic [ADDR_WIDTH-1:0]           wr_addr;
    logic [ADDR_WIDTH-1:0]           rd_addr_A;
    logic [ADDR_WIDTH-1:0]           rd_addr_B;  
    logic [DATA_WIDTH-1:0]           data_in;
    logic [NUM_BYTES_REGISTER-1:0]   wr_en;
    logic [DATA_WIDTH-1:0]           data_out_A;
    logic [DATA_WIDTH-1:0]           data_out_B;

endinterface: riscv_v_rf_if