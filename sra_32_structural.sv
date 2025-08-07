

    
module sra_32_structural (
    output [31:0] s,
    input  [31:0] a,
    input  [4:0]  b
);
    wire [31:0] s1, s2, s3, s4;
wire sign= a[31];
    // layer 0: nếu b[0] = 1, dịch 1 bit
    mux2to1_32 m0(a,   { {1{sign}},a[31:1]},  b[0], s1);

    // Tầng 1: nếu b[1] = 1, dịch thêm 2 bit
    mux2to1_32 m1(s1,  {{2{sign}},s1[31:2] }, b[1], s2);

    // Tầng 2: nếu b[2] = 1, dịch thêm 4 bit
    mux2to1_32 m2(s2,  {{4{sign}},s2[31:4] }, b[2], s3);

    // Tầng 3: nếu b[3] = 1, dịch thêm 8 bit
    mux2to1_32 m3(s3,  {{8{sign}},s3[31:8]}, b[3], s4);

    // Tầng 4: nếu b[4] = 1, dịch thêm 16 bit
    mux2to1_32 m4(s4,  {{16{sign}},s4[31:16]}, b[4], s);

endmodule