//File: riscv_v_logic_ALU.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extension logical ALU

module riscv_v_logic_ALU
import riscv_v_pkg::*;
(
    //Control signals
    input  logic              is_reduct,
    input  logic              is_and,
    //Input sources
    input  riscv_v_alu_data_t srca,
    input  riscv_v_alu_data_t srcb,
    //Output result
    output riscv_v_wb_data_t  result
);

    //And gating is_and
    riscv_v_src_byte_vector_t                           srca_and_gated;
    //Mux reduct is_and
    logic                                               sel_reduct [RISCV_V_NUM_BYTES_DATA-1:0];
    logic [RISCV_V_NUM_BYTES_DATA-2:0] [BYTE_WIDTH-1:0] mux_is_and_reduct;
    //Bitwise AND results
    riscv_v_src_byte_vector_t                           and_result;

    
    generate
        //Gate (is_and & srcA)
        for (genvar i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin : gen_is_and_srcA_gating
            assign srca_and_gated[i] = srca.data.Byte[i] & {BYTE_WIDTH{is_and}};
        end
        //Sel mux reduct
        for (genvar i=0; i<RISCV_V_NUM_BYTES_DATA-1; i++) begin : gen_sel_mux_reduct
            assign sel_reduct[i] = is_reduct & ~srcb.merge[i];
        end
        //Mux reduct
        for (genvar i=0; i<RISCV_V_NUM_BYTES_DATA-1; i++) begin : gen_is_and_mux_reduct
            assign mux_is_and_reduct[i] = (sel_reduct[i]) ? and_result[i+1] : srca_and_gated[i];
        end
        //Bitwise and
        for (genvar i=0; i<RISCV_V_NUM_BYTES_DATA-1; i++) begin : gen_bitwise_and
            
            riscv_v_bitwise_and #(
                .DATA_WIDTH(BYTE_WIDTH)
            )bitwise_and(
                .A(mux_is_and_reduct[i]),
                .B(srcb.data.Byte[i]),
                .S(and_result[i])
            );

        end
    endgenerate

    //Most significant bitwise and
    riscv_v_bitwise_and #(
        .DATA_WIDTH(BYTE_WIDTH)
    ) bitwise_and_msb(
        .A(srca_and_gated[RISCV_V_NUM_BYTES_DATA-1]),
        .B(srcb.data.Byte[RISCV_V_NUM_BYTES_DATA-1]),
        .S(and_result[RISCV_V_NUM_BYTES_DATA-1])
    );

    //Final Mux result
    assign result.data  = and_result;
    assign result.valid = srca.valid & srcb.valid;

endmodule: riscv_v_logic_ALU
