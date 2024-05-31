//Branch prediction BHT
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 03/05/2022

module BHT_1bit#(
    parameter int IGNORED_PC_BITS = 2,              //LSB That are not taken in account to get the addres of the table
    parameter int PC_WIDTH = 32,
    parameter int NUM_ENTRIES = 8,
    //Localparameters
    parameter int IDX_WIDTH = $clog2(NUM_ENTRIES)
)(
    input  logic               clk,
    input  logic               rst_n,
    input  logic[PC_WIDTH-1:0] pc_sel,              //PC used to find the target        
    input  logic[PC_WIDTH-1:0] pc_update,           //PC used to update the target
    input  logic               update_en,            //When 1 update BHT
    input  logic               update_taken,        //Indicates if the branch was taken or not to update table
    output logic               taken_out            //Indicate if branch should be taken or not
);

logic BHT_table[NUM_ENTRIES];

logic[IDX_WIDTH-1:0] sel_idx;
logic[IDX_WIDTH-1:0] update_idx;

assign sel_idx    = pc_sel[IGNORED_PC_BITS +: IDX_WIDTH];
assign update_idx = pc_update[IGNORED_PC_BITS +: IDX_WIDTH];
//Tag is recorded in BTB


//Write BHT
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i=0; i<NUM_ENTRIES; i++) begin
            BHT_table[i] <= 1'b0;
        end
    end else if (update_en) begin
        BHT_table[update_idx] <= update_taken;
    end
end

//Read Table
assign taken_out = BHT_table[sel_idx];

endmodule: BHT_1bit