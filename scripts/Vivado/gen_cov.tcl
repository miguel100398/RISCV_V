cd $WORK_AREA

#Generate Functional coverage
exec xcrg -report_format html -dir ./cov_merge/functional/xsim.covdb/ -report_dir ./cov_reports/functional/

if {$CODE_COVERAGE == 1} {

    set CODE_DBS {}

    foreach test $riscv_v_tb_tests {
        append CODE_DBS -cc_db " " ${test}_code_db " "
    }

    puts "exec xcrg -merge_cc -cc_dir ./cov_merge/code/xsim.codeCov $CODE_DBS -cc_report ./cov_reports/code"

}