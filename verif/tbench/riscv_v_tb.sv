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
        //Integer Register File interface
        .int_rf_rd_data_id(int_rf_vif.data_out_A),
        .int_rf_wr_data_wb(int_rf_vif.data_in),
        .int_rf_wr_en_wb(int_rf_vif.wr_en),
        //CSR External interface
        .ext_data_in_exe('0),
        .ext_wr_vsstatus_id(1'b0),
        .ext_wr_vtype_id(1'b0),
        .ext_wr_vl_id(1'b0),
        .ext_wr_vstart_id(1'b0),
        .ext_wr_vxrm_id(1'b0),
        .ext_wr_vxsat_id(1'b0),
        .syn_addr('0)
    );

    assign stall = riscv_stall || riscv_v_stall;
    //Assign Temporar  signals FIXME: Drive these signals by a BFM or model
    assign clear_pipe  = 1'b0;
    assign riscv_stall = 1'b0;
    assign riscv_instruction_id = '0;

    //Stage signals
    riscv_v_stage#(.DATA_T(riscv_instruction_t), .NUM_STAGES(RISCV_V_ID_2_WB_LATENCY)) riscv_v_instr_stage (.clk(clk), .rst(1'b0), .en(1'b1), .flush(1'b0), .rst_val('x), .flush_val('x), .data_in(riscv_instruction_id), .data_out(riscv_instruction_wb));

    //Integer register file signals
    assign int_rf_vif.wr_addr   = riscv_instruction_wb.R.rd;
    assign int_rf_vif.rd_addr_A = riscv_instruction_id.R.rs1;
    assign int_rf_vif.rd_addr_B = riscv_instruction_id.R.rs2;

    //Vector register file signals
    assign vec_rf_vif.wr_addr    = dut.v_decode.v_rf.wr_addr;
    assign vec_rf_vif.rd_addr_A  = dut.v_decode.v_rf.rd_addr_A;
    assign vec_rf_vif.rd_addr_B  = dut.v_decode.v_rf.rd_addr_B;
    assign vec_rf_vif.data_in    = dut.v_decode.v_rf.data_in;
    assign vec_rf_vif.wr_en      = dut.v_decode.v_rf.wr_en;
    assign vec_rf_vif.data_out_A = dut.v_decode.v_rf.data_out_A;
    assign vec_rf_vif.data_out_B = dut.v_decode.v_rf.data_out_B;

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
    end

    initial begin
        run_test("riscv_v_cpu_doa_test");
    end
    

endmodule: riscv_v_tb