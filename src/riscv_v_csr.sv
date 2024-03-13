//File: riscv_v_csr.sv
//Author: Miguel Bucio
//Date: 15/01/24
//Description: RISC-V Vector extension Control and status register
`timescale 1ns/1ps

module riscv_v_csr
import riscv_pkg::*, riscv_v_pkg::*;
(
    //Clocks and resets
    input  logic                clk,
    input  logic                rst,
    //VSSTATUS
    input  riscv_v_vsstatus_t   vsstatus_data_in,
    input  logic                vsstatus_wr_en,
    output riscv_v_vsstatus_t   vsstatus_data_out,
    //VTYPE
    input  riscv_v_vtype_t      vtype_data_in,
    input  logic                vtype_wr_en,
    output riscv_v_vtype_t      vtype_data_out,
    //VL
    input  riscv_v_vl_t         vl_data_in,
    input  logic                vl_wr_en,
    output riscv_v_vl_t         vl_data_out,
    //VLENB
    output riscv_v_vlenb_t      vlenb_data_out,
    //VSTART
    input  riscv_v_vstart_t     vstart_data_in,
    input  logic                vstart_wr_en,
    output riscv_v_vstart_t     vstart_data_out,
    //VXRM
    input  riscv_v_vxrm_t       vxrm_data_in,
    input  logic                vxrm_wr_en,
    output riscv_v_vxrm_t       vxrm_data_out,
    //VXSAT
    input  riscv_v_vxsat_t      vxsat_data_in,
    input  logic                vxsat_wr_en,
    output riscv_v_vxsat_t      vxsat_data_out,
    //VCSR
    output riscv_v_vcsr_t       vcsr_data_out
);

//Registers
riscv_v_vsstatus_t  vsstatus;
riscv_v_vtype_t     vtype;
riscv_v_vl_t        vl;
riscv_v_vlenb_t     vlenb;
riscv_v_vstart_t    vstart;
riscv_v_vxrm_t      vxrm;
riscv_v_vxsat_t     vxsat;
riscv_v_vcsr_t      vcsr;

//VSSTATUS
always_ff @(posedge clk or posedge rst) begin
    if  (rst) begin
        vsstatus <= RISCV_V_VSSTATUS_RST_VAL;
    end else if (vsstatus_wr_en) begin
        vsstatus <= vsstatus_data_in;
    end
end
assign vsstatus_data_out = vsstatus;

//VTYPE
always_ff @(posedge clk or posedge  rst) begin
    if (rst) begin
        vtype <= RISCV_V_VTYPE_RST_VAL;
    end else if (vtype_wr_en) begin
        vtype <= vtype_data_in;
    end
end
assign vtype_data_out = vtype;

//VL
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        vl <=  RISCV_V_VL_RST_VAL;
    end else if (vl_wr_en) begin
        vl <= vl_data_in;
    end
end
assign vl_data_out = vl;

//VLENB (VL/8)
assign vlenb          = vl.len >> 3;
assign vlenb_data_out = vlenb;

//VSTART
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        vstart <= RISCV_V_VSTART_RST_VAL;
    end else if (vstart_wr_en)  begin
        vstart <= vstart_data_in;
    end 
end
assign vstart_data_out = vstart;

//VXRM
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        vxrm <= RISCV_V_VXRM_RST_VAL;
    end else if (vxrm_wr_en) begin
        vxrm <= vxrm_data_in;
    end
end
assign vxrm_data_out = vxrm;

//VXSAT
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        vxsat <= RISCV_V_VXSAT_RST_VAL;
    end else if (vxsat_wr_en) begin
        vxsat <= vxsat_data_in;
    end
end
assign vxsat_data_out = vxsat;

//VCSR
assign vcsr.rounding_mode = vxrm.rounding_mode;
assign vcsr.saturate      = vxsat.saturate;
assign vcsr_data_out      = vcsr;

////////////////////////////////////////////////Assertions/////////////////////////////////////////////

vstart_supported: assert property ( @(posedge clk)
    vstart.index == 0
) else $fatal("Vstart different than 0 is not supported yet");

vlen_supported: assert property ( @(posedge clk)
    vl.len <= RISCV_V_NUM_ELEMENTS_REG
) else $fatal($sformatf("Vlen different than %0d is not supported yet", RISCV_V_NUM_ELEMENTS_REG));

vlmul_suppoorted: assert property ( @(posedge clk)
    vtype.vlmul == LMUL_1
) else $fatal("vlmul different than 1 is not supported yet");

vsstatus_x: assert property ( @(posedge clk)
    !$isunknown(vsstatus)
) else $error($sformatf("vsstatus is unknown: 0x%0h", vsstatus));

vtype_x: assert property ( @(posedge clk)
    !$isunknown(vtype)
) else $error($sformatf("vtype is unknown: 0x%0h", vtype));

vl_x: assert property ( @(posedge clk)
    !$isunknown(vl)
) else $error($sformatf("vl is unknown: 0x%0h", vl));

vlenb_x: assert property ( @(posedge clk)
    !$isunknown(vlenb)
) else $error($sformatf("vlenb is unknown: 0x%0h", vlenb));

vstart_x: assert property ( @(posedge clk)
    !$isunknown(vstart)
) else $error($sformatf("vstart is unknown: 0x%0h", vstart));

vxrm_x: assert property ( @(posedge clk)
    !$isunknown(vxrm)
) else $error($sformatf("vxrm is unknown: 0x%0h", vxrm));

vxsat_x: assert property ( @(posedge clk)
    !$isunknown(vxsat)
) else $error($sformatf("vxsat is unknown: 0x%0h", vxsat));

vcsr_x: assert property ( @(posedge clk)
    !$isunknown(vcsr)
) else $error($sformatf("vcsr is unknown: 0x%0h", vcsr));

endmodule: riscv_v_csr