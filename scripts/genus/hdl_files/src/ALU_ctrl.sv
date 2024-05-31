//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 12/03/2022
//RISCV32 ALU Control



module ALU_ctrl 
import riscv32_pkg::*,
       ALU_pkg::*;
(
    input riscv_alu_op_e riscv_alu_op,
    input logic[6:0]     funct_7,
    input logic[2:0]     funct_3,
    output ALU_ctrl_e    ALU_op 
);

ALU_ctrl_e ALU_funct_op;

always_comb begin
    case (riscv_alu_op)
        RISCV_ALU_ADD: begin
            ALU_op = ALU_ADD;
        end
        RISCV_ALU_SUB: begin
            ALU_op = ALU_SUB;
        end
        RISCV_ALU_FUNCT: begin
            ALU_op = ALU_funct_op;
        end
        RISCV_ALU_PASS_B: begin
            ALU_op = ALU_PASS_B;
        end
        default: begin
            ALU_op = ALU_ADD;
        end
    endcase
end

always_comb begin
    case(funct_3)
        RISCV32_FUNCT3_ADD: begin
            if (funct_7 == RISCV32_FUNCT7_SUB) begin
                ALU_funct_op = ALU_SUB;
            end else begin
                ALU_funct_op = ALU_ADD;
            end
        end
        RISCV32_FUNCT3_SLT: begin
            ALU_funct_op = ALU_SLT;
        end
        RISCV32_FUNCT3_SLTU: begin
            ALU_funct_op = ALU_SLTU;
        end
        RISCV32_FUNCT3_XOR: begin
            ALU_funct_op = ALU_XOR;
        end
        RISCV32_FUNCT3_OR: begin
            ALU_funct_op = ALU_OR;
        end
        RISCV32_FUNCT3_AND: begin
            ALU_funct_op = ALU_AND;
        end
        RISCV32_FUNCT3_SLL: begin
            ALU_funct_op = ALU_SHL;
        end
        RISCV32_FUNCT3_SRL: begin
            if (funct_7 == RISCV32_FUNCT7_SRA) begin
                ALU_funct_op = ALU_SHRA;
            end else begin
                ALU_funct_op = ALU_SHR;
            end
        end
        default: begin
            ALU_funct_op = ALU_ADD;
        end
    endcase
end

endmodule: ALU_ctrl