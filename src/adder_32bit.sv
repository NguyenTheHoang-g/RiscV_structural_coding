module adder_32bit(
    input  logic [31:0] a_i,
    input  logic [31:0] b_i,
    output logic [31:0] s_o,
    output logic        c_o
);
    logic [31:0] c_w;

    full_adder FA0  (a_i[0], b_i[0], 1'b0, s_o[0], c_w[0]);
    genvar i;
    generate
        for (i = 1; i < 32; i++) begin:gen_adder
            full_adder FA (
            a_i[i], b_i[i], c_w[i-1], s_o[i], c_w[i]);
     end
    endgenerate

    assign c_o = c_w[31];
endmodule