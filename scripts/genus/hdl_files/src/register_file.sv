//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 20/02/2022
//RISCV32 Register File

module register_file#(
    parameter int unsigned DATA_WIDTH           = 32,
    parameter int unsigned NUM_REGS             = 32,
    parameter bit          PROTECT_REG_ZERO     = 1,
    parameter bit          USE_SP_REG           = 1,
    parameter int unsigned SP_REG               = 2,
    parameter logic[DATA_WIDTH-1:0] SP_RST_VAL  = 32'hFFFFFFFF,
    parameter bit          CHECK_PARAM          = 1,
    parameter bit          ASYNC_READ           = 1,
    parameter bit          USE_BYPASS           = 1,                    //Only ASYNC read
    parameter bit          USE_POSEDGE          = 1,
    parameter int unsigned ADDR_WIDTH           = $clog2(NUM_REGS)
)(
    input  logic clk,
    input  logic rst_n,
    input  logic [DATA_WIDTH-1:0] wr_data,
    input  logic [ADDR_WIDTH-1:0] rd_addr1,
    input  logic [ADDR_WIDTH-1:0] rd_addr2,
    input  logic [ADDR_WIDTH-1:0] wr_addr,
    input  logic wr_en,
    output logic [DATA_WIDTH-1:0] rd_data1,
    output logic [DATA_WIDTH-1:0] rd_data2
);

    //Registers
    logic [DATA_WIDTH-1:0] regs[NUM_REGS];
    logic [DATA_WIDTH-1:0] regs_nxt[NUM_REGS];

    //Read Registers
    generate// read 
        if (ASYNC_READ) begin 
            //Asyncrhonus read
            if (USE_BYPASS) begin
                assign rd_data1 = (wr_addr == rd_addr1) ? wr_data : regs[rd_addr1];
                assign rd_data2 = (wr_addr == rd_addr2) ? wr_data : regs[rd_addr2];
            end else begin//NO BYPASS
                assign rd_data1 = regs[rd_addr1];
                assign rd_data2 = regs[rd_addr2];
            end
        end else begin 
            //Syncrhonous read
            always_ff @( posedge clk ) begin 
                rd_data1 <= regs[rd_addr1];
                rd_data2 <= regs[rd_addr2];
            end
        end 
    endgenerate
    
    //Write registers combinational path
    always_comb begin
        for (int i=0; i<NUM_REGS; i++) begin
            regs_nxt[i] = regs[i]; 
        end
        //Write register
        regs_nxt[wr_addr] = wr_data;
        if (PROTECT_REG_ZERO) begin 
            //Protect register 0
            regs_nxt[0] = '0;
        end        
    end

    //Write register flip flops
    generate
        if (USE_POSEDGE) begin
            always_ff @(posedge clk or negedge rst_n) begin : blockName
                if (~rst_n) begin
                    if (USE_SP_REG) begin
                        for (int i=0; i<SP_REG; i++) begin
                            regs[i] <= '0;
                        end
                        regs[SP_REG] <= SP_RST_VAL;
                        for (int i=SP_REG+1; i<NUM_REGS; i++) begin
                            regs[i] <= '0;
                        end
                    end else begin
                        for (int i=0; i<NUM_REGS; i++) begin
                            regs[i] <= '0;
                        end
                    end
                end else if (wr_en) begin
                    for (int i=0; i<NUM_REGS; i++) begin
                        regs[i] <= regs_nxt[i];
                    end
                end
            end
        end else begin //USE_NEGEDGE
            always_ff @(negedge clk or negedge rst_n) begin : blockName
                if (~rst_n) begin
                    if (USE_SP_REG) begin
                        for (int i=0; i<SP_REG; i++) begin
                            regs[i] <= '0;
                        end
                        regs[SP_REG] <= SP_RST_VAL;
                        for (int i=SP_REG+1; i<NUM_REGS; i++) begin
                            regs[i] <= '0;
                        end
                    end else begin
                        for (int i=0; i<NUM_REGS; i++) begin
                            regs[i] <= '0;
                        end
                    end
                end else if (wr_en) begin
                    for (int i=0; i<NUM_REGS; i++) begin
                        regs[i] <= regs_nxt[i];
                    end
                end
            end
        end

    endgenerate
    

endmodule: register_file
