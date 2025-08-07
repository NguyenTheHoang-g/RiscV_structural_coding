module brcomp (
  input  logic [31:0] rs1_data, rs2_data,
  input logic I_U,
  output logic  less, equal
);


slt_sltu_32bit islt( rs1_data, rs2_data, I_U,  less);

equal_32bit iequal( rs1_data, rs2_data, equal);

endmodule

module equal_32bit (
    input  logic [31:0] A,
    input  logic [31:0] B,
    output logic equal
);
    logic [31:0] xnor_bits;

    // XNOR từng bit
    assign xnor_bits = ~(A ^ B);

    // AND tất cả bit lại để kiểm tra A == B
    assign equal = &xnor_bits;  // Toán tử reduction AND

endmodule

 