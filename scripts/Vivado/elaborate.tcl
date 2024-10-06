set_property top_lib xil_defaultlib [get_filesets sim_1]
set_property verilog_define {RISCV_V_USE_WORD RISCV_V_USE_DWORD RISCV_V_USE_QWORD RISCV_V_USE_DQWORD RISCV_V_INST VIVADO} [get_filesets sim_1]

#Compile files
launch_simulation -step compile

#Elaborate Duts
foreach dut $DUTS {
    puts "Elaborating $dut"
    set_property top $dut [get_filesets sim_1]
    launch_simulation -step elaborate
}