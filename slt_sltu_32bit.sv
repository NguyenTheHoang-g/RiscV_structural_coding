module mux2to1 (
    input  logic in0,
    input  logic in1,
    input  logic sel,
    output logic out
);
    assign out = sel ? in1 : in0;
endmodule
module slt_sltu_32bit (
    input  logic [31:0] I_OP_A,
    input  logic [31:0] I_OP_B,
   // input  logic        I_U,       // 1 = unsigned (sltu), 0 = signed (slt)
    output logic        O_Result
);
    logic [31:0] diff;
    logic        borrow;
    logic        sign_a, sign_b, xor_sign;
    logic        sel, out_mux;

    // Subtractor: dùng chuỗi full_subtractor 4-bit (gộp lại 8 lần)
    subtractor_32bit sub_inst (
        .a_i(I_OP_A),
        .b_i(I_OP_B),
        .d_o(diff),
        .b_o(borrow)
    );

    assign sign_a = I_OP_A[31];
    assign sign_b = I_OP_B[31];
    assign xor_sign = ~(sign_a ^ sign_b);

    assign sel = xor_sign; // chọn theo sơ đồ (dùng XOR(a[31], b[31]))

   mux2to1 mux_sel (
    .in0(sign_a),
    .in1(~borrow),
    .sel(sel),
    .out(out_mux)
);

    assign O_Result = out_mux;

endmodule
module subtractor_4bit(
	input logic [3:0] a_i,
	input logic [3:0] b_i,
	output logic [3:0] d_o,
	output logic b_o
	);

	logic [3:0] b_w;
	
	full_subtractor S0(a_i[0], b_i[0], 1'b0, d_o[0], b_w[0]);
	full_subtractor S1(a_i[1], b_i[1], b_w[0], d_o[1], b_w[1]);
	full_subtractor S2(a_i[2], b_i[2], b_w[1], d_o[2], b_w[2]);
	full_subtractor S3(a_i[3], b_i[3], b_w[2], d_o[3], b_w[3]);
	
	assign b_o = b_w[3];
	
endmodule

module full_subtractor(
	input logic a_i,
	input logic b_i,
	input logic c_i,
	output logic d_o,
	output logic b_o
	);

	assign d_o = a_i ^ b_i ^ c_i;
	assign b_o = ((~a_i) & (b_i ^ c_i)) | (b_i & c_i);
	
endmodule
module subtractor_32bit (
    input  logic [31:0] a_i,
    input  logic [31:0] b_i,
    output logic [31:0] d_o,
    output logic        b_o
);
    logic [7:0] borrow;

    subtractor_4bit S0 (a_i[3:0],   b_i[3:0],   d_o[3:0],   borrow[0]);
    subtractor_4bit S1 (a_i[7:4],   b_i[7:4],   d_o[7:4],   borrow[1]);
    subtractor_4bit S2 (a_i[11:8],  b_i[11:8],  d_o[11:8],  borrow[2]);
    subtractor_4bit S3 (a_i[15:12], b_i[15:12], d_o[15:12], borrow[3]);
    subtractor_4bit S4 (a_i[19:16], b_i[19:16], d_o[19:16], borrow[4]);
    subtractor_4bit S5 (a_i[23:20], b_i[23:20], d_o[23:20], borrow[5]);
    subtractor_4bit S6 (a_i[27:24], b_i[27:24], d_o[27:24], borrow[6]);
    subtractor_4bit S7 (a_i[31:28], b_i[31:28], d_o[31:28], borrow[7]);

    assign b_o = borrow[7];
endmodule
