//File: vedic_mul_unsigned
//Author: Miguel Bucio
//Date: 20/09/23
//Description: Unsigned vedic multiplier

module vedic_mul_unsigned
import riscv_v_pkg::*;
#(
    parameter                 WIDTH                 = 2,
    parameter vedic_mul_idx_t MUL_IDX               = VEDIC_LA_LB,
    parameter                 MIN_MUL_LEVEL         = $clog2(16),
    parameter bit             GET_MID_PREV_RESULTS  = 1'b0, 
    localparam                RESULT_WIDTH          = (2*WIDTH),
    localparam                MUL_LEVEL             = $clog2(WIDTH),
    localparam                NUM_PREV_RESULTS      = f_vedic_mul_get_prev_results(MUL_LEVEL, MIN_MUL_LEVEL, MUL_IDX, GET_MID_PREV_RESULTS)
) (
    input  logic [WIDTH-1:0]        A,
    input  logic [WIDTH-1:0]        B,
    output logic [RESULT_WIDTH-1:0] Z,
    output logic [WIDTH-1:0]        prev_result[NUM_PREV_RESULTS-1:0]
);

localparam  HALF_WIDTH          = (WIDTH/2);
localparam NUM_MULTIPLIERS      = 4;


localparam PREV_LEVEL_HL_NUM_PREV_RESULTS  = f_vedic_mul_get_prev_results(MUL_LEVEL-1, MIN_MUL_LEVEL, VEDIC_LA_LB, GET_MID_PREV_RESULTS);
localparam PREV_LEVEL_MID_NUM_PREV_RESULTS = f_vedic_mul_get_prev_results(MUL_LEVEL-1, MIN_MUL_LEVEL, VEDIC_LA_HB, GET_MID_PREV_RESULTS);
localparam VALID_PREV_RESULT               = f_vedic_mul_valid_prev_result(MUL_LEVEL,  MIN_MUL_LEVEL, MUL_IDX,     GET_MID_PREV_RESULTS);

