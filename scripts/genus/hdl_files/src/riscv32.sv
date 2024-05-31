//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 12/03/2022
//RISCV32 Top File

module riscv32
import riscv32_pkg::*,
       ALU_pkg::*;
#(
    parameter bit USE_BRANCH_PREDICTOR = 1'b1
)
(
    //Clock and reset
    input  logic clk,
    input  logic rst_n,
    //Memory
    output logic[RISCV32_ADDR_WIDTH-1:0] addr_out_instr,
    output logic[RISCV32_ADDR_WIDTH-1:0] addr_out_data,
    output logic[RISCV32_DATA_WIDTH-1:0] data_out_data,
    input  logic[RISCV32_DATA_WIDTH-1:0] data_in_instr,
    input  logic[RISCV32_DATA_WIDTH-1:0] data_in_data,
    output logic                         rd_en_data,
    output logic                         wr_en_data
);

////////////////////Instruction Fetch signals///////////////////////////////////////////////////////////
logic                           PCWrite_IF;
logic [RISCV32_DATA_WIDTH-1:0]  PC_IF;
logic [RISCV32_DATA_WIDTH-1:0]  next_PC_IF;
logic [RISCV32_DATA_WIDTH-1:0]  next_PC_branch_IF;
logic [RISCV32_DATA_WIDTH-1:0]  PC_add4_IF;
logic [RISCV32_DATA_WIDTH-1:0]  PC_prediction_IF;          //MUX out (pc+4 or pc_prediction_take)
logic [RISCV32_DATA_WIDTH-1:0]  PC_prediction_take_IF;     //Next from from branch prediction
if_id_t                         IF_ID_reg_IF;        //IF_ID register IF side
logic                           IF_ID_wr_en;
logic [RISCV32_DATA_WIDTH-1:0]  mux_pc_branch_in_IF[2];    //Mux to select between PC+4 or PC_branch
logic                           mux_pc_branch_sel_IF;
logic [RISCV32_DATA_WIDTH-1:0]  mux_pc_jump_in_IF[2];      //Mux to select bewteen PC+4/PC_branch or PC_jump
logic                           mux_pc_jump_sel_IF;
logic [RISCV32_DATA_WIDTH-1:0]  next_pc_branch_add4_IF;
logic [RISCV32_DATA_WIDTH-1:0]  mux_next_pc_branch_in_IF[2];
logic                           mux_next_pc_branch_sel_IF;
logic                           take_branch_pred_IF;
logic [RISCV32_DATA_WIDTH-1:0]  mux_pc_prediction_in_IF[2];
logic                           mux_pc_prediction_sel_IF;
logic                           branch_valid_ex_IF;
///////////////////////////////////Instruction Decode signals//////////////////////////////////////////////////
if_id_t                         IF_ID_reg_ID;       //IF_ID register ID side
r_type_instruction_t            r_instruction_ID;
logic[RISCV32_DATA_WIDTH-1:0]   instruction_ID;
instr_type_e                    instr_type_ID;
// Signals that need to be set to 0 when a hazard is detected
hazard_signals_t                hazard_signals_ID;
//Mux to set control signals to 0 when hazard is detected
logic[HAZARD_SIGNALS_WIDTH-1:0] mux_hazard_in_ID[2];
logic                           mux_hazard_sel_ID;
hazard_signals_t                mux_hazard_out_ID;
id_ex_t                         ID_EX_reg_ID;       //ID_EX_register ID side
//Register FIle
logic[RISCV32_DATA_WIDTH-1:0]  rf_wr_data_WB;
////////////////////////Instruction Execute signals/////////////////////////////////////////////////////////
id_ex_t                        ID_EX_reg_EX;       //ID_EX register EX side         
logic                          take_branch_EX;
logic [RISCV32_DATA_WIDTH-1:0] next_PC_branch_EX;
logic [RISCV32_DATA_WIDTH-1:0] next_PC_jump_EX;
logic jump_en_EX;
logic [RISCV32_DATA_WIDTH-1:0] ALU_result_EX;
logic [RISCV32_DATA_WIDTH-1:0] ALU_A_EX;
logic [RISCV32_DATA_WIDTH-1:0] ALU_B_EX;
logic [RISCV32_DATA_WIDTH-1:0] ALU_A_forward_EX;
logic [RISCV32_DATA_WIDTH-1:0] ALU_B_forward_EX;
ALU_ctrl_e                     ALU_op;
logic                          ALU_zero_EX;
logic [RISCV32_DATA_WIDTH-1:0] mux_ALU_A_in_EX[2];
logic [RISCV32_DATA_WIDTH-1:0] mux_ALU_B_in_EX[2];
logic [RISCV32_DATA_WIDTH-1:0] mux_ALU_A_forward_in_EX[4];
logic [RISCV32_DATA_WIDTH-1:0] mux_ALU_B_forward_in_EX[4];
logic [1:0]                    ForwardA_EX;
logic [1:0]                    ForwardB_EX;
logic                          mux_take_branch_in_EX[2];
ex_mem_t                       EX_MEM_reg_EX;        //EX_MEM register EX side
///////////////////////////////Memory Access signals///////////////////////////////////////////////////
ex_mem_t                       EX_MEM_reg_MEM;       //EX_MEM register MEM side
mem_wb_t                       MEM_WB_reg_MEM;       //MEM_WB register MEM side
//////////////////////////Write Back signals////////////////////////////////////////////////////////////
mem_wb_t                       MEM_WB_reg_WB;       //MEM_WB register WB side
logic[RISCV32_DATA_WIDTH-1:0]  mux_rf_wr_data_in_WB[4];



