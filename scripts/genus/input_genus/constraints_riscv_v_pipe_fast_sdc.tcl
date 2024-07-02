# Miguel Bucio
# User Constraint File: constraints_riscv_v_pipe_fast.tcl

# Set the current design
current_design riscv_v

# Genus COMMANDS TO SET UNITS
set_time_unit -picoseconds
set_load_unit -femtofarads

# COMMON VARIABLES 
set EXTCLK "clk"
set EXTCLK_PERIOD 9200.0
set SKEW 40.0
set MINRISE 30.0
set MAXRISE 50.0
set MINFALL 40.0
set MAXFALL 50.0


# Clock definition
create_clock -name $EXTCLK  -add -period $EXTCLK_PERIOD [get_ports clk]

# slew attribute: Specifies the minimum rise, minimum fall, maximum rise, and
# maximum fall slew values, respectively, in picoseconds.
# The following sentence define the (min rise, min fall, max rise, max fall).
set_clock_transition -rise -min $MINRISE [get_clocks $EXTCLK]
set_clock_transition -rise -max $MAXRISE [get_clocks $EXTCLK]
set_clock_transition -fall -min $MINFALL [get_clocks $EXTCLK]
set_clock_transition -fall -max $MAXFALL [get_clocks $EXTCLK]

# TO DEFINE CLOCK SOURCE AND NETWORK LATENCY IN GENUS
# Define waveform settings for Source Latency
set_clock_latency -rise -source 20 -early -late $EXTCLK  	
set_clock_latency -fall -source 30 -early -late $EXTCLK  	
# Define waveform settings for Network Latency
set_clock_latency -rise 10 $EXTCLK
set_clock_latency -fall 15 $EXTCLK

# CLOCK UNCERTAINTY
set_clock_uncertainty -setup 8 [get_clocks $EXTCLK]
set_clock_uncertainty -hold  4 [get_clocks $EXTCLK]

# Input delay definition: This is the delay coming from outside the design
# for this design it's defined at 10% the period of the clock.
## external_delay -clock [find / -clock 500MHz_CLK] -input 200 -name IDelay [find /des* -port ports_in/*]
## SDC FORMAT
set_input_delay -clock [get_clocks $EXTCLK] -add_delay 200 -name I_DELAY  [get_ports {*rst* *clear_pipe* *riscv_stall* *instruction_id* *int_rf_rd_data_id* *ext_data_in_exe* *ext_wr_vsstatus_id* *ext_wr_vtype_id* *ext_wr_vl_id* *ext_wr_vstart_id* *ext_wr_vxrm_id* *ext_wr_vxsat_id* *syn_addr*}]

# Output delay definition: This is the delay going outside the design
# for this design it's defined at 10% the period of the clock.
##external_delay -clock [find / -clock 500MHz_CLK] -output 200 -name ODelay [find /des* -port ports_out/*]
## SDC FORMAT
set_output_delay -clock [get_clocks $EXTCLK] -add_delay 200 -name O_DELAY [get_ports {*riscv_v_stall* *int_rf_wr_data_wb* *int_rf_wr_en_wb* *syn_data*}]

### SDC FORMAT
set_max_capacitance 5 [all_outputs]

##set_max_fanout 5  [get_ports {SUM sum_struct}]
set_max_fanout 15.000 [current_design]

# set_max_transition

set_max_transition 20 [current_design]

# Alternative to external_pin_cap
set_load 5 -pin_load [get_ports {*riscv_v_stall* *int_rf_wr_data_wb* *int_rf_wr_en_wb* *syn_data*}]

