//File:   ALU_pkg.sv
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date:   september 4, 2021
//Description:
//          Defines the parameters and typedefs used by the ALU

package ALU_pkg;

//Typedefs
typedef enum logic[4:0] {
    ALU_ADD    = 5'd0,       // A + B
    ALU_SUB    = 5'd1,       // A - B
    ALU_NEG_B  = 5'd2,       // -B
    ALU_MUL    = 5'd3,       // A * B
    ALU_AND    = 5'd4,       // A & B
    ALU_OR     = 5'd5,       // A | B
    ALU_A_N    = 5'd6,       // ~A
    ALU_XOR    = 5'd7,       // A ^ B
    ALU_SHL    = 5'd8,       // A << B[3:0]
    ALU_SHR    = 5'd9,       // B >> B[3:0]
    ALU_PASS_B = 5'd10,      //B
    ALU_SLT    = 5'd11,      //signed(A) < signed(B)
    ALU_SLTU   = 5'd12,      //unsigned(A) < unsigned(B)
    ALU_SHRA   = 5'd13       //A >>> B[3:0]
} ALU_ctrl_e;

endpackage: ALU_pkg