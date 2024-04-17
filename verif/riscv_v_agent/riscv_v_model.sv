//File: riscv_v_model
//Author: Miguel Bucio
//Date: 12/02/24
//Description: RiscV V Instruction Fetch Model

`ifndef __RISCV_V_MODEL_SV__
`define __RISCV_V_MODEL_SV__ 

class riscv_v_model extends riscv_v_base_model;

    `uvm_component_utils(riscv_v_model)

    riscv_v_csr_model     csr_model;
    riscv_v_rf_model      rf_model;
    riscv_v_decode_model  decode_model;
    riscv_v_execute_model execute_model;

    function new(string name = "riscv_v_model", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new 

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Models
        csr_model     = riscv_v_csr_model::type_id::create("riscv_v_csr_model", this);
        rf_model      = riscv_v_rf_model::type_id::create("riscv_v_rf_model", this);
        decode_model  = riscv_v_decode_model::type_id::create("riscv_v_decode_model", this);
        execute_model = riscv_v_execute_model::type_id::create("riscv_v_execute_model", this); 
    endfunction: build_phase

    virtual function void rst();
        csr_model.rst();
        rf_model.rst();
        decode_model.rst();
        execute_model.rst();
    endfunction: rst

    virtual function bit execute_v_instruction(
        input riscv_v_type_instruction_t instr,
        input riscv_data_t               src_int,
        output bit                       wr_vec,
        output riscv_v_rf_wr_en_t        vec_wr_en,
        output riscv_v_rf_addr_t         vec_wr_addr,
        output riscv_v_data_t            vec_wr_data,
        output bit                       wr_int,
        output riscv_rf_addr_t           int_wr_addr,
        output riscv_data_t              int_wr_data
    );
    riscv_v_vtype_t    csr_vtype;
    riscv_v_vl_t       csr_vl;
    riscv_v_vstart_t   csr_vstart;
    riscv_instr_rs_t   srca_addr;
    riscv_instr_rs_t   srcb_addr;
    riscv_instr_rs_t   dest_addr;
    riscv_v_data_t     srca;
    riscv_v_data_t     srcb;
    riscv_v_opcode_e   opcode;
    riscv_v_src_type_t srca_type;
    riscv_v_src_type_t srcb_type;
    bit                is_scalar;
    riscv_v_alu_e      ALU;
    riscv_v_imm_t      imm;
    riscv_v_osize_e    src_osize;
    riscv_v_osize_e    dst_osize;
    riscv_v_src_len_t  len;

    wr_vec      = 1'b0;
    vec_wr_en   = 'x;
    vec_wr_addr = 'x;
    vec_wr_data = 'x;
    wr_int      = 1'b0;
    int_wr_addr = 'x;
    int_wr_data = 'x;

    //Check if it is Vector instruction
    if (!decode_model.is_vector_op(instr)) begin
        `uvm_info(get_name(), $sformatf("Instruction is not Vector instruction: %0d", instr), UVM_MEDIUM)
        return 1'b0;
    end

    //Get CSR
    csr_vtype  = csr_model.get_vtype();
    csr_vl     = csr_model.get_vl();
    csr_vstart = csr_model.get_vstart();

    //Decode Instruction
    //Get Sources and destination
    srca_addr = decode_model.get_vs1(instr);
    srcb_addr = decode_model.get_vs2(instr);
    dest_addr = decode_model.get_vd(instr);
    vec_wr_addr = dest_addr;
    int_wr_addr = dest_addr;

    //Get Vector sources from reg file
    srca = rf_model.read_data(srca_addr);
    srcb = rf_model.read_data(srcb_addr);

    //Get opcode
    opcode = rf_model.get_alu_opcode(instr);

    //Get if register files are writen
    wr_vec = decode_model.write_vec_dest(opcode);
    wr_int = decode_model.write_int_dest(opcode);

    //Get sources type
    srca_type = decode_model.get_vs1_type(instr);
    srcb_type = decode_model.get_vs2_type(instr);

    //Get is scalar
    is_scalar = decode_model.is_scalar(instr);

    //Get ALU
    ALU = decode_model.get_ALU(opcode);

    //Get immediate
    imm = decode_model.get_imm(instr);

    //Get osize
    src_osize = decode_model.get_src_osize(csr_vtype);
    dst_osize = decode_model.get_dst_osize(csr_vtype);

    //Get len
    len = decode_model.get_len(csr_vl);

    //Get Valid
    vec_wr_en = decode_model.get_valid(csr_vtype, csr_vl, csr_vstart);


    //Execute instruction
    execute_model.execute_op(
        .opcode(opcode),
        .src_osize(src_osize),
        .dst_osize(dst_osize),
        .ALU(ALU),
        .is_scalar(is_scalar),
        .srca_type(srca_type),
        .srcb_type(srcb_type),
        .srca_vec(srca),
        .srcb_vec(srcb),
        .src_int(src_int),
        .src_imm(imm),
        .vec_result(vec_wr_data),
        .int_result(int_wr_data)
    );

    //Write Back to register File
    if (wr_vec) begin
        rf_model.write_data_en(dest_addr, vec_wr_data, vec_wr_en);
    end

    return 1'b1;

    endfunction: execute_v_instruction

endclass: riscv_v_model 

`endif //__RISCV_V_MODEL_SV__