//File: riscv_v_rf.sv
//Author: Miguel Bucio
//Date: 11/04/23
//Description: RISC-V Vector extension register file

module riscv_v_rf
import riscv_v_pkg::*, riscv_pkg::*;
#(
    parameter bit RD_ASYNC              = 1'b1,
    parameter bit REG_INPUTS            = 1'b0
)(
    input  logic                clk,
    input  riscv_v_rf_addr_t    wr_addr,
    input  riscv_v_rf_addr_t    rd_addr_A,
    input  riscv_v_rf_addr_t    rd_addr_B,  
    input  riscv_v_data_t       data_in,
    input  riscv_v_rf_wr_en_t   wr_en,
    output riscv_v_data_t       data_out_A,
    output riscv_v_data_t       data_out_B,
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
        for (int byte_reg=0; byte_reg<RISCV_V_NUM_BYTES_DATA; byte_reg++) begin
            regs_nxt[wr_addr_int].Byte[byte_reg] = wr_en_int[byte_reg] ? data_in_int.Byte[byte_reg] : regs[wr_addr_int].Byte[byte_reg];
        end
    end


    always_ff @(posedge clk) begin
        regs <= regs_nxt;
    end


endmodule: riscv_v_rf
