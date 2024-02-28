//File: riscv_v_rf_ctrl.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector Register File Control

module riscv_v_rf_ctrl 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic                        clk,
    input  logic                        rst,
    input  logic                        stall,
    input  logic                        flush,
    //Register File interface
    input  riscv_v_rf_addr_t            rf_wr_addr_id,
    output riscv_v_rf_addr_t            rf_wr_addr_mem,
    output riscv_v_rf_addr_t            rf_wr_addr_wb,
    input  riscv_v_rf_wr_en_t           rf_wr_en_exe,
    output riscv_v_rf_wr_en_t           rf_wr_en_mem,
    output riscv_v_rf_wr_en_t           rf_wr_en_wb,
    input  riscv_v_data_t               rf_wr_data_exe,
    output riscv_v_data_t               rf_wr_data_mem,
    output riscv_v_data_t               rf_wr_data_wb,
    input  riscv_v_data_t               rf_rd_data_srca_id,
    output riscv_v_data_t               rf_rd_data_srca_exe,
    input  riscv_v_data_t               rf_rd_data_srcb_id,
    output riscv_v_data_t               rf_rd_data_srcb_exe,             
    //Mask Register File Interface
    input  riscv_v_mask_rf_addr_t       mask_rf_wr_addr_id,
    output riscv_v_mask_rf_addr_t       mask_rf_wr_addr_wb,
    input  riscv_v_mask_t               mask_rf_wr_data_exe,
    output riscv_v_mask_t               mask_rf_wr_data_wb,
    input  logic                        mask_rf_wr_en_id,
    output logic                        mask_rf_wr_en_wb,
    input  riscv_v_mask_t               mask_rf_rd_data_id,
    output riscv_v_mask_t               mask_rf_rd_data_exe,
    //Integer Register File Interface
    input  riscv_data_t                 int_rf_rd_data_id,
    output riscv_data_t                 int_rf_rd_data_exe,
    input  riscv_data_t                 int_rf_wr_data_exe,
    output riscv_data_t                 int_rf_wr_data_wb,
    input  logic                        int_rf_wr_en_id,
    output logic                        int_rf_wr_en_wb
);

logic en_stage;

riscv_v_rf_wr_en_t rf_wr_en_stages[RISCV_V_EXE_2_WB_LATENCY:0];
riscv_v_rf_addr_t  rf_wr_addr_stages[RISCV_V_ID_2_WB_LATENCY:0];
riscv_v_data_t     rf_wr_data_stages[RISCV_V_EXE_2_WB_LATENCY:0];

assign en_stage = ~stall;

//Stage register file interface
riscv_v_stage#(.DATA_T(riscv_v_rf_addr_t),      .NUM_STAGES(RISCV_V_ID_2_WB_LATENCY))  stage_rf_wr_addr      (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(rf_wr_addr_id),       .data_out(rf_wr_addr_wb),           .internal_data(rf_wr_addr_stages));
riscv_v_stage#(.DATA_T(riscv_v_rf_wr_en_t),     .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY)) stage_rf_wr_en        (.clk(clk), .rst(rst),  .en(en_stage), .flush(flush), .rst_val('0), .flush_val('0), .data_in(rf_wr_en_exe),        .data_out(rf_wr_en_wb),             .internal_data(rf_wr_en_stages));
riscv_v_stage#(.DATA_T(riscv_v_data_t),         .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY)) stage_rf_wr_data      (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(rf_wr_data_exe),      .data_out(rf_wr_data_wb),           .internal_data(rf_wr_data_stages));
riscv_v_stage#(.DATA_T(riscv_v_data_t),         .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY)) stage_rf_rd_data_srca (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(rf_rd_data_srca_id),  .data_out(rf_rd_data_srca_exe));
riscv_v_stage#(.DATA_T(riscv_v_data_t),         .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY)) stage_rf_rd_data_srcb (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(rf_rd_data_srcb_id),  .data_out(rf_rd_data_srcb_exe));

//Stage Mask register file interface
riscv_v_stage#(.DATA_T(riscv_v_mask_rf_addr_t), .NUM_STAGES(RISCV_V_ID_2_WB_LATENCY))  stage_mask_rf_wr_addr (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(mask_rf_wr_addr_id),  .data_out(mask_rf_wr_addr_wb));
riscv_v_stage#(.DATA_T(riscv_v_mask_t),         .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY)) stage_mask_rf_wr_data (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(mask_rf_wr_data_exe), .data_out(mask_rf_wr_data_wb));
riscv_v_stage#(.DATA_T(logic),                  .NUM_STAGES(RISCV_V_ID_2_WB_LATENCY))  stage_mask_rf_wr_en   (.clk(clk), .rst(rst),  .en(en_stage), .flush(flush), .rst_val('0), .flush_val('0), .data_in(mask_rf_wr_en_id),    .data_out(mask_rf_wr_en_wb));
riscv_v_stage#(.DATA_T(riscv_v_mask_t),         .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY)) stage_mask_rf_rd_data (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(mask_rf_rd_data_id),  .data_out(mask_rf_rd_data_exe));

//Stage Integer Register File interface
riscv_v_stage#(.DATA_T(riscv_data_t),           .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY)) stage_int_rf_rd_data  (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(int_rf_rd_data_id),   .data_out(int_rf_rd_data_exe));
riscv_v_stage#(.DATA_T(riscv_data_t),           .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY)) stage_int_rf_wr_data  (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(int_rf_wr_data_exe),  .data_out(int_rf_wr_data_wb));
riscv_v_stage#(.DATA_T(logic),                  .NUM_STAGES(RISCV_V_ID_2_WB_LATENCY))  stage_int_rf_wr_en    (.clk(clk), .rst(rst),  .en(en_stage), .flush(flush), .rst_val('0), .flush_val('0), .data_in(int_rf_wr_en_id),     .data_out(int_rf_wr_en_wb));


//Intermediate stages
assign rf_wr_en_mem   = rf_wr_en_stages[RISCV_V_EXE_2_MEM_LATENCY];
assign rf_wr_addr_mem = rf_wr_addr_stages[RISCV_V_ID_2_MEM_LATENCY];
assign rf_wr_data_mem = rf_wr_data_stages[RISCV_V_EXE_2_MEM_LATENCY];




endmodule: riscv_v_rf_ctrl