module vedic_mul_unsigned_128bits(
    input wire [127:0] A,
    input wire [127:0] B,
    output wire [255:0] Z,
    output wire [3839:0] prev_result //[127:0][29:0]
);

localparam WIDTH = 128;
localparam HALF_WIDTH = WIDTH/2;
localparam RESULT_WIDTH = WIDTH*2;

///Sources
wire [HALF_WIDTH-1:0] A_l;
wire [HALF_WIDTH-1:0] A_h;
wire [HALF_WIDTH-1:0] B_l;
wire [HALF_WIDTH-1:0] B_h;
//Multipliers
wire [WIDTH-1:0] mul[3:0];

//Low adder
wire [WIDTH-1:0] srcA_low_adder;
wire [WIDTH-1:0] srcB_low_adder;
wire [WIDTH-1:0] result_low_adder;
wire       cin_low_adder;
wire       cout_low_adder;

//Mid adder
wire [WIDTH-1:0] srcA_mid_adder;
wire [WIDTH-1:0] srcB_mid_adder;
wire [WIDTH-1:0] result_mid_adder;
wire             cin_mid_adder;
wire             cout_mid_adder;

        //High adder
wire [WIDTH-1:0] srcA_high_adder;
wire [WIDTH-1:0] srcB_high_adder;
wire [WIDTH-1:0] result_high_adder;
wire             cin_high_adder;
wire             cout_high_adder;

//Or Gate
wire or_carry;

//Previous result
wire [895:0] prev_result_mul_la_lb;
wire [895:0] prev_result_mul_ha_hb;

//Divide sources in low and high part
assign A_l = A[0       +: HALF_WIDTH];
assign A_h = A[WIDTH-1 -: HALF_WIDTH];

assign B_l = B[0       +: HALF_WIDTH];
assign B_h = B[WIDTH-1 -: HALF_WIDTH];

//Instantiate multipliers
        vedic_mul_unsigned_64bits mul_la_lb(
            .A(A_l),
            .B(B_l),
            .Z(mul[0]),
            .prev_result(prev_result_mul_la_lb)
        );

        vedic_mul_unsigned_64bits mul_la_hb(
            .A(A_l),
            .B(B_h),
            .Z(mul[1]),
            .prev_result()
        );

        vedic_mul_unsigned_64bits mul_ha_lb(
            .A(A_h),
            .B(B_l),
            .Z(mul[2]),
            .prev_result()
        );

        vedic_mul_unsigned_64bits mul_ha_hb(
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
            .RIPPLE_CARRY(1'b1),
            .BEHAVIORAL(1'b0)
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
            .RIPPLE_CARRY(1'b1),
            .BEHAVIORAL(1'b0)
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
            .RIPPLE_CARRY(1'b1),
            .BEHAVIORAL(1'b0)
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

        //Prev results
        assign prev_result[0*128 +: 128]  = {64'b0, prev_result_mul_la_lb[0*64 +: 64]}; 
        assign prev_result[1*128 +: 128]  = {64'b0, prev_result_mul_la_lb[1*64 +: 64]};
        assign prev_result[2*128 +: 128]  = {64'b0, prev_result_mul_la_lb[2*64 +: 64]};
        assign prev_result[3*128 +: 128]  = {64'b0, prev_result_mul_la_lb[3*64 +: 64]};
        assign prev_result[4*128 +: 128]  = {64'b0, prev_result_mul_la_lb[4*64 +: 64]};
        assign prev_result[5*128 +: 128]  = {64'b0, prev_result_mul_la_lb[5*64 +: 64]};
        assign prev_result[6*128 +: 128]  = {64'b0, prev_result_mul_la_lb[6*64 +: 64]};
        assign prev_result[7*128 +: 128]  = {64'b0, prev_result_mul_la_lb[7*64 +: 64]};
        assign prev_result[8*128 +: 128]  = {64'b0, prev_result_mul_la_lb[8*64 +: 64]};
        assign prev_result[9*128 +: 128]  = {64'b0, prev_result_mul_la_lb[9*64 +: 64]};
        assign prev_result[10*128 +: 128]  = {64'b0, prev_result_mul_la_lb[10*64 +: 64]};
        assign prev_result[11*128 +: 128]  = {64'b0, prev_result_mul_la_lb[11*64 +: 64]};
        assign prev_result[12*128 +: 128]  = {64'b0, prev_result_mul_la_lb[12*64 +: 64]};
        assign prev_result[13*128 +: 128]  = {64'b0, prev_result_mul_la_lb[13*64 +: 64]};

        assign prev_result[14*128 +: 128]  = {64'b0, prev_result_mul_ha_hb[0*64 +: 64]};
        assign prev_result[15*128 +: 128]  = {64'b0, prev_result_mul_ha_hb[1*64 +: 64]};
        assign prev_result[16*128 +: 128]  = {64'b0, prev_result_mul_ha_hb[2*64 +: 64]};
        assign prev_result[17*128 +: 128]  = {64'b0, prev_result_mul_ha_hb[3*64 +: 64]};
        assign prev_result[18*128 +: 128] = {64'b0, prev_result_mul_ha_hb[4*64 +: 64]};
        assign prev_result[19*128 +: 128] = {64'b0, prev_result_mul_ha_hb[5*64 +: 64]};
        assign prev_result[20*128 +: 128] = {64'b0, prev_result_mul_ha_hb[6*64 +: 64]};
        assign prev_result[21*128 +: 128] = {64'b0, prev_result_mul_ha_hb[7*64 +: 64]};
        assign prev_result[22*128 +: 128] = {64'b0, prev_result_mul_ha_hb[8*64 +: 64]};
        assign prev_result[23*128 +: 128] = {64'b0, prev_result_mul_ha_hb[9*64 +: 64]};
        assign prev_result[24*128 +: 128] = {64'b0, prev_result_mul_ha_hb[10*64 +: 640]};
        assign prev_result[25*128 +: 128] = {64'b0, prev_result_mul_ha_hb[11*64 +: 64]};
        assign prev_result[26*128 +: 128] = {64'b0, prev_result_mul_ha_hb[12*64 +: 64]};
        assign prev_result[27*128 +: 128] = {64'b0, prev_result_mul_ha_hb[13*64 +: 64]};

        assign prev_result[28*128 +: 128] = mul[0];
        assign prev_result[29*128 +: 128] = mul[3];

endmodule 