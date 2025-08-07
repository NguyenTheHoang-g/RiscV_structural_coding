module pc_plus_4(
    input  logic [31:0] pc_i,
    output logic [31:0] pc_o,
    output logic        carry_out
);
    
	logic [29:0] pc_next;
    adder_nbit #(.WIDTH(29)) u_adder (
        .a_i(pc_i[31:2]),
        .b_i(29'b1),
        .s_o(pc_next),
        .c_o(carry_out)
    );
	 assign pc_o = {pc_next, 2'b00};
endmodule