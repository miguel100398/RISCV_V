//Description: riscv_multi_cycle_gpio top file
//Author: Miguel Bucio miguel_angel_bucio@hotmail.com
//Date: 3/13/2022

module RISC_V_pipeline
import riscv32_pkg::*,
       UART_pkg::*,
	   UART_csr_pkg::*;
#(
    parameter bit USE_BRANCH_PREDICTOR = 1'b1
)
(
    inout VDD1,
    inout VDD2,
    inout VSS1,
    inout VSS2,
    inout VSS3,
    inout VDDIOR,
    inout VSSIOR,
    //Inputs
    input  logic clk_pad,                       //50Mhz clk
    input  logic reset_pad,                     //KEY[0]
    // Output 
    output logic [7:0] gpio_port_out_pad,       //LED{7:0]
    input  logic [7:0] gpio_port_in_pad,         //SW[7:0]
    //clk 1hz
    //output logic clk_1hz                    //LED[8]
    //UART signals
    input  logic uart_rx_pad,
    output logic uart_tx_pad
);

logic rst_n;

logic clk;
logic reset;
logic [7:0] gpio_port_out;
logic [7:0] gpio_port_in;
logic uart_rx;
logic uart_tx;

//Input pads
PADDI pad_clk  (.PAD(clk_pad),  .Y(clk));
PADDI pad_reset (.PAD(reset_pad), .Y(reset));
PADDI pad_gpio_port_in_0 (.PAD(gpio_port_in_pad[0]), .Y(gpio_port_in[0]));
PADDI pad_gpio_port_in_1 (.PAD(gpio_port_in_pad[1]), .Y(gpio_port_in[1]));
PADDI pad_gpio_port_in_2 (.PAD(gpio_port_in_pad[2]), .Y(gpio_port_in[2]));
PADDI pad_gpio_port_in_3 (.PAD(gpio_port_in_pad[3]), .Y(gpio_port_in[3]));
PADDI pad_gpio_port_in_4 (.PAD(gpio_port_in_pad[4]), .Y(gpio_port_in[4]));
PADDI pad_gpio_port_in_5 (.PAD(gpio_port_in_pad[5]), .Y(gpio_port_in[5]));
PADDI pad_gpio_port_in_6 (.PAD(gpio_port_in_pad[6]), .Y(gpio_port_in[6]));
PADDI pad_gpio_port_in_7 (.PAD(gpio_port_in_pad[7]), .Y(gpio_port_in[7]));
PADDI pad_uart_rx (.PAD(uart_rx_pad), .Y(uart_rx));
//Output pads
PADDO pad_gpio_port_out_0 (.PAD(gpio_port_out_pad[0]), .A(gpio_port_out[0]));
PADDO pad_gpio_port_out_1 (.PAD(gpio_port_out_pad[1]), .A(gpio_port_out[1]));
PADDO pad_gpio_port_out_2 (.PAD(gpio_port_out_pad[2]), .A(gpio_port_out[2]));
PADDO pad_gpio_port_out_3 (.PAD(gpio_port_out_pad[3]), .A(gpio_port_out[3]));
PADDO pad_gpio_port_out_4 (.PAD(gpio_port_out_pad[4]), .A(gpio_port_out[4]));
PADDO pad_gpio_port_out_5 (.PAD(gpio_port_out_pad[5]), .A(gpio_port_out[5]));
PADDO pad_gpio_port_out_6 (.PAD(gpio_port_out_pad[6]), .A(gpio_port_out[6]));
PADDO pad_gpio_port_out_7 (.PAD(gpio_port_out_pad[7]), .A(gpio_port_out[7]));
PADDO pad_uart_tx (.PAD(uart_tx_pad), .A(uart_tx));

// CORE POWER PADS

//PADVDD: Bond Pad for Digital Power
PADVDD pad_vdd_i1 ( .VDD(VDD1) );
PADVDD pad_vdd_i2 ( .VDD(VDD2) );

//PADVSS: Bond Pad for Digital Ground 
PADVSS pad_vss_i1 ( .VSS(VSS1) );
PADVSS pad_vss_i2 ( .VSS(VSS2) );
PADVSS pad_vss_i3 ( .VSS(VSS3) );


// I/O Frame POWER PADS
// PADVDDIOR: Bond Pad for IO Ring Power 
PADVDDIOR pad_vdd_ior ( .VDDIOR(VDDIOR) );

// PADVSSIOR: A Bond Pad for IO Ring ground.
PADVSSIOR pad_vss_ior ( .VSSIOR(VSSIOR) );

// CORNER PADS: This cell provides I/O-cell and power-distribution continuity around a chip corner.
padIORINGCORNER ne_padIORINGCORNER ();
padIORINGCORNER nw_padIORINGCORNER ();
padIORINGCORNER se_padIORINGCORNER ();
padIORINGCORNER sw_padIORINGCORNER ();

assign rst_n = reset;