////////////////////////////////////Instruction Fetch/////////////////////////////////////////////////////////////

//Branch is valid in execute stage (i.e instructions was not flushed)
assign branch_valid_ex_IF = ID_EX_reg_EX.BNE || ID_EX_reg_EX.BEQ;

//PC register
register #(
    .WIDTH(RISCV32_DATA_WIDTH),
    .RST_VAL(RISCV32_PC_RST_VAL)
)pc_reg(
    .clk(clk),
    .rst_n(rst_n),
    .en(PCWrite_IF),
    .D(next_PC_IF),
    .Q(PC_IF)
);

//PC+4 adder
Adder #(
    .WIDTH(RISCV32_DATA_WIDTH)
) adder_pc4 (
    .c_in(1'b0),
    .A(PC_IF),
    .B(32'd4),
    .S(PC_add4_IF)
);


assign mux_next_pc_branch_in_IF[0] = next_PC_branch_EX;
assign mux_next_pc_branch_in_IF[1] = ID_EX_reg_EX.pc_add4;
assign mux_next_pc_branch_sel_IF   = ID_EX_reg_EX.take_branch_pred;                 //If branch was taken in branch prediction take pc+4(pc not taken) in case of error in prediction)
mux #(
    .NUM_ENTRIES(2),
    .WIDTH(RISCV32_DATA_WIDTH)
) mux_next_pc_branch(
    .d_in(mux_next_pc_branch_in_IF),
    .sel(mux_next_pc_branch_sel_IF),
    .d_out(next_PC_branch_IF)
);

assign mux_pc_prediction_in_IF[0] = PC_add4_IF;
assign mux_pc_prediction_in_IF[1] = PC_prediction_take_IF;
assign mux_pc_prediction_sel_IF   = take_branch_pred_IF && ~mux_hazard_sel_ID && ~ID_EX_reg_EX.jump_en;
mux #(
    .NUM_ENTRIES(2),
    .WIDTH(RISCV32_DATA_WIDTH)
) mux_pc_prediction(
    .d_in(mux_pc_prediction_in_IF),
    .sel(mux_pc_prediction_sel_IF),
    .d_out(PC_prediction_IF)
);

//PC muxes
assign mux_pc_branch_in_IF[0] = PC_prediction_IF;
assign mux_pc_branch_in_IF[1] = next_PC_branch_IF;
assign mux_pc_branch_sel_IF   = ((take_branch_EX != ID_EX_reg_EX.take_branch_pred) && branch_valid_ex_IF);      //Take branch_pc if mismatch in prediction
mux #(
    .NUM_ENTRIES(2),
    .WIDTH(RISCV32_DATA_WIDTH)
) mux_pc_branch(
    .d_in(mux_pc_branch_in_IF),
    .sel(mux_pc_branch_sel_IF),
    .d_out(next_pc_branch_add4_IF)
);

assign mux_pc_jump_in_IF[0] = next_pc_branch_add4_IF;
assign mux_pc_jump_in_IF[1] = next_PC_jump_EX;
assign mux_pc_jump_sel_IF   = jump_en_EX;
mux #(
    .NUM_ENTRIES(2),
    .WIDTH(RISCV32_DATA_WIDTH)
) mux_pc_jump(
    .d_in(mux_pc_jump_in_IF),
    .sel(mux_pc_jump_sel_IF),
    .d_out(next_PC_IF)
);


//Instruction memory
assign addr_out_instr = PC_IF;
assign IF_ID_reg_IF.instruction = data_in_instr;

