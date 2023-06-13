//File: riscv_v_alu_seq_item
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extension ALU in sequence item

`ifndef __RISCV_V_ALU_IN_SEQ_ITEM__
`define __RISCV_V_ALU_IN_SEQ_ITEM__ 

class riscv_v_alu_in_seq_item extends riscv_v_base_seq_item;
    rand riscv_v_alu_data_t srca;
    rand riscv_v_alu_data_t srcb;
    rand riscv_v_osize_e    osize;
    rand riscv_v_opcode_e   opcode;

    `uvm_object_utils_begin(riscv_v_alu_in_seq_item)
        `uvm_field_enum(riscv_v_opcode_e, opcode,   UVM_ALL_ON)
        `uvm_field_enum(riscv_v_osize_e,  osize,   UVM_ALL_ON)
        `uvm_field_int(srca.data,   UVM_ALL_ON)
        `uvm_field_int(srca.merge,  UVM_ALL_ON)
        `uvm_field_int(srca.valid,  UVM_ALL_ON)
        `uvm_field_int(srcb.data,   UVM_ALL_ON)
        `uvm_field_int(srcb.merge,  UVM_ALL_ON)
        `uvm_field_int(srcb.valid,  UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor 
    function new (string name = "riscv_v_alu_in_seq_item");
        super.new(name);
    endfunction: new

    constraint src_valid_c {srca.valid == srcb.valid;}
    constraint src_merge_c {srca.merge == srcb.merge;}

    //Constraint osize
    constraint osize_c { osize inside {OSIZE_8, OSIZE_16, OSIZE_32, OSIZE_64, OSIZE_128};}

    /*
    constraint src_valid_osize {
        if (osize == OSIZE_16){
            //srca
            {{2{srca.valid[0]}}  == srca.valid[0  +: 2]};
            {{2{srca.valid[2]}}  == srca.valid[2  +: 2]};
            {{2{srca.valid[4]}}  == srca.valid[4  +: 2]};
            {{2{srca.valid[6]}}  == srca.valid[6  +: 2]};
            {{2{srca.valid[8]}}  == srca.valid[8  +: 2]};
            {{2{srca.valid[10]}} == srca.valid[10 +: 2]};
            {{2{srca.valid[12]}} == srca.valid[12 +: 2]};
            {{2{srca.valid[14]}} == srca.valid[14 +: 2]};
            //srcb
            {{2{srcb.valid[0]}}  == srcb.valid[0  +: 2]};
            {{2{srcb.valid[2]}}  == srcb.valid[2  +: 2]};
            {{2{srcb.valid[4]}}  == srcb.valid[4  +: 2]};
            {{2{srcb.valid[6]}}  == srcb.valid[6  +: 2]};
            {{2{srcb.valid[7]}}  == srcb.valid[8  +: 2]};
            {{2{srcb.valid[10]}} == srcb.valid[10 +: 2]};
            {{2{srcb.valid[12]}} == srcb.valid[12 +: 2]};
            {{2{srcb.valid[14]}} == srcb.valid[14 +: 2]};
        } else if (osize == OSIZE_32){
            //srca
            {{4{srca.valid[0]}}  == srca.valid[0  +: 4]};
            {{4{srca.valid[4]}}  == srca.valid[4  +: 4]};
            {{4{srca.valid[8]}}  == srca.valid[8  +: 4]};
            {{4{srca.valid[12]}} == srca.valid[12 +: 4]};
            //srcb
            {{4{srcb.valid[0]}}  == srcb.valid[0  +: 4]};
            {{4{srcb.valid[4]}}  == srcb.valid[4  +: 4]};
            {{4{srcb.valid[8]}}  == srcb.valid[8  +: 4]};
            {{4{srcb.valid[12]}} == srcb.valid[12 +: 4]};
        } else if (osize == OSIZE_64){
            //srca
            {{8{srca.valid[0]}}  == srca.valid[0 +: 8]};
            {{8{srca.valid[8]}}  == srca.valid[8 +: 8]};
            //srcb
            {{8{srcb.valid[0]}}  == srcb.valid[0 +: 8]};
            {{8{srcb.valid[8]}}  == srcb.valid[8 +: 8]};
        } else if (osize == OSIZE_128){
            //srca
            {{16{srca.valid[0]}} == srca.valid[0 +: 16]};
            //srcb
            {{16{srcb.valid[0]}} == srcb.valid[0 +: 16]};
        }
    }

    constraint src_merge_osize {
        if (osize == OSIZE_8){
            {srca.merge == '0};
            {srcb.merge == '0};
        }
        else if (osize == OSIZE_16){
            //srca
            {srca.merge[0  +: 2] == 2'b01};
            {srca.merge[2  +: 2] == 2'b01};
            {srca.merge[4  +: 2] == 2'b01};
            {srca.merge[6  +: 2] == 2'b01};
            {srca.merge[8  +: 2] == 2'b01};
            {srca.merge[10 +: 2] == 2'b01};
            {srca.merge[12 +: 2] == 2'b01};
            {srca.merge[14 +: 2] == 2'b01};
            //srcb
            {srcb.merge[0  +: 2] == 2'b01};
            {srcb.merge[2  +: 2] == 2'b01};
            {srcb.merge[4  +: 2] == 2'b01};
            {srcb.merge[6  +: 2] == 2'b01};
            {srcb.merge[8  +: 2] == 2'b01};
            {srcb.merge[10 +: 2] == 2'b01};
            {srcb.merge[12 +: 2] == 2'b01};
            {srcb.merge[14 +: 2] == 2'b01};
        } else if (osize == OSIZE_32){
            //srca
            {srca.merge[0 +: 4]  == 4'b0111};
            {srca.merge[4 +: 4]  == 4'b0111};
            {srca.merge[8 +: 4]  == 4'b0111};
            {srca.merge[12 +: 4] == 4'b0111};
            //srcb
            {srcb.merge[0 +: 4]  == 4'b0111};
            {srcb.merge[4 +: 4]  == 4'b0111};
            {srcb.merge[8 +: 4]  == 4'b0111};
            {srcb.merge[12 +: 4] == 4'b0111};
        } else if (osize == OSIZE_64){
            //srca
            {srca.merge[0 +: 8] == 7'b01111111};
            {srca.merge[8 +: 8] == 7'b01111111};
            //srcb
            {srca.merge[0 +: 8] == 7'b01111111};
            {srca.merge[8 +: 8] == 7'b01111111};
        } else if (osize == OSIZE_128){
            //srca
            {srca.merge[0 +: 16] == 16'b0111111111111111};
            {srcb.merge[0 +: 16] == 16'b0111111111111111};
        }
    }
    */

endclass: riscv_v_alu_in_seq_item

`endif // __RISCV_V_ALU_IN_SEQ_ITEM