logic[RISCV32_ADDR_WIDTH-1:0] riscv_instr_addr;
logic[RISCV32_ADDR_WIDTH-1:0] riscv_data_addr;
logic[RISCV32_DATA_WIDTH-1:0] riscv_data_out;
logic[RISCV32_DATA_WIDTH-1:0] riscv_data_in_instr;
logic[RISCV32_DATA_WIDTH-1:0] riscv_data_in_data;
logic                         riscv_rd_en;
logic                         riscv_wr_en;

logic[RISCV32_ADDR_WIDTH-1:0] instr_mem_addr;
logic[RISCV32_ADDR_WIDTH-1:0] data_mem_addr;
logic[RISCV32_ADDR_WIDTH-1:0] gpio_addr;
uart_csr_addr_t               uart_addr;
logic[RISCV32_DATA_WIDTH-1:0] instr_mem_data_in;
logic[RISCV32_DATA_WIDTH-1:0] instr_mem_data_out;
logic[RISCV32_DATA_WIDTH-1:0] data_mem_data_in;
logic[RISCV32_DATA_WIDTH-1:0] data_mem_data_out;
logic[7:0]                    gpio_data_in;
logic[7:0]                    gpio_data_out;
uart_csr_data_t               uart_data_in;
uart_csr_data_t               uart_data_out;
logic                         instr_mem_wr_en;
logic                         data_mem_wr_en;
logic                         gpio_wr_en;
logic                         uart_wr_en;
logic                         uart_rd_en;

//Clock divider
/*
clk_divider #(
    .FREQ_IN(50e6),
    .FREQ_OUT(1)
)clk_divider_i(
    .clk(clk),
    .rst_n(rst_n),
    .clk_div(clk_1hz)
);
*/

riscv32 #(
    .USE_BRANCH_PREDICTOR(USE_BRANCH_PREDICTOR)
)riscv(
    .clk(clk),
    .rst_n(rst_n),
    .addr_out_instr(riscv_instr_addr),
    .addr_out_data(riscv_data_addr),
    .data_out_data(riscv_data_out),
    .data_in_instr(riscv_data_in_instr),
    .data_in_data(riscv_data_in_data),
    .rd_en_data(riscv_rd_en),
    .wr_en_data(riscv_wr_en)
);


//Memory controller
mem_ctrl mem_ctrl0(
    .wr_en(riscv_wr_en),
    .rd_en(riscv_rd_en),
    .addr_instr(riscv_instr_addr),
    .addr_data(riscv_data_addr),
    .data_in(riscv_data_out),
    .data_out_instr(riscv_data_in_instr),
    .data_out_data(riscv_data_in_data),
    .instr_mem_addr(instr_mem_addr),
    .data_mem_addr(data_mem_addr),
    .gpio_addr(gpio_addr),
    .uart_addr(uart_addr),
    .instr_mem_wr_en(instr_mem_wr_en),
    .data_mem_wr_en(data_mem_wr_en),
    .gpio_wr_en(gpio_wr_en),
    .uart_wr_en(uart_wr_en),
    .instr_mem_data_in(instr_mem_data_in),
    .instr_mem_data_out(instr_mem_data_out),
    .data_mem_data_in(data_mem_data_in),
    .data_mem_data_out(data_mem_data_out),
    .gpio_data_in(gpio_data_in),
    .gpio_data_out(gpio_data_out),
    .uart_data_in(uart_data_in),
    .uart_data_out(uart_data_out),
    .uart_rd_en(uart_rd_en)
);

//GPIO
GPIO gpio_i(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(gpio_wr_en),
    .data_in(gpio_data_in),
    .data_out(gpio_data_out),
    .addr(gpio_addr),
    .gpio_port_in_data(gpio_port_in),
    .gpio_port_out_data(gpio_port_out)
);
//Instruction memory
ROM #(
    .DATA_WIDTH(RISCV32_DATA_WIDTH),
    .ADDR_WIDTH(12)
)instr_mem(
    .clk(clk),
    .addr(instr_mem_addr[11:0]),
    .data_o(instr_mem_data_out)
);

//Data memory
RAM #(
    .DATA_WIDTH(RISCV32_DATA_WIDTH),
    .ADDR_WIDTH(8)
) data_mem(
    .clk(clk),
    .addr(data_mem_addr[7:0]),
    .wr_data(data_mem_data_in),
    .wr_en(data_mem_wr_en),
    .rd_data(data_mem_data_out)
);

//UART
UART uart0(
    .clk(clk),
    .rst_n(rst_n),
    .csr_wr_addr(uart_addr),
    .csr_wr_data(uart_data_in),
    .csr_wen(uart_wr_en),
    .csr_rd_addr(uart_addr),
    .csr_ren(uart_rd_en),
    .csr_rd_data(uart_data_out),
    .tx(uart_tx),
    .rx(uart_rx)
);

endmodule: RISC_V_pipeline
