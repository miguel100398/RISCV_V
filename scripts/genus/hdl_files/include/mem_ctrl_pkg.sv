//Description: Mem controller package
//Author: Miguel Bucio miguel_angel_bucio@hotmail.com
//Date: 3/13/2022

package mem_ctrl_pkg;

parameter INSTR_MEM_BEGIN_ADDR = 32'h00400000;
parameter INSTR_MEM_END_ADDR   = 32'h00400FFF;
parameter DATA_MEM_BEGIN_ADDR  = 32'h11000000;
parameter DATA_MEM_END_ADDR    = 32'hFFFFFFFF;
parameter GPIO_MEM_BEGIN_ADDR  = 32'h10010000;
parameter GPIO_MEM_END_ADDR    = 32'h100100FF;
parameter UART_MEM_BEGIN_ADDR  = 32'h10100000;
parameter UART_MEM_END_ADDR    = 32'h101000FF;

endpackage: mem_ctrl_pkg