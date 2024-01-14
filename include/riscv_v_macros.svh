/////////////////////////////////////////MACROS/////////////////////////////////////////
//Zero extend signal to size
`define RISCV_V_ZX(signal, size)\
    {{(size-$bits(signal)){1'b0}}, signal}

//Sign extend signal to size
`define RISCV_V_SX(signal, size)\
    {{(size-$bits(signal)){signal[$bits(signal)-1]}},signal}