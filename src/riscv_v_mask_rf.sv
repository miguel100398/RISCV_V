//File: riscv_v_mask_rf.sv
//Author: Miguel Bucio
//Date: 15/011/24
//Description: RISC-V Vector extension Mask register file

module riscv_v_mask_rf 
import riscv_v_pkg::*, riscv_pkg::*;
#(
    parameter bit RD_ASYNC   = 1'b1,
    parameter bit REG_INPUTS = 1'b0
)(
    input  logic        clk,
    input  riscv_v_mask_rf_addr_t wr_addr,
    input  riscv_v_mask_rf_addr_t rd_addr,
    input  riscv_v_mask_reg_t     data_in,
    input  logic                  wr_en,
    output riscv_v_mask_reg_t     data_out
);

    //Registers
    riscv_v_mask_regs_t regs;

    //Internal inputs
    riscv_v_mask_rf_addr_t wr_addr_int;
    riscv_v_mask_rf_addr_t rd_addr_int;
    riscv_v_mask_reg_t     data_in_int;
    logic                  wr_en_int;

    //Register or bypass inputs
    generate
        if (REG_INPUTS) begin : GEN_REG_INPUTS

            always_ff @(posedge clk) begin
                wr_addr_int <= wr_addr;
                rd_addr_int <= rd_addr;
                data_in_int <= data_in;
                wr_en_int   <= wr_en;
            end

        end else begin : GEN_BYPASS_INPUTS

            always_comb begin
                wr_addr_int = wr_addr;
                rd_addr_int = rd_addr;
                data_in_int = data_in;
                wr_en_int   = wr_en;
            end

        end
    endgenerate

    //Read
    generate
        if (RD_ASYNC) begin : GEN_READ_ASYNC 

            assign data_out = regs[rd_addr_int];

        end else begin : GEN_READ_SYNC 

            always_ff @(posedge clk) begin
                data_out <= regs[rd_addr_int];
            end

        end
    endgenerate

    //Write register
    always_ff @(posedge clk) begin
        if (wr_en_int) begin
            regs[wr_addr_int] <= data_in_int;
        end
    end

endmodule: riscv_v_mask_rf