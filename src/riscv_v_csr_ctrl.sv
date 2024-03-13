//File: riscv_v_csr_ctrl.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector CSR Control
`timescale 1ns/1ps

module riscv_v_csr_ctrl 
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic                clk,
    input  logic                rst,
    input  logic                stall,
    input  logic                flush,
    //RISCV External interface
    input  riscv_data_t         ext_data_in_exe,
    input  logic                ext_wr_vsstatus_id,
    input  logic                ext_wr_vtype_id,
    input  logic                ext_wr_vl_id,
    input  logic                ext_wr_vstart_id,
    input  logic                ext_wr_vxrm_id,
    input  logic                ext_wr_vxsat_id,
    //RISCV Vector interface
    input  riscv_v_data_t       vec_data_in_exe,
    input  logic                vec_wr_vsstatus_id,
    input  logic                vec_wr_vtype_id,
    input  logic                vec_wr_vl_id,
    input  logic                vec_wr_vstart_id,
    input  logic                vec_wr_vxrm_id,
    input  logic                vec_wr_vxsat_id,
    //CSR interface
    output logic                csr_wr_en_vsstatus_wb,
    output logic                csr_wr_en_vtype_wb,
    output logic                csr_wr_en_vl_wb,
    output logic                csr_wr_en_vstart_wb,
    output logic                csr_wr_en_vxrm_wb,
    output logic                csr_wr_en_vxsat_wb,
    output riscv_v_vsstatus_t   csr_wr_data_vsstatus_wb,
    output riscv_v_vtype_t      csr_wr_data_vtype_wb,
    output riscv_v_vl_t         csr_wr_data_vl_wb,
    output riscv_v_vstart_t     csr_wr_data_vstart_wb,
    output riscv_v_vxrm_t       csr_wr_data_vxrm_wb,
    output riscv_v_vxsat_t      csr_wr_data_vxsat_wb
);

logic en_stage;

logic   ext_wr_vsstatus_exe;
logic   ext_wr_vtype_exe;
logic   ext_wr_vl_exe;
logic   ext_wr_vstart_exe;
logic   ext_wr_vxrm_exe;
logic   ext_wr_vxsat_exe;

logic   vec_wr_vsstatus_exe;
logic   vec_wr_vtype_exe;
logic   vec_wr_vl_exe;
logic   vec_wr_vstart_exe;
logic   vec_wr_vxrm_exe;
logic   vec_wr_vxsat_exe;

logic   wr_vsstatus_exe;
logic   wr_vtype_exe;
logic   wr_vl_exe;
logic   wr_vstart_exe;
logic   wr_vxrm_exe;
logic   wr_vxsat_exe;

riscv_v_vsstatus_t vsstatus_exe;
riscv_v_vtype_t    vtype_exe;
riscv_v_vl_t       vl_exe;
riscv_v_vstart_t   vstart_exe;
riscv_v_vxrm_t     vxrm_exe;
riscv_v_vxsat_t    vxsat_exe;

assign en_stage = ~stall;

//Stage signals
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_ext_wr_vsstatus (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(ext_wr_vsstatus_id),       .data_out(ext_wr_vsstatus_exe));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_ext_wr_vtype    (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(ext_wr_vtype_id),          .data_out(ext_wr_vtype_exe));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_ext_wr_vl       (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(ext_wr_vl_id),             .data_out(ext_wr_vl_exe));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_ext_wr_vstart   (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(ext_wr_vstart_id),         .data_out(ext_wr_vstart_exe));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_ext_wr_vxrm     (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(ext_wr_vxrm_id),           .data_out(ext_wr_vxrm_exe));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_ext_wr_vxsat    (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(ext_wr_vxsat_id),          .data_out(ext_wr_vxsat_exe));

riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_vec_wr_vsstatus (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(vec_wr_vsstatus_id),       .data_out(vec_wr_vsstatus_exe));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_vec_wr_vtype    (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(vec_wr_vtype_id),          .data_out(vec_wr_vtype_exe));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_vec_wr_vl       (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(vec_wr_vl_id),             .data_out(vec_wr_vl_exe));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_vec_wr_vstart   (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(vec_wr_vstart_id),         .data_out(vec_wr_vstart_exe));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_vec_wr_vxrm     (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(vec_wr_vxrm_id),           .data_out(vec_wr_vxrm_exe));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_ID_2_EXE_LATENCY))  stage_vec_wr_vxsat    (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(vec_wr_vxsat_id),          .data_out(vec_wr_vxsat_exe));


assign wr_vsstatus_exe = ext_wr_vsstatus_exe || vec_wr_vsstatus_exe;
assign wr_vtype_exe    = ext_wr_vtype_exe    || vec_wr_vtype_exe;
assign wr_vl_exe       = ext_wr_vl_exe       || vec_wr_vl_exe;
assign wr_vstart_exe   = ext_wr_vstart_exe   || vec_wr_vstart_exe;
assign wr_vxrm_exe     = ext_wr_vxrm_exe     || vec_wr_vxrm_exe;
assign wr_vxsat_exe    = ext_wr_vxsat_exe    || vec_wr_vxsat_exe;

assign vsstatus_exe = (ext_data_in_exe[RISCV_V_VSSTATUS_WIDTH-1:0] & {RISCV_V_VSSTATUS_WIDTH{ext_wr_vsstatus_exe}})
                    | (vec_data_in_exe[RISCV_V_VSSTATUS_WIDTH-1:0] & {RISCV_V_VSSTATUS_WIDTH{vec_wr_vsstatus_exe}});

assign vtype_exe    = (ext_data_in_exe[RISCV_V_VTYPE_WIDTH-1:0]    & {RISCV_V_VTYPE_WIDTH{ext_wr_vtype_exe}})
                    | (vec_data_in_exe[RISCV_V_VTYPE_WIDTH-1:0]    & {RISCV_V_VTYPE_WIDTH{vec_wr_vtype_exe}});

assign vl_exe       = (ext_data_in_exe[RISCV_V_VL_WIDTH-1:0]       & {RISCV_V_VL_WIDTH{ext_wr_vl_exe}})
                    | (vec_data_in_exe[RISCV_V_VL_WIDTH-1:0]       & {RISCV_V_VL_WIDTH{vec_wr_vl_exe}});

assign vstart_exe   = (ext_data_in_exe[RISCV_V_VSTART_WIDTH-1:0]   & {RISCV_V_VSTART_WIDTH{ext_wr_vstart_exe}})
                    | (vec_data_in_exe[RISCV_V_VSTART_WIDTH-1:0]   & {RISCV_V_VSTART_WIDTH{vec_wr_vstart_exe}});

assign vxrm_exe     = (ext_data_in_exe[RISCV_V_VXRM_WIDTH-1:0]     & {RISCV_V_VXRM_WIDTH{ext_wr_vxrm_exe}})
                    | (vec_data_in_exe[RISCV_V_VXRM_WIDTH-1:0]     & {RISCV_V_VXRM_WIDTH{vec_wr_vxrm_exe}});

assign vxsat_exe    = (ext_data_in_exe[RISCV_V_VXSAT_WIDTH-1:0]    & {RISCV_V_VXSAT_WIDTH{ext_wr_vxsat_exe}})
                    | (vec_data_in_exe[RISCV_V_VXSAT_WIDTH-1:0]    & {RISCV_V_VXSAT_WIDTH{vec_wr_vxsat_exe}});

riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY))  stage_wr_en_vsstatus (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(wr_vsstatus_exe),       .data_out(csr_wr_en_vsstatus_wb));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY))  stage_wr_en_vtype    (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(wr_vtype_exe),          .data_out(csr_wr_en_vtype_wb));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY))  stage_wr_en_vl       (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(wr_vl_exe),             .data_out(csr_wr_en_vl_wb));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY))  stage_wr_en_vstart   (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(wr_vstart_exe),         .data_out(csr_wr_en_vstart_wb));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY))  stage_wr_en_vxrm     (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(wr_vxrm_exe),           .data_out(csr_wr_en_vxrm_wb));
riscv_v_stage#(.DATA_T(logic),  .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY))  stage_wr_en_vxsat    (.clk(clk), .rst(rst), .en(en_stage), .flush(flush),  .rst_val('0), .flush_val('0), .data_in(wr_vxsat_exe),          .data_out(csr_wr_en_vxsat_wb));

riscv_v_stage#(.DATA_T(riscv_v_vsstatus_t), .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY))  stage_wr_data_vsstatus (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(vsstatus_exe),       .data_out(csr_wr_data_vsstatus_wb));
riscv_v_stage#(.DATA_T(riscv_v_vtype_t),    .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY))  stage_wr_data_vtype    (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(vtype_exe),          .data_out(csr_wr_data_vtype_wb));
riscv_v_stage#(.DATA_T(riscv_v_vl_t),       .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY))  stage_wr_data_vl       (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(vl_exe),             .data_out(csr_wr_data_vl_wb));
riscv_v_stage#(.DATA_T(riscv_v_vstart_t),   .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY))  stage_wr_data_vstart   (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(vstart_exe),         .data_out(csr_wr_data_vstart_wb));
riscv_v_stage#(.DATA_T(riscv_v_vxrm_t),     .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY))  stage_wr_data_vxrm     (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(vxrm_exe),           .data_out(csr_wr_data_vxrm_wb));
riscv_v_stage#(.DATA_T(riscv_v_vxsat_t),    .NUM_STAGES(RISCV_V_EXE_2_WB_LATENCY))  stage_wr_data_vxsat    (.clk(clk), .rst(1'b0), .en(en_stage), .flush(1'b0),  .rst_val('x), .flush_val('x), .data_in(vxsat_exe),          .data_out(csr_wr_data_vxsat_wb));


///////////////////////////////////Asserts/////////////////////////////////////////
wr_vsstatus_id: assert property ( @(posedge clk)
    ~(ext_wr_vsstatus_id && vec_wr_vsstatus_id)
) else $fatal(1, "Trying to write vsstatus from external and vec at the same time ID");

wr_vtype_id: assert property ( @(posedge clk)
    ~(ext_wr_vtype_id && vec_wr_vtype_id)
) else $fatal(1, "Trying to write vtype from external and vec at the same time ID");

wr_vl_id: assert property ( @(posedge clk)
    ~(ext_wr_vl_id && vec_wr_vl_id)
) else $fatal(1, "Trying to write vl from external and vec at the same time ID");

wr_vstart_id: assert property ( @(posedge clk)
    ~(ext_wr_vstart_id && vec_wr_vstart_id)
) else $fatal(1, "Trying to write vstart from external and vec at the same time ID");

wr_vxrm_id: assert property ( @(posedge clk)
    ~(ext_wr_vxrm_id && vec_wr_vxrm_id)
) else $fatal(1, "Trying to write vxrm from external and vec at the same time ID");

wr_vxsat_id: assert property ( @(posedge clk)
    ~(ext_wr_vxsat_id && vec_wr_vxsat_id)
) else $fatal(1, "Trying to write vxsat from external and vec at the same time ID");




endmodule: riscv_v_csr_ctrl