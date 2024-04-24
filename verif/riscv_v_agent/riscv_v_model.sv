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
    riscv_v_vtype_t     csr_vtype;
    riscv_v_vl_t        csr_vl;
    riscv_v_vstart_t    csr_vstart;
    riscv_instr_rs_t    srca_addr;
    riscv_instr_rs_t    srcb_addr;
    riscv_instr_rs_t    dest_addr;
    riscv_v_data_t      srca;
    riscv_v_data_t      srcb;
    riscv_v_data_t      read_dest;
    riscv_v_opcode_e    opcode;
    riscv_v_src_type_t  srca_type;
    riscv_v_src_type_t  srcb_type;
    bit                 is_scalar;
    bit                 use_mask;
    bit                 is_mask;
    bit                 is_reduct;
    bit                 use_carry;
    riscv_v_alu_e       ALU;
    riscv_v_imm_t       imm;
    riscv_v_osize_e     src_osize;
    riscv_v_osize_e     dst_osize;
    riscv_v_vlen_t      len;
    riscv_v_src_start_t start;
    riscv_v_mask_t      mask;
    riscv_v_mask_t      dst_mask_merge;
    bit                 is_shift;
    bit                 is_i2v;
    bit                 is_v2i;

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
    csr_vtype  = csr_model.read_vtype();
    csr_vl     = csr_model.read_vl();
    csr_vstart = csr_model.read_vstart();

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
    read_dest = rf_model.read_data(dest_addr);
    dst_mask_merge = read_dest[RISCV_V_NUM_BYTES_ALLOCATE_MASK-1:0];

    //Get Mask
    mask = rf_model.read_mask();

    //Get opcode
    opcode = decode_model.get_alu_opcode(instr);

    //Get if register files are writen
    wr_vec = decode_model.write_vec_dest(opcode);
    wr_int = decode_model.write_int_dest(opcode);

    //Get sources type
    srca_type = decode_model.get_vs1_type(instr);
    srcb_type = decode_model.get_vs2_type(instr);

    //Get is scalar
    is_scalar = decode_model.is_scalar(instr);

    //Get use carry
    use_carry = decode_model.get_use_carry(instr);

    //Get use mask
    use_mask  = decode_model.get_use_mask(instr, use_carry);

    //Get is mask
    is_mask   = decode_model.get_is_mask(instr);

    //Get is reduct
    is_reduct = decode_model.get_is_reduct(opcode);

    //Get ALU
    ALU = decode_model.get_ALU(opcode);

    //Get immediate
    imm = decode_model.get_imm(instr);

    //Get osize
    src_osize = decode_model.get_src_osize(csr_vtype, opcode, srca_addr);
    dst_osize = decode_model.get_dst_osize(csr_vtype);

    //Get len
    len = decode_model.get_len(csr_vl, dst_osize);

    //Get is shift
    is_shift = decode_model.get_is_shift(instr);

    //Get start
    start = decode_model.get_start(csr_vstart);

    //Get is_i2v
    is_i2v = decode_model.get_is_i2v(instr);

    //Get is_v2i
    is_v2i = decode_model.get_is_v2i(instr);

    //Get Valid
    vec_wr_en = decode_model.get_valid(csr_vtype, csr_vl, csr_vstart, use_mask, mask, is_mask, is_reduct, is_i2v, is_v2i);

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
        .len(len),
        .start(start),
        .use_mask(use_mask),
        .mask(mask),
        .dst_mask_merge(dst_mask_merge),
        .is_shift(is_shift),
        .vec_result(vec_wr_data),
        .int_result(int_wr_data)
    );

    `uvm_info(get_name(), $sformatf("Instruction executed: \
    Instruction: 0x%0h \
    Opcode: %0s \
    ALU: %0s \
    is_scalar: %0b \
    use_mask : %0b \
    dst_osize: %0s \
    src_osize: %0s \
    srca_type: %0s \
    srcb_type: %0s \
    srca_addr: %0d \
    srcb_addr: %0d \
    dest_addr: %0d \
    srca: 0x%0h \
    srcb: 0x%0h \
    mask: 0x%0h \
    imm: 0x%0h \
    src_int: 0x%0h \
    len: %0d \
    vstart: %0d \
    result: 0x%0h \
    ref_wr_en: 0x%0h", instr, opcode.name(), ALU.name(), is_scalar, use_mask, dst_osize.name(), src_osize.name(), srca_type.name(), srcb_type.name(), srca_addr, srcb_addr, dest_addr, srca, srcb, mask, imm, src_int, len, start, vec_wr_data, vec_wr_en), UVM_MEDIUM)

    //Write Back to register File
    if (wr_vec) begin
        rf_model.write_data_en(dest_addr, vec_wr_data, vec_wr_en);
    end

    return 1'b1;

    endfunction: execute_v_instruction

    virtual function void update_ext_csr(
        riscv_data_t ext_data_in,
        bit ext_wr_vsstatus,
        bit ext_wr_vtype,
        bit ext_wr_vl,
        bit ext_wr_vstart,
        bit ext_wr_vxrm,
        bit ext_wr_vxsat
    );
        csr_model.write_ext_vsstatus(ext_data_in,  ext_wr_vsstatus);
        csr_model.write_ext_vtype(ext_data_in,     ext_wr_vtype);
        csr_model.write_ext_vl(ext_data_in,        ext_wr_vl);
        csr_model.write_ext_vstart(ext_data_in,    ext_wr_vstart);
        csr_model.write_ext_vxrm(ext_data_in,      ext_wr_vxrm);
        csr_model.write_ext_vxsat(ext_data_in,     ext_wr_vxsat);
    endfunction: update_ext_csr

endclass: riscv_v_model 

`endif //__RISCV_V_MODEL_SV__