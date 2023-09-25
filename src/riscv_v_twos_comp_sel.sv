//File: riscv_v_twos_comp_sel
//Author: Miguel Bucio
//Date: 20/09/23
//Description: riscv v twos complement

module riscv_v_twos_comp_sel 
import riscv_v_pkg::*;
#(
    parameter BLOCK_WIDTH              = BYTE_WIDTH
)
(
    input  logic [RISCV_V_NUM_BYTES_DATA-1:0] [BLOCK_WIDTH-1:0]      in,
    input  riscv_v_complement_t                                      complement,
    input  osize_vector_t                                            osize_vector,
    input  riscv_v_merge_data_t                                      merge,
    output logic [RISCV_V_NUM_BYTES_DATA-1:0] [BLOCK_WIDTH-1:0]      out
);

localparam NUM_TWOS_COMP_BLOCKS = RISCV_V_NUM_BYTES_DATA;

typedef logic [RISCV_V_NUM_BYTES_DATA-1:0] [BLOCK_WIDTH-1:0] data_t;

//Carries
riscv_v_carry_in_t   carry_out_adders;
riscv_v_carry_in_t   carry_in_adders;
//xor in
data_t in_xor;

//Extend complement
riscv_v_complement_t complement_ext;
riscv_v_complement_t complement_ext_osize[RISCV_V_NUM_VALID_OSIZES-1:0];

//Extend complement
generate

    for (genvar osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin : gen_ext_comp 
        localparam OSIZE_WIDTH   = (BYTE_WIDTH*(2**osize_idx));
        localparam JUMP_SIZE     = OSIZE_WIDTH/BYTE_WIDTH;
        localparam NUM_BLOCKS    = (RISCV_V_DATA_WIDTH/OSIZE_WIDTH);
        always_comb begin
            for (int i=0; i < NUM_BLOCKS; i++) begin
                //complement_ext_osize[osize_idx][(i*JUMP_SIZE) +: JUMP_SIZE] = `RISCV_V_SX(complement[i*JUMP_SIZE], JUMP_SIZE);
                complement_ext_osize[osize_idx][(i*JUMP_SIZE) +: JUMP_SIZE] = {JUMP_SIZE{complement[i*JUMP_SIZE]}};
            end
        end

    end

endgenerate

always_comb begin
    complement_ext = '0;
    for (int osize_idx = 0; osize_idx < RISCV_V_NUM_VALID_OSIZES; osize_idx++) begin
        complement_ext |= complement_ext_osize[osize_idx] & {RISCV_V_NUM_BYTES_DATA{osize_vector[osize_idx]}};
    end
end


//Select carries
generate

    assign carry_in_adders[0] = complement[0];
    for (genvar carry_idx = 1; carry_idx < RISCV_V_NUM_BYTES_DATA; carry_idx++) begin : gen_carry
        assign carry_in_adders[carry_idx] = complement[carry_idx] | (carry_out_adders[carry_idx-1] & merge[carry_idx-1]);
    end
endgenerate

//Twos complement blocks
generate
    for (genvar block_idx = 0; block_idx < RISCV_V_NUM_BYTES_DATA; block_idx++) begin : gen_twos_comp_blocks 

        assign in_xor[block_idx]      = in[block_idx] ^ {BLOCK_WIDTH{complement_ext[block_idx]}};

        adder_nbit#(
            .ADDER_TYPE("BEHAVIORAL_ADDER"),
            .WIDTH(BLOCK_WIDTH)
        ) adder (
            .A(in_xor[block_idx]),
            .B('0),
            .cin(carry_in_adders[block_idx]),
            .S(out[block_idx]),
            .cout(carry_out_adders[block_idx])
        );

    end

endgenerate


endmodule: riscv_v_twos_comp_sel