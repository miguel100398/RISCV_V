//Description: GPIO control and status registers
//Author: Miguel Bucio miguel_angel_bucio@hotmail.com
//Date: 3/13/2022

module GPIO_csr
import GPIO_pkg::*;
(
    input  logic clk,
    input  logic rst_n,
    input  logic wr_en,
    input  logic[7:0] data_in,
    input  logic[31:0] addr,
    output logic[7:0] data_out,
    //GPIO Internal signals
    input  logic[7:0] gpio_port_in_data,
    output logic[7:0] gpio_port_out_data
);

//Register
logic[7:0] gpio_port_out;
logic[7:0] gpio_port_in;

assign gpio_port_out_data = gpio_port_out;

//Write gpio_port_out
always_ff @(posedge clk) begin
    if (~rst_n) begin
        gpio_port_out <= 8'b0;
    end else if (wr_en) begin
        if (addr == GPIO_PORT_OUT_ADDR) begin
            gpio_port_out <= data_in;
        end
    end
end

//Write gpio_port_in
always_ff @(posedge clk) begin
    gpio_port_in <= gpio_port_in_data;
end

//Read registers
always_comb begin
    case (addr) 
        GPIO_PORT_OUT_ADDR: begin
            data_out = gpio_port_out;
        end
        GPIO_PORT_IN_ADDR: begin
            data_out = gpio_port_in;
        end
        default: begin
            data_out = 8'b0;
        end
    endcase
end

endmodule: GPIO_csr