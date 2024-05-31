//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 25/04/2022
//RISCV32 MEM/WB pipeline register

module mem_wb_reg
import riscv32_pkg::*;
(
    input  logic    clk,
    input  logic    rst_n,
    input  mem_wb_t data_in,
    output mem_wb_t data_out
);

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_out <= 'h0;
    end else begin
        data_out <= data_in;
    end 
end

endmodule: mem_wb_reg