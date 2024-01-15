//File: riscv_csr.sv
//Author: Miguel Bucio
//Date: 15/011/24
//Description: RISCV csr

module riscv_csr 
import riscv_pkg::*;
(
    //Clock and reset
    input  logic            clk,
    input  logic            rst,
    //mstatus
    input  riscv_mstatus_t  mstatus_data_in,
    input  logic            mstatus_wr_en,
    output riscv_mstatus_t  mstatus_data_out
);

//MSTATUS 
riscv_mstatus_t mstatus;

always_ff @(posedge clk) begin
    if (mstatus_wr_en) begin
        mstatus <= mstatus_data_in;
    end
end
assign mstatus_data_out = mstatus;

endmodule: riscv_csr 