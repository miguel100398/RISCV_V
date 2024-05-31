//Branch predictor
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 03/05/2022

module branch_predictor_1bit#(
    parameter int IGNORED_PC_BITS = 2,              //LSB That are not taken in account to get the addres of the table
    parameter int PC_WIDTH = 32,
    parameter int NUM_ENTRIES = 8
)(
    input  logic               clk,
    input  logic               rst_n,
    input  logic[PC_WIDTH-1:0] pc_sel,              //PC used to find the target        
    input  logic[PC_WIDTH-1:0] pc_update,           //PC used to update the target
    input  logic               wr_pc_target,        //When 1 update target
    input  logic[PC_WIDTH-1:0] new_pc_target,       //Target to be updated
    input  logic               update_taken,        //Indicates if the branch was taken or not to update table
    output logic[PC_WIDTH-1:0] pc_target,           //Output target
    output logic               take_target          //When 1 indicates that the PC should take po_target instead of PC+4
);

logic target_valid;
logic taken;

assign take_target  = (target_valid && taken);

BTB#(
    .IGNORED_PC_BITS(IGNORED_PC_BITS),
    .PC_WIDTH(PC_WIDTH),
    .NUM_ENTRIES(NUM_ENTRIES)
) BTB_i(
    .clk(clk),
    .rst_n(rst_n),
    .pc_sel(pc_sel),
    .pc_update(pc_update),
    .wr_pc_target(wr_pc_target),
    .new_pc_target(new_pc_target),
    .pc_target(pc_target),
    .target_valid(target_valid)
);

BHT_1bit #(
    .IGNORED_PC_BITS(IGNORED_PC_BITS),
    .PC_WIDTH(PC_WIDTH),
    .NUM_ENTRIES(NUM_ENTRIES)
) BHT_i(
    .clk(clk),
    .rst_n(rst_n),
    .pc_sel(pc_sel),
    .pc_update(pc_update),
    .update_en(wr_pc_target),
    .update_taken(update_taken),
    .taken_out(taken)
);

endmodule: branch_predictor_1bit