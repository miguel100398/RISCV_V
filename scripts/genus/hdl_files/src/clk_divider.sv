//Description: clock divider
//Author: Miguel Bucio miguel_angel_bucio@hotmail.com
//Date: 3/13/2022

module clk_divider#(
    parameter int unsigned FREQ_IN  = 50e6,
    parameter int unsigned FREQ_OUT = 1
)(
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

localparam MAX_COUNT = ((1/FREQ_OUT)*FREQ_IN)/2;
localparam CNTR_WIDTH = $clog2(MAX_COUNT);

logic[CNTR_WIDTH-1:0] cntr;
logic cntr_done;

assign cntr_done = cntr == MAX_COUNT;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cntr <= 'h0;
    end else if (cntr_done) begin
        cntr <= 'h0;
    end else begin
        cntr <= cntr + 1'b1;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else if (cntr_done) begin
        clk_div <= ~clk_div;
    end
end

endmodule: clk_divider