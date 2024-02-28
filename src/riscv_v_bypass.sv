//File: riscv_v_bypass.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector Bypass unit

module riscv_v_bypass
import riscv_pkg::*, riscv_v_pkg::*;
`include "riscv_v_macros.svh"
(
    input  riscv_data_t         integer_data,
    input  riscv_v_imm_t        imm,
    input  riscv_v_data_t       srca,
    input  riscv_v_data_t       srcb,
    input  osize_vector_t       osize_vector,
    input  logic                is_scalar,
    input  logic                is_scalar_int,
    input  logic                is_scalar_vec,
    input  logic                is_scalar_imm,
    input  logic                is_scalar_fp,
    input  riscv_v_rf_wr_en_t   rf_wr_en_mem,
    input  riscv_v_rf_wr_en_t   rf_wr_en_wb,
    input  riscv_instr_rs_t     rf_rd_addr_srca_exe,
    input  riscv_instr_rs_t     rf_rd_addr_srcb_exe,
    input  riscv_instr_rd_t     rf_wr_addr_mem,
    input  riscv_instr_rd_t     rf_wr_addr_wb,
    input  riscv_v_data_t       rf_wr_data_mem,
    input  riscv_v_data_t       rf_wr_data_wb,
    output riscv_v_data_t       srca_byp,
    output riscv_v_data_t       srcb_byp
);

    //Get data from bypass
    logic                     rd_addr_A_mem_match;
    logic                     rd_addr_A_wb_match;
    logic                     rd_addr_B_mem_match;
    logic                     rd_addr_B_wb_match;
    riscv_v_num_byte_vector_t srca_mem_sel;
    riscv_v_num_byte_vector_t srca_wb_sel;
    riscv_v_num_byte_vector_t srcb_mem_sel;
    riscv_v_num_byte_vector_t srcb_wb_sel;

    riscv_v_data_t srca_vec_byp;
    riscv_v_data_t srcb_vec_byp;

    //Get data from scalar
    logic sign_imm_int;
    riscv_v_data_t sign_extended_data;
    riscv_v_data_t data_to_replicate;
    riscv_v_data_t data_replicated_osize[RISCV_V_NUM_VALID_OSIZES-1:0];
    riscv_v_data_t data_replicated;

    //Vector Bypass
    assign rd_addr_A_mem_match = (rf_rd_addr_srca_exe == rf_wr_addr_mem);
    assign rd_addr_A_wb_match  = (rf_rd_addr_srca_exe == rf_wr_addr_wb);

    assign rd_addr_B_mem_match = (rf_rd_addr_srcb_exe == rf_wr_addr_mem);
    assign rd_addr_B_wb_match  = (rf_rd_addr_srcb_exe == rf_wr_addr_wb);

    
    always_comb begin
        for (int idx = 0; idx < RISCV_V_NUM_BYTES_DATA; idx++) begin
            srca_mem_sel[idx] = rd_addr_A_mem_match && rf_wr_en_mem[idx];
            srca_wb_sel[idx]  = rd_addr_A_wb_match  && rf_wr_en_wb[idx];
        end
    end
    
    always_comb begin
        for (int idx = 0; idx < RISCV_V_NUM_BYTES_DATA; idx++) begin
            srcb_mem_sel[idx] = rd_addr_B_mem_match && rf_wr_en_mem[idx];
            srcb_wb_sel[idx]  = rd_addr_B_wb_match  && rf_wr_en_wb[idx];
        end
    end

    always_comb  begin
        for (int idx = 0; idx < RISCV_V_NUM_BYTES_DATA; idx++) begin
            if (srca_mem_sel[idx]) begin
                srca_vec_byp.Byte[idx] = rf_wr_data_mem.Byte[idx];
            end else if (srca_wb_sel[idx]) begin
                srca_vec_byp.Byte[idx] = rf_wr_data_wb.Byte[idx];
            end else begin
                srca_vec_byp.Byte[idx] = srca.Byte[idx];
            end
        end
    end

    always_comb  begin
        for (int idx = 0; idx < RISCV_V_NUM_BYTES_DATA; idx++) begin
            if (srcb_mem_sel[idx]) begin
                srcb_vec_byp.Byte[idx] = rf_wr_data_mem.Byte[idx];
            end else if (srcb_wb_sel[idx]) begin
                srcb_vec_byp.Byte[idx] = rf_wr_data_wb.Byte[idx];
            end else begin
                srcb_vec_byp.Byte[idx] = srcb.Byte[idx];
            end
        end
    end

    //Select between Vector source or replicated data (scalar int, imm, vec)
    assign srca_byp = (is_scalar) ? data_replicated : srca_vec_byp;
    //Srcb is alwayyss vector source
    assign srcb_byp = srcb_vec_byp;

    //Get sign for sign extend integer and immediate data
    assign sign_imm_int = (is_scalar_imm) ? imm[RISCV_V_IMM_WIDTH-1] : integer_data[RISCV_DATA_WIDTH-1];
    //Sign extend data
    always_comb begin
        sign_extended_data[RISCV_V_DATA_WIDTH-1:RISCV_DATA_WIDTH]   = {(RISCV_V_DATA_WIDTH-RISCV_DATA_WIDTH){sign_imm_int}};
        sign_extended_data[RISCV_DATA_WIDTH-1:RISCV_V_IMM_WIDTH]    = (is_scalar_imm) ? {(RISCV_DATA_WIDTH-RISCV_V_IMM_WIDTH){sign_imm_int}} : integer_data[RISCV_DATA_WIDTH-1 : RISCV_V_IMM_WIDTH];
        sign_extended_data[RISCV_V_IMM_WIDTH-1:0]                   = (is_scalar_imm) ? imm : integer_data[RISCV_V_IMM_WIDTH-1:0];
    end

    //Select data to be replicated between int, imm or vec
    assign data_to_replicate = (is_scalar_vec) ? srca_vec_byp : sign_extended_data;

    //Replicate Data
    generate 
        for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
            localparam OSIZE_WIDTH = (2**osize_idx)*BYTE_WIDTH;
            localparam NUM_BLOCKS_OSIZE = RISCV_V_DATA_WIDTH / OSIZE_WIDTH; 
            assign data_replicated_osize[osize_idx] = {NUM_BLOCKS_OSIZE{data_to_replicate[OSIZE_WIDTH-1:0]}};
        end
    endgenerate

    //Select data replicated with osize
    always_comb begin 
        data_replicated = '0;
        for (int osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
            data_replicated |= data_replicated_osize[osize_idx] & {RISCV_V_DATA_WIDTH{osize_vector[osize_idx]}};
        end
    end
    

endmodule: riscv_v_bypass
