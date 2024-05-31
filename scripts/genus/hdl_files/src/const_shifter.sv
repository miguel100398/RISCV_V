//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 12/03/2022
//Behavioral Constant Shifter

module const_shifter#(
    parameter int unsigned             WIDTH       = 32,
    parameter logic[$clog2(WIDTH)-1:0] SHIFT       = 1,
    parameter bit                      SHIFT_LEFT  = 1'b1,
    parameter bit                      ARITHMETIC  = 1'b1
) (
    input  logic[WIDTH-1:0] data_in,
    output logic[WIDTH-1:0] data_out
);

generate
    //Shift left
    if (SHIFT_LEFT) begin
        //Arithmetic
        if (ARITHMETIC) begin
            assign data_out = signed'(data_in) <<< SHIFT;
        end else begin //Logical
            assign data_out = data_in << SHIFT;
        end
    end else begin //Shift Right
        //Arithmetic
        if (ARITHMETIC) begin
            assign data_out = signed'(data_in) >>> SHIFT;
        end else begin //Logical
            assign data_out = data_in >> SHIFT;
        end
    end

endgenerate

endmodule: const_shifter