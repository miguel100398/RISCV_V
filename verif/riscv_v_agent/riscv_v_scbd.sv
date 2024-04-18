//File: riscv_v_scbd
//Author: Miguel Bucio
//Date: 10/02/24
//Description: RISC-Vregister file Scoreboard

`ifndef __RISCV_V_SCBD_SV__
`define __RISCV_V_SCBD_SV__ 

class riscv_v_scbd extends riscv_v_base_scbd#(
    .seq_item_in_t(riscv_v_in_seq_item),
    .seq_item_out_t(riscv_v_out_seq_item),
    .model_t(riscv_v_model)
);

    `uvm_component_utils(riscv_v_scbd)

    bit compare_en;
    bit wr_vec_exp;
    riscv_v_rf_wr_en_t vec_rf_wr_en_exp;
    riscv_v_rf_addr_t  vec_rf_wr_addr_exp;
    riscv_v_data_t     vec_rf_wr_data_exp;
    bit wr_int_exp;
    riscv_rf_addr_t int_wr_addr_exp;
    riscv_data_t    int_wr_data_exp;


    function new(string name = "riscv_v_scbd", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new    

    //Write port
    virtual function void calc_in();
        
        //Check only 1 wr_en is set at time
        if (!$onehot0({txn_in.ext_wr_vsstatus, txn_in.ext_wr_vtype, txn_in.ext_wr_vl, txn_in.ext_wr_vstart, txn_in.ext_wr_vxrm, txn_in.ext_wr_vxsat})) begin
            `uvm_error(get_name(), $sformatf("More than 1 ext_csr_write asserted at time: {vstatus, vtype, vl, vstart, vxrm, vxsat }%0b",
            {txn_in.ext_wr_vsstatus, txn_in.ext_wr_vtype, txn_in.ext_wr_vl, txn_in.ext_wr_vstart, txn_in.ext_wr_vxrm, txn_in.ext_wr_vxsat}))
            fail();
        end

        //Write External csr
        model.update_ext_csr(
            .ext_data_in(txn_in.ext_data_in),
            .ext_wr_vsstatus(txn_in.ext_wr_vsstatus),
            .ext_wr_vtype(txn_in.ext_wr_vtype),
            .ext_wr_vl(txn_in.ext_wr_vl),
            .ext_wr_vstart(txn_in.ext_wr_vstart),
            .ext_wr_vxrm(txn_in.ext_wr_vxrm),
            .ext_wr_vxsat(txn_in.ext_wr_vxsat)
        );

        //Execute instruction
        compare_en = model.execute_v_instruction(
            .instr(txn_in.instruction),
            .src_int(txn_in.int_rf_rd_data),
            .wr_vec(wr_vec_exp),
            .vec_wr_en(vec_rf_wr_en_exp),
            .vec_wr_addr(vec_rf_wr_addr_exp),
            .vec_wr_data(vec_rf_wr_data_exp),
            .wr_int(wr_int_exp),
            .int_wr_addr(int_wr_addr_exp),
            .int_wr_data(int_wr_data_exp)
        );
        
    endfunction: calc_in 

    //Read port
    virtual function void calc_out();
        //Check data
        if (compare_en) begin
            
            //Check int
            check_int(txn_out.int_rf_wr_en, txn_out.int_rf_wr_data);

            //Check vec
            check_vec(txn_out.vec_rf_wr_en, txn_out.vec_rf_wr_addr, txn_out.vec_rf_wr_data);

        end

        compare_en = 1'b0;
    endfunction: calc_out

    virtual function void check_int(bit int_rf_wr_en, riscv_data_t int_rf_wr_data);
        // Check int wr_en
        if (int_rf_wr_en != wr_int_exp) begin
            `uvm_error(get_name(), $sformatf("Mismatch in int_rf_wr_en, actual: %0b, expected: %0b", int_rf_wr_en, wr_int_exp))
            fail();
        end else begin
            pass();
        end
        //Check int wr_data
        if (|{int_rf_wr_en, wr_int_exp}) begin
            if (int_rf_wr_data != int_wr_data_exp) begin
                `uvm_error(get_name(), $sformatf("Mismatch in int_rf_wr_data, actual: 0x%0h, expected: 0x%0h", int_rf_wr_data, int_wr_data_exp))
                fail();
            end else begin
                pass();
            end
        end
    endfunction: check_int

    virtual function void check_vec(riscv_v_rf_wr_en_t vec_rf_wr_en, riscv_v_rf_addr_t vec_rf_wr_addr, riscv_v_data_t vec_rf_wr_data);
        if (wr_vec_exp) begin
            
            //Check wr_en
            if (vec_rf_wr_en != vec_rf_wr_en_exp) begin
                `uvm_error(get_name(), $sformatf("Mismatch in vec_rf_wr_en, actual: 0x%0h, expected: 0x%0h", vec_rf_wr_en, vec_rf_wr_en_exp))
                fail();
            end else begin
                pass();
            end

            //Check wr_addr
            if (vec_rf_wr_addr != vec_rf_wr_addr_exp) begin
                `uvm_error(get_name(), $sformatf("Mismatchh in vec_rf_wr_addr, actual: %0d, expected: %0d", vec_rf_wr_addr, vec_rf_wr_addr_exp))
                fail();
            end else begin
                pass();
            end

            //Check wr_data
            if (vec_rf_wr_data != vec_rf_wr_data_exp) begin
                `uvm_error(get_name(), $sformatf("Mismatch in vec_rf_wr_data, actual: %0d, expected: %0d", vec_rf_wr_data, vec_rf_wr_data_exp))
                fail();
            end else begin
                pass();
            end

        end
    endfunction: check_vec


endclass: riscv_v_scbd

`endif //__RISCV_V_SCBD_SV__ 