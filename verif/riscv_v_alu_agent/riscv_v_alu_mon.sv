//File: riscv_v_alu_mon.sv
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector ALU Mon

`ifndef __RISCV_V_ALU_MON_SV__
`define __RISCV_V_ALU_MON_SV__ 

class riscv_v_alu_mon extends riscv_v_base_mon#(
                                                 .seq_item_in_t(riscv_v_alu_in_seq_item),
                                                 .seq_item_out_t(riscv_v_alu_out_seq_item) );
    `uvm_component_utils(riscv_v_alu_mon)

    localparam int in_sem_keys = 1;
    localparam int out_sem_keys = 2;
    //Semaphore to process inputs before result
    semaphore in_sem [riscv_v_alu_e];

    //Virtual interfaces
    riscv_v_alu_interfaces_names_t  interfaces_names;
    virtual riscv_v_logic_ALU_if logic_vif;
    virtual riscv_v_arithmetic_ALU_if arithmetic_vif;
    virtual riscv_v_mask_ALU_if mask_vif;
    virtual riscv_v_permutation_ALU_if permutation_vif;

    function new(string name = "riscv_v_alu_mon", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Create semaphores
        in_sem[LOGIC_ALU]       = new(in_sem_keys);
        in_sem[ARITHMETIC_ALU]  = new(in_sem_keys);
        in_sem[MASK_ALU]        = new(in_sem_keys);
        in_sem[PERMUTATION_ALU] = new(in_sem_keys);
    endfunction: build_phase

    virtual function void check_interface_name();
        if (!(uvm_config_db #(string)::get(this, "", "logic_vif_name", interfaces_names[LOGIC_ALU]))) begin
            `uvm_fatal(get_name(), "logic_vif_name configuration not found in uvm_db");
        end
        if (!(uvm_config_db #(string)::get(this, "", "arithmetic_vif_name", interfaces_names[ARITHMETIC_ALU]))) begin
            `uvm_fatal(get_name(), "arithmetic_vif_name configuration not found in uvm_db");
        end
        if (!(uvm_config_db #(string)::get(this, "", "mask_vif_name", interfaces_names[MASK_ALU]))) begin
            `uvm_fatal(get_name(), "mask_vif_name configuration not found in uvm_db");
        end
        if (!(uvm_config_db #(string)::get(this, "", "permutation_vif_name", interfaces_names[PERMUTATION_ALU]))) begin
            `uvm_fatal(get_name(), "permutation_vif_name configuration not found in uvm_db");
        end
    endfunction: check_interface_name

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask: run_phase

    virtual task mon_rtl_in();
        fork
            begin
                forever mon_in_logic();
            end
            begin
                forever mon_in_arithmetic();
            end
            begin
                forever mon_in_mask();
            end
            begin
                forever mon_in_permutation();
            end
        join
    endtask: mon_rtl_in

    virtual task mon_in_logic();
        riscv_v_logic_alu_in_seq_item logic_in_txn;
        @(logic_vif.cb_mon);
        in_sem[LOGIC_ALU].get(in_sem_keys);
        if (is_logic_op()) begin
            `uvm_info(get_name(), "Transaction captured in logic_alu in port", UVM_HIGH);
            logic_in_txn = riscv_v_logic_alu_in_seq_item::type_id::create("logic_in_txn", this);
            logic_in_txn.srca                    = logic_vif.cb_mon.srca;
            logic_in_txn.srcb                    = logic_vif.cb_mon.srcb;
            logic_in_txn.dst_osize_vector        = logic_vif.cb_mon.dst_osize_vector;
            logic_in_txn.is_greater_osize_vector = logic_vif.cb_mon.is_greater_osize_vector;
            `ifdef RISCV_V_INST
                logic_in_txn.osize  = logic_vif.cb_mon.osize;
                logic_in_txn.opcode = logic_vif.cb_mon.opcode;
                logic_in_txn.len    = logic_vif.cb_mon.len;
            `else 
                logic_in_txn.osize  = get_osize(logic_vif.cb_mon.srca.merge); 
                logic_in_txn.opcode = get_logic_opcode();
                logic_in_txn.len    = get_len(logic_in_txn.osize);
            `endif// RISCV_V_INST 
            rtl_in_ap.write(logic_in_txn);
        end
        //Set keys to process result
        in_sem[LOGIC_ALU].put(out_sem_keys);
    endtask: mon_in_logic 

    virtual task mon_in_arithmetic();
        riscv_v_arithmetic_alu_in_seq_item arithmetic_in_txn;
        @(arithmetic_vif.cb_mon);
        in_sem[ARITHMETIC_ALU].get(in_sem_keys);
        if (is_arithmetic_op()) begin
            `uvm_info(get_name(), "Transaction captured in arithmetic_alu in port", UVM_HIGH);
            arithmetic_in_txn = riscv_v_arithmetic_alu_in_seq_item::type_id::create("arithmetic_in_txn", this);
            arithmetic_in_txn.srca                    = arithmetic_vif.cb_mon.srca;
            arithmetic_in_txn.srcb                    = arithmetic_vif.cb_mon.srcb;
            arithmetic_in_txn.carry_in                = arithmetic_vif.cb_mon.carry_in;
            arithmetic_in_txn.dst_osize_vector        = arithmetic_vif.cb_mon.dst_osize_vector;
            arithmetic_in_txn.src_osize_vector        = arithmetic_vif.cb_mon.src_osize_vector;
            arithmetic_in_txn.is_greater_osize_vector = arithmetic_vif.cb_mon.is_greater_osize_vector;
            arithmetic_in_txn.is_less_osize_vector    = arithmetic_vif.cb_mon.is_less_osize_vector;
            `ifdef RISCV_V_INST
                arithmetic_in_txn.osize  = arithmetic_vif.cb_mon.osize;
                arithmetic_in_txn.opcode = arithmetic_vif.cb_mon.opcode;
                arithmetic_in_txn.len    = arithmetic_vif.cb_mon.len;
            `else 
                arithmetic_in_txn.osize  = get_osize(arithmetic_vif.cb_mon.srca.merge); 
                arithmetic_in_txn.opcode = get_arithmetic_opcode();
                arithmetic_in_txn.len    = get_len(arithmetic_in_txn.osize);
            `endif// RISCV_V_INST 
            rtl_in_ap.write(arithmetic_in_txn);
        end
        //Set keys to process result
        in_sem[ARITHMETIC_ALU].put(out_sem_keys);
        
    endtask: mon_in_arithmetic

    virtual task mon_in_mask();
        riscv_v_mask_alu_in_seq_item mask_in_txn;
        @(mask_vif.cb_mon);
        in_sem[MASK_ALU].get(in_sem_keys);
        if (is_mask_op()) begin
            `uvm_info(get_name(), "Transaction captured in mask_alu in port", UVM_HIGH);
            mask_in_txn = riscv_v_mask_alu_in_seq_item::type_id::create("mask_in_txn", this);
            mask_in_txn.srca_mask           = mask_vif.cb_mon.srca;
            mask_in_txn.srcb_mask           = mask_vif.cb_mon.srcb;
            `ifdef RISCV_V_INST 
                mask_in_txn.opcode          = mask_vif.cb_mon.opcode;
            `else 
                mask_in_txn.opcode          = get_mask_opcode();
            `endif //RISCV_V_INST  
            rtl_in_ap.write(mask_in_txn);
        end
        //Set Keys to process result
        in_sem[MASK_ALU].put(out_sem_keys);
    endtask: mon_in_mask

    virtual task mon_in_permutation();
        riscv_v_permutation_alu_in_seq_item permutation_in_txn;
        @(permutation_vif.cb_mon);
        in_sem[PERMUTATION_ALU].get(in_sem_keys);
        if (is_permutation_op()) begin
            `uvm_info(get_name(), "Transaction captured in permutation_alu in port", UVM_HIGH);
            permutation_in_txn = riscv_v_permutation_alu_in_seq_item::type_id::create("permutation_in_txn", this);
            permutation_in_txn.srca                 = permutation_vif.cb_mon.srca;
            permutation_in_txn.srcb                 = permutation_vif.cb_mon.srcb;
            `ifdef RISCV_V_INST
                permutation_in_txn.opcode           = permutation_vif.cb_mon.opcode;
                permutation_in_txn.osize            = permutation_vif.cb_mon.osize;
            `else 
                permutation_in_txn.opcode           = get_permutation_opcode();
                permutation_in_txn.osize            = get_osize(permutation_vif.cb_mon.srcb.merge);
            `endif
            rtl_in_ap.write(permutation_in_txn);
        end
        //Set Keys to process result
        in_sem[PERMUTATION_ALU].put(out_sem_keys);
    endtask: mon_in_permutation

    virtual task mon_rtl_out();
        fork
            begin
                forever mon_out_logic();
            end
            begin
                forever mon_out_arithmetic();
            end
            begin
                forever mon_out_mask();
            end
            begin
                forever mon_out_permutation();
            end
        join
    endtask: mon_rtl_out

    virtual task mon_out_logic();
        riscv_v_alu_out_seq_item logic_out_txn;
        @(logic_vif.cb_mon);
        //Input transaction is processed before result
        in_sem[LOGIC_ALU].get(out_sem_keys);
        if (is_logic_op()) begin
            `uvm_info(get_name(), "Transaction captured in logic_alu out port", UVM_HIGH);
            logic_out_txn = riscv_v_alu_out_seq_item::type_id::create("logic_out_txn", this);
            logic_out_txn.result = logic_vif.cb_mon.result;
            logic_out_txn.ALU    = LOGIC_ALU;
            rtl_out_ap.write(logic_out_txn);
        end
        in_sem[LOGIC_ALU].put(in_sem_keys);
    endtask: mon_out_logic

    virtual task mon_out_arithmetic();
        riscv_v_alu_out_seq_item arithmetic_out_txn;
        @(arithmetic_vif.cb_mon);
        //Input transaction is processed before result
        in_sem[ARITHMETIC_ALU].get(out_sem_keys);
        if (is_arithmetic_op()) begin
            `uvm_info(get_name(), "Transaction captured in arithmetic_alu out port", UVM_HIGH);
            arithmetic_out_txn = riscv_v_alu_out_seq_item::type_id::create("arithmetic_out_txn", this);
            arithmetic_out_txn.result = arithmetic_vif.cb_mon.result;
            arithmetic_out_txn.zf     = arithmetic_vif.cb_mon.zf;
            arithmetic_out_txn.of     = arithmetic_vif.cb_mon.of;
            arithmetic_out_txn.cf     = arithmetic_vif.cb_mon.cf;
            arithmetic_out_txn.ALU    = ARITHMETIC_ALU;
            rtl_out_ap.write(arithmetic_out_txn);
        end
        in_sem[ARITHMETIC_ALU].put(in_sem_keys);
    endtask: mon_out_arithmetic

    virtual task mon_out_mask();
        riscv_v_mask_alu_out_seq_item mask_out_txn;
        @(arithmetic_vif.cb_mon);
        //Input trasnaction is processsed before result
        in_sem[MASK_ALU].get(out_sem_keys);
        if (is_mask_op()) begin
            `uvm_info(get_name(), "Transaction captured in mask_alu out port", UVM_HIGH);
            mask_out_txn = riscv_v_mask_alu_out_seq_item::type_id::create("mask_out_txn", this);
            mask_out_txn.result_mask = mask_vif.cb_mon.result;
            mask_out_txn.ALU         = MASK_ALU;
            rtl_out_ap.write(mask_out_txn);
        end
        in_sem[MASK_ALU].put(in_sem_keys);
    endtask: mon_out_mask

    virtual task mon_out_permutation();
        riscv_v_permutation_alu_out_seq_item permutation_out_txn;
        @(permutation_vif.cb_mon);
        //Input transaction is processed before result
        in_sem[PERMUTATION_ALU].get(out_sem_keys);
        if (is_permutation_op()) begin
            `uvm_info(get_name(), "Transaction captured in permutation_alu out port", UVM_HIGH);
            permutation_out_txn = riscv_v_permutation_alu_out_seq_item::type_id::create("riscv_v_permutation_alu_out_seq_item", this);
            permutation_out_txn.integer_data_out = permutation_vif.cb_mon.integer_data_out;
            permutation_out_txn.vector_data_out  = permutation_vif.cb_mon.vector_data_out;
            permutation_out_txn.ALU              = PERMUTATION_ALU;
            rtl_out_ap.write(permutation_out_txn);
        end
        in_sem[PERMUTATION_ALU].put(in_sem_keys);
    endtask: mon_out_permutation

    virtual function riscv_v_osize_e get_osize(riscv_v_merge_data_t merge);
        if (!merge[0]) begin
            return OSIZE_8;
        end else if (!merge[1]) begin
            return OSIZE_16;
        end else if (!merge[3]) begin
            return OSIZE_32;
        end else if (!merge[7]) begin
            return OSIZE_64;
        end else if (!merge[15]) begin
            return OSIZE_128;
        end
    endfunction: get_osize

    virtual function riscv_v_opcode_e get_logic_opcode();
        unique case(3'b111)
            {1'b1,                      logic_vif.cb_mon.is_reduct,  (logic_vif.cb_mon.is_and & ~logic_vif.cb_mon.is_mask)} : return BW_AND_REDUCT;
            {1'b1,                      ~logic_vif.cb_mon.is_reduct, (logic_vif.cb_mon.is_and & ~logic_vif.cb_mon.is_mask)} : return BW_AND;
            {1'b1,                      logic_vif.cb_mon.is_reduct,  (logic_vif.cb_mon.is_or  & ~logic_vif.cb_mon.is_mask)} : return BW_OR_REDUCT;
            {1'b1,                      ~logic_vif.cb_mon.is_reduct, (logic_vif.cb_mon.is_or  & ~logic_vif.cb_mon.is_mask)} : return BW_OR;
            {1'b1,                      logic_vif.cb_mon.is_reduct,  (logic_vif.cb_mon.is_xor & ~logic_vif.cb_mon.is_mask)} : return BW_XOR_REDUCT;
            {1'b1,                      ~logic_vif.cb_mon.is_reduct, (logic_vif.cb_mon.is_xor & ~logic_vif.cb_mon.is_mask)} : return BW_XOR;
            {logic_vif.cb_mon.is_shift, logic_vif.cb_mon.is_left,    1'b1}                                                  : return SLL;
            {logic_vif.cb_mon.is_shift, ~logic_vif.cb_mon.is_left,   ~logic_vif.cb_mon.is_arith}                            : return SRL;
            {logic_vif.cb_mon.is_shift, ~logic_vif.cb_mon.is_left,   logic_vif.cb_mon.is_arith}                             : return SRA;
            default                                                                                                         : return NOP;
        endcase
    endfunction: get_logic_opcode

    virtual function riscv_v_opcode_e get_arithmetic_opcode();
        if (arithmetic_vif.cb_mon.is_max) begin
            if (arithmetic_vif.cb_mon.is_signed) begin
                if (arithmetic_vif.cb_mon.is_reduct) begin
                    return MAXS_REDUCT;
                end else begin
                    return MAXS;
                end
            end else begin
                if (arithmetic_vif.cb_mon.is_reduct) begin
                    return MAXU_REDUCT;
                end else begin
                    return MAXU;
                end
            end
            
        end else if (arithmetic_vif.cb_mon.is_min) begin
            if (arithmetic_vif.cb_mon.is_signed) begin
                if (arithmetic_vif.cb_mon.is_reduct) begin
                    return MINU_REDUCT;
                end else begin
                    return MINU;
                end
            end else begin
                if (arithmetic_vif.cb_mon.is_reduct) begin
                    return MINS_REDUCT;
                end else begin
                    return MINS;
                end
            end
        end else if (arithmetic_vif.cb_mon.is_zero_ext) begin
            return ZERO_EXT;
        end else if (arithmetic_vif.cb_mon.is_sign_ext) begin
            return SIGN_EXT;
        end else if (arithmetic_vif.cb_mon.is_add) begin
            if (arithmetic_vif.cb_mon.use_carry) begin
                return ADDC;
            end else if (arithmetic_vif.cb_mon.is_reduct) begin
                return ADD_REDUCT;
            end else begin
                return ADD;
            end
        end else if (arithmetic_vif.cb_mon.is_sub) begin
            if (arithmetic_vif.cb_mon.use_carry) begin
                return SUBB;
            end else if (arithmetic_vif.cb_mon.is_reduct) begin
                return SUB_REDUCT;
            end else begin
                return SUB;
            end
        end else if (arithmetic_vif.cb_mon.is_mul) begin
            if (arithmetic_vif.cb_mon.is_signed) begin
                if (arithmetic_vif.cb_mon.is_high) begin
                    return MULHS;
                end else begin
                    return MULLS;
                end
            end else begin
                if (arithmetic_vif.cb_mon.is_high) begin
                    return MULHU;
                end else begin
                    return MULLU;
                end
            end
        end else if (arithmetic_vif.cb_mon.is_set_equal) begin
            if (arithmetic_vif.cb_mon.is_set_less) begin
                if (arithmetic_vif.cb_mon.is_signed) begin
                    return SLE;
                end else begin
                    return SLEU;
                end
            end else  begin
                return SEQ;
            end
        end else if (arithmetic_vif.cb_mon.is_set_nequal) begin
            return SNE;
        end else if (arithmetic_vif.cb_mon.is_set_less) begin
            if (arithmetic_vif.cb_mon.is_signed) begin
                return SLT;
            end else begin
                return SLTU;
            end
        end else if (arithmetic_vif.cb_mon.is_set_greater) begin
            if (arithmetic_vif.cb_mon.is_signed) begin
                return SGT;
            end else begin
                return SGTU;
            end
        end else begin
            return NOP;
        end
    endfunction: get_arithmetic_opcode

    virtual function riscv_v_opcode_e get_mask_opcode();
        unique case(3'b111)
            {~mask_vif.cb_mon.is_negate_result,     ~mask_vif.cb_mon.is_negate_srca,    mask_vif.cb_mon.is_and} : return MAND;
            {mask_vif.cb_mon.is_negate_result,      ~mask_vif.cb_mon.is_negate_srca,    mask_vif.cb_mon.is_and} : return MNAND;
            {~mask_vif.cb_mon.is_negate_result,     mask_vif.cb_mon.is_negate_srca,     mask_vif.cb_mon.is_and} : return MANDN;
            {~mask_vif.cb_mon.is_negate_result,     ~mask_vif.cb_mon.is_negate_srca,    mask_vif.cb_mon.is_or}  : return MOR;
            {mask_vif.cb_mon.is_negate_result,      ~mask_vif.cb_mon.is_negate_srca,    mask_vif.cb_mon.is_or}  : return MNOR;
            {~mask_vif.cb_mon.is_negate_result,     mask_vif.cb_mon.is_negate_srca,     mask_vif.cb_mon.is_or}  : return MORN;
            {~mask_vif.cb_mon.is_negate_result,     ~mask_vif.cb_mon.is_negate_srca,    mask_vif.cb_mon.is_xor} : return MXOR;
            {mask_vif.cb_mon.is_negate_result,      ~mask_vif.cb_mon.is_negate_srca,    mask_vif.cb_mon.is_xor} : return MXNOR;
            default : return NOP;
        endcase
    endfunction: get_mask_opcode

    virtual function riscv_v_opcode_e get_permutation_opcode();
        unique case(1'b1)
            permutation_vif.cb_mon.is_i2v   : return I2V;
            permutation_vif.cb_mon.is_v2i   : return V2I;
            default : return NOP;
        endcase
    endfunction: get_permutation_opcode

    virtual function riscv_v_src_len_t get_len(riscv_v_osize_e osize);
        int num_srcb_valid = 0;
        //Number valid bits in srcb
        for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
            num_srcb_valid += logic_vif.cb_mon.srcb.valid[i];
        end
        case (osize)
            OSIZE_8: return num_srcb_valid;
            OSIZE_16: return num_srcb_valid/2;
            OSIZE_32: return num_srcb_valid/4;
            OSIZE_64: return num_srcb_valid/8;
            OSIZE_128: return num_srcb_valid/16;
            default: return 0;
        endcase
    endfunction: get_len

    virtual function bit is_logic_op();
        bit is_logic = 0;
        is_logic |= (logic_vif.cb_mon.is_and & ~logic_vif.cb_mon.is_mask);
        is_logic |= (logic_vif.cb_mon.is_or  & ~logic_vif.cb_mon.is_mask);
        is_logic |= (logic_vif.cb_mon.is_xor & ~logic_vif.cb_mon.is_mask);
        is_logic |= logic_vif.cb_mon.is_shift;
        return is_logic;
    endfunction: is_logic_op

    virtual function bit is_arithmetic_op();
        bit is_arithmetic = 0;
        is_arithmetic |= arithmetic_vif.cb_mon.is_add;
        is_arithmetic |= arithmetic_vif.cb_mon.is_sub;
        is_arithmetic |= arithmetic_vif.cb_mon.is_mul;
        is_arithmetic |= arithmetic_vif.cb_mon.is_zero_ext;
        is_arithmetic |= arithmetic_vif.cb_mon.is_sign_ext;
        is_arithmetic |= arithmetic_vif.cb_mon.is_max;
        is_arithmetic |= arithmetic_vif.cb_mon.is_min;
        is_arithmetic |= arithmetic_vif.cb_mon.is_set_equal;
        is_arithmetic |= arithmetic_vif.cb_mon.is_set_nequal;
        is_arithmetic |= arithmetic_vif.cb_mon.is_set_less;
        is_arithmetic |= arithmetic_vif.cb_mon.is_set_greater;
        return is_arithmetic;
    endfunction: is_arithmetic_op

    virtual function bit is_mask_op();
        bit is_mask = 0;
        is_mask |= mask_vif.cb_mon.is_mask;
        return is_mask;
    endfunction: is_mask_op

    virtual function bit is_permutation_op();
        bit is_permutation = 0;
        is_permutation |= permutation_vif.cb_mon.is_i2v;
        is_permutation |= permutation_vif.cb_mon.is_v2i;
        return is_permutation;
    endfunction: is_permutation_op

    //Get interface
    virtual function void get_vif();
        if (!uvm_config_db#(virtual riscv_v_logic_ALU_if)::get(this, "*", interfaces_names[LOGIC_ALU], logic_vif)) begin
        `uvm_fatal(get_name(), $sformatf("NO_VIF: virtual interface must be set for: %s", interfaces_names[LOGIC_ALU]));
        end
        if (!uvm_config_db#(virtual riscv_v_arithmetic_ALU_if)::get(this, "*", interfaces_names[ARITHMETIC_ALU], arithmetic_vif)) begin
        `uvm_fatal(get_name(), $sformatf("NO_VIF: virtual interface must be set for: %s", interfaces_names[ARITHMETIC_ALU]));
        end
        if (!uvm_config_db#(virtual riscv_v_mask_ALU_if)::get(this, "*", interfaces_names[MASK_ALU], mask_vif)) begin
        `uvm_fatal(get_name(), $sformatf("NO_VIF: virtual interface must be set for: %s", interfaces_names[MASK_ALU]));
        end
        if (!uvm_config_db#(virtual riscv_v_permutation_ALU_if)::get(this, "*", interfaces_names[PERMUTATION_ALU], permutation_vif)) begin
        `uvm_fatal(get_name(), $sformatf("NO_VIF: virtual interface must be set for: %s", interfaces_names[PERMUTATION_ALU]));
        end
    endfunction: get_vif

endclass: riscv_v_alu_mon

`endif // __RISCV_V_ALU_MON_SV__