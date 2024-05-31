//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 25/04/2022
//RISCV32 Forwarding unit

module forwarding_unit
import riscv32_pkg::*;
(
    input  logic[RISCV32_RF_ADDR_WIDTH-1:0] rs1,
    input  logic[RISCV32_RF_ADDR_WIDTH-1:0] rs2,
    input  logic[RISCV32_RF_ADDR_WIDTH-1:0] rd_mem,
    input  logic[RISCV32_RF_ADDR_WIDTH-1:0] rd_wb,
    input  logic                            RegWrite_mem,
    input  logic                            RegWrite_wb,
    output logic[1:0]                       ForwardA,
    output logic[1:0]                       ForwardB
);

//Check RD is not 0, register zero can't be written
logic rd_mem_is_not_0;
logic rd_wb_is_not_0;

//Check RD and RS1/RS1 are the same register
logic rd_mem_same_rs1;
logic rd_mem_same_rs2;
logic rd_wb_same_rs1;
logic rd_wb_same_rs2;

//Rd is not 0 and RegWrite is 1
logic rd_mem_valid;
logic rd_wb_valid;

assign rd_mem_is_not_0 = (rd_mem != 0);
assign rd_wb_is_not_0  = (rd_wb != 0);

assign rd_mem_same_rs1 = (rd_mem == rs1);
assign rd_mem_same_rs2 = (rd_mem == rs2);
assign rd_wb_same_rs1  = (rd_wb == rs1);
assign rd_wb_same_rs2  = (rd_wb == rs2);

assign rd_mem_valid = (RegWrite_mem && rd_mem_is_not_0);
assign rd_wb_valid  = (RegWrite_wb  && rd_wb_is_not_0);

always_comb begin
    if (rd_mem_valid && rd_mem_same_rs1) begin
        ForwardA = 2'b01;
    end else if (rd_wb_valid && rd_wb_same_rs1) begin
        ForwardA = 2'b10;
    end else begin
        ForwardA = 2'b00;
    end
end

always_comb begin
    if (rd_mem_valid && rd_mem_same_rs2) begin
        ForwardB = 2'b01;
    end else if (rd_wb_valid && rd_wb_same_rs2) begin
        ForwardB = 2'b10;
    end else begin
        ForwardB = 2'b00;
    end
end

endmodule: forwarding_unit