generate
    if (WIDTH > 2) begin : gen_vedic_multiplier

        //Sources divided in low and high part
        logic [HALF_WIDTH-1:0] A_l;
        logic [HALF_WIDTH-1:0] A_h;
        logic [HALF_WIDTH-1:0] B_l;
        logic [HALF_WIDTH-1:0] B_h;
        //Multipliers
        logic [WIDTH-1:0]      mul[NUM_MULTIPLIERS-1:0];

        //Low adder
        logic [WIDTH-1:0] srcA_low_adder;
        logic [WIDTH-1:0] srcB_low_adder;
        logic [WIDTH-1:0] result_low_adder;
        logic             cin_low_adder;
        logic             cout_low_adder;

        //Mid adder
        logic [WIDTH-1:0] srcA_mid_adder;
        logic [WIDTH-1:0] srcB_mid_adder;
        logic [WIDTH-1:0] result_mid_adder;
        logic             cin_mid_adder;
        logic             cout_mid_adder;

        //High adder
        logic [WIDTH-1:0] srcA_high_adder;
        logic [WIDTH-1:0] srcB_high_adder;
        logic [WIDTH-1:0] result_high_adder;
        logic             cin_high_adder;
        logic             cout_high_adder;

        //Or Gate
        logic or_carry;

        //Previous result
        logic [HALF_WIDTH-1:0] prev_result_mul_la_lb[PREV_LEVEL_HL_NUM_PREV_RESULTS-1:0];
        logic [HALF_WIDTH-1:0] prev_result_mul_la_hb[PREV_LEVEL_MID_NUM_PREV_RESULTS-1:0];
        logic [HALF_WIDTH-1:0] prev_result_mul_ha_lb[PREV_LEVEL_MID_NUM_PREV_RESULTS-1:0];
        logic [HALF_WIDTH-1:0] prev_result_mul_ha_hb[PREV_LEVEL_HL_NUM_PREV_RESULTS-1:0];

        //Divide sources in low and high part
        assign A_l = A[0       +: HALF_WIDTH];
        assign A_h = A[WIDTH-1 -: HALF_WIDTH];

        assign B_l = B[0       +: HALF_WIDTH];
        assign B_h = B[WIDTH-1 -: HALF_WIDTH];

        //Instantiate multipliers
        vedic_mul_unsigned #(
            .WIDTH(HALF_WIDTH),
            .MUL_IDX(VEDIC_LA_LB),
            .MIN_MUL_LEVEL(MIN_MUL_LEVEL),
            .GET_MID_PREV_RESULTS(GET_MID_PREV_RESULTS)
        ) mul_la_lb(
            .A(A_l),
            .B(B_l),
            .Z(mul[0]),
            .prev_result(prev_result_mul_la_lb)
        );

        vedic_mul_unsigned #(
            .WIDTH(HALF_WIDTH),
            .MUL_IDX(VEDIC_LA_HB),
            .MIN_MUL_LEVEL(MIN_MUL_LEVEL),
            .GET_MID_PREV_RESULTS(GET_MID_PREV_RESULTS)
        ) mul_la_hb(
            .A(A_l),
            .B(B_h),
            .Z(mul[1]),
            .prev_result(prev_result_mul_la_hb)
        );

        vedic_mul_unsigned #(
            .WIDTH(HALF_WIDTH),
            .MUL_IDX(VEDIC_HA_LB),
            .MIN_MUL_LEVEL(MIN_MUL_LEVEL),
            .GET_MID_PREV_RESULTS(GET_MID_PREV_RESULTS)
        ) mul_ha_lb(
            .A(A_h),
            .B(B_l),
            .Z(mul[2]),
            .prev_result(prev_result_mul_ha_lb)
        );

        vedic_mul_unsigned #(
            .WIDTH(HALF_WIDTH),
            .MUL_IDX(VEDIC_HA_HB),
            .MIN_MUL_LEVEL(MIN_MUL_LEVEL),
            .GET_MID_PREV_RESULTS(GET_MID_PREV_RESULTS)
        ) mul_ha_hb(
            .A(A_h),
            .B(B_h),
            .Z(mul[3]),
            .prev_result(prev_result_mul_ha_hb)
        );

        //Low adder
        assign srcA_low_adder = {{HALF_WIDTH{1'b0}}, mul[0][WIDTH-1 -: HALF_WIDTH]};
        assign srcB_low_adder = result_mid_adder;
        assign cin_low_adder  = 1'b0;
        adder_nbit #(
            .WIDTH(WIDTH),
            .ADDER_TYPE("BEHAVIORAL_ADDER")
        ) low_adder(
            .A      (srcA_low_adder),
            .B      (srcB_low_adder),
            .cin    (cin_low_adder),
            .S      (result_low_adder),
            .cout   (cout_low_adder)
        );

        //Mid adder
        assign srcA_mid_adder = mul[1];
        assign srcB_mid_adder = mul[2];
        assign cin_mid_adder  = 1'b0;
        adder_nbit #(
            .WIDTH(WIDTH),
            .ADDER_TYPE("BEHAVIORAL_ADDER")
        ) mid_adder(
            .A      (srcA_mid_adder),
            .B      (srcB_mid_adder),
            .cin    (cin_mid_adder),
            .S      (result_mid_adder),
            .cout   (cout_mid_adder)
        );

        //High adder
        assign srcA_high_adder = {{HALF_WIDTH-1{1'b0}}, or_carry, result_low_adder[WIDTH-1 -: HALF_WIDTH]};
        assign srcB_high_adder = mul[3];
        assign cin_high_adder  = 1'b0;
        adder_nbit #(
            .WIDTH(WIDTH),
            .ADDER_TYPE("BEHAVIORAL_ADDER")
        ) high_adder(
            .A      (srcA_high_adder),
            .B      (srcB_high_adder),
            .cin    (cin_high_adder),
            .S      (result_high_adder),
            .cout   (cout_high_adder)
        );

        //Or Gate
        assign or_carry =  cout_low_adder | cout_mid_adder;

        //Assign result
        assign Z[0              +: HALF_WIDTH] = mul[0][0 +: HALF_WIDTH];
        assign Z[HALF_WIDTH     +: HALF_WIDTH] = result_low_adder[0 +: HALF_WIDTH];
        assign Z[RESULT_WIDTH-1 -: WIDTH]      = result_high_adder;

        //Previous results
        if (VALID_PREV_RESULT) begin
            
            always_comb begin
                automatic int num_prev_prev_result;
                automatic int num_prev_prev_result_div;
                automatic int accum_prev_level = 0;
                automatic int current_idx = 0;
                //New Previous result
                
                if (GET_MID_PREV_RESULTS) begin
                    
                    //Previous previous results
                    for (int prev_level=MIN_MUL_LEVEL; prev_level < MUL_LEVEL; prev_level++) begin
                        num_prev_prev_result     = f_vedic_mul_num_prev_results_level_diff(MUL_LEVEL, prev_level-1, GET_MID_PREV_RESULTS);
                        num_prev_prev_result_div = num_prev_prev_result / 2; 
                        //LA_LB
                        for (int lalb_idx = accum_prev_level; lalb_idx < (accum_prev_level + num_prev_prev_result_div); lalb_idx++) begin
                            prev_result[current_idx++] = `RISCV_V_ZX(prev_result_mul_la_lb[lalb_idx], WIDTH);
                        end
                        //LA_HB
                        for (int lahb_idx = accum_prev_level; lahb_idx < (accum_prev_level + num_prev_prev_result_div); lahb_idx++) begin
                            prev_result[current_idx++] = `RISCV_V_ZX(prev_result_mul_la_hb[lahb_idx], WIDTH);
                        end
                        //HA_LB
                        for (int halb_idx = accum_prev_level; halb_idx < (accum_prev_level + num_prev_prev_result_div); halb_idx++) begin
                            prev_result[current_idx++] = `RISCV_V_ZX(prev_result_mul_ha_lb[halb_idx], WIDTH);
                        end
                        //HA_HB
                        for (int hahb_idx = accum_prev_level; hahb_idx < (accum_prev_level + num_prev_prev_result_div); hahb_idx++) begin
                            prev_result[current_idx++] = `RISCV_V_ZX(prev_result_mul_ha_hb[hahb_idx], WIDTH);
                        end
                        accum_prev_level += num_prev_prev_result_div;
                    end
                    
                    
                    //New previous results
                    for (int new_idx=0; new_idx < 4; new_idx++) begin
                        prev_result[current_idx++]  = mul[new_idx];
                    end

                end else begin
                

                    //Previous previous results
                    
                    for (int prev_level=MIN_MUL_LEVEL; prev_level < MUL_LEVEL; prev_level++) begin
                        num_prev_prev_result     = f_vedic_mul_num_prev_results_level_diff(MUL_LEVEL, prev_level-1, GET_MID_PREV_RESULTS);
                        num_prev_prev_result_div = num_prev_prev_result / 2;
                        //LA_LB
                        for (int lalb_idx = accum_prev_level; lalb_idx < (accum_prev_level + num_prev_prev_result_div); lalb_idx++) begin
                            prev_result[current_idx++] = `RISCV_V_ZX(prev_result_mul_la_lb[lalb_idx], WIDTH);
                        end
                        //HA_HB
                        for (int hahb_idx = accum_prev_level; hahb_idx < (accum_prev_level + num_prev_prev_result_div); hahb_idx++) begin
                            prev_result[current_idx++] = `RISCV_V_ZX(prev_result_mul_ha_hb[hahb_idx], WIDTH);
                        end
                        accum_prev_level += num_prev_prev_result_div;
                    end

                    //New previous results
                    
                    for (int new_idx=0; new_idx < 2; new_idx++) begin
                        prev_result[current_idx++]  = mul[new_idx*3];
                    end
                    
                end
            end

        end else begin
            assign prev_result[0] = 'Z;
        end


    end else begin  : gen_base_multiplier

        multiplier_2bit mul(
            .A(A),
            .B(B),
            .Z(Z)
        );

        if (VALID_PREV_RESULT) begin
            if (GET_MID_PREV_RESULTS) begin
                assign prev_result[0] = A[0] & B[0];       //la_lb
                assign prev_result[1] = A[0] & B[1];       //la_hb
                assign prev_result[2] = A[1] & B[0];       //ha_lb
                assign prev_result[3] = A[1] & B[1];       //ha_hb
            end else begin
                assign prev_result[0] = A[0] & B[0];       //la_lb
                assign prev_result[0] = A[1] & B[1];       //ha_hb
            end
        end else begin
            assign prev_result[0] = 'Z;
        end

    end
endgenerate

//Check Parameter
initial begin
    if (WIDTH%2) begin
        $fatal("WIDTH should be a power of 2, WIDTH:%0d", WIDTH);
    end
end

endmodule: vedic_mul_unsigned