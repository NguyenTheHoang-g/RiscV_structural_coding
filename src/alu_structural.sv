module alu_structural (
    input  [3:0]  alu_control,
    input  [31:0] a, b,
    output [31:0] result
);
    // Tính trước các kết quả từ module cấu trúc
    wire [31:0] res [0:9];

    // ADD
    wire add_carry;
    adder_32bit u_add (
        .a_i(a),
        .b_i(b),
        .s_o(res[0]),
        .c_o(add_carry)
    );

    // SLL
    sll_32_structural u_sll (
        .a(a),
        .b(b[4:0]),
        .s(res[1])	
    );

    // SLTU
    wire slt_result;
    slt_sltu_32bit u_slt (
        .I_OP_A(a),
        .I_OP_B(b),
        .I_U(1'b0),
        .O_Result(slt_result)
    );
    assign res[2] = {31'b0, slt_result};

    // XOR
  
 // SLTU (signed)
    wire sltu_result;
    slt_sltu_32bit u_sltu (
        .I_OP_A(a),
        .I_OP_B(b),
       .I_U(1'b1),
        .O_Result(sltu_result)
    );
    assign res[3] = {31'b0, sltu_result};

	 assign res[4] = a^ b;
	 
    // SRL
    srl_32_structural u_srl (
        .a(a),
        .b(b[4:0]),
        .s(res[5])
    );

    // OR
    assign res[6] = a | b;

    // AND
    assign res[7] = a & b;

    // SUB
    wire sub_borrow;
    subtractor_32bit u_sub (
        .a_i(a),
        .b_i(b),
        .d_o(res[8]),
        .b_o(sub_borrow)
    );

    // SRA
    sra_32_structural u_sra (
        .a(a),
        .b(b[4:0]),
        .s(res[9])
    );

    // MUX tree (10 inputs → chọn 1)
    wire [31:0] mux_l1 [0:4];
    wire [31:0] mux_l2 [0:2];
    wire [31:0] mux_l3 [0:1];
    wire [31:0] mux_l4;

    // Level 1
    mux2to1_32 m1_0(res[0], res[1], alu_control[0], mux_l1[0]);
    mux2to1_32 m1_1(res[2], res[3], alu_control[0], mux_l1[1]);
    mux2to1_32 m1_2(res[4], res[5], alu_control[0], mux_l1[2]);
    mux2to1_32 m1_3(res[6], res[7], alu_control[0], mux_l1[3]);
    mux2to1_32 m1_4(res[8], 32'b0, alu_control[0], mux_l1[4]);

    // Level 2
    mux2to1_32 m2_0(mux_l1[0], mux_l1[1], alu_control[1], mux_l2[0]);
    mux2to1_32 m2_1(mux_l1[2], mux_l1[3], alu_control[1], mux_l2[1]);
    mux2to1_32 m2_2(mux_l1[4], 32'b0,      alu_control[1], mux_l2[2]); // padding

    // Level 3
    mux2to1_32 m3_0(mux_l2[0], mux_l2[1], alu_control[2], mux_l3[0]);
    mux2to1_32 m3_1(mux_l2[2], res[9] ,      alu_control[2], mux_l3[1]); // padding

    // Level 4
    mux2to1_32 m4(mux_l3[0], mux_l3[1], alu_control[3], result);

endmodule
