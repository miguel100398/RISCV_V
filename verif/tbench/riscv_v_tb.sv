//File: riscv_v_tb
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-V Vector extension test bench

`timescale 1ns/1ps

module riscv_v_tb;
    import riscv_pkg::*;
    import riscv_v_pkg::*;
    import uvm_pkg::*;
    import riscv_v_base_pkg::*;
    import riscv_rf_agt_pkg::*;
    import riscv_v_rf_agt_pkg::*;
    import riscv_v_alu_agt_pkg::*;
    import riscv_v_test_pkg::*;

    //Check parameters
    riscv_v_check_params chk_param();

    logic clk;
    logic rst;
    riscv_instruction_t riscv_instruction_id;
    riscv_instruction_t riscv_instruction_wb;

    logic clear_pipe;
    logic riscv_stall;
    logic riscv_v_stall;
    logic stall;

    //Clock generation
    initial begin
        clk = 0;
        forever begin
            #25 clk = ~clk;
        end
    end

    //Interfaces
    riscv_rf_if int_rf_vif(
        .clk(clk)
    );

    riscv_v_rf_if vec_rf_vif(
        .clk(clk)
    );

    riscv_v_arithmetic_ALU_if vec_arithmetic_alu_vif(
        .clk(clk)
    );

    riscv_v_logic_ALU_if vec_logic_alu_vif(
        .clk(clk)
    );

    riscv_v_mask_ALU_if vec_mask_alu_vif(
        .clk(clk)
    );
    
    riscv_v_permutation_ALU_if vec_permutation_alu_vif(
        .clk(clk)
    );

    riscv_v_if_if riscv_v_if_vif(
        .clk(clk)
    );

    riscv_v_ext_csr_if riscv_v_ext_csr_vif(
        .clk(clk)
    );

    riscv_v_if riscv_v_vif(
        .clk(clk)
    );

    riscv_v_csr_if riscv_v_csr_vif(
        .clk(clk)
    );

    //Dut
    riscv_v dut(
        //Clocks and resets
        .clk(clk),
        .rst(rst),
        .clear_pipe(clear_pipe),
        .riscv_stall(riscv_stall),
        .riscv_v_stall(riscv_v_stall),
        //RISCV Integer Interface
        .instruction_id(riscv_instruction_id),
        `ifdef RISCV_V_INST
            .opcode_id(riscv_v_if_vif.opcode),
        `endif //RISCV_V_INST
        //Integer Register File interface
        .int_rf_rd_data_id(int_rf_vif.data_out_A),
        .int_rf_wr_data_wb(int_rf_vif.data_in),
        .int_rf_wr_en_wb(int_rf_vif.wr_en),
        //CSR External interface
        .ext_data_in_exe(riscv_v_ext_csr_vif.ext_csr_data),
        .ext_wr_vsstatus_id(riscv_v_ext_csr_vif.ext_wr_vsstatus),
        .ext_wr_vtype_id(riscv_v_ext_csr_vif.ext_wr_vtype),
        .ext_wr_vl_id(riscv_v_ext_csr_vif.ext_wr_vl),
        .ext_wr_vstart_id(riscv_v_ext_csr_vif.ext_wr_vstart),
        .ext_wr_vxrm_id(riscv_v_ext_csr_vif.ext_wr_vxrm),
        .ext_wr_vxsat_id(riscv_v_ext_csr_vif.ext_wr_vxsat),
        .syn_addr('0)
    );

    

    assign stall = riscv_stall || riscv_v_stall;
    //Assign Temporar  signals FIXME: Drive these signals by a BFM or model
    assign clear_pipe  = 1'b0;
    assign riscv_stall = 1'b0;
    

    //Stage signals
    riscv_v_stage#(.DATA_T(riscv_instruction_t), .NUM_STAGES(RISCV_V_ID_2_WB_LATENCY)) riscv_v_instr_stage (.clk(clk), .rst(1'b0), .en(1'b1), .flush(1'b0), .rst_val('x), .flush_val('x), .data_in(riscv_instruction_id), .data_out(riscv_instruction_wb));

    //RISCV-V signals
    assign riscv_v_vif.rst                          = rst;
    assign riscv_v_vif.clear_pipe                   = clear_pipe;
    assign riscv_v_vif.riscv_stall                  = riscv_stall;
    assign riscv_v_vif.riscv_v_stall                = riscv_v_stall;
    assign riscv_v_vif.instruction_id               = riscv_instruction_id;
    `ifdef RISCV_V_INST
        assign riscv_v_vif.opcode_id                = riscv_v_if_vif.opcode;
    `endif //RISCV_V_INST
    assign riscv_v_vif.int_rf_rd_data_id            = int_rf_vif.data_out_A;
    assign riscv_v_vif.int_rf_wr_data_wb            = int_rf_vif.data_in;
    assign riscv_v_vif.int_rf_wr_en_wb              = int_rf_vif.wr_en;
    assign riscv_v_vif.ext_data_in_exe              = riscv_v_ext_csr_vif.ext_csr_data;
    assign riscv_v_vif.ext_wr_vsstatus_id           = riscv_v_ext_csr_vif.ext_wr_vsstatus;
    assign riscv_v_vif.ext_wr_vtype_id              = riscv_v_ext_csr_vif.ext_wr_vtype;
    assign riscv_v_vif.ext_wr_vl_id                 = riscv_v_ext_csr_vif.ext_wr_vl;
    assign riscv_v_vif.ext_wr_vstart_id             = riscv_v_ext_csr_vif.ext_wr_vstart;
    assign riscv_v_vif.ext_wr_vxrm_id               = riscv_v_ext_csr_vif.ext_wr_vxrm;
    assign riscv_v_vif.ext_wr_vxsat_id              = riscv_v_ext_csr_vif.ext_wr_vxsat;
    assign riscv_v_vif.v_rf_if.wr_addr              = vec_rf_vif.wr_addr;
    assign riscv_v_vif.v_rf_if.rd_addr_A            = vec_rf_vif.rd_addr_A;
    assign riscv_v_vif.v_rf_if.rd_addr_B            = vec_rf_vif.rd_addr_B;
    assign riscv_v_vif.v_rf_if.data_in              = vec_rf_vif.data_in;
    assign riscv_v_vif.v_rf_if.wr_en                = vec_rf_vif.wr_en;
    assign riscv_v_vif.v_rf_if.data_out_A           = vec_rf_vif.data_out_A;
    assign riscv_v_vif.v_rf_if.data_out_B           = vec_rf_vif.data_out_B;
    assign riscv_v_vif.v_csr_if.rst                 = riscv_v_csr_vif.rst;
    assign riscv_v_vif.v_csr_if.vsstatus_data_in    = riscv_v_csr_vif.vsstatus_data_in;
    assign riscv_v_vif.v_csr_if.vsstatus_wr_en      = riscv_v_csr_vif.vsstatus_wr_en;
    assign riscv_v_vif.v_csr_if.vsstatus_data_out   = riscv_v_csr_vif.vsstatus_data_out;
    assign riscv_v_vif.v_csr_if.vtype_data_in       = riscv_v_csr_vif.vtype_data_in;
    assign riscv_v_vif.v_csr_if.vtype_wr_en         = riscv_v_csr_vif.vtype_wr_en;
    assign riscv_v_vif.v_csr_if.vtype_data_out      = riscv_v_csr_vif.vtype_data_out;
    assign riscv_v_vif.v_csr_if.vl_data_in          = riscv_v_csr_vif.vl_data_in;
    assign riscv_v_vif.v_csr_if.vl_wr_en            = riscv_v_csr_vif.vl_wr_en;
    assign riscv_v_vif.v_csr_if.vl_data_out         = riscv_v_csr_vif.vl_data_out;
    assign riscv_v_vif.v_csr_if.vlenb_data_out      = riscv_v_csr_vif.vlenb_data_out;
    assign riscv_v_vif.v_csr_if.vstart_data_in      = riscv_v_csr_vif.vstart_data_in;
    assign riscv_v_vif.v_csr_if.vstart_wr_en        = riscv_v_csr_vif.vstart_wr_en;
    assign riscv_v_vif.v_csr_if.vstart_data_out     = riscv_v_csr_vif.vstart_data_out;
    assign riscv_v_vif.v_csr_if.vxrm_data_in        = riscv_v_csr_vif.vxrm_data_in;
    assign riscv_v_vif.v_csr_if.vxrm_wr_en          = riscv_v_csr_vif.vxrm_wr_en;
    assign riscv_v_vif.v_csr_if.vxrm_data_out       = riscv_v_csr_vif.vxrm_data_out;
    assign riscv_v_vif.v_csr_if.vxsat_data_in       = riscv_v_csr_vif.vxsat_data_in;
    assign riscv_v_vif.v_csr_if.vxsat_wr_en         = riscv_v_csr_vif.vxsat_wr_en;
    assign riscv_v_vif.v_csr_if.vxsat_data_out      = riscv_v_csr_vif.vxsat_data_out;
    assign riscv_v_vif.v_csr_if.vcsr_data_out       = riscv_v_csr_vif.vcsr_data_out;
     
    
    //Integer register file signals
    assign int_rf_vif.wr_addr   = riscv_instruction_wb.R.rd;
    assign int_rf_vif.rd_addr_A = riscv_instruction_id.R.rs1;
    assign int_rf_vif.rd_addr_B = riscv_instruction_id.R.rs2;

    //Instruction Fetch signals
    assign riscv_instruction_id = riscv_v_if_vif.instruction;
    assign riscv_v_if_vif.rst   = rst;

    //External CSR interface signals
    assign riscv_v_ext_csr_vif.rst = rst;

    //Vector register file signals
    assign vec_rf_vif.wr_addr    = dut.v_decode.v_rf.wr_addr;
    assign vec_rf_vif.rd_addr_A  = dut.v_decode.v_rf.rd_addr_A;
    assign vec_rf_vif.rd_addr_B  = dut.v_decode.v_rf.rd_addr_B;
    assign vec_rf_vif.data_in    = dut.v_decode.v_rf.data_in;
    assign vec_rf_vif.wr_en      = dut.v_decode.v_rf.wr_en;
    assign vec_rf_vif.data_out_A = dut.v_decode.v_rf.data_out_A;
    assign vec_rf_vif.data_out_B = dut.v_decode.v_rf.data_out_B;

    //Vector CSR signals
    assign riscv_v_csr_vif.rst                  = dut.v_decode.v_csr.rst;
    assign riscv_v_csr_vif.vsstatus_data_in     = dut.v_decode.v_csr.vsstatus_data_in;
    assign riscv_v_csr_vif.vsstatus_wr_en       = dut.v_decode.v_csr.vsstatus_wr_en;
    assign riscv_v_csr_vif.vsstatus_data_out    = dut.v_decode.v_csr.vsstatus_data_out;
    assign riscv_v_csr_vif.vtype_data_in        = dut.v_decode.v_csr.vtype_data_in;
    assign riscv_v_csr_vif.vtype_wr_en          = dut.v_decode.v_csr.vtype_wr_en;
    assign riscv_v_csr_vif.vtype_data_out       = dut.v_decode.v_csr.vtype_data_out;
    assign riscv_v_csr_vif.vl_data_in           = dut.v_decode.v_csr.vl_data_in;
    assign riscv_v_csr_vif.vl_wr_en             = dut.v_decode.v_csr.vl_wr_en;
    assign riscv_v_csr_vif.vl_data_out          = dut.v_decode.v_csr.vl_data_out;
    assign riscv_v_csr_vif.vlenb_data_out       = dut.v_decode.v_csr.vlenb_data_out;
    assign riscv_v_csr_vif.vstart_data_in       = dut.v_decode.v_csr.vstart_data_in;
    assign riscv_v_csr_vif.vstart_wr_en         = dut.v_decode.v_csr.vstart_wr_en;
    assign riscv_v_csr_vif.vstart_data_out      = dut.v_decode.v_csr.vstart_data_out;
    assign riscv_v_csr_vif.vxrm_data_in         = dut.v_decode.v_csr.vxrm_data_in;
    assign riscv_v_csr_vif.vxrm_wr_en           = dut.v_decode.v_csr.vxrm_wr_en;
    assign riscv_v_csr_vif.vxrm_data_out        = dut.v_decode.v_csr.vxrm_data_out;
    assign riscv_v_csr_vif.vxsat_data_in        = dut.v_decode.v_csr.vxsat_data_in;
    assign riscv_v_csr_vif.vxsat_wr_en          = dut.v_decode.v_csr.vxsat_wr_en;
    assign riscv_v_csr_vif.vxsat_data_out       = dut.v_decode.v_csr.vxsat_data_out;
    assign riscv_v_csr_vif.vcsr_data_out        = dut.v_decode.v_csr.vcsr_data_out;


    //Arithmetic ALU signals
    assign vec_arithmetic_alu_vif.is_reduct                 = dut.v_execute.exe_alu.arithmetic_ALU.is_reduct;
    assign vec_arithmetic_alu_vif.is_add                    = dut.v_execute.exe_alu.arithmetic_ALU.is_add;
    assign vec_arithmetic_alu_vif.is_sub                    = dut.v_execute.exe_alu.arithmetic_ALU.is_sub;
    assign vec_arithmetic_alu_vif.is_mul                    = dut.v_execute.exe_alu.arithmetic_ALU.is_mul;
    assign vec_arithmetic_alu_vif.is_zero_ext               = dut.v_execute.exe_alu.arithmetic_ALU.is_zero_ext;
    assign vec_arithmetic_alu_vif.is_sign_ext               = dut.v_execute.exe_alu.arithmetic_ALU.is_sign_ext;
    assign vec_arithmetic_alu_vif.is_set_equal              = dut.v_execute.exe_alu.arithmetic_ALU.is_set_equal;
    assign vec_arithmetic_alu_vif.is_set_nequal             = dut.v_execute.exe_alu.arithmetic_ALU.is_set_nequal;
    assign vec_arithmetic_alu_vif.is_set_less               = dut.v_execute.exe_alu.arithmetic_ALU.is_set_less;
    assign vec_arithmetic_alu_vif.is_set_greater            = dut.v_execute.exe_alu.arithmetic_ALU.is_set_greater;
    assign vec_arithmetic_alu_vif.is_max                    = dut.v_execute.exe_alu.arithmetic_ALU.is_max;
    assign vec_arithmetic_alu_vif.is_min                    = dut.v_execute.exe_alu.arithmetic_ALU.is_min;
    assign vec_arithmetic_alu_vif.is_high                   = dut.v_execute.exe_alu.arithmetic_ALU.is_high;
    assign vec_arithmetic_alu_vif.is_signed                 = dut.v_execute.exe_alu.arithmetic_ALU.is_signed;
    assign vec_arithmetic_alu_vif.use_carry                 = dut.v_execute.exe_alu.arithmetic_ALU.use_carry;
    assign vec_arithmetic_alu_vif.dst_osize_vector          = dut.v_execute.exe_alu.arithmetic_ALU.dst_osize_vector;
    assign vec_arithmetic_alu_vif.src_osize_vector          = dut.v_execute.exe_alu.arithmetic_ALU.src_osize_vector;
    assign vec_arithmetic_alu_vif.is_greater_osize_vector   = dut.v_execute.exe_alu.arithmetic_ALU.is_greater_osize_vector;
    assign vec_arithmetic_alu_vif.is_less_osize_vector      = dut.v_execute.exe_alu.arithmetic_ALU.is_less_osize_vector;
    assign vec_arithmetic_alu_vif.srca                      = dut.v_execute.exe_alu.arithmetic_ALU.srca;
    assign vec_arithmetic_alu_vif.srcb                      = dut.v_execute.exe_alu.arithmetic_ALU.srcb;
    assign vec_arithmetic_alu_vif.carry_in                  = dut.v_execute.exe_alu.arithmetic_ALU.carry_in;
    assign vec_arithmetic_alu_vif.result                    = dut.v_execute.exe_alu.arithmetic_ALU.result;
    assign vec_arithmetic_alu_vif.zf                        = dut.v_execute.exe_alu.arithmetic_ALU.zf;
    assign vec_arithmetic_alu_vif.of                        = dut.v_execute.exe_alu.arithmetic_ALU.of;
    assign vec_arithmetic_alu_vif.cf                        = dut.v_execute.exe_alu.arithmetic_ALU.cf;
    `ifdef RISCV_V_INST
        assign vec_arithmetic_alu_vif.osize                 = dut.v_execute.exe_alu.arithmetic_ALU.osize;
        assign vec_arithmetic_alu_vif.opcode                = dut.v_execute.exe_alu.arithmetic_ALU.opcode;
        assign vec_arithmetic_alu_vif.len                   = dut.v_execute.exe_alu.arithmetic_ALU.len;
    `endif //RISCV_V_INST

    //Logic ALU signals
    assign vec_logic_alu_vif.is_reduct                      = dut.v_execute.exe_alu.logic_ALU.is_reduct;
    assign vec_logic_alu_vif.is_and                         = dut.v_execute.exe_alu.logic_ALU.is_and;
    assign vec_logic_alu_vif.is_or                          = dut.v_execute.exe_alu.logic_ALU.is_or;
    assign vec_logic_alu_vif.is_xor                         = dut.v_execute.exe_alu.logic_ALU.is_xor;
    assign vec_logic_alu_vif.is_mask                        = dut.v_execute.exe_alu.logic_ALU.is_mask;
    assign vec_logic_alu_vif.is_shift                       = dut.v_execute.exe_alu.logic_ALU.is_shift;
    assign vec_logic_alu_vif.is_left                        = dut.v_execute.exe_alu.logic_ALU.is_left;
    assign vec_logic_alu_vif.is_arith                       = dut.v_execute.exe_alu.logic_ALU.is_arith;
    assign vec_logic_alu_vif.dst_osize_vector               = dut.v_execute.exe_alu.logic_ALU.dst_osize_vector;
    assign vec_logic_alu_vif.is_greater_osize_vector        = dut.v_execute.exe_alu.logic_ALU.is_greater_osize_vector;
    assign vec_logic_alu_vif.is_less_osize_vector           = dut.v_execute.exe_alu.logic_ALU.is_less_osize_vector;
    assign vec_logic_alu_vif.srca                           = dut.v_execute.exe_alu.logic_ALU.srca;
    assign vec_logic_alu_vif.srcb                           = dut.v_execute.exe_alu.logic_ALU.srcb;
    assign vec_logic_alu_vif.result                         = dut.v_execute.exe_alu.logic_ALU.result;
    `ifdef RISCV_V_INST
        assign vec_logic_alu_vif.osize                      = dut.v_execute.exe_alu.logic_ALU.osize;
        assign vec_logic_alu_vif.opcode                     = dut.v_execute.exe_alu.logic_ALU.opcode;
        assign vec_logic_alu_vif.len                        = dut.v_execute.exe_alu.logic_ALU.len;
    `endif //RISCV_V_INST

    //Mask ALU signals
    assign  vec_mask_alu_vif.is_mask                        = dut.v_execute.exe_alu.mask_ALU.is_mask;
    assign  vec_mask_alu_vif.is_and                         = dut.v_execute.exe_alu.mask_ALU.is_and;
    assign  vec_mask_alu_vif.is_or                          = dut.v_execute.exe_alu.mask_ALU.is_or;
    assign  vec_mask_alu_vif.is_xor                         = dut.v_execute.exe_alu.mask_ALU.is_xor;
    assign  vec_mask_alu_vif.is_negate_srca                 = dut.v_execute.exe_alu.mask_ALU.is_negate_srca;
    assign  vec_mask_alu_vif.is_negate_result               = dut.v_execute.exe_alu.mask_ALU.is_negate_result;
    assign  vec_mask_alu_vif.srca                           = dut.v_execute.exe_alu.mask_ALU.srca;
    assign  vec_mask_alu_vif.srcb                           = dut.v_execute.exe_alu.mask_ALU.srcb;
    assign  vec_mask_alu_vif.result                         = dut.v_execute.exe_alu.mask_ALU.result;
    `ifdef RISCV_V_INST 
        assign vec_mask_alu_vif.opcode                      = dut.v_execute.exe_alu.mask_ALU.opcode;
    `endif //RISCV_V_INST

    //Permutation ALU signals
    assign vec_permutation_alu_vif.is_v2i                   = dut.v_execute.exe_alu.permutation_ALU.is_v2i;
    assign vec_permutation_alu_vif.is_i2v                   = dut.v_execute.exe_alu.permutation_ALU.is_i2v;
    assign vec_permutation_alu_vif.integer_data_in          = dut.v_execute.exe_alu.permutation_ALU.integer_data_in;
    assign vec_permutation_alu_vif.vector_data_in           = dut.v_execute.exe_alu.permutation_ALU.vector_data_in;
    assign vec_permutation_alu_vif.integer_data_out         = dut.v_execute.exe_alu.permutation_ALU.integer_data_out;
    assign vec_permutation_alu_vif.vector_data_out          = dut.v_execute.exe_alu.permutation_ALU.vector_data_out;
    `ifdef RISCV_V_INST 
        assign vec_permutation_alu_vif.opcode               = dut.v_execute.exe_alu.permutation_ALU.opcode;
    `endif //RISCV_V_INST

    //Drive rst
    initial begin
        rst = 1'b1;
        repeat (5) begin 
            @(posedge clk);
        end
        @(negedge clk);
        rst = 1'b0;
    end

    initial begin
        //Set interface to DB
        uvm_config_db#(virtual riscv_rf_if)::set(uvm_root::get(),"*","riscv_v_int_rf_vif",int_rf_vif);
        uvm_config_db#(virtual riscv_v_rf_if)::set(uvm_root::get(),"*","riscv_v_vec_rf_vif",vec_rf_vif);
        uvm_config_db#(virtual riscv_v_arithmetic_ALU_if)::set(uvm_root::get(),"*","riscv_v_vec_arithmetic_alu_vif",vec_arithmetic_alu_vif);
        uvm_config_db#(virtual riscv_v_logic_ALU_if)::set(uvm_root::get(),"*","riscv_v_vec_logic_alu_vif",vec_logic_alu_vif);
        uvm_config_db#(virtual riscv_v_mask_ALU_if)::set(uvm_root::get(),"*","riscv_v_vec_mask_alu_vif",vec_mask_alu_vif);
        uvm_config_db#(virtual riscv_v_permutation_ALU_if)::set(uvm_root::get(),"*","riscv_v_vec_permutation_alu_vif",vec_permutation_alu_vif);
        uvm_config_db#(virtual riscv_v_if_if)::set(uvm_root::get(),"*","riscv_v_if_vif",riscv_v_if_vif);
        uvm_config_db#(virtual riscv_v_ext_csr_if)::set(uvm_root::get(),"*","riscv_v_ext_csr_vif",riscv_v_ext_csr_vif);
        uvm_config_db#(virtual riscv_v_if)::set(uvm_root::get(), "*", "riscv_v_vif", riscv_v_vif);
    end

    initial begin
        run_test("riscv_v_cpu_vsub_test");
    end
    

endmodule: riscv_v_tb