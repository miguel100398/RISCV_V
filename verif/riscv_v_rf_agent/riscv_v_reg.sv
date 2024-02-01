//File: riscv_v_reg.sv
//Author: Miguel Bucio
//Date: 21/05/23
//Description: RISC-V Register

`ifndef __RISCV_V_REG__
`define __RISCV_V_REG__

class riscv_v_reg #(type data_t  = riscv_v_data_t,
                            type wr_en_t = riscv_v_rf_wr_en_t) extends riscv_v_base_seq_item;

    typedef riscv_v_reg#(data_t) this_type_t;

    localparam NUM_BITS    = $bits(data_t);
    localparam NUM_BYTES   = NUM_BITS / BYTE_WIDTH;
    localparam NUM_WORDS   = NUM_BITS / WORD_WIDTH;
    localparam NUM_DWORDS  = NUM_BITS / DWORD_WIDTH;
    localparam NUM_QWORDS  = NUM_BITS / QWORD_WIDTH;
    localparam NUM_DQWORDS = NUM_BITS / DQWORD_WIDTH;

    //Register Data
    data_t data;

    //Constructor
    function new(string name = "riscv_v_reg");
        super.new(name);
    endfunction: new

    /* Reset data of register
    Default value is 0
    */
    virtual function void reset_reg(data_t rst_val = '0);
        data = rst_val;
    endfunction: reset_reg

    /* Write data to registesr
    Default value is 0
    */
    virtual function void write_reg(data_t write_val = '0, wr_en_t wr_en= '0);
        for (int byte_idx = 0; byte_idx < NUM_BYTES; byte_idx++) begin
            if (wr_en[byte_idx] == 1'b1) begin
                data.Byte[byte_idx] = write_val.Byte[byte_idx];
            end
        end
    endfunction: write_reg

    /* Read data from registesr
    */
    virtual function data_t read_reg();
        return data;
    endfunction: read_reg

    //Print Register
    virtual function string convert2string();
        string print;

        print = $sformatf("Data: \n");
        //Print Bits
        print = {print, printBits()};
        
        //Print Bytes
        print = {print, printBytes()};

        //Print Words
        `ifdef RISCV_V_USE_WORD
            print = {print, printWords()};
        `endif // RISCV_V_USE_WORD

        //Print Dwords
        `ifdef RISCV_V_USE_DWORD
            print = {print, printDwords()};
        `endif // RISCV_V_USE_DWORD

        //Print Qwords
        `ifdef RISCV_V_USE_QWORD
            print = {print, printQwords()};
        `endif // RISCV_V_USE_QWORD

        //Print Dqwords
        `ifdef RISCV_V_USE_DQWORD
            print = {print, printDqwords()};
        `endif // RISCV_V_USE_DQWORD

        return print;
    endfunction: convert2string

    //Print Bits
    virtual function string printBits();
        string print = "";
            if (NUM_BITS == 0) begin
                return print;
            end
            print = {print, $sformatf("Bits[%0d:0] = 0x%0h \n", NUM_BITS-1, data.Bit)};
        return print;
    endfunction: printBits

    virtual function string printBytes();
        string print = "";
        if (NUM_BYTES == 0) begin
            return print;
        end
        for (int byte_idx=0; byte_idx<NUM_BYTES; byte_idx++) begin 
            print = {print, $sformatf("Byte[%d] = 0x%0h", byte_idx, data.Byte[byte_idx])};
        end
        return print;
    endfunction: printBytes

    `ifdef RISCV_V_USE_WORD
        virtual function string printWords();
            string print = "";
            if (NUM_WORDS == 0) begin
                return print;
            end
            for (int word_idx=0; word_idx<NUM_BYTES; word_idx++) begin 
                print = {print, $sformatf("Word[%d] = 0x%0h", word_idx, data.Word[word_idx])};
            end
            return print;
        endfunction: printWords
    `endif // RISCV_V_USE_WORD

    `ifdef RISCV_V_USE_DWORD
        virtual function string printDwords();
            string print = "";
            if (NUM_DWORDS == 0) begin
                return print;
            end
            for (int dword_idx=0; dword_idx<NUM_BYTES; dword_idx++) begin 
                print = {print, $sformatf("Dword[%d] = 0x%0h", dword_idx, data.Dword[dword_idx])};
            end
            return print;
        endfunction: printDwords
    `endif // RISCV_V_USE_DWORD

    `ifdef RISCV_V_USE_QWORD
        virtual function string printQwords();
            string print = "";
            if (NUM_QWORDS == 0) begin
                return print;
            end
            for (int qword_idx=0; qword_idx<NUM_BYTES; qword_idx++) begin 
                print = {print, $sformatf("Qword[%d] = 0x%0h", qword_idx, data.Qword[qword_idx])};
            end
            return print;
        endfunction: printQwords
    `endif // RISCV_V_USE_QWORD

    `ifdef RISCV_V_USE_DQWORD
        virtual function string printDqwords();
            string print = "";
            if (NUM_DQWORDS == 0) begin
                return print;
            end
            for (int dqword_idx=0; dqword_idx<NUM_BYTES; dqword_idx++) begin 
                print = {print, $sformatf("Dqword[%d] = 0x%0h", dqword_idx, data.Dqword[dqword_idx])};
            end
            return print;
        endfunction: printDqwords
    `endif // RISCV_V_USE_DQWORD
    
    
    //Comparer
    virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        this_type_t _rhs;
        bit res;
        //Cast
        if (!$cast(_rhs, rhs)) begin
            $fatal(get_name(), $sformatf("Can't cast rhs to %s in riscv_v_reg do_compare", $typename(this_type_t)));
        end

        res = super.do_compare(_rhs, comparer) &&
               data === _rhs.data;

        return res;

    endfunction: do_compare

    //Copy
    virtual function void do_copy(uvm_object rhs);
        this_type_t _rhs;
        if (!$cast(_rhs, rhs)) begin
            $fatal(get_name(), $sformatf("Can't cast rhs to %s in riscv_v_reg do_copy", $typename(this_type_t)));
        end
        super.do_copy(_rhs);

        data = _rhs.data;

    endfunction: do_copy

endclass: riscv_v_reg


`endif //__RISCV_V_REG__