//ROM memory
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: november 15, 2021

module ROM#(
    //parameter string       MEMORY_FILE   = "no_file",     //Cant use paramter in readmem in quartus
    parameter int unsigned DATA_WIDTH    = 32,
    parameter int unsigned ADDR_WIDTH    = 32
)(
    input  logic                 clk,
    input  logic[ADDR_WIDTH-1:0] addr,
    output logic[DATA_WIDTH-1:0] data_o
);

localparam int unsigned NUM_MEM = 2**(ADDR_WIDTH);

//Memory
logic [DATA_WIDTH-1:0] rom_mem[NUM_MEM];

//Initialize ROM

always_comb begin
    for (int i=0; i<NUM_MEM; i++) begin
        rom_mem[i] = 32'h0;
    end
    rom_mem[0] = 32'h10100437;
    rom_mem[1] = 32'h00040413;
    rom_mem[2] = 32'h000014b7;
    rom_mem[3] = 32'h45848493;
    rom_mem[4] = 32'h00942023;
    rom_mem[5] = 32'h02300493;
    rom_mem[6] = 32'h00942223;
    rom_mem[7] = 32'h00500293;
    rom_mem[8] = 32'h110003b7;
    rom_mem[9] = 32'h00038393;
    rom_mem[10] = 32'h00400313;
    rom_mem[11] = 32'h00400f13;
    rom_mem[12] = 32'h00000f93;
    rom_mem[13] = 32'h00842e03;
    rom_mem[14] = 32'h008e7e13;
    rom_mem[15] = 32'hffc00ce3;
    rom_mem[16] = 32'h01042e83;
    rom_mem[17] = 32'h008f9f93;
    rom_mem[18] = 32'h01dfefb3;
    rom_mem[19] = 32'hffff0f13;
    rom_mem[20] = 32'hffe012e3;
    rom_mem[21] = 32'h01f3a023;
    rom_mem[22] = 32'h00438393;
    rom_mem[23] = 32'hfff30313;
    rom_mem[24] = 32'hfc6016e3;
    rom_mem[25] = 32'hfff28293;
    rom_mem[26] = 32'hfc5010e3;
    rom_mem[27] = 32'h00500293;
    rom_mem[28] = 32'h110003b7;
    rom_mem[29] = 32'h00038393;
    rom_mem[30] = 32'h11000f37;
    rom_mem[31] = 32'h050f0f13;
    rom_mem[32] = 32'h00400313;
    rom_mem[33] = 32'h11000e37;
    rom_mem[34] = 32'h040e0e13;
    rom_mem[35] = 32'h00000e93;
    rom_mem[36] = 32'h0003a603;
    rom_mem[37] = 32'h000e2683;
    rom_mem[38] = 32'hff410113;
    rom_mem[39] = 32'h00512023;
    rom_mem[40] = 32'h00612223;
    rom_mem[41] = 32'h00712423;
    rom_mem[42] = 32'h088000ef;
    rom_mem[43] = 32'h00012283;
    rom_mem[44] = 32'h00412303;
    rom_mem[45] = 32'h00812383;
    rom_mem[46] = 32'h00c10113;
    rom_mem[47] = 32'h00ae8eb3;
    rom_mem[48] = 32'h00438393;
    rom_mem[49] = 32'h004e0e13;
    rom_mem[50] = 32'hfff30313;
    rom_mem[51] = 32'hfc6012e3;
    rom_mem[52] = 32'h01df2023;
    rom_mem[53] = 32'h004f0f13;
    rom_mem[54] = 32'hfff28293;
    rom_mem[55] = 32'hfa5012e3;
    rom_mem[56] = 32'h00500293;
    rom_mem[57] = 32'h110003b7;
    rom_mem[58] = 32'h05038393;
    rom_mem[59] = 32'h06300f13;
    rom_mem[60] = 32'h00400313;
    rom_mem[61] = 32'h01800e13;
    rom_mem[62] = 32'h0003ae83;
    rom_mem[63] = 32'h01cedeb3;
    rom_mem[64] = 32'h01d42623;
    rom_mem[65] = 32'h01e42223;
    rom_mem[66] = 32'h00842e83;
    rom_mem[67] = 32'h010efe93;
    rom_mem[68] = 32'hffd00ce3;
    rom_mem[69] = 32'hff8e0e13;
    rom_mem[70] = 32'hfff30313;
    rom_mem[71] = 32'hfc601ee3;
    rom_mem[72] = 32'h00438393;
    rom_mem[73] = 32'hfff28293;
    rom_mem[74] = 32'hfc5014e3;
    rom_mem[75] = 32'hef1ff06f;
    rom_mem[76] = 32'h00000513;
    rom_mem[77] = 32'h00000393;
    rom_mem[78] = 32'h000622b3;
    rom_mem[79] = 32'h00028863;
    rom_mem[80] = 32'hfff64613;
    rom_mem[81] = 32'h00160613;
    rom_mem[82] = 32'h0013c393;
    rom_mem[83] = 32'h0006a2b3;
    rom_mem[84] = 32'h00028863;
    rom_mem[85] = 32'hfff6c693;
    rom_mem[86] = 32'h00168693;
    rom_mem[87] = 32'h0013c393;
    rom_mem[88] = 32'h00d622b3;
    rom_mem[89] = 32'h00028a63;
    rom_mem[90] = 32'h000602b3;
    rom_mem[91] = 32'h00068333;
    rom_mem[92] = 32'h00030633;
    rom_mem[93] = 32'h000286b3;
    rom_mem[94] = 32'h00068863;
    rom_mem[95] = 32'h00a60533;
    rom_mem[96] = 32'hfff68693;
    rom_mem[97] = 32'hff5ff06f;
    rom_mem[98] = 32'h00700663;
    rom_mem[99] = 32'hfff54513;
    rom_mem[100] = 32'h00150513;
    rom_mem[101] = 32'h00008067;
    rom_mem[102] = 32'h00000033;
    rom_mem[103] = 32'h00000033;
    rom_mem[104] = 32'h00000033;
    rom_mem[105] = 32'h00000033;
end

//Read rom
assign data_o = rom_mem[addr>>2];


endmodule: ROM
