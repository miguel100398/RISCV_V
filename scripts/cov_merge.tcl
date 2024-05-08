merge -out merge_run -overwrite -runfile merge_cov_list.txt -metrics all
load cov_work/scope/merge_run/
report -detail -html -out report_merge_cov -overwrite