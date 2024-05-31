//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 25/04/2022
//RISCV32 IF/ID pipeline register

module if_id_reg
import riscv32_pkg::*;
(
    input  logic   clk,
    input  logic   rst_n,
    input  logic   wr_en,
    input  if_id_t data_in,
    output if_id_t data_out    
);

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_out <= 'h0;
    end else if (wr_en) begin
        data_out <= data_in;
    end
end

endmodule: if_id_reg