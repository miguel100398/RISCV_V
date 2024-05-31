//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 12/03/2022
//RISCV32 Control unit


module riscv32_control_unit
import riscv32_pkg::*;
(
    input  logic[RISCV32_DATA_WIDTH-1:0] instruction,
    output logic                         BNE,
    output logic                         BEQ,
    output logic                         MemRead,
    output logic                         MemWrite,
    output logic[1:0]                    MemtoReg,
    output riscv_alu_op_e                riscv_alu_op,
    output logic                         ALUsrcB,
    output logic                         ALUsrcA,
    output logic                         RegWrite,
    output instr_type_e                  instr_type,
    output logic                         jump_en
);

logic[6:0] op_code;
logic[2:0] funct3;
logic[6:0] funct7;

logic is_branch;
logic is_sw_lw;
logic is_sw;
logic is_lw;
logic is_bne;
logic is_beq;
logic has_imm;
logic is_jal;
logic is_jalr;
logic is_jump;
logic is_u_type;

assign op_code = instruction[6:0];
assign funct3  = instruction[14:12];
assign funct7  = instruction[31:25]; 

assign is_branch = (op_code == RISCV32_B_TYPE_OP_CODE);
assign is_beq = (is_branch) && (funct3 == RISCV32_FUNCT3_BEQ);
assign is_bne = (is_branch) && (funct3 == RISCV32_FUNCT3_BNE);

assign is_sw_lw = (is_sw || is_lw);
assign is_sw = (op_code == RISCV32_S_TYPE_OP_CODE);
assign is_lw = (op_code == RISCV32_LOAD_OP_CODE) && (funct3 == RISCV32_FUNCT3_LW);

assign has_imm = (op_code != RISCV32_R_TYPE_OP_CODE);
assign is_jal = (op_code == RISCV32_J_TYPE_OP_CODE);
assign is_jump = (is_jal) || (is_jalr);
assign is_jalr = (op_code == RISCV32_JALR_OP_CODE);
assign is_u_type = instr_type == U_TYPE;

//Outputs 
assign BNE      = is_bne;
assign BEQ      = is_beq;
assign MemRead  = is_lw;
assign MemWrite = is_sw;
assign jump_en  = is_jump;

always_comb begin
    if (is_lw) begin
        MemtoReg = 2'b01;
    end else if (is_jump) begin
        MemtoReg = 2'b10;
    end else begin
        MemtoReg = 2'b00;
    end
end

always_comb begin
    if (is_sw_lw || is_jump || is_u_type) begin
        riscv_alu_op = RISCV_ALU_ADD;
    end else if (is_branch) begin
        riscv_alu_op = RISCV_ALU_SUB;
    end else begin
        riscv_alu_op = RISCV_ALU_FUNCT;
    end
end
assign ALUsrcB = (has_imm && ~is_branch);
assign ALUsrcA = is_jal;
assign RegWrite = (~is_branch && ~is_sw);

always_comb begin
    if ((op_code == RISCV32_I_TYPE_OP_CODE) || (op_code == RISCV32_LOAD_OP_CODE)) begin
        instr_type = I_TYPE;
    end else if (op_code == RISCV32_S_TYPE_OP_CODE) begin
        instr_type = S_TYPE;
    end else if (op_code == RISCV32_B_TYPE_OP_CODE) begin
        instr_type = B_TYPE;
    end else if (op_code == RISCV32_J_TYPE_OP_CODE) begin
        instr_type = J_TYPE;
    end else if ((op_code == RISCV32_AUIPC_OP_CODE) || (op_code == RISCV32_LUI_OP_CODE)) begin
        instr_type = U_TYPE;
    end else begin
        instr_type = R_TYPE;
    end
end

endmodule: riscv32_control_unit