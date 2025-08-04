module adder_nbit
#(parameter WIDTH=32)(
    input  logic [WIDTH-1:0] a_i,
    input  logic [WIDTH-1:0] b_i,
    output logic [WIDTH-1:0] s_o,
    output logic        c_o
);
    logic [WIDTH-1:0] c_w;

    full_adder FA0  (a_i[0], b_i[0], 1'b0, s_o[0], c_w[0]);
    genvar i;
    generate
        for (i = 1; i < WIDTH; i++) begin:gen_adder
            full_adder FA (
            a_i[i], b_i[i], c_w[i-1], s_o[i], c_w[i]);
     end
    endgenerate
	 
	 /*genvar i;
    generate
        for (i = 1; i < WIDTH - 1; i++) begin:gen_adder
            full_adder FA (
            a_i[i], b_i[i], c_w[i-1], s_o[i], c_w[i]);
     end
	  assign s_o[WIDTH - 1] = a[WIDTH - 1] ^ [WIDTH - 1] ^ c_w[WIDTH - 2];
    endgenerate*/

    assign c_o = c_w[WIDTH-1];
endmodule