assign IF_ID_reg_IF.pc_add4 = PC_add4_IF;
assign IF_ID_reg_IF.pc      = PC_IF;
assign IF_ID_reg_IF.take_branch_pred = take_branch_pred_IF && ~mux_hazard_sel_ID && ~ID_EX_reg_ID.jump_en;       

generate
    if (USE_BRANCH_PREDICTOR) begin
        
        branch_predictor_1bit #(
            .IGNORED_PC_BITS(2),
            .PC_WIDTH(RISCV32_DATA_WIDTH),
            .NUM_ENTRIES(8)
        )branch_pred(
            .clk(clk),
            .rst_n(rst_n),
            .pc_sel(PC_IF),
            .pc_update(ID_EX_reg_EX.pc),
            .wr_pc_target(branch_valid_ex_IF),
            .new_pc_target(next_PC_branch_EX),
            .update_taken(take_branch_EX),
            .pc_target(PC_prediction_take_IF),
            .take_target(take_branch_pred_IF)
        );

    end else begin
        assign take_branch_pred_IF = 1'b0;    //No prediction, always branch is not taken
    end
endgenerate

//IF/ID Register
if_id_reg if_id_pipe(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(IF_ID_wr_en),
    .data_in(IF_ID_reg_IF),
    .data_out(IF_ID_reg_ID)
);

////////////////////////////Instruction Decode/////////////////////////////////////////////////////////////////

assign r_instruction_ID = IF_ID_reg_ID.instruction;

//Hazard detection unit
hazard_detection_unit hazard_detection(
    .clk(clk),
    .rs1(r_instruction_ID.rs1),
    .rs2(r_instruction_ID.rs2),
    .rd(ID_EX_reg_EX.rd),
    .mem_read(ID_EX_reg_EX.MemRead),
    .ex_jump(ID_EX_reg_EX.jump_en),
    .fetch_take_branch(ID_EX_reg_EX.take_branch_pred),
    .ex_take_branch(take_branch_EX),
    .wr_pc(PCWrite_IF),
    .wr_if_id_reg(IF_ID_wr_en),
    .sel_mux_id_ex(mux_hazard_sel_ID)
);

//Control Unit
riscv32_control_unit control(
    .instruction(IF_ID_reg_ID.instruction),
    .BNE(hazard_signals_ID.BNE),
    .BEQ(hazard_signals_ID.BEQ),
    .MemRead(hazard_signals_ID.MemRead),
    .MemWrite(hazard_signals_ID.MemWrite),
    .MemtoReg(ID_EX_reg_ID.MemtoReg),
    .riscv_alu_op(ID_EX_reg_ID.riscv_alu_op),
    .ALUsrcA(ID_EX_reg_ID.ALUsrcA),
    .ALUsrcB(ID_EX_reg_ID.ALUsrcB),
    .RegWrite(hazard_signals_ID.RegWrite),
    .instr_type(instr_type_ID),
    .jump_en(hazard_signals_ID.jump_en)
);

assign hazard_signals_ID.take_branch_pred = IF_ID_reg_ID.take_branch_pred;

//Hazard mux
assign mux_hazard_in_ID[0] = hazard_signals_ID;
assign mux_hazard_in_ID[1] = 'h0;
mux #(
    .NUM_ENTRIES(2),
    .WIDTH(HAZARD_SIGNALS_WIDTH)
) mux_hazard(
    .d_in(mux_hazard_in_ID),
    .sel(mux_hazard_sel_ID),
    .d_out(mux_hazard_out_ID)
);
//Assign hazard signals
assign ID_EX_reg_ID.BNE      = mux_hazard_out_ID.BNE;
assign ID_EX_reg_ID.BEQ      = mux_hazard_out_ID.BEQ;
assign ID_EX_reg_ID.MemRead  = mux_hazard_out_ID.MemRead;
assign ID_EX_reg_ID.MemWrite = mux_hazard_out_ID.MemWrite;
assign ID_EX_reg_ID.RegWrite = mux_hazard_out_ID.RegWrite;
assign ID_EX_reg_ID.jump_en  = mux_hazard_out_ID.jump_en;
assign ID_EX_reg_ID.take_branch_pred = mux_hazard_out_ID.take_branch_pred;

