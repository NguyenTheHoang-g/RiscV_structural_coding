`timescale 1ns/1ps

module slt_sltu_32bit_tb;

  logic [31:0] I_OP_A, I_OP_B;
  logic I_U;
  logic O_Result;

  slt_sltu_32bit dut (
    .I_OP_A(I_OP_A),
    .I_OP_B(I_OP_B),
    .I_U(I_U),
    .O_Result(O_Result)
  );

  task check(input [31:0] a, input [31:0] b, input logic I_U_mode, input logic expected);
    begin
      I_OP_A = a;
      I_OP_B = b;
      I_U = I_U_mode;
      #1;
      $display("%s | a = 0x%08x, b = 0x%08x => result = %0d, expected = %0d %s",
        I_U ? "SLTU unsigned" : "SLT signed",
        a, b, O_Result, expected,
        (O_Result === expected) ? "✅" : "❌");
    end
  endtask

  initial begin
    $display("=== Testing SLT/SLTU ===");

    // SLT (signed)
    check(32'h00000001, 32'h00000002, 1'b0, 1); // 1 < 2
    check(32'hffffffff, 32'h00000001, 1'b0, 1); // -1 < 1
    check(32'h7fffffff, 32'h80000000, 1'b0, 0); // 2147483647 > -2147483648
    check(32'h80000000, 32'h00000000, 1'b0, 1); // -2147483648 < 0
    check(32'h80000000, 32'hffffffff, 1'b0, 1); // -2147483648 < -1
    check(32'h00000001, 32'h00000001, 1'b0, 0); // equal

    // SLTU (unsigned)
    check(32'h00000001, 32'h00000002, 1'b1, 1); // 1 < 2
    check(32'hffffffff, 32'h00000001, 1'b1, 0); // 0xFFFFFFFF > 1
    check(32'h00000000, 32'hffffffff, 1'b1, 1); // 0 < 0xFFFFFFFF
    check(32'h80000000, 32'h7fffffff, 1'b1, 0); // 0x80000000 > 0x7FFFFFFF
    check(32'h00000001, 32'h00000001, 1'b1, 0); // equal

    $finish;
  end

endmodule
