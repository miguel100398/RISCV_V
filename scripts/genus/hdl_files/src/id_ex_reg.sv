//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 25/04/2022
//RISCV32 ID/EX pipeline register

module id_ex_reg
import riscv32_pkg::*;
(
    input  logic   clk,
    input  logic   rst_n,
    input  id_ex_t data_in,
    output id_ex_t data_out
);

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_out <= 'h0;
    end else begin
        data_out <= data_in;
    end
end

endmodule: id_ex_reg