//Registe File
register_file #(
    .DATA_WIDTH(RISCV32_DATA_WIDTH),
    .NUM_REGS(RISCV32_NUM_REGS_RF),
    .PROTECT_REG_ZERO(1'b1),
    .USE_SP_REG(1'b1),
    .SP_REG(RISCV32_SP_REG),
    .SP_RST_VAL(RISCV32_SP_RST_VAL),
    .CHECK_PARAM(1'b1),
    .ASYNC_READ(1'b1),
    .USE_POSEDGE(1'b0),
    .USE_BYPASS(1'b0)
) rf(
    .clk(clk),
    .rst_n(rst_n),
    .wr_data(rf_wr_data_WB),
    .rd_addr1(r_instruction_ID.rs1),
    .rd_addr2(r_instruction_ID.rs2),
    .wr_addr(MEM_WB_reg_WB.rd),
    .wr_en(MEM_WB_reg_WB.RegWrite),
    .rd_data1(ID_EX_reg_ID.rd_reg1),
    .rd_data2(ID_EX_reg_ID.rd_reg2)
);

//Imm generator
riscv32_imm_gen imm_gen(
    .instruction(IF_ID_reg_ID.instruction),
    .instr_type(instr_type_ID),
    .immediate(ID_EX_reg_ID.immediate)
);

//Asiign signals to pipe mux
assign ID_EX_reg_ID.rs1              = r_instruction_ID.rs1;
assign ID_EX_reg_ID.rs2              = r_instruction_ID.rs2;
assign ID_EX_reg_ID.rd               = r_instruction_ID.rd;
assign ID_EX_reg_ID.pc_add4          = IF_ID_reg_ID.pc_add4;
assign ID_EX_reg_ID.funct3           = r_instruction_ID.funct3;
assign ID_EX_reg_ID.funct7           = r_instruction_ID.funct7;
assign ID_EX_reg_ID.pc               = IF_ID_reg_ID.pc;

//Pipe register
id_ex_reg id_ex_pipe(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(ID_EX_reg_ID),
    .data_out(ID_EX_reg_EX)
);

//////////////////////////////////////////////////////////////////Instruction Execute////////////////////////////////////////////////////////////////////////////////

//ALU
ALU_ctrl ALU_ctrl_i(
    .riscv_alu_op(ID_EX_reg_EX.riscv_alu_op),
    .funct_7(ID_EX_reg_EX.funct7),
    .funct_3(ID_EX_reg_EX.funct3),
    .ALU_op(ALU_op)
);

ALU #(
    .LENGTH(RISCV32_DATA_WIDTH),
    .REG_INPUTS(1'b0),
    .REG_OUTPUTS(1'b0),
    .CHECK_PARAM(1'b1)
) ALU_i(
    .clk(clk),
    .rst_n(rst_n),
    .en(1'b1),
    .A(ALU_A_EX),
    .B(ALU_B_EX),
    .ctrl(ALU_op),
    .Result(ALU_result_EX),
    .zero_f(ALU_zero_EX)
);

//Muxes ALU in
assign mux_ALU_A_in_EX[0] = ALU_A_forward_EX;
assign mux_ALU_A_in_EX[1] = ID_EX_reg_EX.pc;
mux #(
    .NUM_ENTRIES(2),
    .WIDTH(RISCV32_DATA_WIDTH)
) mux_ALU_A (
    .d_in(mux_ALU_A_in_EX),
    .sel(ID_EX_reg_EX.ALUsrcA),
    .d_out(ALU_A_EX)
);

assign mux_ALU_B_in_EX[0] = ALU_B_forward_EX;
assign mux_ALU_B_in_EX[1] = ID_EX_reg_EX.immediate;
mux #(
    .NUM_ENTRIES(2),
    .WIDTH(RISCV32_DATA_WIDTH)
) mux_ALU_B(
    .d_in(mux_ALU_B_in_EX),
    .sel(ID_EX_reg_EX.ALUsrcB),
    .d_out(ALU_B_EX)
);

//Forward muxes
assign mux_ALU_A_forward_in_EX[0] = ID_EX_reg_EX.rd_reg1;
assign mux_ALU_A_forward_in_EX[1] = EX_MEM_reg_MEM.ALU_result;
assign mux_ALU_A_forward_in_EX[2] = rf_wr_data_WB;
assign mux_ALU_A_forward_in_EX[3] = 32'h0;
mux #(
    .NUM_ENTRIES(4),
    .WIDTH(RISCV32_DATA_WIDTH)
) mux_forward_A(
    .d_in(mux_ALU_A_forward_in_EX),
    .sel(ForwardA_EX),
    .d_out(ALU_A_forward_EX)
);
assign mux_ALU_B_forward_in_EX[0] = ID_EX_reg_EX.rd_reg2;
assign mux_ALU_B_forward_in_EX[1] = EX_MEM_reg_MEM.ALU_result;
assign mux_ALU_B_forward_in_EX[2] = rf_wr_data_WB;
assign mux_ALU_B_forward_in_EX[3] = 32'h0;
mux #(
    .NUM_ENTRIES(4),
    .WIDTH(RISCV32_DATA_WIDTH)
) mux_forward_B(
    .d_in(mux_ALU_B_forward_in_EX),
    .sel(ForwardB_EX),
    .d_out(ALU_B_forward_EX)
);

//Forwarding unit
forwarding_unit forward(
    .rs1(ID_EX_reg_EX.rs1),
    .rs2(ID_EX_reg_EX.rs2),
    .rd_mem(EX_MEM_reg_MEM.rd),
    .rd_wb(MEM_WB_reg_WB.rd),
    .RegWrite_mem(EX_MEM_reg_MEM.RegWrite),
    .RegWrite_wb(MEM_WB_reg_WB.RegWrite),
    .ForwardA(ForwardA_EX),
    .ForwardB(ForwardB_EX)
);

//Adder branch
Adder #(
    .WIDTH(RISCV32_DATA_WIDTH)
) adder_branch(
    .c_in(1'b0),
    .A(ID_EX_reg_EX.pc),
    .B(ID_EX_reg_EX.immediate),
    .S(next_PC_branch_EX)
);


//PC jump
assign next_PC_jump_EX = ALU_result_EX;
assign jump_en_EX      = ID_EX_reg_EX.jump_en;

//Mux take_branch
assign mux_take_branch_in_EX[0] = ID_EX_reg_EX.BNE;
assign mux_take_branch_in_EX[1] = ID_EX_reg_EX.BEQ;
mux #(
    .NUM_ENTRIES(2),
    .WIDTH(1'b1)
) mux_take_branch (
    .d_in(mux_take_branch_in_EX),
    .sel(ALU_zero_EX),
    .d_out(take_branch_EX)
);

//EX/MEM register
assign EX_MEM_reg_EX.RegWrite   = ID_EX_reg_EX.RegWrite;
assign EX_MEM_reg_EX.MemRead    = ID_EX_reg_EX.MemRead;
assign EX_MEM_reg_EX.MemWrite   = ID_EX_reg_EX.MemWrite;
assign EX_MEM_reg_EX.MemtoReg   = ID_EX_reg_EX.MemtoReg;
assign EX_MEM_reg_EX.rd         = ID_EX_reg_EX.rd;
assign EX_MEM_reg_EX.ALU_result = ALU_result_EX;
assign EX_MEM_reg_EX.rd_reg2    = ALU_B_forward_EX;
assign EX_MEM_reg_EX.pc_add4    = ID_EX_reg_EX.pc_add4;

//Pipe register
ex_mem_reg ex_mem_pipe(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(EX_MEM_reg_EX),
    .data_out(EX_MEM_reg_MEM)
);

////////////////////////////////////////////////////////////////////////////////////////Memory Access///////////////////////////////////////////////////////////////////////

//Data Memory
assign addr_out_data = EX_MEM_reg_MEM.ALU_result;
assign data_out_data = EX_MEM_reg_MEM.rd_reg2;
assign rd_en_data    = EX_MEM_reg_MEM.MemRead;
assign wr_en_data    = EX_MEM_reg_MEM.MemWrite;

//MEM/WB register
assign MEM_WB_reg_MEM.RegWrite   = EX_MEM_reg_MEM.RegWrite;
assign MEM_WB_reg_MEM.MemtoReg   = EX_MEM_reg_MEM.MemtoReg;
assign MEM_WB_reg_MEM.rd         = EX_MEM_reg_MEM.rd;
assign MEM_WB_reg_MEM.ALU_result = EX_MEM_reg_MEM.ALU_result;
assign MEM_WB_reg_MEM.data_mem   = data_in_data;
assign MEM_WB_reg_MEM.pc_add4    = EX_MEM_reg_MEM.pc_add4;
//Pipe register
mem_wb_reg mem_wb_pipe(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(MEM_WB_reg_MEM),
    .data_out(MEM_WB_reg_WB)
);

///////////////////////////////////////////////////////////////////////////////////Write Back///////////////////////////////////////////////////////////////////////////

//Mux wr data register file
assign mux_rf_wr_data_in_WB[0] = MEM_WB_reg_WB.ALU_result;
assign mux_rf_wr_data_in_WB[1] = MEM_WB_reg_WB.data_mem;
assign mux_rf_wr_data_in_WB[2] = MEM_WB_reg_WB.pc_add4;
assign mux_rf_wr_data_in_WB[3] = 32'h0;
mux #(
    .NUM_ENTRIES(4),
    .WIDTH(RISCV32_DATA_WIDTH)
) mux_wr_data_rf(
    .d_in(mux_rf_wr_data_in_WB),
    .sel(MEM_WB_reg_WB.MemtoReg),
    .d_out(rf_wr_data_WB)
);

endmodule: riscv32