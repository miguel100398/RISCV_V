#Script to check Test results


# import OS module
import os
# import regex
import re

if not "WORKAREA" in os.environ:
    print("Error, WORKAREA is not defined, exiting")
    exit(1)

WORKAREA = os.getenv("WORKAREA")

print("WORKAREA is %s" % (WORKAREA))

REGRESSION_DIR = "%s/regression_xcelium/" % (WORKAREA)
regex = re.compile('xrun.log')

regression = []

num_test  = 0
num_pass  = 0
num_fail  = 0

print("Starting Riscv-v Check regression")

for root, dirs, files in os.walk(REGRESSION_DIR):
  for file in files:
    if regex.match(file):
       test_name = os.path.basename(os.path.normpath(root))
       print("Test file found " + test_name)
       regression.append((test_name, os.path.abspath(root + "/" + file)))

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

exit(0)