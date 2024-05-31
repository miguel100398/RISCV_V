//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 25/04/2022
//RISCV32 EX/MEM pipeline register

module ex_mem_reg
import riscv32_pkg::*;
(
    input  logic    clk,
    input  logic    rst_n,
    input  ex_mem_t data_in,
    output ex_mem_t data_out
);

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_out <= 'h0;
    end else begin
        data_out <= data_in;
    end
end

endmodule: ex_mem_reg