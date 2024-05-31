//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 12/03/2022
//Parametrizable mux


module mux#(
    parameter int unsigned NUM_ENTRIES = 2,
    parameter int unsigned WIDTH       = 8,
    parameter int unsigned SEL_WIDTH   = $clog2(NUM_ENTRIES)
)(
    input  logic[WIDTH-1:0]     d_in[NUM_ENTRIES],
    input  logic[SEL_WIDTH-1:0] sel,
    output logic[WIDTH-1:0]     d_out
);

    assign d_out = d_in[sel];

endmodule: mux