//File: base_pkg.sv
//Author: Miguel Bucio
//Date: 21/01/24
//Description:  Base package

package base_pkg;

import uvm_pkg::*;

`include "uvm_macros.svh"
`include "base_seq_item.sv"
`include "base_subscriber_2ports.sv"
`include "base_cfg_obj.sv"
`include "base_bfm_cfg_obj.sv"
`include "base_sqr.sv"
`include "base_seq.sv"
`include "base_drv.sv"
`include "base_mon.sv"
`include "base_scbd.sv"
`include "base_trk.sv"
`include "base_cov.sv"
`include "base_agt.sv"
`include "base_env.sv"
`include "base_bfm.sv"
`include "base_model.sv"
`include "rf_model.sv"

endpackage: base_pkg