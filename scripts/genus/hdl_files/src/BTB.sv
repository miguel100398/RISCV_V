//Branch prediction BTB
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 03/05/2022

module BTB#(
    parameter int IGNORED_PC_BITS = 2,              //LSB That are not taken in account to get the addres of the table
    parameter int PC_WIDTH = 32,
    parameter int NUM_ENTRIES = 8,
    //Localparameters
    parameter int IDX_WIDTH = $clog2(NUM_ENTRIES),
    parameter int TAG_WIDTH = PC_WIDTH-IGNORED_PC_BITS-IDX_WIDTH
)(
    input  logic               clk,
    input  logic               rst_n,
    input  logic[PC_WIDTH-1:0] pc_sel,              //PC used to find the target        
    input  logic[PC_WIDTH-1:0] pc_update,           //PC used to update the target
    input  logic               wr_pc_target,        //When 1 update target
    input  logic[PC_WIDTH-1:0] new_pc_target,       //Target to be updated
    output logic[PC_WIDTH-1:0] pc_target,           //Output target
    output logic               target_valid         //When 1 indicates that the output target matches pc_sel
);

typedef struct packed {
    logic[TAG_WIDTH-1:0] tag;
    logic[PC_WIDTH-1:0]  target;
    logic                valid;
} BTB_entry_t;

BTB_entry_t BTB_table[NUM_ENTRIES];

logic[IDX_WIDTH-1:0] sel_idx;
logic[IDX_WIDTH-1:0] update_idx;

logic[TAG_WIDTH-1:0] sel_tag;
logic[TAG_WIDTH-1:0] update_tag;

assign sel_idx    = pc_sel[IGNORED_PC_BITS +: IDX_WIDTH];
assign update_idx = pc_update[IGNORED_PC_BITS +: IDX_WIDTH];

assign sel_tag    = pc_sel[(IGNORED_PC_BITS+IDX_WIDTH) +: TAG_WIDTH];
assign update_tag = pc_update[(IGNORED_PC_BITS+IDX_WIDTH) +: TAG_WIDTH];

//Write table
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i=0; i<NUM_ENTRIES; i++) begin
            BTB_table[i].valid <= 1'b0;
        end
    end else if (wr_pc_target) begin
        BTB_table[update_idx].tag    <= update_tag;
        BTB_table[update_idx].target <= new_pc_target;
        BTB_table[update_idx].valid  <= 1'b1;
    end
end

//Read table
assign pc_target    = BTB_table[sel_idx].target;
assign target_valid = ((BTB_table[sel_idx].tag == sel_tag) && BTB_table[sel_idx].valid);

endmodule: BTB