//Description: Mem controller
//Author: Miguel Bucio miguel_angel_bucio@hotmail.com
//Date: 3/13/2022

module mem_ctrl
import mem_ctrl_pkg::*,
       UART_pkg::*,
	   UART_csr_pkg::*;
(
    input  logic wr_en,
    input  logic rd_en,
    input  logic [31:0] data_in,
    input  logic [31:0] addr_instr,
    input  logic [31:0] addr_data,
    output logic [31:0] data_out_instr,
    output logic [31:0] data_out_data,
    //Peripheral signals
    output logic [31:0] instr_mem_addr,
    output logic [31:0] data_mem_addr,
    output logic [31:0] gpio_addr,
    output uart_csr_addr_t uart_addr,
    output logic        instr_mem_wr_en,
    output logic        data_mem_wr_en,
    output logic        gpio_wr_en,
    output logic        uart_wr_en,
    output logic [31:0] instr_mem_data_in,
    output logic [31:0] data_mem_data_in,
    output logic [7:0]  gpio_data_in,
    input logic [31:0] instr_mem_data_out,
    input logic [31:0] data_mem_data_out,
    input logic [7:0]  gpio_data_out,
    output uart_csr_data_t uart_data_in,
    input uart_csr_data_t uart_data_out,
    output logic        uart_rd_en
);

logic instr_mem_sel;
logic data_mem_sel;
logic gpio_sel;
logic uart_sel;

assign instr_mem_addr = addr_instr;
assign data_mem_addr  = addr_data;
assign gpio_addr      = addr_data;
assign uart_addr      = addr_data[UART_CSR_ADDR_WIDTH-1:0];

assign instr_mem_data_in = data_in;
assign data_mem_data_in  = data_in;
assign gpio_data_in      = data_in[7:0];
assign uart_data_in      = data_in;

assign instr_mem_sel = (addr_instr >= INSTR_MEM_BEGIN_ADDR) && (addr_instr <= INSTR_MEM_END_ADDR);
assign data_mem_sel  = (addr_data >= DATA_MEM_BEGIN_ADDR)  && (addr_data <= DATA_MEM_END_ADDR);
assign gpio_sel      = (addr_data >= GPIO_MEM_BEGIN_ADDR)  && (addr_data <= GPIO_MEM_END_ADDR);
assign uart_sel      = (addr_data >= UART_MEM_BEGIN_ADDR)  && (addr_data <= UART_MEM_END_ADDR);

assign instr_mem_wr_en = (wr_en) && (instr_mem_sel);
assign data_mem_wr_en  = (wr_en) && (data_mem_sel);
assign gpio_wr_en      = (wr_en) && (gpio_sel);
assign uart_wr_en      = (wr_en) && (uart_sel);

assign uart_rd_en = (rd_en && uart_sel);

assign data_out_instr = (instr_mem_sel) ? instr_mem_data_out : 32'h0;

always_comb begin
    if (data_mem_sel) begin
        data_out_data = data_mem_data_out;
    end else if (gpio_sel) begin
        data_out_data = gpio_data_out;
    end else if (uart_sel) begin
        data_out_data = uart_data_out;
    end else begin
        data_out_data = 32'h0;
    end
end



endmodule: mem_ctrl