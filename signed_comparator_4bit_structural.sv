module bit_comparator (
    input a,
    input b,
    output gt,  // a > b
    output eq,  // a == b
    output lt   // a < b
);
    assign gt =  a & ~b;
    assign eq = ~(a ^ b);
    assign lt = ~a & b;
endmodule

module signed_comparator_4bit_structural(
    input  [31:0] a,
    input  [31:0] b,
    output        lt,
    output        eq,
    output        gt
);
    wire [30:0] gt_wire, eq_wire, lt_wire;

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : gen_bit_comp
            bit_comparator comp (
                .a(a[30 - i]),
                .b(b[30 - i]),
                .gt(gt_wire[30 - i]),
                .eq(eq_wire[30 - i]),
                .lt(lt_wire[30 - i])
            );
        end
    endgenerate

    // unsigned comparator for bits [30:0]
    wire [30:0] equal_chain;
    assign equal_chain[30] = 1'b1;

    genvar j;
    generate
        for (j = 0; j < 30; j = j + 1) begin : gen_eq_chain
            assign equal_chain[29 - j] = equal_chain[30 - j] & eq_wire[30 - j];
        end
    endgenerate

    wire [30:0] gt_terms, lt_terms;
    generate
        for (i = 0; i < 31; i = i + 1) begin : gen_terms
            assign gt_terms[i] = equal_chain[i] & gt_wire[i];
            assign lt_terms[i] = equal_chain[i] & lt_wire[i];
        end
    endgenerate

    wire unsigned_lt = |lt_terms;
    wire unsigned_gt = |gt_terms;
    wire unsigned_eq = &eq_wire;

    // xử lý bit dấu (bit 31)
    wire a_sign = a[31];
    wire b_sign = b[31];

    // nếu dấu khác nhau → quyết định luôn
    wire diff_sign = a_sign ^ b_sign;
    assign lt = (diff_sign & a_sign) | (~diff_sign & unsigned_lt);
    assign gt = (diff_sign & b_sign) | (~diff_sign & unsigned_gt);
    assign eq = ~diff_sign & unsigned_eq;

endmodule
