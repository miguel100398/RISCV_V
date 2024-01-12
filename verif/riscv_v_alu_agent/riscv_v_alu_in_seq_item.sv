//File: riscv_v_alu_seq_item
//Author: Miguel Bucio
//Date: 11/06/23
//Description: RISC-V Vector extension ALU in sequence item

`ifndef __RISCV_V_ALU_IN_SEQ_ITEM__
`define __RISCV_V_ALU_IN_SEQ_ITEM__ 

class riscv_v_alu_in_seq_item extends riscv_v_base_seq_item;
    rand riscv_v_alu_data_t         srca;
    rand riscv_v_alu_data_t         srcb;
    rand riscv_v_osize_e            osize;
    rand riscv_v_opcode_e           opcode;
    rand riscv_v_src_len_t          len;
    rand osize_vector_t             dst_osize_vector;
    rand osize_vector_t             src_osize_vector;
    rand osize_vector_t             is_greater_osize_vector;
    rand osize_vector_t             is_less_osize_vector;

    `uvm_object_utils_begin(riscv_v_alu_in_seq_item)
        `uvm_field_enum(riscv_v_opcode_e, opcode,   UVM_ALL_ON)
        `uvm_field_enum(riscv_v_osize_e,  osize,    UVM_ALL_ON)
        `uvm_field_int(len,                         UVM_ALL_ON)
        `uvm_field_int(dst_osize_vector,            UVM_ALL_ON)
        `uvm_field_int(src_osize_vector,            UVM_ALL_ON)
        `uvm_field_int(is_greater_osize_vector,     UVM_ALL_ON)
        `uvm_field_int(is_less_osize_vector,        UVM_ALL_ON)
        `uvm_field_int(srca.data,                   UVM_ALL_ON)
        `uvm_field_int(srca.merge,                  UVM_ALL_ON)
        `uvm_field_int(srca.valid,                  UVM_ALL_ON)
        `uvm_field_int(srcb.data,                   UVM_ALL_ON)
        `uvm_field_int(srcb.merge,                  UVM_ALL_ON)
        `uvm_field_int(srcb.valid,                  UVM_ALL_ON)
    `uvm_object_utils_end

    //Constructor 
    function new (string name = "riscv_v_alu_in_seq_item");
        super.new(name);
    endfunction: new

    function void post_randomize();
        constraint_len();
        constraint_valid();
        constraint_merge();
        constraint_is_greater_osize_vector();
        constraint_is_less_osize_vector();
        constraint_src_osize_vector();
    endfunction: post_randomize

    virtual function void constraint_len();
        case(osize)
            OSIZE_8: begin
                std::randomize(len) with {
                    len <= (RISCV_V_NUM_BYTES_DATA);
                };
            end
            OSIZE_16: begin
                std::randomize(len) with {
                    len <= (RISCV_V_NUM_BYTES_DATA/2);
                };
            end
            OSIZE_32: begin
                std::randomize(len) with {
                    len <= (RISCV_V_NUM_BYTES_DATA/4);
                };
            end
            OSIZE_64: begin
                std::randomize(len) with {
                    len <= (RISCV_V_NUM_BYTES_DATA/8);
                };
            end
            OSIZE_128: begin
                std::randomize(len) with {
                    len <= (RISCV_V_NUM_BYTES_DATA/16);
                };
            end
        endcase
    endfunction: constraint_len

    virtual function void constraint_valid();
        case(osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    std::randomize(srca.valid[i]);
                    srca.valid[i] &= (len > i);
                    srcb.valid[i] = srca.valid[i];
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    std::randomize(srca.valid[i*2]);
                    srca.valid[i*2]      &= (len > i);
                    srca.valid[i*2 +: 2] = {2{srca.valid[i*2]}};
                    srcb.valid[i*2 +: 2] = {2{srca.valid[i*2]}};
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    std::randomize(srca.valid[i*4]);
                    srca.valid[i*4]      &= (len > i);
                    srca.valid[i*4 +: 4] = {4{srca.valid[i*4]}};
                    srcb.valid[i*4 +: 4] = {4{srca.valid[i*4]}};
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    std::randomize(srca.valid[i*8]);
                    srca.valid[i*8]      &= (len > i);
                    srca.valid[i*8 +: 8] = {8{srca.valid[i*8]}};
                    srcb.valid[i*8 +: 8] = {8{srca.valid[i*8]}};
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    std::randomize(srca.valid[i*16]);
                    srca.valid[i*16]       &= (len > i);
                    srca.valid[i*16 +: 16] = {16{srca.valid[i*16]}};
                    srcb.valid[i*16 +: 16] = {16{srca.valid[i*16]}};
                end
            end
            default: begin
                `uvm_fatal(get_name(), $sformatf("Invalid OSIZE: %s", osize.name()))
            end
        endcase
    endfunction: constraint_valid

    virtual function void constraint_merge();
        case(osize)
            OSIZE_8: begin
                srca.merge = '0;
                srcb.merge = '0;
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    srca.merge[i*2 +: 2] = 2'b01;
                    srcb.merge[i*2 +: 2] = 2'b01;
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    srca.merge[i*4 +: 4] = 4'b0111;
                    srcb.merge[i*4 +: 4] = 4'b0111;
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    srca.merge[i*8 +: 8] = 8'b01111111;
                    srcb.merge[i*8 +: 8] = 8'b01111111;
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    srca.merge[i*16 +: 16] = 16'b0111111111111111;
                    srcb.merge[i*16 +: 16] = 16'b0111111111111111;
                end
            end
            default: begin
                `uvm_fatal(get_name(), $sformatf("Invalid Osize: %s", osize.name()))
            end
        endcase
    endfunction: constraint_merge

    virtual function void constraint_is_greater_osize_vector();
        //Bit 0 is always 1 since all osizes are greater than osize0
        is_greater_osize_vector[0] = 1'b1;
        /*
        //Lower half
        for (int idx=1; idx <= (RISCV_V_NUM_VALID_OSIZES/2); idx++) begin
            is_greater_osize_vector[idx] = ~(|osize_vector[0 +: idx]);
        end
        //Upper half
        for (int idx=(RISCV_V_NUM_VALID_OSIZES/2)+1; idx < RISCV_V_NUM_VALID_OSIZES; idx++) begin
            is_greater_osize_vector[idx] = |osize_vector[RISCV_V_NUM_VALID_OSIZES-1 -: RISCV_V_NUM_VALID_OSIZES-idx];
        end
        */
        for (int idx=1; idx <= (RISCV_V_NUM_VALID_OSIZES); idx++) begin
            is_greater_osize_vector[idx] = (dst_osize_vector >= (2**(idx)));
        end
    endfunction: constraint_is_greater_osize_vector

    virtual function void constraint_is_less_osize_vector();
        for (int idx=0; idx < RISCV_V_NUM_VALID_OSIZES-1; idx++) begin
            is_less_osize_vector[idx] = ~is_greater_osize_vector[idx+1];
        end
        //MSB is always 1 since all osizes are less than MAX_OSIZE+1
        is_less_osize_vector[RISCV_V_NUM_VALID_OSIZES-1] = 1'b1;
    endfunction: constraint_is_less_osize_vector

    virtual function void constraint_src_osize_vector();
        src_osize_vector = dst_osize_vector;

        if (opcode inside {SIGN_EXT, ZERO_EXT}) begin
            int shift_cnt;
            int max_shift_cnt;
            case (osize)
                OSIZE_8:   max_shift_cnt = 0;
                OSIZE_16:  max_shift_cnt = 1;
                OSIZE_32:  max_shift_cnt = 2;
                OSIZE_64:  max_shift_cnt = 3;
                OSIZE_128: max_shift_cnt = 4;
                default:   `uvm_fatal(get_name(), "Invalid OSIZE")
            endcase
            assert(std::randomize(shift_cnt) with {
                shift_cnt >= 0;
                shift_cnt <= max_shift_cnt;
            }) else `uvm_fatal(get_name(), "can't randomize shift_cnt for src_osize_vector")

            src_osize_vector = 1 << shift_cnt;
        end

    endfunction: constraint_src_osize_vector

    //Constraint osize
    constraint osize_c { osize inside {OSIZE_8, OSIZE_16, OSIZE_32, OSIZE_64, OSIZE_128};}
    //constraint osize_c { osize inside {OSIZE_64};}

    constraint dst_osize_vector_c {
        {dst_osize_vector[0] == (osize==OSIZE_8)};
        {dst_osize_vector[1] == (osize==OSIZE_16)};
        {dst_osize_vector[2] == (osize==OSIZE_32)};
        {dst_osize_vector[3] == (osize==OSIZE_64)};
        {dst_osize_vector[4] == (osize==OSIZE_128)};
    };
/*
    constraint dst_osize_vector_one_hot_c {
        $countones(dst_osize_vector) == 1;
    };

    constraint src_osize_vector_c {
        if (opcode inside {SIGN_EXT, ZERO_EXT}){
            src_osize_vector <= dst_osize_vector;
        } else {
            src_osize_vector == dst_osize_vector;
        }
    };

    constraint src_osize_vector_one_hot_c {
        $countones(src_osize_vector) == 1;
    };

    constraint src_valid_osize {
        if (osize == OSIZE_8){
            {srca.valid == srcb.valid};
        }
        else if (osize == OSIZE_16){
            //srca
            {srca.valid[1]  == srca.valid[0]};
            {srca.valid[3]  == srca.valid[2]};
            {srca.valid[5]  == srca.valid[4]};
            {srca.valid[7]  == srca.valid[6]};
            {srca.valid[9]  == srca.valid[8]};
            {srca.valid[11] == srca.valid[10]};
            {srca.valid[13] == srca.valid[12]};
            {srca.valid[15] == srca.valid[14]};
            //srcb
            {srcb.valid[1]  == srca.valid[0]};
            {srcb.valid[3]  == srca.valid[2]};
            {srcb.valid[5]  == srca.valid[4]};
            {srcb.valid[7]  == srca.valid[6]};
            {srcb.valid[9]  == srca.valid[8]};
            {srcb.valid[11] == srca.valid[10]};
            {srcb.valid[13] == srca.valid[12]};
            {srcb.valid[15] == srca.valid[14]}; 
        } else if (osize == OSIZE_32){
            //srca
            {srca.valid[0  +: 4] == ({4{srca.valid[0]}})};
            {srca.valid[4  +: 4] == ({4{srca.valid[4]}})};
            {srca.valid[8  +: 4] == ({4{srca.valid[8]}})};
            {srca.valid[12 +: 4] == ({4{srca.valid[12]}})};
            //srcb
            {srcb.valid[0  +: 4] == ({4{srca.valid[0]}})};
            {srcb.valid[4  +: 4] == ({4{srca.valid[4]}})};
            {srcb.valid[8  +: 4] == ({4{srca.valid[8]}})};
            {srcb.valid[12 +: 4] == ({4{srca.valid[12]}})};

        } else if (osize == OSIZE_64){
            //srca
            {srca.valid[0 +: 8] == ({8{srca.valid[0]}})};
            {srca.valid[8 +: 8] == ({8{srca.valid[8]}})};
            //srcb
            {srcb.valid[0 +: 8] == ({8{srcb.valid[0]}})};
            {srcb.valid[8 +: 8] == ({8{srcb.valid[8]}})};
        } else if (osize == OSIZE_128){
            //srca
            {srca.valid[0 +: 16] == ({16{srca.valid[0]}})};
            //srcb
            {srcb.valid[0 +: 16] == ({16{srcb.valid[0]}})};
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