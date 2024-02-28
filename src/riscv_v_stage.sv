//File: riscv_v_stage.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension stage module to flop signals 

module riscv_v_stage#(
    parameter type DATA_T     = logic,
    parameter int  NUM_STAGES = 1
) (
    input  logic  clk,
    input  logic  rst,
    input  logic  en,
    input  logic  flush,
    input  DATA_T rst_val,
    input  DATA_T flush_val,
    input  DATA_T data_in,
    output DATA_T data_out,
    output DATA_T internal_data[NUM_STAGES:0]
);

generate

    assign internal_data[0] = data_in;

    for (genvar idx = 1; idx <= NUM_STAGES; idx++) begin : gen_stage_data

        always_ff @(posedge clk or posedge rst) begin
            if (rst) begin
                internal_data[idx] <= rst_val;
            end else if (flush) begin
                internal_data[idx] <= flush_val;
            end else if (en) begin
                internal_data[idx] <= internal_data[idx-1];
            end
        end

    end

    assign data_out = internal_data[NUM_STAGES];

endgenerate

endmodule: riscv_v_stage