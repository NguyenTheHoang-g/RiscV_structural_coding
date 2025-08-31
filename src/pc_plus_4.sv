module pc_plus_4(
    input  logic [31:0] pc_i,
    output logic [31:0] pc_o,
    output logic        carry_out
);
    
	logic [31:0] pc_next;
    adder_32bit u_adder (
        .a_i(pc_i),
        .b_i(32'd4),
        .s_o(pc_next),
        .c_o(carry_out)
    );
	 assign pc_o = pc_next;
endmodule
