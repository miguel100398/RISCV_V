//File: riscv_v_rf.sv
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file
`timescale 1ns/1ps

module riscv_v_rf
import riscv_v_pkg::*, riscv_pkg::*;
#(
    parameter bit RD_ASYNC              = 1'b1,
    parameter bit REG_INPUTS            = 1'b0,
    parameter bit USE_BYPASS            = 1'b1
)(
    input  logic                clk,
    input  riscv_v_rf_addr_t    wr_addr,
    input  riscv_v_rf_addr_t    rd_addr_A,
    input  riscv_v_rf_addr_t    rd_addr_B,  
    input  riscv_v_data_t       data_in,
    input  riscv_v_rf_wr_en_t   wr_en,
    output riscv_v_data_t       data_out_A,
    output riscv_v_data_t       data_out_B,
    output riscv_v_mask_t       mask,
    //Interface to synthesis
    input  riscv_v_rf_addr_t    syn_addr,
    output riscv_v_data_t       syn_data
);

    //Registers
    riscv_v_rf_regs_t regs;
    riscv_v_rf_regs_t regs_nxt;

    //Internal Inputs
    riscv_v_rf_addr_t    wr_addr_int;
    riscv_v_rf_addr_t    rd_addr_A_int;
    riscv_v_rf_addr_t    rd_addr_B_int;  
    riscv_v_data_t       data_in_int;
    riscv_v_rf_wr_en_t   wr_en_int;

    assign syn_data = regs[syn_addr];


    //Mask is always register 0
    assign mask = regs[RISCV_V_MASK_RF_POS][RISCV_V_NUM_ELEMENTS_REG-1:0];

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
            
            if (USE_BYPASS) begin : GEN_READ_SRCA_BYPASS

                logic wr_addr_match_srca;

                assign wr_addr_match_srca = (wr_addr_int == rd_addr_A_int);

                always_comb begin
                    for (int idx = 0; idx < RISCV_V_NUM_BYTES_DATA; idx++) begin
                        if (wr_en_int[idx] && wr_addr_match_srca) begin
                            data_out_A.Byte[idx] = data_in.Byte[idx];
                        end else begin
                            data_out_A.Byte[idx] = regs[rd_addr_A_int].Byte[idx];
                        end
                    end
                end
                
            end else begin : GEN_READ_SRCA_NO_BYPASS
                assign data_out_A = regs[rd_addr_A_int];
            end

        end else begin : GEN_READ_SRCA_SYNC

            always_ff @(posedge clk) begin
                data_out_A <= regs[rd_addr_A_int];
            end

        end
    endgenerate

     //Read srcB
    generate
        if (RD_ASYNC) begin : GEN_READ_SRCB_ASYNC
            
            if (USE_BYPASS) begin : GEN_READ_SRCB_BYPASS

                logic wr_addr_match_srcb;

                assign wr_addr_match_srcb = (wr_addr_int == rd_addr_B_int);

                always_comb begin
                    for (int idx = 0; idx < RISCV_V_NUM_BYTES_DATA; idx++) begin
                        if (wr_en_int[idx] && wr_addr_match_srcb) begin
                            data_out_B.Byte[idx] = data_in.Byte[idx];
                        end else begin
                            data_out_B.Byte[idx] = regs[rd_addr_B_int].Byte[idx];
                        end
                    end
                end
                
            end else begin : GEN_READ_SRCB_NO_BYPASS
                assign data_out_B = regs[rd_addr_B_int];
            end

        end else begin : GEN_READ_SRCB_SYNC

            always_ff @(posedge clk) begin
                data_out_B <= regs[rd_addr_B_int];
            end

        end
    endgenerate

    //Write register
    always_comb begin
        regs_nxt = regs;
        for (int byte_reg=0; byte_reg<RISCV_V_NUM_BYTES_DATA; byte_reg++) begin
            regs_nxt[wr_addr_int].Byte[byte_reg] = wr_en_int[byte_reg] ? data_in_int.Byte[byte_reg] : regs[wr_addr_int].Byte[byte_reg];
        end
    end


    always_ff @(posedge clk) begin
        regs <= regs_nxt;
    end


endmodule: riscv_v_rf
