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
    virtual riscv_v_logic_ALU_if logic_vif;

    function new(string name = "riscv_v_alu_mon", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Create semaphores
        in_sem[LOGIC_ALU] = new(in_sem_keys);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask: run_phase

    virtual task mon_rtl_in();
        fork
            begin
                forever mon_in_logic();
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
            logic_in_txn.srca   = logic_vif.cb_mon.srca;
            logic_in_txn.srcb   = logic_vif.cb_mon.srcb;
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

    virtual task mon_rtl_out();
        fork
            begin
                forever mon_out_logic();
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
        if (logic_vif.cb_mon.is_and && logic_vif.cb_mon.is_reduct) begin
            return BW_AND_REDUCT;
        end else if (logic_vif.cb_mon.is_and) begin
            return BW_AND;
        end else begin
            return NOP;
        end
    endfunction: get_logic_opcode

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
        return logic_vif.cb_mon.is_and;
    endfunction: is_logic_op

    //Get interface
    virtual function void get_vif();
        if (!uvm_config_db#(virtual riscv_v_logic_ALU_if)::get(this, "*", "riscv_v_logic_alu_vif", logic_vif)) begin
            `uvm_fatal("NO_VIF", "virtual interface must be set for: riscv_v_logic_alu_vif");
        end
    endfunction: get_vif

endclass: riscv_v_alu_mon

`endif // __RISCV_V_ALU_MON_SV__