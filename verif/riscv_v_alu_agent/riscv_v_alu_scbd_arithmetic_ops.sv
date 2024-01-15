//File: riscv_v_alu_scbd_arithmetic_ops.sv
//Author: Miguel Bucio
//Date: 30/08/23
//Description: RISC-V Vector ALU Scoreboard arithmetic ops

    virtual function void calc_addc();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    {cf_exp[i], arithmetic_exp_result.data.Byte[i]} = ((arithmetic_in_txn.srca.data.Byte[i]) + (arithmetic_in_txn.srcb.data.Byte[i]) + arithmetic_in_txn.carry_in[i]);
                    zf_exp[i] = (arithmetic_exp_result.data.Byte[i] == 0);
                    of_exp[i] = (~arithmetic_in_txn.srca.data.Byte[i][BYTE_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Byte[i][BYTE_WIDTH-1] & arithmetic_exp_result.data.Byte[i][BYTE_WIDTH-1]) ||
                                (arithmetic_in_txn.srca.data.Byte[i][BYTE_WIDTH-1]  & arithmetic_in_txn.srcb.data.Byte[i][BYTE_WIDTH-1]  & ~arithmetic_exp_result.data.Byte[i][BYTE_WIDTH-1]);
                end     
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    {cf_exp[(2*i)+1], arithmetic_exp_result.data.Word[i]} = ((arithmetic_in_txn.srca.data.Word[i]) + (arithmetic_in_txn.srcb.data.Word[i]) + arithmetic_in_txn.carry_in[2*i]);
                    zf_exp[(2*i)+1] = (arithmetic_exp_result.data.Word[i] == 0);
                    of_exp[(2*i)+1] = (~arithmetic_in_txn.srca.data.Word[i][WORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Word[i][WORD_WIDTH-1] & arithmetic_exp_result.data.Word[i][WORD_WIDTH-1]) ||
                                  (arithmetic_in_txn.srca.data.Word[i][WORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Word[i][WORD_WIDTH-1]  & ~arithmetic_exp_result.data.Word[i][WORD_WIDTH-1]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    {cf_exp[(4*i)+3], arithmetic_exp_result.data.Dword[i]} = ((arithmetic_in_txn.srca.data.Dword[i]) + (arithmetic_in_txn.srcb.data.Dword[i]) + arithmetic_in_txn.carry_in[4*i]);
                    zf_exp[(4*i)+3] = (arithmetic_exp_result.data.Dword[i] == 0);
                    of_exp[(4*i)+3] = (~arithmetic_in_txn.srca.data.Dword[i][DWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dword[i][DWORD_WIDTH-1] & arithmetic_exp_result.data.Dword[i][DWORD_WIDTH-1]) ||
                                  (arithmetic_in_txn.srca.data.Dword[i][DWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dword[i][DWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Dword[i][DWORD_WIDTH-1]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    {cf_exp[(8*i)+7], arithmetic_exp_result.data.Qword[i]} = ((arithmetic_in_txn.srca.data.Qword[i]) + (arithmetic_in_txn.srcb.data.Qword[i]) + arithmetic_in_txn.carry_in[8*i]);
                    zf_exp[(8*i)+7] = (arithmetic_exp_result.data.Qword[i] == 0);
                    of_exp[(8*i)+7] = (~arithmetic_in_txn.srca.data.Qword[i][QWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Qword[i][QWORD_WIDTH-1] & arithmetic_exp_result.data.Qword[i][QWORD_WIDTH-1]) ||
                                  (arithmetic_in_txn.srca.data.Qword[i][QWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Qword[i][QWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Qword[i][QWORD_WIDTH-1]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    {cf_exp[(16*i)+15], arithmetic_exp_result.data.Dqword[i]} = ((arithmetic_in_txn.srca.data.Dqword[i]) + (arithmetic_in_txn.srcb.data.Dqword[i]) + arithmetic_in_txn.carry_in[16*i]);
                    zf_exp[(16*i)+15] = (arithmetic_exp_result.data.Dqword[i] == 0);
                    of_exp[(16*i)+15] = (~arithmetic_in_txn.srca.data.Dqword[i][DQWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dqword[i][DQWORD_WIDTH-1] & arithmetic_exp_result.data.Dqword[i][DQWORD_WIDTH-1]) ||
                                   (arithmetic_in_txn.srca.data.Dqword[i][DQWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dqword[i][DQWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Dqword[i][DQWORD_WIDTH-1]);
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_addc

    virtual function void calc_add();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    {cf_exp[i], arithmetic_exp_result.data.Byte[i]} = ((arithmetic_in_txn.srca.data.Byte[i]) + (arithmetic_in_txn.srcb.data.Byte[i]));
                    zf_exp[i] = (arithmetic_exp_result.data.Byte[i] == 0);
                    of_exp[i] = (~arithmetic_in_txn.srca.data.Byte[i][BYTE_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Byte[i][BYTE_WIDTH-1] & arithmetic_exp_result.data.Byte[i][BYTE_WIDTH-1]) ||
                                (arithmetic_in_txn.srca.data.Byte[i][BYTE_WIDTH-1]  & arithmetic_in_txn.srcb.data.Byte[i][BYTE_WIDTH-1]  & ~arithmetic_exp_result.data.Byte[i][BYTE_WIDTH-1]);
                end     
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    {cf_exp[(2*i)+1], arithmetic_exp_result.data.Word[i]} = ((arithmetic_in_txn.srca.data.Word[i]) + (arithmetic_in_txn.srcb.data.Word[i]));
                    zf_exp[(2*i)+1] = (arithmetic_exp_result.data.Word[i] == 0);
                    of_exp[(2*i)+1] = (~arithmetic_in_txn.srca.data.Word[i][WORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Word[i][WORD_WIDTH-1] & arithmetic_exp_result.data.Word[i][WORD_WIDTH-1]) ||
                                  (arithmetic_in_txn.srca.data.Word[i][WORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Word[i][WORD_WIDTH-1]  & ~arithmetic_exp_result.data.Word[i][WORD_WIDTH-1]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    {cf_exp[(4*i)+3], arithmetic_exp_result.data.Dword[i]} = ((arithmetic_in_txn.srca.data.Dword[i]) + (arithmetic_in_txn.srcb.data.Dword[i]));
                    zf_exp[(4*i)+3] = (arithmetic_exp_result.data.Dword[i] == 0);
                    of_exp[(4*i)+3] = (~arithmetic_in_txn.srca.data.Dword[i][DWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dword[i][DWORD_WIDTH-1] & arithmetic_exp_result.data.Dword[i][DWORD_WIDTH-1]) ||
                                  (arithmetic_in_txn.srca.data.Dword[i][DWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dword[i][DWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Dword[i][DWORD_WIDTH-1]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    {cf_exp[(8*i)+7], arithmetic_exp_result.data.Qword[i]} = ((arithmetic_in_txn.srca.data.Qword[i]) + (arithmetic_in_txn.srcb.data.Qword[i]));
                    zf_exp[(8*i)+7] = (arithmetic_exp_result.data.Qword[i] == 0);
                    of_exp[(8*i)+7] = (~arithmetic_in_txn.srca.data.Qword[i][QWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Qword[i][QWORD_WIDTH-1] & arithmetic_exp_result.data.Qword[i][QWORD_WIDTH-1]) ||
                                  (arithmetic_in_txn.srca.data.Qword[i][QWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Qword[i][QWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Qword[i][QWORD_WIDTH-1]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    {cf_exp[(16*i)+15], arithmetic_exp_result.data.Dqword[i]} = ((arithmetic_in_txn.srca.data.Dqword[i]) + (arithmetic_in_txn.srcb.data.Dqword[i]));
                    zf_exp[(16*i)+15] = (arithmetic_exp_result.data.Dqword[i] == 0);
                    of_exp[(16*i)+15] = (~arithmetic_in_txn.srca.data.Dqword[i][DQWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dqword[i][DQWORD_WIDTH-1] & arithmetic_exp_result.data.Dqword[i][DQWORD_WIDTH-1]) ||
                                   (arithmetic_in_txn.srca.data.Dqword[i][DQWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dqword[i][DQWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Dqword[i][DQWORD_WIDTH-1]);
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_add

    virtual function void calc_add_reduct();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        {zf_exp, of_exp, cf_exp} = 3'b000;
        arithmetic_exp_result.data    = '0;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin

                {cf_exp[0], arithmetic_exp_result.data.Byte[0]} = ((arithmetic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1]) + (arithmetic_in_txn.srcb.data.Byte[0]));
                of_exp[0] = (~arithmetic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1][BYTE_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Byte[0][BYTE_WIDTH-1] & arithmetic_exp_result.data.Byte[0][BYTE_WIDTH-1]) ||
                            (arithmetic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1][BYTE_WIDTH-1]  & arithmetic_in_txn.srcb.data.Byte[0][BYTE_WIDTH-1]  & ~arithmetic_exp_result.data.Byte[0][BYTE_WIDTH-1]);

                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    logic [BYTE_WIDTH-1:0] tmp_result;
                    {cf_exp[0], tmp_result} = ((arithmetic_exp_result.data.Byte[0]) + (arithmetic_in_txn.srcb.data.Byte[i]));
                    of_exp[0] |= (~arithmetic_exp_result.data.Byte[0][BYTE_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Byte[i][BYTE_WIDTH-1] & tmp_result[BYTE_WIDTH-1]) ||
                                 (arithmetic_exp_result.data.Byte[0][BYTE_WIDTH-1]  & arithmetic_in_txn.srcb.data.Byte[i][BYTE_WIDTH-1]  & tmp_result[BYTE_WIDTH-1]);
                    arithmetic_exp_result.data.Byte[0] = tmp_result;
                end  

                zf_exp[0] = (arithmetic_exp_result.data.Byte[0] == 0);

            end
            OSIZE_16: begin

                {cf_exp[1], arithmetic_exp_result.data.Word[0]} = ((arithmetic_in_txn.srca.data.Word[RISCV_V_NUM_WORDS_DATA-1]) + (arithmetic_in_txn.srcb.data.Word[0]));
                of_exp[1] = (~arithmetic_in_txn.srca.data.Word[0][WORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Word[0][WORD_WIDTH-1] & arithmetic_exp_result.data.Word[0][WORD_WIDTH-1]) ||
                            (arithmetic_in_txn.srca.data.Word[0][WORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Word[0][WORD_WIDTH-1]  & ~arithmetic_exp_result.data.Word[0][WORD_WIDTH-1]);

                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    logic [WORD_WIDTH-1:0] tmp_result;
                    {cf_exp[1], tmp_result} = ((arithmetic_exp_result.data.Word[0]) + (arithmetic_in_txn.srcb.data.Word[i]));
                    of_exp[1] |= (~arithmetic_exp_result.data.Word[0][WORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Word[i][WORD_WIDTH-1] & tmp_result[WORD_WIDTH-1]) ||
                                 (arithmetic_exp_result.data.Word[0][WORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Word[i][WORD_WIDTH-1]  & tmp_result[WORD_WIDTH-1]);
                    arithmetic_exp_result.data.Word[0] = tmp_result;
                end  

                zf_exp[1] = (arithmetic_exp_result.data.Word[0] == 0);
            end
            OSIZE_32: begin

                {cf_exp[3], arithmetic_exp_result.data.Dword[0]} = ((arithmetic_in_txn.srca.data.Dword[RISCV_V_NUM_DWORDS_DATA-1]) + (arithmetic_in_txn.srcb.data.Dword[0]));
                of_exp[3] = (~arithmetic_in_txn.srca.data.Dword[0][DWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dword[0][DWORD_WIDTH-1] & arithmetic_exp_result.data.Dword[0][DWORD_WIDTH-1]) ||
                            (arithmetic_in_txn.srca.data.Dword[0][DWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dword[0][DWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Dword[0][DWORD_WIDTH-1]);

                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    logic [DWORD_WIDTH-1:0] tmp_result;
                    {cf_exp[3], tmp_result} = ((arithmetic_exp_result.data.Dword[0]) + (arithmetic_in_txn.srcb.data.Dword[i]));
                    of_exp[3] |= (~arithmetic_exp_result.data.Dword[0][DWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dword[i][DWORD_WIDTH-1] & tmp_result[DWORD_WIDTH-1]) ||
                                 (arithmetic_exp_result.data.Dword[0][DWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dword[i][DWORD_WIDTH-1]  & tmp_result[DWORD_WIDTH-1]);
                    arithmetic_exp_result.data.Dword[0] = tmp_result;
                end  

                zf_exp[3] = (arithmetic_exp_result.data.Dword[0] == 0);
            end
            OSIZE_64: begin

                {cf_exp[7], arithmetic_exp_result.data.Qword[0]} = ((arithmetic_in_txn.srca.data.Qword[RISCV_V_NUM_QWORDS_DATA-1]) + (arithmetic_in_txn.srcb.data.Qword[0]));
                of_exp[7] = (~arithmetic_in_txn.srca.data.Qword[0][QWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Qword[0][QWORD_WIDTH-1] & arithmetic_exp_result.data.Qword[0][QWORD_WIDTH-1]) ||
                            (arithmetic_in_txn.srca.data.Qword[0][QWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Qword[0][QWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Qword[0][QWORD_WIDTH-1]);

                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    logic [QWORD_WIDTH-1:0] tmp_result;
                    {cf_exp[7], tmp_result} = ((arithmetic_exp_result.data.Qword[0]) + (arithmetic_in_txn.srcb.data.Qword[i]));
                    of_exp[7] |= (~arithmetic_exp_result.data.Qword[0][QWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Qword[i][QWORD_WIDTH-1] & tmp_result[QWORD_WIDTH-1]) ||
                                 (arithmetic_exp_result.data.Qword[0][QWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Qword[i][QWORD_WIDTH-1]  & tmp_result[QWORD_WIDTH-1]);
                    arithmetic_exp_result.data.Qword[0] = tmp_result;
                end  

                zf_exp[7] = (arithmetic_exp_result.data.Qword[0] == 0);
            end
            OSIZE_128: begin
                {cf_exp[15], arithmetic_exp_result.data.Dqword[0]} = ((arithmetic_in_txn.srca.data.Dqword[RISCV_V_NUM_DQWORDS_DATA-1]) + (arithmetic_in_txn.srcb.data.Dqword[0]));
                of_exp[15] = (~arithmetic_in_txn.srca.data.Dqword[0][DQWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dqword[0][DQWORD_WIDTH-1] & arithmetic_exp_result.data.Dqword[0][DQWORD_WIDTH-1]) ||
                            (arithmetic_in_txn.srca.data.Dqword[0][DQWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dqword[0][DQWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Dqword[0][DQWORD_WIDTH-1]);

                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    logic [DQWORD_WIDTH-1:0] tmp_result;
                    {cf_exp[15], tmp_result} = ((arithmetic_exp_result.data.Dqword[0]) + (arithmetic_in_txn.srcb.data.Dqword[i]));
                    of_exp[15] |= (~arithmetic_exp_result.data.Dqword[0][DQWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dqword[i][DQWORD_WIDTH-1] & tmp_result[DQWORD_WIDTH-1]) ||
                                 (arithmetic_exp_result.data.Dqword[0][DQWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dqword[i][DQWORD_WIDTH-1]  & tmp_result[DQWORD_WIDTH-1]);
                    arithmetic_exp_result.data.Dqword[0] = tmp_result;
                end  

                zf_exp[15] = (arithmetic_exp_result.data.Dqword[0] == 0);
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_add_reduct

    virtual function void calc_subb();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    {cf_exp[i], arithmetic_exp_result.data.Byte[i]} = ((arithmetic_in_txn.srca.data.Byte[i]) - (arithmetic_in_txn.srcb.data.Byte[i]) - arithmetic_in_txn.carry_in[i]);
                    zf_exp[i] = (arithmetic_exp_result.data.Byte[i] == 0);
                    of_exp[i] = (~arithmetic_in_txn.srca.data.Byte[i][BYTE_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Byte[i][BYTE_WIDTH-1] & arithmetic_exp_result.data.Byte[i][BYTE_WIDTH-1]) ||
                                (arithmetic_in_txn.srca.data.Byte[i][BYTE_WIDTH-1]  & arithmetic_in_txn.srcb.data.Byte[i][BYTE_WIDTH-1]  & ~arithmetic_exp_result.data.Byte[i][BYTE_WIDTH-1]);
                end     
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    {cf_exp[(2*i)+1], arithmetic_exp_result.data.Word[i]} = ((arithmetic_in_txn.srca.data.Word[i]) - (arithmetic_in_txn.srcb.data.Word[i]) - arithmetic_in_txn.carry_in[2*i]);
                    zf_exp[(2*i)+1] = (arithmetic_exp_result.data.Word[i] == 0);
                    of_exp[(2*i)+1] = (~arithmetic_in_txn.srca.data.Word[i][WORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Word[i][WORD_WIDTH-1] & arithmetic_exp_result.data.Word[i][WORD_WIDTH-1]) ||
                                  (arithmetic_in_txn.srca.data.Word[i][WORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Word[i][WORD_WIDTH-1]  & ~arithmetic_exp_result.data.Word[i][WORD_WIDTH-1]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    {cf_exp[(4*i)+3], arithmetic_exp_result.data.Dword[i]} = ((arithmetic_in_txn.srca.data.Dword[i]) - (arithmetic_in_txn.srcb.data.Dword[i]) - arithmetic_in_txn.carry_in[4*i]);
                    zf_exp[(4*i)+3] = (arithmetic_exp_result.data.Dword[i] == 0);
                    of_exp[(4*i)+3] = (~arithmetic_in_txn.srca.data.Dword[i][DWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dword[i][DWORD_WIDTH-1] & arithmetic_exp_result.data.Dword[i][DWORD_WIDTH-1]) ||
                                  (arithmetic_in_txn.srca.data.Dword[i][DWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dword[i][DWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Dword[i][DWORD_WIDTH-1]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    {cf_exp[(8*i)+7], arithmetic_exp_result.data.Qword[i]} = ((arithmetic_in_txn.srca.data.Qword[i]) - (arithmetic_in_txn.srcb.data.Qword[i]) - arithmetic_in_txn.carry_in[8*i]);
                    zf_exp[(8*i)+7] = (arithmetic_exp_result.data.Qword[i] == 0);
                    of_exp[(8*i)+7] = (~arithmetic_in_txn.srca.data.Qword[i][QWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Qword[i][QWORD_WIDTH-1] & arithmetic_exp_result.data.Qword[i][QWORD_WIDTH-1]) ||
                                  (arithmetic_in_txn.srca.data.Qword[i][QWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Qword[i][QWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Qword[i][QWORD_WIDTH-1]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    {cf_exp[(16*i)+15], arithmetic_exp_result.data.Dqword[i]} = ((arithmetic_in_txn.srca.data.Dqword[i]) - (arithmetic_in_txn.srcb.data.Dqword[i]) - arithmetic_in_txn.carry_in[16*i]);
                    zf_exp[(16*i)+15] = (arithmetic_exp_result.data.Dqword[i] == 0);
                    of_exp[(16*i)+15] = (~arithmetic_in_txn.srca.data.Dqword[i][DQWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dqword[i][DQWORD_WIDTH-1] & arithmetic_exp_result.data.Dqword[i][DQWORD_WIDTH-1]) ||
                                   (arithmetic_in_txn.srca.data.Dqword[i][DQWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dqword[i][DQWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Dqword[i][DQWORD_WIDTH-1]);
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_subb 

    virtual function void calc_sub();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    {cf_exp[i], arithmetic_exp_result.data.Byte[i]} = ((arithmetic_in_txn.srca.data.Byte[i]) - (arithmetic_in_txn.srcb.data.Byte[i]));
                    zf_exp[i] = (arithmetic_exp_result.data.Byte[i] == 0);
                    of_exp[i] = (~arithmetic_in_txn.srca.data.Byte[i][BYTE_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Byte[i][BYTE_WIDTH-1] & arithmetic_exp_result.data.Byte[i][BYTE_WIDTH-1]) ||
                                (arithmetic_in_txn.srca.data.Byte[i][BYTE_WIDTH-1]  & arithmetic_in_txn.srcb.data.Byte[i][BYTE_WIDTH-1]  & ~arithmetic_exp_result.data.Byte[i][BYTE_WIDTH-1]);
                end     
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    {cf_exp[(2*i)+1], arithmetic_exp_result.data.Word[i]} = ((arithmetic_in_txn.srca.data.Word[i]) - (arithmetic_in_txn.srcb.data.Word[i]));
                    zf_exp[(2*i)+1] = (arithmetic_exp_result.data.Word[i] == 0);
                    of_exp[(2*i)+1] = (~arithmetic_in_txn.srca.data.Word[i][WORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Word[i][WORD_WIDTH-1] & arithmetic_exp_result.data.Word[i][WORD_WIDTH-1]) ||
                                  (arithmetic_in_txn.srca.data.Word[i][WORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Word[i][WORD_WIDTH-1]  & ~arithmetic_exp_result.data.Word[i][WORD_WIDTH-1]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    {cf_exp[(4*i)+3], arithmetic_exp_result.data.Dword[i]} = ((arithmetic_in_txn.srca.data.Dword[i]) - (arithmetic_in_txn.srcb.data.Dword[i]));
                    zf_exp[(4*i)+3] = (arithmetic_exp_result.data.Dword[i] == 0);
                    of_exp[(4*i)+3] = (~arithmetic_in_txn.srca.data.Dword[i][DWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dword[i][DWORD_WIDTH-1] & arithmetic_exp_result.data.Dword[i][DWORD_WIDTH-1]) ||
                                  (arithmetic_in_txn.srca.data.Dword[i][DWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dword[i][DWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Dword[i][DWORD_WIDTH-1]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    {cf_exp[(8*i)+7], arithmetic_exp_result.data.Qword[i]} = ((arithmetic_in_txn.srca.data.Qword[i]) - (arithmetic_in_txn.srcb.data.Qword[i]));
                    zf_exp[(8*i)+7] = (arithmetic_exp_result.data.Qword[i] == 0);
                    of_exp[(8*i)+7] = (~arithmetic_in_txn.srca.data.Qword[i][QWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Qword[i][QWORD_WIDTH-1] & arithmetic_exp_result.data.Qword[i][QWORD_WIDTH-1]) ||
                                  (arithmetic_in_txn.srca.data.Qword[i][QWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Qword[i][QWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Qword[i][QWORD_WIDTH-1]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    {cf_exp[(16*i)+15], arithmetic_exp_result.data.Dqword[i]} = ((arithmetic_in_txn.srca.data.Dqword[i]) - (arithmetic_in_txn.srcb.data.Dqword[i]));
                    zf_exp[(16*i)+15] = (arithmetic_exp_result.data.Dqword[i] == 0);
                    of_exp[(16*i)+15] = (~arithmetic_in_txn.srca.data.Dqword[i][DQWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dqword[i][DQWORD_WIDTH-1] & arithmetic_exp_result.data.Dqword[i][DQWORD_WIDTH-1]) ||
                                   (arithmetic_in_txn.srca.data.Dqword[i][DQWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dqword[i][DQWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Dqword[i][DQWORD_WIDTH-1]);
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_sub

    virtual function void calc_sub_reduct();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin

                {cf_exp[0], arithmetic_exp_result.data.Byte[0]} = ((arithmetic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1]) - (arithmetic_in_txn.srcb.data.Byte[0]));
                of_exp[0] = (~arithmetic_in_txn.srca.data.Byte[0][BYTE_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Byte[0][BYTE_WIDTH-1] & arithmetic_exp_result.data.Byte[0][BYTE_WIDTH-1]) ||
                            (arithmetic_in_txn.srca.data.Byte[0][BYTE_WIDTH-1]  & arithmetic_in_txn.srcb.data.Byte[0][BYTE_WIDTH-1]  & ~arithmetic_exp_result.data.Byte[0][BYTE_WIDTH-1]);

                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    logic [BYTE_WIDTH-1:0] tmp_result;
                    {cf_exp[0], tmp_result} = ((arithmetic_exp_result.data.Byte[0]) - (arithmetic_in_txn.srcb.data.Byte[i]));
                    of_exp[0] |= (~arithmetic_exp_result.data.Byte[0][BYTE_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Byte[i][BYTE_WIDTH-1] & tmp_result[BYTE_WIDTH-1]) ||
                                 (arithmetic_exp_result.data.Byte[0][BYTE_WIDTH-1]  & arithmetic_in_txn.srcb.data.Byte[i][BYTE_WIDTH-1]  & tmp_result[BYTE_WIDTH-1]);
                    arithmetic_exp_result.data.Byte[0] = tmp_result;
                end  

                zf_exp[0] = (arithmetic_exp_result.data.Byte[0] == 0);

            end
            OSIZE_16: begin

                {cf_exp[1], arithmetic_exp_result.data.Word[0]} = ((arithmetic_in_txn.srca.data.Word[RISCV_V_NUM_WORDS_DATA-1]) - (arithmetic_in_txn.srcb.data.Word[0]));
                of_exp[1] = (~arithmetic_in_txn.srca.data.Word[0][WORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Word[0][WORD_WIDTH-1] & arithmetic_exp_result.data.Word[0][WORD_WIDTH-1]) ||
                            (arithmetic_in_txn.srca.data.Word[0][WORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Word[0][WORD_WIDTH-1]  & ~arithmetic_exp_result.data.Word[0][WORD_WIDTH-1]);

                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    logic [WORD_WIDTH-1:0] tmp_result;
                    {cf_exp[1], tmp_result} = ((arithmetic_exp_result.data.Word[0]) - (arithmetic_in_txn.srcb.data.Word[i]));
                    of_exp[1] |= (~arithmetic_exp_result.data.Word[0][WORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Word[i][WORD_WIDTH-1] & tmp_result[WORD_WIDTH-1]) ||
                                 (arithmetic_exp_result.data.Word[0][WORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Word[i][WORD_WIDTH-1]  & tmp_result[WORD_WIDTH-1]);
                    arithmetic_exp_result.data.Word[0] = tmp_result;
                end  

                zf_exp[1] = (arithmetic_exp_result.data.Word[0] == 0);
            end
            OSIZE_32: begin

                {cf_exp[3], arithmetic_exp_result.data.Dword[0]} = ((arithmetic_in_txn.srca.data.Dword[RISCV_V_NUM_DWORDS_DATA-1]) - (arithmetic_in_txn.srcb.data.Dword[0]));
                of_exp[3] = (~arithmetic_in_txn.srca.data.Dword[0][DWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dword[0][DWORD_WIDTH-1] & arithmetic_exp_result.data.Dword[0][DWORD_WIDTH-1]) ||
                            (arithmetic_in_txn.srca.data.Dword[0][DWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dword[0][DWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Dword[0][DWORD_WIDTH-1]);

                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    logic [DWORD_WIDTH-1:0] tmp_result;
                    {cf_exp[3], tmp_result} = ((arithmetic_exp_result.data.Dword[0]) - (arithmetic_in_txn.srcb.data.Dword[i]));
                    of_exp[3] |= (~arithmetic_exp_result.data.Dword[0][DWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dword[i][DWORD_WIDTH-1] & tmp_result[DWORD_WIDTH-1]) ||
                                 (arithmetic_exp_result.data.Dword[0][DWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dword[i][DWORD_WIDTH-1]  & tmp_result[DWORD_WIDTH-1]);
                    arithmetic_exp_result.data.Dword[0] = tmp_result;
                end  

                zf_exp[3] = (arithmetic_exp_result.data.Dword[0] == 0);
            end
            OSIZE_64: begin

                {cf_exp[7], arithmetic_exp_result.data.Qword[0]} = ((arithmetic_in_txn.srca.data.Qword[RISCV_V_NUM_QWORDS_DATA-1]) - (arithmetic_in_txn.srcb.data.Qword[0]));
                of_exp[7] = (~arithmetic_in_txn.srca.data.Qword[0][QWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Qword[0][QWORD_WIDTH-1] & arithmetic_exp_result.data.Qword[0][QWORD_WIDTH-1]) ||
                            (arithmetic_in_txn.srca.data.Qword[0][QWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Qword[0][QWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Qword[0][QWORD_WIDTH-1]);

                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    logic [QWORD_WIDTH-1:0] tmp_result;
                    {cf_exp[7], tmp_result} = ((arithmetic_exp_result.data.Qword[0]) - (arithmetic_in_txn.srcb.data.Qword[i]));
                    of_exp[7] |= (~arithmetic_exp_result.data.Qword[0][QWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Qword[i][QWORD_WIDTH-1] & tmp_result[QWORD_WIDTH-1]) ||
                                 (arithmetic_exp_result.data.Qword[0][QWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Qword[i][QWORD_WIDTH-1]  & tmp_result[QWORD_WIDTH-1]);
                    arithmetic_exp_result.data.Qword[0] = tmp_result;
                end  

                zf_exp[7] = (arithmetic_exp_result.data.Qword[0] == 0);
            end
            OSIZE_128: begin
                {cf_exp[15], arithmetic_exp_result.data.Dqword[0]} = ((arithmetic_in_txn.srca.data.Dqword[RISCV_V_NUM_DQWORDS_DATA-1]) - (arithmetic_in_txn.srcb.data.Dqword[0]));
                of_exp[15] = (~arithmetic_in_txn.srca.data.Dqword[0][DQWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dqword[0][DQWORD_WIDTH-1] & arithmetic_exp_result.data.Dqword[0][DQWORD_WIDTH-1]) ||
                            (arithmetic_in_txn.srca.data.Dqword[0][DQWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dqword[0][DQWORD_WIDTH-1]  & ~arithmetic_exp_result.data.Dqword[0][DQWORD_WIDTH-1]);

                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    logic [DQWORD_WIDTH-1:0] tmp_result;
                    {cf_exp[15], tmp_result} = ((arithmetic_exp_result.data.Dqword[0]) - (arithmetic_in_txn.srcb.data.Dqword[i]));
                    of_exp[15] |= (~arithmetic_exp_result.data.Dqword[0][DQWORD_WIDTH-1] & ~arithmetic_in_txn.srcb.data.Dqword[i][DQWORD_WIDTH-1] & tmp_result[DQWORD_WIDTH-1]) ||
                                 (arithmetic_exp_result.data.Dqword[0][DQWORD_WIDTH-1]  & arithmetic_in_txn.srcb.data.Dqword[i][DQWORD_WIDTH-1]  & tmp_result[DQWORD_WIDTH-1]);
                    arithmetic_exp_result.data.Dqword[0] = tmp_result;
                end  

                zf_exp[15] = (arithmetic_exp_result.data.Dqword[0] == 0);
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_sub_reduct

    virtual function void calc_sign_ext();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                `uvm_fatal(get_name(), "Invalid OSIZE_8 for zero extend")
            end
            OSIZE_16: begin
                unique case (1'b1)
                    arithmetic_in_txn.src_osize_vector[0] : begin
                        for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Word[i] = `RISCV_V_SX(arithmetic_in_txn.srca.data.Byte[i*2], 16);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid src_osize_vector, Osize: %0s, src_osize_vector: %0b",  arithmetic_in_txn.osize, arithmetic_in_txn.src_osize_vector))
                endcase
            end
            OSIZE_32: begin
                unique case (1'b1)
                    arithmetic_in_txn.src_osize_vector[0] : begin
                        for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Dword[i] = `RISCV_V_SX(arithmetic_in_txn.srca.data.Byte[i*4], 32);
                        end
                    end
                    arithmetic_in_txn.src_osize_vector[1] : begin
                        for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Dword[i] = `RISCV_V_SX(arithmetic_in_txn.srca.data.Word[i*2], 32);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid src_osize_vector, Osize: %0s, src_osize_vector: %0b",  arithmetic_in_txn.osize, arithmetic_in_txn.src_osize_vector))
                endcase
            end
            OSIZE_64: begin
                unique case (1'b1)
                    arithmetic_in_txn.src_osize_vector[0] : begin
                        for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Qword[i] = `RISCV_V_SX(arithmetic_in_txn.srca.data.Byte[i*8], 64);
                        end
                    end
                    arithmetic_in_txn.src_osize_vector[1] : begin
                        for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Qword[i] = `RISCV_V_SX(arithmetic_in_txn.srca.data.Word[i*4], 64);
                        end
                    end
                    arithmetic_in_txn.src_osize_vector[2] : begin
                        for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Qword[i] = `RISCV_V_SX(arithmetic_in_txn.srca.data.Dword[i*2], 64);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid src_osize_vector, Osize: %0s, src_osize_vector: %0b",  arithmetic_in_txn.osize, arithmetic_in_txn.src_osize_vector))
                endcase
            end
            OSIZE_128: begin
                unique case (1'b1)
                    arithmetic_in_txn.src_osize_vector[0] : begin
                        for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Dqword[i] = `RISCV_V_SX(arithmetic_in_txn.srca.data.Byte[i*16], 128);
                        end
                    end
                    arithmetic_in_txn.src_osize_vector[1] : begin
                        for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Dqword[i] = `RISCV_V_SX(arithmetic_in_txn.srca.data.Word[i*8], 128);
                        end
                    end
                    arithmetic_in_txn.src_osize_vector[2] : begin
                        for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Dqword[i] = `RISCV_V_SX(arithmetic_in_txn.srca.data.Dword[i*4], 128);
                        end
                    end
                    arithmetic_in_txn.src_osize_vector[3] : begin
                        for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Dqword[i] = `RISCV_V_SX(arithmetic_in_txn.srca.data.Qword[i*2], 128);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid src_osize_vector, Osize: %0s, src_osize_vector: %0b",  arithmetic_in_txn.osize, arithmetic_in_txn.src_osize_vector))
                endcase
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_sign_ext

    virtual function void calc_zero_ext();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                `uvm_fatal(get_name(), "Invalid OSIZE_8 for zero extend")
            end
            OSIZE_16: begin
                unique case (1'b1)
                    arithmetic_in_txn.src_osize_vector[0] : begin
                        for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Word[i] = `RISCV_V_ZX(arithmetic_in_txn.srca.data.Byte[i*2], 16);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid src_osize_vector, Osize: %0s, src_osize_vector: %0b",  arithmetic_in_txn.osize, arithmetic_in_txn.src_osize_vector))
                endcase
            end
            OSIZE_32: begin
                unique case (1'b1)
                    arithmetic_in_txn.src_osize_vector[0] : begin
                        for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Dword[i] = `RISCV_V_ZX(arithmetic_in_txn.srca.data.Byte[i*4], 32);
                        end
                    end
                    arithmetic_in_txn.src_osize_vector[1] : begin
                        for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Dword[i] = `RISCV_V_ZX(arithmetic_in_txn.srca.data.Word[i*2], 32);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid src_osize_vector, Osize: %0s, src_osize_vector: %0b",  arithmetic_in_txn.osize, arithmetic_in_txn.src_osize_vector))
                endcase
            end
            OSIZE_64: begin
                unique case (1'b1)
                    arithmetic_in_txn.src_osize_vector[0] : begin
                        for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Qword[i] = `RISCV_V_ZX(arithmetic_in_txn.srca.data.Byte[i*8], 64);
                        end
                    end
                    arithmetic_in_txn.src_osize_vector[1] : begin
                        for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Qword[i] = `RISCV_V_ZX(arithmetic_in_txn.srca.data.Word[i*4], 64);
                        end
                    end
                    arithmetic_in_txn.src_osize_vector[2] : begin
                        for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Qword[i] = `RISCV_V_ZX(arithmetic_in_txn.srca.data.Dword[i*2], 64);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid src_osize_vector, Osize: %0s, src_osize_vector: %0b",  arithmetic_in_txn.osize, arithmetic_in_txn.src_osize_vector))
                endcase
            end
            OSIZE_128: begin
                unique case (1'b1)
                    arithmetic_in_txn.src_osize_vector[0] : begin
                        for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Dqword[i] = `RISCV_V_ZX(arithmetic_in_txn.srca.data.Byte[i*16], 128);
                        end
                    end
                    arithmetic_in_txn.src_osize_vector[1] : begin
                        for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Dqword[i] = `RISCV_V_ZX(arithmetic_in_txn.srca.data.Word[i*8], 128);
                        end
                    end
                    arithmetic_in_txn.src_osize_vector[2] : begin
                        for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Dqword[i] = `RISCV_V_ZX(arithmetic_in_txn.srca.data.Dword[i*4], 128);
                        end
                    end
                    arithmetic_in_txn.src_osize_vector[3] : begin
                        for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                            arithmetic_exp_result.data.Dqword[i] = `RISCV_V_ZX(arithmetic_in_txn.srca.data.Qword[i*2], 128);
                        end
                    end
                    default : `uvm_fatal(get_name(), $sformatf("Invalid src_osize_vector, Osize: %0s, src_osize_vector: %0b",  arithmetic_in_txn.osize, arithmetic_in_txn.src_osize_vector))
                endcase
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_zero_ext

    virtual function void calc_mins();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    if (signed'(arithmetic_in_txn.srca.data.Byte[i]) < signed'(arithmetic_in_txn.srcb.data.Byte[i])) begin
                        arithmetic_exp_result.data.Byte[i] = arithmetic_in_txn.srca.data.Byte[i];
                    end else begin
                        arithmetic_exp_result.data.Byte[i] = arithmetic_in_txn.srcb.data.Byte[i];
                    end
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    if (signed'(arithmetic_in_txn.srca.data.Word[i]) < signed'(arithmetic_in_txn.srcb.data.Word[i])) begin
                        arithmetic_exp_result.data.Word[i] = arithmetic_in_txn.srca.data.Word[i];
                    end else begin
                        arithmetic_exp_result.data.Word[i] = arithmetic_in_txn.srcb.data.Word[i];
                    end
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    if (signed'(arithmetic_in_txn.srca.data.Dword[i]) < signed'(arithmetic_in_txn.srcb.data.Dword[i])) begin
                        arithmetic_exp_result.data.Dword[i] = arithmetic_in_txn.srca.data.Dword[i];
                    end else begin
                        arithmetic_exp_result.data.Dword[i] = arithmetic_in_txn.srcb.data.Dword[i];
                    end
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    if (signed'(arithmetic_in_txn.srca.data.Qword[i]) < signed'(arithmetic_in_txn.srcb.data.Qword[i])) begin
                        arithmetic_exp_result.data.Qword[i] = arithmetic_in_txn.srca.data.Qword[i];
                    end else begin
                        arithmetic_exp_result.data.Qword[i] = arithmetic_in_txn.srcb.data.Qword[i];
                    end
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    if (signed'(arithmetic_in_txn.srca.data.Dqword[i]) < signed'(arithmetic_in_txn.srcb.data.Dqword[i])) begin
                        arithmetic_exp_result.data.Dqword[i] = arithmetic_in_txn.srca.data.Dqword[i];
                    end else begin
                        arithmetic_exp_result.data.Dqword[i] = arithmetic_in_txn.srcb.data.Dqword[i];
                    end
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_mins

    virtual function void calc_mins_reduct();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                if (signed'(arithmetic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1]) < signed'(arithmetic_in_txn.srcb.data.Byte[0])) begin
                    arithmetic_exp_result.data.Byte[0] = arithmetic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Byte[0] = arithmetic_in_txn.srcb.data.Byte[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (signed'(arithmetic_exp_result.data.Byte[0]) < signed'(arithmetic_in_txn.srcb.data.Byte[i])) begin
                        arithmetic_exp_result.data.Byte[0] = arithmetic_exp_result.data.Byte[0];
                    end else begin
                        arithmetic_exp_result.data.Byte[0] = arithmetic_in_txn.srcb.data.Byte[i];
                    end
                end
            end
            OSIZE_16: begin
                if (signed'(arithmetic_in_txn.srca.data.Word[RISCV_V_NUM_WORDS_DATA-1]) < signed'(arithmetic_in_txn.srcb.data.Word[0])) begin
                    arithmetic_exp_result.data.Word[0] = arithmetic_in_txn.srca.data.Word[RISCV_V_NUM_WORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Word[0] = arithmetic_in_txn.srcb.data.Word[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (signed'(arithmetic_exp_result.data.Word[0]) < signed'(arithmetic_in_txn.srcb.data.Word[i])) begin
                        arithmetic_exp_result.data.Word[0] = arithmetic_exp_result.data.Word[0];
                    end else begin
                        arithmetic_exp_result.data.Word[0] = arithmetic_in_txn.srcb.data.Word[i];
                    end
                end
            end
            OSIZE_32: begin
                if (signed'(arithmetic_in_txn.srca.data.Dword[RISCV_V_NUM_DWORDS_DATA-1]) < signed'(arithmetic_in_txn.srcb.data.Dword[0])) begin
                    arithmetic_exp_result.data.Dword[0] = arithmetic_in_txn.srca.data.Dword[RISCV_V_NUM_DWORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Dword[0] = arithmetic_in_txn.srcb.data.Dword[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (signed'(arithmetic_exp_result.data.Dword[0]) < signed'(arithmetic_in_txn.srcb.data.Dword[i])) begin
                        arithmetic_exp_result.data.Dword[0] = arithmetic_exp_result.data.Dword[0];
                    end else begin
                        arithmetic_exp_result.data.Dword[0] = arithmetic_in_txn.srcb.data.Dword[i];
                    end
                end
            end
            OSIZE_64: begin
                if (signed'(arithmetic_in_txn.srca.data.Qword[RISCV_V_NUM_QWORDS_DATA-1]) < signed'(arithmetic_in_txn.srcb.data.Qword[0])) begin
                    arithmetic_exp_result.data.Qword[0] = arithmetic_in_txn.srca.data.Qword[RISCV_V_NUM_QWORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Qword[0] = arithmetic_in_txn.srcb.data.Qword[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (signed'(arithmetic_exp_result.data.Qword[0]) < signed'(arithmetic_in_txn.srcb.data.Qword[i])) begin
                        arithmetic_exp_result.data.Qword[0] = arithmetic_exp_result.data.Qword[0];
                    end else begin
                        arithmetic_exp_result.data.Qword[0] = arithmetic_in_txn.srcb.data.Qword[i];
                    end
                end
            end
            OSIZE_128: begin
                if (signed'(arithmetic_in_txn.srca.data.Dqword[RISCV_V_NUM_DQWORDS_DATA-1]) < signed'(arithmetic_in_txn.srcb.data.Dqword[0])) begin
                    arithmetic_exp_result.data.Dqword[0] = arithmetic_in_txn.srca.data.Dqword[RISCV_V_NUM_DQWORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Dqword[0] = arithmetic_in_txn.srcb.data.Dqword[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (signed'(arithmetic_exp_result.data.Dqword[0]) < signed'(arithmetic_in_txn.srcb.data.Dqword[i])) begin
                        arithmetic_exp_result.data.Dqword[0] = arithmetic_exp_result.data.Dqword[0];
                    end else begin
                        arithmetic_exp_result.data.Dqword[0] = arithmetic_in_txn.srcb.data.Dqword[i];
                    end
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_mins_reduct

    virtual function void calc_minu();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    if (unsigned'(arithmetic_in_txn.srca.data.Byte[i]) < unsigned'(arithmetic_in_txn.srcb.data.Byte[i])) begin
                        arithmetic_exp_result.data.Byte[i] = arithmetic_in_txn.srca.data.Byte[i];
                    end else begin
                        arithmetic_exp_result.data.Byte[i] = arithmetic_in_txn.srcb.data.Byte[i];
                    end
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    if (unsigned'(arithmetic_in_txn.srca.data.Word[i]) < unsigned'(arithmetic_in_txn.srcb.data.Word[i])) begin
                        arithmetic_exp_result.data.Word[i] = arithmetic_in_txn.srca.data.Word[i];
                    end else begin
                        arithmetic_exp_result.data.Word[i] = arithmetic_in_txn.srcb.data.Word[i];
                    end
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    if (unsigned'(arithmetic_in_txn.srca.data.Dword[i]) < unsigned'(arithmetic_in_txn.srcb.data.Dword[i])) begin
                        arithmetic_exp_result.data.Dword[i] = arithmetic_in_txn.srca.data.Dword[i];
                    end else begin
                        arithmetic_exp_result.data.Dword[i] = arithmetic_in_txn.srcb.data.Dword[i];
                    end
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    if (unsigned'(arithmetic_in_txn.srca.data.Qword[i]) < unsigned'(arithmetic_in_txn.srcb.data.Qword[i])) begin
                        arithmetic_exp_result.data.Qword[i] = arithmetic_in_txn.srca.data.Qword[i];
                    end else begin
                        arithmetic_exp_result.data.Qword[i] = arithmetic_in_txn.srcb.data.Qword[i];
                    end
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    if (unsigned'(arithmetic_in_txn.srca.data.Dqword[i]) < unsigned'(arithmetic_in_txn.srcb.data.Dqword[i])) begin
                        arithmetic_exp_result.data.Dqword[i] = arithmetic_in_txn.srca.data.Dqword[i];
                    end else begin
                        arithmetic_exp_result.data.Dqword[i] = arithmetic_in_txn.srcb.data.Dqword[i];
                    end
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_minu

    virtual function void calc_minu_reduct();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                if (unsigned'(arithmetic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1]) < unsigned'(arithmetic_in_txn.srcb.data.Byte[0])) begin
                    arithmetic_exp_result.data.Byte[0] = arithmetic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Byte[0] = arithmetic_in_txn.srcb.data.Byte[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (unsigned'(arithmetic_exp_result.data.Byte[0]) < unsigned'(arithmetic_in_txn.srcb.data.Byte[i])) begin
                        arithmetic_exp_result.data.Byte[0] = arithmetic_exp_result.data.Byte[0];
                    end else begin
                        arithmetic_exp_result.data.Byte[0] = arithmetic_in_txn.srcb.data.Byte[i];
                    end
                end
            end
            OSIZE_16: begin
                if (unsigned'(arithmetic_in_txn.srca.data.Word[RISCV_V_NUM_WORDS_DATA-1]) < unsigned'(arithmetic_in_txn.srcb.data.Word[0])) begin
                    arithmetic_exp_result.data.Word[0] = arithmetic_in_txn.srca.data.Word[RISCV_V_NUM_WORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Word[0] = arithmetic_in_txn.srcb.data.Word[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (unsigned'(arithmetic_exp_result.data.Word[0]) < unsigned'(arithmetic_in_txn.srcb.data.Word[i])) begin
                        arithmetic_exp_result.data.Word[0] = arithmetic_exp_result.data.Word[0];
                    end else begin
                        arithmetic_exp_result.data.Word[0] = arithmetic_in_txn.srcb.data.Word[i];
                    end
                end
            end
            OSIZE_32: begin
                if (unsigned'(arithmetic_in_txn.srca.data.Dword[RISCV_V_NUM_DWORDS_DATA-1]) < unsigned'(arithmetic_in_txn.srcb.data.Dword[0])) begin
                    arithmetic_exp_result.data.Dword[0] = arithmetic_in_txn.srca.data.Dword[RISCV_V_NUM_DWORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Dword[0] = arithmetic_in_txn.srcb.data.Dword[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (unsigned'(arithmetic_exp_result.data.Dword[0]) < unsigned'(arithmetic_in_txn.srcb.data.Dword[i])) begin
                        arithmetic_exp_result.data.Dword[0] = arithmetic_exp_result.data.Dword[0];
                    end else begin
                        arithmetic_exp_result.data.Dword[0] = arithmetic_in_txn.srcb.data.Dword[i];
                    end
                end
            end
            OSIZE_64: begin
                if (unsigned'(arithmetic_in_txn.srca.data.Qword[RISCV_V_NUM_QWORDS_DATA-1]) < unsigned'(arithmetic_in_txn.srcb.data.Qword[0])) begin
                    arithmetic_exp_result.data.Qword[0] = arithmetic_in_txn.srca.data.Qword[RISCV_V_NUM_QWORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Qword[0] = arithmetic_in_txn.srcb.data.Qword[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (unsigned'(arithmetic_exp_result.data.Qword[0]) < unsigned'(arithmetic_in_txn.srcb.data.Qword[i])) begin
                        arithmetic_exp_result.data.Qword[0] = arithmetic_exp_result.data.Qword[0];
                    end else begin
                        arithmetic_exp_result.data.Qword[0] = arithmetic_in_txn.srcb.data.Qword[i];
                    end
                end
            end
            OSIZE_128: begin
                if (unsigned'(arithmetic_in_txn.srca.data.Dqword[RISCV_V_NUM_DQWORDS_DATA-1]) < unsigned'(arithmetic_in_txn.srcb.data.Dqword[0])) begin
                    arithmetic_exp_result.data.Dqword[0] = arithmetic_in_txn.srca.data.Dqword[RISCV_V_NUM_DQWORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Dqword[0] = arithmetic_in_txn.srcb.data.Dqword[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (unsigned'(arithmetic_exp_result.data.Dqword[0]) < unsigned'(arithmetic_in_txn.srcb.data.Dqword[i])) begin
                        arithmetic_exp_result.data.Dqword[0] = arithmetic_exp_result.data.Dqword[0];
                    end else begin
                        arithmetic_exp_result.data.Dqword[0] = arithmetic_in_txn.srcb.data.Dqword[i];
                    end
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_minu_reduct

    virtual function void calc_maxs();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    if (signed'(arithmetic_in_txn.srca.data.Byte[i]) > signed'(arithmetic_in_txn.srcb.data.Byte[i])) begin
                        arithmetic_exp_result.data.Byte[i] = arithmetic_in_txn.srca.data.Byte[i];
                    end else begin
                        arithmetic_exp_result.data.Byte[i] = arithmetic_in_txn.srcb.data.Byte[i];
                    end
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    if (signed'(arithmetic_in_txn.srca.data.Word[i]) > signed'(arithmetic_in_txn.srcb.data.Word[i])) begin
                        arithmetic_exp_result.data.Word[i] = arithmetic_in_txn.srca.data.Word[i];
                    end else begin
                        arithmetic_exp_result.data.Word[i] = arithmetic_in_txn.srcb.data.Word[i];
                    end
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    if (signed'(arithmetic_in_txn.srca.data.Dword[i]) > signed'(arithmetic_in_txn.srcb.data.Dword[i])) begin
                        arithmetic_exp_result.data.Dword[i] = arithmetic_in_txn.srca.data.Dword[i];
                    end else begin
                        arithmetic_exp_result.data.Dword[i] = arithmetic_in_txn.srcb.data.Dword[i];
                    end
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    if (signed'(arithmetic_in_txn.srca.data.Qword[i]) > signed'(arithmetic_in_txn.srcb.data.Qword[i])) begin
                        arithmetic_exp_result.data.Qword[i] = arithmetic_in_txn.srca.data.Qword[i];
                    end else begin
                        arithmetic_exp_result.data.Qword[i] = arithmetic_in_txn.srcb.data.Qword[i];
                    end
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    if (signed'(arithmetic_in_txn.srca.data.Dqword[i]) > signed'(arithmetic_in_txn.srcb.data.Dqword[i])) begin
                        arithmetic_exp_result.data.Dqword[i] = arithmetic_in_txn.srca.data.Dqword[i];
                    end else begin
                        arithmetic_exp_result.data.Dqword[i] = arithmetic_in_txn.srcb.data.Dqword[i];
                    end
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_maxs

    virtual function void calc_maxs_reduct();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                if (signed'(arithmetic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1]) > signed'(arithmetic_in_txn.srcb.data.Byte[0])) begin
                    arithmetic_exp_result.data.Byte[0] = arithmetic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Byte[0] = arithmetic_in_txn.srcb.data.Byte[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (signed'(arithmetic_exp_result.data.Byte[0]) > signed'(arithmetic_in_txn.srcb.data.Byte[i])) begin
                        arithmetic_exp_result.data.Byte[0] = arithmetic_exp_result.data.Byte[0];
                    end else begin
                        arithmetic_exp_result.data.Byte[0] = arithmetic_in_txn.srcb.data.Byte[i];
                    end
                end
            end
            OSIZE_16: begin
                if (signed'(arithmetic_in_txn.srca.data.Word[RISCV_V_NUM_WORDS_DATA-1]) > signed'(arithmetic_in_txn.srcb.data.Word[0])) begin
                    arithmetic_exp_result.data.Word[0] = arithmetic_in_txn.srca.data.Word[RISCV_V_NUM_WORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Word[0] = arithmetic_in_txn.srcb.data.Word[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (signed'(arithmetic_exp_result.data.Word[0]) > signed'(arithmetic_in_txn.srcb.data.Word[i])) begin
                        arithmetic_exp_result.data.Word[0] = arithmetic_exp_result.data.Word[0];
                    end else begin
                        arithmetic_exp_result.data.Word[0] = arithmetic_in_txn.srcb.data.Word[i];
                    end
                end
            end
            OSIZE_32: begin
                if (signed'(arithmetic_in_txn.srca.data.Dword[RISCV_V_NUM_DWORDS_DATA-1]) > signed'(arithmetic_in_txn.srcb.data.Dword[0])) begin
                    arithmetic_exp_result.data.Dword[0] = arithmetic_in_txn.srca.data.Dword[RISCV_V_NUM_DWORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Dword[0] = arithmetic_in_txn.srcb.data.Dword[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (signed'(arithmetic_exp_result.data.Dword[0]) > signed'(arithmetic_in_txn.srcb.data.Dword[i])) begin
                        arithmetic_exp_result.data.Dword[0] = arithmetic_exp_result.data.Dword[0];
                    end else begin
                        arithmetic_exp_result.data.Dword[0] = arithmetic_in_txn.srcb.data.Dword[i];
                    end
                end
            end
            OSIZE_64: begin
                if (signed'(arithmetic_in_txn.srca.data.Qword[RISCV_V_NUM_QWORDS_DATA-1]) > signed'(arithmetic_in_txn.srcb.data.Qword[0])) begin
                    arithmetic_exp_result.data.Qword[0] = arithmetic_in_txn.srca.data.Qword[RISCV_V_NUM_QWORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Qword[0] = arithmetic_in_txn.srcb.data.Qword[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (signed'(arithmetic_exp_result.data.Qword[0]) > signed'(arithmetic_in_txn.srcb.data.Qword[i])) begin
                        arithmetic_exp_result.data.Qword[0] = arithmetic_exp_result.data.Qword[0];
                    end else begin
                        arithmetic_exp_result.data.Qword[0] = arithmetic_in_txn.srcb.data.Qword[i];
                    end
                end
            end
            OSIZE_128: begin
                if (signed'(arithmetic_in_txn.srca.data.Dqword[RISCV_V_NUM_DQWORDS_DATA-1]) > signed'(arithmetic_in_txn.srcb.data.Dqword[0])) begin
                    arithmetic_exp_result.data.Dqword[0] = arithmetic_in_txn.srca.data.Dqword[RISCV_V_NUM_DQWORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Dqword[0] = arithmetic_in_txn.srcb.data.Dqword[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (signed'(arithmetic_exp_result.data.Dqword[0]) > signed'(arithmetic_in_txn.srcb.data.Dqword[i])) begin
                        arithmetic_exp_result.data.Dqword[0] = arithmetic_exp_result.data.Dqword[0];
                    end else begin
                        arithmetic_exp_result.data.Dqword[0] = arithmetic_in_txn.srcb.data.Dqword[i];
                    end
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_maxs_reduct

    virtual function void calc_maxu();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_ELEN/BYTE_WIDTH; i++) begin
                    if (unsigned'(arithmetic_in_txn.srca.data.Byte[i]) > unsigned'(arithmetic_in_txn.srcb.data.Byte[i])) begin
                        arithmetic_exp_result.data.Byte[i] = arithmetic_in_txn.srca.data.Byte[i];
                    end else begin
                        arithmetic_exp_result.data.Byte[i] = arithmetic_in_txn.srcb.data.Byte[i];
                    end
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_ELEN/WORD_WIDTH; i++) begin
                    if (unsigned'(arithmetic_in_txn.srca.data.Word[i]) > unsigned'(arithmetic_in_txn.srcb.data.Word[i])) begin
                        arithmetic_exp_result.data.Word[i] = arithmetic_in_txn.srca.data.Word[i];
                    end else begin
                        arithmetic_exp_result.data.Word[i] = arithmetic_in_txn.srcb.data.Word[i];
                    end
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_ELEN/DWORD_WIDTH; i++) begin
                    if (unsigned'(arithmetic_in_txn.srca.data.Dword[i]) > unsigned'(arithmetic_in_txn.srcb.data.Dword[i])) begin
                        arithmetic_exp_result.data.Dword[i] = arithmetic_in_txn.srca.data.Dword[i];
                    end else begin
                        arithmetic_exp_result.data.Dword[i] = arithmetic_in_txn.srcb.data.Dword[i];
                    end
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_ELEN/QWORD_WIDTH; i++) begin
                    if (unsigned'(arithmetic_in_txn.srca.data.Qword[i]) > unsigned'(arithmetic_in_txn.srcb.data.Qword[i])) begin
                        arithmetic_exp_result.data.Qword[i] = arithmetic_in_txn.srca.data.Qword[i];
                    end else begin
                        arithmetic_exp_result.data.Qword[i] = arithmetic_in_txn.srcb.data.Qword[i];
                    end
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_ELEN/DQWORD_WIDTH; i++) begin
                    if (unsigned'(arithmetic_in_txn.srca.data.Dqword[i]) > unsigned'(arithmetic_in_txn.srcb.data.Dqword[i])) begin
                        arithmetic_exp_result.data.Dqword[i] = arithmetic_in_txn.srca.data.Dqword[i];
                    end else begin
                        arithmetic_exp_result.data.Dqword[i] = arithmetic_in_txn.srcb.data.Dqword[i];
                    end
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_maxu

    virtual function void calc_maxu_reduct();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                if (unsigned'(arithmetic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1]) > unsigned'(arithmetic_in_txn.srcb.data.Byte[0])) begin
                    arithmetic_exp_result.data.Byte[0] = arithmetic_in_txn.srca.data.Byte[RISCV_V_NUM_BYTES_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Byte[0] = arithmetic_in_txn.srcb.data.Byte[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (unsigned'(arithmetic_exp_result.data.Byte[0]) > unsigned'(arithmetic_in_txn.srcb.data.Byte[i])) begin
                        arithmetic_exp_result.data.Byte[0] = arithmetic_exp_result.data.Byte[0];
                    end else begin
                        arithmetic_exp_result.data.Byte[0] = arithmetic_in_txn.srcb.data.Byte[i];
                    end
                end
            end
            OSIZE_16: begin
                if (unsigned'(arithmetic_in_txn.srca.data.Word[RISCV_V_NUM_WORDS_DATA-1]) > unsigned'(arithmetic_in_txn.srcb.data.Word[0])) begin
                    arithmetic_exp_result.data.Word[0] = arithmetic_in_txn.srca.data.Word[RISCV_V_NUM_WORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Word[0] = arithmetic_in_txn.srcb.data.Word[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (unsigned'(arithmetic_exp_result.data.Word[0]) > unsigned'(arithmetic_in_txn.srcb.data.Word[i])) begin
                        arithmetic_exp_result.data.Word[0] = arithmetic_exp_result.data.Word[0];
                    end else begin
                        arithmetic_exp_result.data.Word[0] = arithmetic_in_txn.srcb.data.Word[i];
                    end
                end
            end
            OSIZE_32: begin
                if (unsigned'(arithmetic_in_txn.srca.data.Dword[RISCV_V_NUM_DWORDS_DATA-1]) > unsigned'(arithmetic_in_txn.srcb.data.Dword[0])) begin
                    arithmetic_exp_result.data.Dword[0] = arithmetic_in_txn.srca.data.Dword[RISCV_V_NUM_DWORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Dword[0] = arithmetic_in_txn.srcb.data.Dword[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (unsigned'(arithmetic_exp_result.data.Dword[0]) > unsigned'(arithmetic_in_txn.srcb.data.Dword[i])) begin
                        arithmetic_exp_result.data.Dword[0] = arithmetic_exp_result.data.Dword[0];
                    end else begin
                        arithmetic_exp_result.data.Dword[0] = arithmetic_in_txn.srcb.data.Dword[i];
                    end
                end
            end
            OSIZE_64: begin
                if (unsigned'(arithmetic_in_txn.srca.data.Qword[RISCV_V_NUM_QWORDS_DATA-1]) > unsigned'(arithmetic_in_txn.srcb.data.Qword[0])) begin
                    arithmetic_exp_result.data.Qword[0] = arithmetic_in_txn.srca.data.Qword[RISCV_V_NUM_QWORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Qword[0] = arithmetic_in_txn.srcb.data.Qword[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (unsigned'(arithmetic_exp_result.data.Qword[0]) > unsigned'(arithmetic_in_txn.srcb.data.Qword[i])) begin
                        arithmetic_exp_result.data.Qword[0] = arithmetic_exp_result.data.Qword[0];
                    end else begin
                        arithmetic_exp_result.data.Qword[0] = arithmetic_in_txn.srcb.data.Qword[i];
                    end
                end
            end
            OSIZE_128: begin
                if (unsigned'(arithmetic_in_txn.srca.data.Dqword[RISCV_V_NUM_DQWORDS_DATA-1]) > unsigned'(arithmetic_in_txn.srcb.data.Dqword[0])) begin
                    arithmetic_exp_result.data.Dqword[0] = arithmetic_in_txn.srca.data.Dqword[RISCV_V_NUM_DQWORDS_DATA-1];
                end else begin
                    arithmetic_exp_result.data.Dqword[0] = arithmetic_in_txn.srcb.data.Dqword[0];
                end
                for (int i=1; i < arithmetic_in_txn.len; i++) begin
                    if (unsigned'(arithmetic_exp_result.data.Dqword[0]) > unsigned'(arithmetic_in_txn.srcb.data.Dqword[i])) begin
                        arithmetic_exp_result.data.Dqword[0] = arithmetic_exp_result.data.Dqword[0];
                    end else begin
                        arithmetic_exp_result.data.Dqword[0] = arithmetic_in_txn.srcb.data.Dqword[i];
                    end
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_maxu_reduct

    virtual function void calc_mullu();
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
                    logic [(2*BYTE_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = unsigned'(arithmetic_in_txn.srca.data.Byte[i]) * unsigned'(arithmetic_in_txn.srcb.data.Byte[i]);
                    arithmetic_exp_result.data.Byte[i] = tmp_rslt[0 +: BYTE_WIDTH];
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_NUM_WORDS_DATA; i++) begin
                    logic [(2*WORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = unsigned'(arithmetic_in_txn.srca.data.Word[i]) * unsigned'(arithmetic_in_txn.srcb.data.Word[i]);
                    arithmetic_exp_result.data.Word[i] = tmp_rslt[0 +: WORD_WIDTH];
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_NUM_DWORDS_DATA; i++) begin
                    logic [(2*DWORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = unsigned'(arithmetic_in_txn.srca.data.Dword[i]) * unsigned'(arithmetic_in_txn.srcb.data.Dword[i]);
                    arithmetic_exp_result.data.Dword[i] = tmp_rslt[0 +: DWORD_WIDTH];
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_NUM_QWORDS_DATA; i++) begin
                    logic [(2*QWORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = unsigned'(arithmetic_in_txn.srca.data.Qword[i]) * unsigned'(arithmetic_in_txn.srcb.data.Qword[i]);
                    arithmetic_exp_result.data.Qword[i] = tmp_rslt[0 +: QWORD_WIDTH];
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_NUM_DQWORDS_DATA; i++) begin
                    logic [(2*DQWORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = unsigned'(arithmetic_in_txn.srca.data.Dqword[i]) * unsigned'(arithmetic_in_txn.srcb.data.Dqword[i]);
                    arithmetic_exp_result.data.Dqword[i] = tmp_rslt[0 +: DQWORD_WIDTH];
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase 
    endfunction: calc_mullu

    virtual function void calc_mulls();
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
                    logic [(2*BYTE_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = signed'(arithmetic_in_txn.srca.data.Byte[i]) * signed'(arithmetic_in_txn.srcb.data.Byte[i]);
                    arithmetic_exp_result.data.Byte[i] = tmp_rslt[0 +: BYTE_WIDTH];
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_NUM_WORDS_DATA; i++) begin
                    logic [(2*WORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = signed'(arithmetic_in_txn.srca.data.Word[i]) * signed'(arithmetic_in_txn.srcb.data.Word[i]);
                    arithmetic_exp_result.data.Word[i] = tmp_rslt[0 +: WORD_WIDTH];
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_NUM_DWORDS_DATA; i++) begin
                    logic [(2*DWORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = signed'(arithmetic_in_txn.srca.data.Dword[i]) * signed'(arithmetic_in_txn.srcb.data.Dword[i]);
                    arithmetic_exp_result.data.Dword[i] = tmp_rslt[0 +: DWORD_WIDTH];
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_NUM_QWORDS_DATA; i++) begin
                    logic [(2*QWORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = signed'(arithmetic_in_txn.srca.data.Qword[i]) * signed'(arithmetic_in_txn.srcb.data.Qword[i]);
                    arithmetic_exp_result.data.Qword[i] = tmp_rslt[0 +: QWORD_WIDTH];
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_NUM_DQWORDS_DATA; i++) begin
                    logic [(2*DQWORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = signed'(arithmetic_in_txn.srca.data.Dqword[i]) * signed'(arithmetic_in_txn.srcb.data.Dqword[i]);
                    arithmetic_exp_result.data.Dqword[i] = tmp_rslt[0 +: DQWORD_WIDTH];
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase 
    endfunction: calc_mulls

    virtual function void calc_mulhu();
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
                    logic [(2*BYTE_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = unsigned'(arithmetic_in_txn.srca.data.Byte[i]) * unsigned'(arithmetic_in_txn.srcb.data.Byte[i]);
                    arithmetic_exp_result.data.Byte[i] = tmp_rslt[BYTE_WIDTH +: BYTE_WIDTH];
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_NUM_WORDS_DATA; i++) begin
                    logic [(2*WORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = unsigned'(arithmetic_in_txn.srca.data.Word[i]) * unsigned'(arithmetic_in_txn.srcb.data.Word[i]);
                    arithmetic_exp_result.data.Word[i] = tmp_rslt[WORD_WIDTH +: WORD_WIDTH];
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_NUM_DWORDS_DATA; i++) begin
                    logic [(2*DWORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = unsigned'(arithmetic_in_txn.srca.data.Dword[i]) * unsigned'(arithmetic_in_txn.srcb.data.Dword[i]);
                    arithmetic_exp_result.data.Dword[i] = tmp_rslt[DWORD_WIDTH +: DWORD_WIDTH];
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_NUM_QWORDS_DATA; i++) begin
                    logic [(2*QWORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = unsigned'(arithmetic_in_txn.srca.data.Qword[i]) * unsigned'(arithmetic_in_txn.srcb.data.Qword[i]);
                    arithmetic_exp_result.data.Qword[i] = tmp_rslt[QWORD_WIDTH +: QWORD_WIDTH];
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_NUM_DQWORDS_DATA; i++) begin
                    logic [(2*DQWORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = unsigned'(arithmetic_in_txn.srca.data.Dqword[i]) * unsigned'(arithmetic_in_txn.srcb.data.Dqword[i]);
                    arithmetic_exp_result.data.Dqword[i] = tmp_rslt[DQWORD_WIDTH +: DQWORD_WIDTH];
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase 
    endfunction: calc_mulhu

    virtual function void calc_mulhs();
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
                    logic [(2*BYTE_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = signed'(arithmetic_in_txn.srca.data.Byte[i]) * signed'(arithmetic_in_txn.srcb.data.Byte[i]);
                    arithmetic_exp_result.data.Byte[i] = tmp_rslt[BYTE_WIDTH +: BYTE_WIDTH];
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_NUM_WORDS_DATA; i++) begin
                    logic [(2*WORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = signed'(arithmetic_in_txn.srca.data.Word[i]) * signed'(arithmetic_in_txn.srcb.data.Word[i]);
                    arithmetic_exp_result.data.Word[i] = tmp_rslt[WORD_WIDTH +: WORD_WIDTH];
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_NUM_DWORDS_DATA; i++) begin
                    logic [(2*DWORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = signed'(arithmetic_in_txn.srca.data.Dword[i]) * signed'(arithmetic_in_txn.srcb.data.Dword[i]);
                    arithmetic_exp_result.data.Dword[i] = tmp_rslt[DWORD_WIDTH +: DWORD_WIDTH];
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_NUM_QWORDS_DATA; i++) begin
                    logic [(2*QWORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = signed'(arithmetic_in_txn.srca.data.Qword[i]) * signed'(arithmetic_in_txn.srcb.data.Qword[i]);
                    arithmetic_exp_result.data.Qword[i] = tmp_rslt[QWORD_WIDTH +: QWORD_WIDTH];
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_NUM_DQWORDS_DATA; i++) begin
                    logic [(2*DQWORD_WIDTH)-1:0]  tmp_rslt;
                    tmp_rslt = signed'(arithmetic_in_txn.srca.data.Dqword[i]) * signed'(arithmetic_in_txn.srcb.data.Dqword[i]);
                    arithmetic_exp_result.data.Dqword[i] = tmp_rslt[DQWORD_WIDTH +: DQWORD_WIDTH];
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase 
    endfunction: calc_mulhs

    virtual function void calc_seq();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        arithmetic_exp_result.data = '0;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
                    arithmetic_exp_result.data.Byte[i][0]  = (arithmetic_in_txn.srca.data.Byte[i] == arithmetic_in_txn.srcb.data.Byte[i]);
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_NUM_WORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Word[i][0]  = (arithmetic_in_txn.srca.data.Word[i] == arithmetic_in_txn.srcb.data.Word[i]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_NUM_DWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dword[i][0]  = (arithmetic_in_txn.srca.data.Dword[i] == arithmetic_in_txn.srcb.data.Dword[i]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_NUM_QWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Qword[i][0]  = (arithmetic_in_txn.srca.data.Qword[i] == arithmetic_in_txn.srcb.data.Qword[i]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_NUM_DQWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dqword[i][0]  = (arithmetic_in_txn.srca.data.Dqword[i] == arithmetic_in_txn.srcb.data.Dqword[i]);
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_seq

    virtual function void calc_sne();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        arithmetic_exp_result.data = '0;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
                    arithmetic_exp_result.data.Byte[i][0]  = (arithmetic_in_txn.srca.data.Byte[i] != arithmetic_in_txn.srcb.data.Byte[i]);
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_NUM_WORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Word[i][0]  = (arithmetic_in_txn.srca.data.Word[i] != arithmetic_in_txn.srcb.data.Word[i]);
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_NUM_DWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dword[i][0]  = (arithmetic_in_txn.srca.data.Dword[i] != arithmetic_in_txn.srcb.data.Dword[i]);
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_NUM_QWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Qword[i][0]  = (arithmetic_in_txn.srca.data.Qword[i] != arithmetic_in_txn.srcb.data.Qword[i]);
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_NUM_DQWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dqword[i][0]  = (arithmetic_in_txn.srca.data.Dqword[i] != arithmetic_in_txn.srcb.data.Dqword[i]);
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_sne

    virtual function void calc_sle();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        arithmetic_exp_result.data = '0;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
                    arithmetic_exp_result.data.Byte[i][0]  = (signed'(arithmetic_in_txn.srca.data.Byte[i]) <= signed'(arithmetic_in_txn.srcb.data.Byte[i]));
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_NUM_WORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Word[i][0]  = (signed'(arithmetic_in_txn.srca.data.Word[i]) <= signed'(arithmetic_in_txn.srcb.data.Word[i]));
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_NUM_DWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dword[i][0]  = (signed'(arithmetic_in_txn.srca.data.Dword[i]) <= signed'(arithmetic_in_txn.srcb.data.Dword[i]));
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_NUM_QWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Qword[i][0]  = (signed'(arithmetic_in_txn.srca.data.Qword[i]) <= signed'(arithmetic_in_txn.srcb.data.Qword[i]));
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_NUM_DQWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dqword[i][0]  = (signed'(arithmetic_in_txn.srca.data.Dqword[i]) <= signed'(arithmetic_in_txn.srcb.data.Dqword[i]));
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_sle

    virtual function void calc_sleu();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        arithmetic_exp_result.data = '0;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
                    arithmetic_exp_result.data.Byte[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Byte[i]) <= unsigned'(arithmetic_in_txn.srcb.data.Byte[i]));
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_NUM_WORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Word[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Word[i]) <= unsigned'(arithmetic_in_txn.srcb.data.Word[i]));
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_NUM_DWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dword[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Dword[i]) <= unsigned'(arithmetic_in_txn.srcb.data.Dword[i]));
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_NUM_QWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Qword[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Qword[i]) <= unsigned'(arithmetic_in_txn.srcb.data.Qword[i]));
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_NUM_DQWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dqword[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Dqword[i]) <= unsigned'(arithmetic_in_txn.srcb.data.Dqword[i]));
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_sleu

    virtual function void calc_slt();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        arithmetic_exp_result.data = '0;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
                    arithmetic_exp_result.data.Byte[i][0]  = (signed'(arithmetic_in_txn.srca.data.Byte[i]) < signed'(arithmetic_in_txn.srcb.data.Byte[i]));
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_NUM_WORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Word[i][0]  = (signed'(arithmetic_in_txn.srca.data.Word[i]) < signed'(arithmetic_in_txn.srcb.data.Word[i]));
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_NUM_DWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dword[i][0]  = (signed'(arithmetic_in_txn.srca.data.Dword[i]) < signed'(arithmetic_in_txn.srcb.data.Dword[i]));
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_NUM_QWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Qword[i][0]  = (signed'(arithmetic_in_txn.srca.data.Qword[i]) < signed'(arithmetic_in_txn.srcb.data.Qword[i]));
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_NUM_DQWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dqword[i][0]  = (signed'(arithmetic_in_txn.srca.data.Dqword[i]) < signed'(arithmetic_in_txn.srcb.data.Dqword[i]));
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_slt

    virtual function void calc_sltu();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        arithmetic_exp_result.data = '0;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
                    arithmetic_exp_result.data.Byte[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Byte[i]) < unsigned'(arithmetic_in_txn.srcb.data.Byte[i]));
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_NUM_WORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Word[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Word[i]) < unsigned'(arithmetic_in_txn.srcb.data.Word[i]));
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_NUM_DWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dword[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Dword[i]) < unsigned'(arithmetic_in_txn.srcb.data.Dword[i]));
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_NUM_QWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Qword[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Qword[i]) < unsigned'(arithmetic_in_txn.srcb.data.Qword[i]));
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_NUM_DQWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dqword[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Dqword[i]) < unsigned'(arithmetic_in_txn.srcb.data.Dqword[i]));
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_sltu

    virtual function void calc_sgt();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        arithmetic_exp_result.data = '0;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
                    arithmetic_exp_result.data.Byte[i][0]  = (signed'(arithmetic_in_txn.srca.data.Byte[i]) > signed'(arithmetic_in_txn.srcb.data.Byte[i]));
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_NUM_WORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Word[i][0]  = (signed'(arithmetic_in_txn.srca.data.Word[i]) > signed'(arithmetic_in_txn.srcb.data.Word[i]));
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_NUM_DWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dword[i][0]  = (signed'(arithmetic_in_txn.srca.data.Dword[i]) > signed'(arithmetic_in_txn.srcb.data.Dword[i]));
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_NUM_QWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Qword[i][0]  = (signed'(arithmetic_in_txn.srca.data.Qword[i]) > signed'(arithmetic_in_txn.srcb.data.Qword[i]));
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_NUM_DQWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dqword[i][0]  = (signed'(arithmetic_in_txn.srca.data.Dqword[i]) > signed'(arithmetic_in_txn.srcb.data.Dqword[i]));
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_sgt

    virtual function void calc_sgtu();
        {zf_exp, of_exp, cf_exp} = 3'b000;
        arithmetic_exp_result.data = '0;
        case(arithmetic_in_txn.osize)
            OSIZE_8: begin
                for (int i=0; i<RISCV_V_NUM_BYTES_DATA; i++) begin
                    arithmetic_exp_result.data.Byte[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Byte[i]) > unsigned'(arithmetic_in_txn.srcb.data.Byte[i]));
                end
            end
            OSIZE_16: begin
                for (int i=0; i<RISCV_V_NUM_WORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Word[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Word[i]) > unsigned'(arithmetic_in_txn.srcb.data.Word[i]));
                end
            end
            OSIZE_32: begin
                for (int i=0; i<RISCV_V_NUM_DWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dword[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Dword[i]) > unsigned'(arithmetic_in_txn.srcb.data.Dword[i]));
                end
            end
            OSIZE_64: begin
                for (int i=0; i<RISCV_V_NUM_QWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Qword[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Qword[i]) > unsigned'(arithmetic_in_txn.srcb.data.Qword[i]));
                end
            end
            OSIZE_128: begin
                for (int i=0; i<RISCV_V_NUM_DQWORDS_DATA; i++) begin
                    arithmetic_exp_result.data.Dqword[i][0]  = (unsigned'(arithmetic_in_txn.srca.data.Dqword[i]) > unsigned'(arithmetic_in_txn.srcb.data.Dqword[i]));
                end
            end
            default: `uvm_fatal(get_name(), $sformatf("Invalid Osize"))
        endcase
    endfunction: calc_sgtu