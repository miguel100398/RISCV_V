//File: riscv_v_check_params.sv
//Author: Miguel Bucio
//Date: 16/04/23
//Description: RISC-V Vector Check Parameters module

module riscv_v_check_params;
import riscv_v_pkg::*;

//Check data width is greater or equal than 8
if (RISCV_V_DATA_WIDTH < BYTE_WIDTH) begin
    $error("Illegal RISCV_V_DATA_WIDTH=%0d, is less than 8", RISCV_V_DATA_WIDTH);
end
//Check data width is less than 2^16
if (RISCV_V_DATA_WIDTH > (2**16) ) begin
    $error("Illegal RISCV_V_DATA_WIDTH=&0d, is greater than 2^16", RISCV_V_DATA_WIDTH);
end

//Check RISCV_V_USE_WORD
`ifdef RISCV_V_USE_WORD
    if (RISCV_V_DATA_WIDTH < WORD_WIDTH) begin
        $error("Illegal definition of RISCV_V_USE_WORD, RISCV_V_DATA_WIDTH=%0d is less than WORD_WIDTH=%0d", RISCV_V_DATA_WIDTH, WORD_WIDTH);
    end
`endif //RISCV_V_USE_WORD

//Check RISCV_V_USE_DWORD
`ifdef RISCV_V_USE_DWORD
    if (RISCV_V_DATA_WIDTH < DWORD_WIDTH) begin
        $error("Illegal definition of RISCV_V_USE_DWORD, RISCV_V_DATA_WIDTH=%0d is less than DWORD_WIDTH=%0d", RISCV_V_DATA_WIDTH, DWORD_WIDTH);
    end
`endif //RISCV_V_USE_DWORD

//Check RISCV_V_USE_QWORD
`ifdef RISCV_V_USE_QWORD
    if (RISCV_V_DATA_WIDTH < QWORD_WIDTH) begin
        $error("Illegal definition of RISCV_V_USE_QWORD, RISCV_V_DATA_WIDTH=%0d is less than QWORD_WIDTH=%0d", RISCV_V_DATA_WIDTH, QWORD_WIDTH);
    end
`endif //RISCV_V_USE_QWORD

//Check RISCV_V_USE_DQWORD
`ifdef RISCV_V_USE_DQWORD
    if (RISCV_V_DATA_WIDTH < DQWORD_WIDTH) begin
        $error("Illegal definition of RISCV_V_USE_DQWORD, RISCV_V_DATA_WIDTH=%0d is less than DQWORD_WIDTH=%0d", RISCV_V_DATA_WIDTH, DQWORD_WIDTH);
    end
`endif //RISCV_V_USE_DQWORD


endmodule: riscv_v_check_params