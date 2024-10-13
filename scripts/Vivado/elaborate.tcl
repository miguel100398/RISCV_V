set_property top_lib xil_defaultlib [get_filesets sim_1]
set_property verilog_define {RISCV_V_USE_WORD RISCV_V_USE_DWORD RISCV_V_USE_QWORD RISCV_V_USE_DQWORD RISCV_V_INST VIVADO} [get_filesets sim_1]

if {$CODE_COVERAGE == 1} {
    set_property -name {xsim.elaborate.coverage.name} -value {code_cov_db} -objects [get_filesets sim_1]
    set_property -name {xsim.elaborate.coverage.dir} -value {code_cov} -objects [get_filesets sim_1]
    set_property -name {xsim.elaborate.coverage.type} -value {all} -objects [get_filesets sim_1]
} else {
    set_property -name {xsim.elaborate.coverage.name} -value {} -objects [get_filesets sim_1]
    set_property -name {xsim.elaborate.coverage.dir} -value {} -objects [get_filesets sim_1]
    set_property -name {xsim.elaborate.coverage.type} -value {} -objects [get_filesets sim_1]
}


#Compile files
launch_simulation -step compile

#Elaborate Duts
foreach dut $DUTS {
    puts "Elaborating $dut"
    set_property top $dut [get_filesets sim_1]
    launch_simulation -step elaborate
}