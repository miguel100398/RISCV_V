#Script to check Test results


# import OS module
import os
# import regex
import re

REGRESSION_DIR = "./Vivado/riscv_v.sim/sim_1/behav/xsim"
regex = re.compile('(.*testlog$)')

regression = []

num_test  = 0
num_pass  = 0
num_fail  = 0

print("Starting Riscv-v Check regression")

for root, dirs, files in os.walk(REGRESSION_DIR):
  for file in files:
    if regex.match(file):
       print("Test file found " + file)
       regression.append((file, os.path.abspath(root + "\\" + file)))

print(str(len(regression)) + " files found in regression")

for test in regression:
    print("Analysing test " + test[0])
    num_test += 1
    with open(test[1], 'r') as file:
        content = file.read()
        if "RISCV-V TEST FINAL RESULT: TEST PASS" in content:
            print(test[0] + " PASS!")
            num_pass += 1
        else:
            print(test[0] + " FAIL!")
            num_fail += 1

print("Regression analysed, num_test: " + str(num_test) + " num_pass: " + str(num_pass) + "  num_fail: " + str(num_fail))

if (num_fail == 0):
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("!!!!!!!!!!RISCV-V REGRESSION PASS!!!!!!!!!!!!!!!!!")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
else:
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("!!!!!!!!!!RISCV-V REGRESSION FAIL!!!!!!!!!!!!!!!!!")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
