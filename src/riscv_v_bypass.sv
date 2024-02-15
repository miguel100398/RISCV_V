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
    output riscv_v_data_t       srca_byp,
    output riscv_v_data_t       srcb_byp
);

    logic sign_imm_int;
    riscv_v_data_t sign_extended_data;
    riscv_v_data_t data_to_replicate;
    riscv_v_data_t data_replicated_osize[RISCV_V_NUM_VALID_OSIZES-1:0];
    riscv_v_data_t data_replicated;

    //Select between Vector source or replicated data (scalar int, imm, vec)
    assign srca_byp = (is_scalar) ? data_replicated : srca;
    //Srcb is alwayyss vector source
    assign srcb_byp = srcb;

    //Get sign for sign extend integer and immediate data
    assign sign_imm_int = (is_scalar_imm) ? imm[RISCV_V_IMM_WIDTH-1] : integer_data[RISCV_DATA_WIDTH-1];
    //Sign extend data
    always_comb begin
        sign_extended_data[RISCV_V_DATA_WIDTH-1:RISCV_DATA_WIDTH]   = {(RISCV_V_DATA_WIDTH-RISCV_DATA_WIDTH){sign_imm_int}};
        sign_extended_data[RISCV_DATA_WIDTH-1:RISCV_V_IMM_WIDTH]    = (is_scalar_imm) ? {(RISCV_DATA_WIDTH-RISCV_V_IMM_WIDTH){sign_imm_int}} : integer_data[RISCV_DATA_WIDTH-1 : RISCV_V_IMM_WIDTH];
        sign_extended_data[RISCV_V_IMM_WIDTH-1:0]                   = (is_scalar_imm) ? imm : integer_data[RISCV_V_IMM_WIDTH-1:0];
    end

    //Select data to be replicated between int, imm or vec
    assign data_to_replicate = (is_scalar_vec) ? srca : sign_extended_data;

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
