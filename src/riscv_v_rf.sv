//File: riscv_v_rf.sv
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file

module riscv_v_rf#(
    parameter int DATA_WIDTH            = 32,
    parameter int NUM_REGS              = 32,
    parameter bit RD_ASYNC              = 1'b1,
    parameter bit REG_INPUTS            = 1'b0,
    parameter int ADDR_WIDTH            = $clog2(NUM_REGS),
    parameter int NUM_BYTES_REGISTER    = DATA_WIDTH/8
)(
    input  logic                            clk,
    input  logic [ADDR_WIDTH-1:0]           wr_addr,
    input  logic [ADDR_WIDTH-1:0]           rd_addr_A,
    input  logic [ADDR_WIDTH-1:0]           rd_addr_B,  
    input  logic [DATA_WIDTH-1:0]           data_in,
    input  logic [NUM_BYTES_REGISTER-1:0]   wr_en,
    output logic [DATA_WIDTH-1:0]           data_out_A,
    output logic [DATA_WIDTH-1:0]           data_out_B
);

import  riscv_v_pkg::*;

    //Registers
    logic[NUM_BYTES_REGISTER-1:0][BYTE_WIDTH-1:0] regs [NUM_REGS];
    logic[NUM_BYTES_REGISTER-1:0][BYTE_WIDTH-1:0] regs_nxt [NUM_REGS];

    //Internal Inputs
    logic [ADDR_WIDTH-1:0]           wr_addr_int;
    logic [ADDR_WIDTH-1:0]           rd_addr_A_int;
    logic [ADDR_WIDTH-1:0]           rd_addr_B_int;  
    logic [DATA_WIDTH-1:0]           data_in_int;
    logic [NUM_BYTES_REGISTER-1:0]   wr_en_int;


    //Register or bypass inputs
    generate
        if (REG_INPUTS) begin : GEN_REG_INPUTS

            always_ff @(posedge clk) begin
                wr_addr_int   <= wr_addr;
                rd_addr_A_int <= rd_addr_A;
                rd_addr_B_int <= rd_addr_B;
                data_in_int   <= data_in;
                wr_en_int     <= wr_en;
            end
            
        end else begin : GEN_BYPASS_INPUTS

            always_comb begin
                wr_addr_int   = wr_addr;
                rd_addr_A_int = rd_addr_A;
                rd_addr_B_int = rd_addr_B;
                data_in_int   = data_in;
                wr_en_int     = wr_en;
            end

        end
    endgenerate

    //Read srcA
    generate
        if (RD_ASYNC) begin : GEN_READ_SRCA_ASYNC
            
            assign data_out_A = regs[rd_addr_A_int];

        end else begin : GEN_READ_SRCA_SYNC

            always_ff @(posedge clk) begin
                data_out_A <= regs[rd_addr_A_int];
            end

        end
    endgenerate

     //Read srcB
    generate
        if (RD_ASYNC) begin : GEN_READ_SRCB_ASYNC
            
            assign data_out_B = regs[rd_addr_B_int];

        end else begin : GEN_READ_SRCB_SYNC

            always_ff @(posedge clk) begin
                data_out_B <= regs[rd_addr_B_int];
            end

        end
    endgenerate

    //Write register
    always_comb begin
        regs_nxt = regs;
        for (int byte_reg=0; byte_reg<NUM_BYTES_REGISTER; byte_reg++) begin
            regs_nxt[wr_addr_int][byte_reg] = wr_en_int[byte_reg] ? data_in_int[byte_reg*BYTE_WIDTH +: BYTE_WIDTH] : regs[wr_addr_int][byte_reg];
        end
    end


    always_ff @(posedge clk) begin
        regs <= regs_nxt;
    end


endmodule: riscv_v_rf