//File: riscv_v_csr_cov.sv
//Author: Miguel Bucio
//Date: 28/01/23
//Description: RISCV V CSR Coverage

`ifndef __RISCV_V_CSR_COV_SV__
`define __RISCV_V_CSR_COV_SV__ 

class riscv_v_csr_cov extends riscv_v_base_cov#(
                                                .seq_item_in_t  (riscv_v_csr_in_seq_item),
                                                .seq_item_out_t (riscv_v_csr_out_seq_item));

    `uvm_component_utils(riscv_v_csr_cov)

    int num_wr_sampled = 0;
    int num_rd_sampled = 0;

    covergroup cg_wr_csr;
        option.per_instance = 1;
        option.name = "cg_wr_csr";

        cp_wr_en_vsstatus: coverpoint txn_in.vsstatus_wr_en{
            bins wr_en = {1'b1};
        }
        cp_wr_en_vtype: coverpoint txn_in.vtype_wr_en{
            bins wr_en = {1'b1};
        }
        cp_wr_en_vl: coverpoint txn_in.vl_wr_en{
            bins wr_en = {1'b1};
        }
        cp_wr_en_vstart: coverpoint txn_in.vstart_wr_en{
            bins wr_en = {1'b1};
        }
        cp_wr_en_vxrm: coverpoint txn_in.vxrm_wr_en{
            bins wr_en = {1'b1};
        }
        cp_wr_en_vxsat: coverpoint txn_in.vsstatus_wr_en{
            bins wr_en = {1'b1};
        }

        cp_wr_vsstatus: coverpoint txn_in.vsstatus_data_in iff (txn_in.vsstatus_wr_en){
            wildcard bins NO_VS = {10'b0_?????????};
            wildcard bins VS    = {10'b1_?????????};
        }
        cp_wr_vtype: coverpoint txn_in.vtype_data_in iff (txn_in.vtype_wr_en){
            wildcard bins VILL    = {9'b1_?_?_???_???};
            wildcard bins NO_VILL = {9'b0_?_?_???_???};
            wildcard bins VMA     = {9'b?_1_?_???_???};
            wildcard bins NO_VMA  = {9'b?_0_?_???_???};
            wildcard bins VTA     = {9'b?_?_1_???_???};
            wildcard bins NO_VTA  = {9'b?_?_0_???_???};
            wildcard bins VSEW128 = {9'b?_?_?_100_???};
            wildcard bins VSEW64  = {9'b?_?_?_011_???};
            wildcard bins VSEW32  = {9'b?_?_?_010_???};
            wildcard bins VSEW16  = {9'b?_?_?_001_???};
            wildcard bins VSEW8   = {9'b?_?_?_000_???};
            wildcard bins LMUL8   = {9'b?_?_?_???_011};
            wildcard bins LMUL4   = {9'b?_?_?_???_010};
            wildcard bins LMUL2   = {9'b?_?_?_???_001};
            wildcard bins LMUL1   = {9'b?_?_?_???_000};
        }
        cp_wr_vl: coverpoint txn_in.vl_data_in iff (txn_in.vl_wr_en){
            bins len_0  = {0};
            bins len_1  = {1};
            bins len_2  = {2};
            bins len_3  = {3};
            bins len_4  = {4};
            bins len_5  = {5};
            bins len_6  = {6};
            bins len_7  = {7};
            bins len_8  = {8};
            bins len_9  = {9};
            bins len_10 = {10};
            bins len_11 = {11};
            bins len_12 = {12};
            bins len_13 = {13};
            bins len_14 = {14};
            bins len_15 = {15};
            bins len_16 = {16};
            bins len_greater_16 = {[17:$]};
        }
        cp_wr_vstart: coverpoint txn_in.vstart_data_in iff (txn_in.vstart_wr_en){
            bins start_0  = {0};
            bins start_1  = {1};
            bins start_2  = {2};
            bins start_3  = {3};
            bins start_4  = {4};
            bins start_5  = {5};
            bins start_6  = {6};
            bins start_7  = {7};
            bins start_8  = {8};
            bins start_9  = {9};
            bins start_10 = {10};
            bins start_11 = {11};
            bins start_12 = {12};
            bins start_13 = {13};
            bins start_14 = {14};
            bins start_15 = {15};
            bins start_16 = {16};
            bins start_greater_16 = {[17:$]};
        }
        cp_wr_vxrm: coverpoint txn_in.vxrm_data_in iff (txn_in.vxrm_wr_en){
            bins RNU = {2'b00};
            bins RNE = {2'b01};
            bins RDN = {2'b10};
            bins ROD = {2'b11};
        }
        cp_wr_vxsat: coverpoint txn_in.vxsat_data_in iff (txn_in.vxsat_wr_en){
            bins NO_SATURATE = {1'b0};
            bins SATURATE = {1'b1};
        }



    endgroup: cg_wr_csr 

    covergroup cg_rd_csr;
        option.per_instance = 1;
        option.name = "cg_rd_csr";

        cp_rd_vsstatus: coverpoint txn_out.vsstatus_data_out{
            wildcard bins NO_VS = {10'b0_?????????};
            wildcard bins VS    = {10'b1_?????????};
        }
        cp_rd_vtype: coverpoint txn_out.vtype_data_out{
            wildcard bins VILL    = {9'b1_?_?_???_???};
            wildcard bins NO_VILL = {9'b0_?_?_???_???};
            wildcard bins VMA     = {9'b?_1_?_???_???};
            wildcard bins NO_VMA  = {9'b?_0_?_???_???};
            wildcard bins VTA     = {9'b?_?_1_???_???};
            wildcard bins NO_VTA  = {9'b?_?_0_???_???};
            wildcard bins VSEW128 = {9'b?_?_?_100_???};
            wildcard bins VSEW64  = {9'b?_?_?_011_???};
            wildcard bins VSEW32  = {9'b?_?_?_010_???};
            wildcard bins VSEW16  = {9'b?_?_?_001_???};
            wildcard bins VSEW8   = {9'b?_?_?_000_???};
            wildcard bins LMUL8   = {9'b?_?_?_???_011};
            wildcard bins LMUL4   = {9'b?_?_?_???_010};
            wildcard bins LMUL2   = {9'b?_?_?_???_001};
            wildcard bins LMUL1   = {9'b?_?_?_???_000};
        }
        cp_rd_vl: coverpoint txn_out.vl_data_out{
            bins len_0  = {0};
            bins len_1  = {1};
            bins len_2  = {2};
            bins len_3  = {3};
            bins len_4  = {4};
            bins len_5  = {5};
            bins len_6  = {6};
            bins len_7  = {7};
            bins len_8  = {8};
            bins len_9  = {9};
            bins len_10 = {10};
            bins len_11 = {11};
            bins len_12 = {12};
            bins len_13 = {13};
            bins len_14 = {14};
            bins len_15 = {15};
            bins len_16 = {16};
            bins len_greater_16 = {[17:$]};
            bins len_less_start = {[0:$]} iff (txn_out.vl_data_out < txn_out.vstart_data_out);
        }
        cp_rd_vstart: coverpoint txn_out.vstart_data_out{
            bins start_0  = {0};
            bins start_1  = {1};
            bins start_2  = {2};
            bins start_3  = {3};
            bins start_4  = {4};
            bins start_5  = {5};
            bins start_6  = {6};
            bins start_7  = {7};
            bins start_8  = {8};
            bins start_9  = {9};
            bins start_10 = {10};
            bins start_11 = {11};
            bins start_12 = {12};
            bins start_13 = {13};
            bins start_14 = {14};
            bins start_15 = {15};
            bins start_16 = {16};
            bins start_greater_16 = {[17:$]};
        }
        cp_rd_vxrm: coverpoint txn_out.vxrm_data_out{
            bins RNU = {2'b00};
            bins RNE = {2'b01};
            bins RDN = {2'b10};
            bins ROD = {2'b11};
        }
        cp_rd_vxsat: coverpoint txn_out.vxsat_data_out{
            bins NO_SATURATE = {1'b0};
            bins SATURATE = {1'b1};
        }

    endgroup: cg_rd_csr 


    function new(string name = "riscv_v_csr_cov", uvm_component parent = null);
        super.new(name, parent);
        cg_wr_csr = new();
        cg_rd_csr = new();
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    //Cover Writes
    virtual function void cov_in();
        num_wr_sampled++;
        cg_wr_csr.sample();
    endfunction: cov_in 

    //Cover reads
    virtual function void cov_out();
        num_rd_sampled++;
        cg_rd_csr.sample();
    endfunction: cov_out

    virtual function void check_phase(uvm_phase phase);
        `uvm_info(get_name(), $sformatf("num_wr_sampled: %0d, num_rd_sampled: %0d", num_wr_sampled, num_rd_sampled), UVM_NONE)
    endfunction: check_phase

endclass: riscv_v_csr_cov

`endif // __RISCV_V_CSR_COV_SV__