//Description: GPIO top module
//Author: Miguel Bucio miguel_angel_bucio@hotmail.com
//Date: 3/13/2022

module GPIO(
    //core interface
    input  logic clk,
    input  logic rst_n,
    input  logic wr_en,
    input  logic[7:0] data_in,
    input  logic[31:0] addr,
    output logic[7:0] data_out,
    //GPIO signals
    input  logic[7:0] gpio_port_in_data,
    output logic[7:0] gpio_port_out_data
);

GPIO_csr csr(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en),
    .data_in(data_in),
    .addr(addr),
    .data_out(data_out),
    .gpio_port_in_data(gpio_port_in_data),
    .gpio_port_out_data(gpio_port_out_data)
);


endmodule: GPIO