//File: mulvec_behavioral
//Author: Miguel Bucio
//Date: 20/09/23
//Description: vectorial multiplier behavioral

module mulvec_behavioral(
    input  logic         clk,
    input  logic [127:0] srca_in,
    input  logic [127:0] srcb_in,
    input  logic [2:0]   sel_in,
    input  logic         is_mul_in,
    input  logic         is_high_in,
    input  logic         is_signed_in,
    output logic [127:0] result_out
);

    logic [2:0] sel;
    logic is_mul;
    logic is_high;
    logic is_signed;

    logic [127:0] srca;
    logic [127:0] srcb;
    logic [7:0]   srca_8  [15:0];
    logic [7:0]   srcb_8  [15:0]; 
    logic [15:0]   srca_16  [7:0];
    logic [15:0]   srcb_16  [7:0];
    logic [31:0]   srca_32  [3:0];
    logic [31:0]   srcb_32  [3:0];
    logic [63:0]   srca_64  [1:0];
    logic [63:0]   srcb_64  [1:0];
    logic [127:0]   srca_128  [0:0];
    logic [127:0]   srcb_128  [0:0];

    logic [7:0]   result_8  [15:0];
    logic [15:0]   result_16  [7:0];
    logic [31:0]   result_32  [3:0];
    logic [63:0]   result_64  [1:0];
    logic [127:0]   result_128  [0:0];
    logic [127:0]  result;

    always_ff @(posedge clk) begin
        srca       <= srca_in;
        srcb       <= srcb_in;
        sel        <= sel_in;
        is_mul     <= is_mul_in;
        is_high    <= is_high_in;
        is_signed  <= is_signed_in;
        result_out <= result;
    end

    always_comb begin
        case (sel)
            0: result = {result_8[15], result_8[14], result_8[13], result_8[12], result_8[11], result_8[10], result_8[9], result_8[8], result_8[7], result_8[6], result_8[5], result_8[4], result_8[3], result_8[2], result_8[1], result_8[0]};
            1: result = {result_16[7], result_16[6], result_16[5], result_16[4], result_16[3], result_16[2], result_16[1], result_16[0]};
            2: result = {result_32[3], result_32[2], result_32[1], result_32[0]};
            3: result = {result_64[1], result_64[0]};
            4: result = {result_128[0]};
            default: result = '0;
        endcase
    end

generate
    for (genvar i=0; i<16; i++) begin : gen_mul_8 

        assign srca_8[i] = srca[i*8 +: 8];
        assign srcb_8[i] = srcb[i*8 +: 8];

        mul_array#(
            .WIDTH(8)
        ) mul(
            .srca(srca_8[i]),
            .srcb(srcb_8[i]),
            .is_mul(is_mul),
            .is_high(is_high),
            .is_signed(is_signed),
            .result(result_8[i])
        );
    end
    
    for (genvar i=0; i<8; i++) begin : gen_mul_16 

        assign srca_16[i] = srca[i*16 +: 16];
        assign srcb_16[i] = srcb[i*16 +: 16];

        mul_array#(
            .WIDTH(16)
        ) mul(
            .srca(srca_16[i]),
            .srcb(srcb_16[i]),
            .is_mul(is_mul),
            .is_high(is_high),
            .is_signed(is_signed),
            .result(result_16[i])
        );
    end

    for (genvar i=0; i<4; i++) begin : gen_mul_32 

        assign srca_32[i] = srca[i*32 +: 32];
        assign srcb_32[i] = srcb[i*32 +: 32];

        mul_array#(
            .WIDTH(32)
        ) mul(
            .srca(srca_32[i]),
            .srcb(srcb_32[i]),
            .is_mul(is_mul),
            .is_high(is_high),
            .is_signed(is_signed),
            .result(result_32[i])
        );
    end

    for (genvar i=0; i<2; i++) begin : gen_mul_64 

        assign srca_64[i] = srca[i*64 +: 64];
        assign srcb_64[i] = srcb[i*64 +: 64];

        mul_array#(
            .WIDTH(64)
        ) mul(
            .srca(srca_64[i]),
            .srcb(srcb_64[i]),
            .is_mul(is_mul),
            .is_high(is_high),
            .is_signed(is_signed),
            .result(result_64[i])
        );
    end

    for (genvar i=0; i<1; i++) begin : gen_mul_128 

        assign srca_128[i] = srca[i*128 +: 128];
        assign srcb_128[i] = srcb[i*128 +: 128];

        mul_array#(
            .WIDTH(128)
        ) mul(
            .srca(srca_128[i]),
            .srcb(srcb_128[i]),
            .is_mul(is_mul),
            .is_high(is_high),
            .is_signed(is_signed),
            .result(result_128[i])
        );
    end

endgenerate

endmodule: mulvec_behavioral