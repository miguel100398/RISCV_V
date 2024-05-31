//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 12/03/2022
//RISCV32 Immediate generator


module riscv32_imm_gen
import riscv32_pkg::*;
(
    input  logic[RISCV32_DATA_WIDTH-1:0] instruction,
    input  instr_type_e                  instr_type,
    output logic[RISCV32_DATA_WIDTH-1:0] immediate
);

logic[RISCV32_DATA_WIDTH-1:0] i_imm;
logic[RISCV32_DATA_WIDTH-1:0] b_imm;
logic[RISCV32_DATA_WIDTH-1:0] u_imm;
logic[RISCV32_DATA_WIDTH-1:0] s_imm;
logic[RISCV32_DATA_WIDTH-1:0] j_imm;

//Create immediates
assign i_imm = {{20{instruction[31]}}, instruction[31:20]};
assign b_imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
assign s_imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
assign u_imm = {instruction[31:12], 12'b0};
assign j_imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};

//Select immadiate
always_comb begin
    case (instr_type)
        I_TYPE: begin
            immediate = i_imm;
        end
        S_TYPE: begin
            immediate = s_imm;
        end
        B_TYPE: begin
            immediate = b_imm;
        end
        U_TYPE: begin
            immediate = u_imm;
        end
        J_TYPE: begin
            immediate = j_imm;
        end
        default: begin
            immediate = i_imm;
        end
    endcase
end

endmodule: riscv32_imm_gen