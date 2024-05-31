//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 25/04/2022
//RISCV32 Hazard detection unit

module hazard_detection_unit
import riscv32_pkg::*;
(
    input  logic                            clk,
    input  logic[RISCV32_RF_ADDR_WIDTH-1:0] rs1,
    input  logic[RISCV32_RF_ADDR_WIDTH-1:0] rs2,
    input  logic[RISCV32_RF_ADDR_WIDTH-1:0] rd,
    input  logic                            mem_read,
    input  logic                            ex_jump,
    input  logic                            fetch_take_branch,
    input  logic                            ex_take_branch,
    output logic                            wr_pc,
    output logic                            wr_if_id_reg,
    output logic                            sel_mux_id_ex
);

//Hazard detected
logic hazard;
//Hazard MEM_READ  RS1/RS2==RD_EX
logic hazard_mem_read_ex;
//Hazard jump
logic hazard_jump;
//Hazard branch
logic hazard_branch;
//Miss prediction branch
logic miss_branch;
logic miss_branch_ff;
//Ex jump delayed 1 clock cycle
logic ex_jump_ff;
//Rd == Rs1
logic rd_same_rs1;
//Rd == rs2
logic rd_same_rs2;
//(RD==rs1) || (RD==rs2)
logic rd_same_rs1_or_rs2;

assign rd_same_rs1 = (rd == rs1);
assign rd_same_rs2 = (rd == rs2);
assign rd_same_rs1_or_rs2 = (rd_same_rs1 || rd_same_rs2);

assign miss_branch = (fetch_take_branch != ex_take_branch);

assign hazard_mem_read_ex = ((mem_read) && (rd_same_rs1_or_rs2));
assign hazard_jump        = (ex_jump || ex_jump_ff);
assign hazard_branch      = (miss_branch || miss_branch_ff);

assign hazard = (hazard_mem_read_ex || hazard_jump || hazard_branch);

//Outputs
assign wr_pc         = ~hazard_mem_read_ex;
assign wr_if_id_reg  = ~hazard_mem_read_ex;
assign sel_mux_id_ex = hazard;

always_ff @(posedge clk) begin
    ex_jump_ff     <= ex_jump;
    miss_branch_ff <= miss_branch;
end

endmodule: hazard_detection_unit