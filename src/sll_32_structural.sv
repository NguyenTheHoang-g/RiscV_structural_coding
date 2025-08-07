
module mux2to1_32(
    input  [31:0] in0,
    input  [31:0] in1,
    input         sel,
    output [31:0] o
);
    assign o = sel ? in1 : in0;
endmodule
module sll_32_structural (
    output [31:0] s,
    input  [31:0] a,
    input  [4:0]  b
);
    wire [31:0] s1, s2, s3, s4;

    // layer 0: nếu b[0] = 1, dịch 1 bit
    mux2to1_32 m0(a,   {a[30:0], 1'b0},  b[0], s1);

    // Tầng 1: nếu b[1] = 1, dịch thêm 2 bit
    mux2to1_32 m1(s1,  {s1[29:0], 2'b0}, b[1], s2);

    // Tầng 2: nếu b[2] = 1, dịch thêm 4 bit
    mux2to1_32 m2(s2,  {s2[27:0], 4'b0}, b[2], s3);

    // Tầng 3: nếu b[3] = 1, dịch thêm 8 bit
    mux2to1_32 m3(s3,  {s3[23:0], 8'b0}, b[3], s4);

    // Tầng 4: nếu b[4] = 1, dịch thêm 16 bit
    mux2to1_32 m4(s4,  {s4[15:0], 16'b0}, b[4], s);

endmodule