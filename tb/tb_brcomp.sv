`timescale 1ns/1ps

module tb_brcomp;

  // Inputs
  logic [31:0] rs1_data, rs2_data;
  logic        I_U;

  // Outputs
  logic less, equal;

  // Instantiate DUT
  brcomp uut (
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .I_U(I_U),
    .less(less),
    .equal(equal)
  );

  // Task to test one case
  task test_case(
    input [31:0] a,
    input [31:0] b,
    input        is_unsigned,
    input        expected_equal,
    input        expected_less,
    input  [127:0] test_name
  );
    begin
      rs1_data = a;
      rs2_data = b;
      I_U = is_unsigned;
      #1; // Wait 1 time unit for logic to settle

      $display("Test: %s", test_name);
      $display("  rs1 = 0x%h, rs2 = 0x%h, I_U = %b", a, b, is_unsigned);
      $display("  => equal = %b (expected %b), less = %b (expected %b)\n",
                equal, expected_equal, less, expected_less);
      if (equal !== expected_equal || less !== expected_less)
        $fatal("❌ Test FAILED!");
      else
        $display("✅ Test PASSED!\n");
    end
  endtask

  initial begin
    // Test equal
    test_case(32'h00000010, 32'h00000010, 0, 1, 0, "Equal signed");
    test_case(32'hFFFFFFFF, 32'hFFFFFFFF, 1, 1, 0, "Equal unsigned (0xFFFFFFFF)");

    // Test signed less-than
    test_case(32'hFFFFFFFF, 32'h00000001, 0, 0, 1, "Signed: -1 < 1");
    test_case(32'h00000001, 32'hFFFFFFFF, 0, 0, 0, "Signed: 1 < -1 => false");

    // Test unsigned less-than
    test_case(32'h00000001, 32'hFFFFFFFF, 1, 0, 1, "Unsigned: 1 < 0xFFFFFFFF");
    test_case(32'hFFFFFFFF, 32'h00000001, 1, 0, 0, "Unsigned: 0xFFFFFFFF < 1 => false");

    // Test signed negative vs positive
    test_case(32'h80000000, 32'h00000000, 0, 0, 1, "Signed: -2147483648 < 0");

    // Test unsigned wrap
    test_case(32'h80000000, 32'h00000000, 1, 0, 0, "Unsigned: 0x80000000 < 0 => false");

    $display("🎉 All tests passed.");
    $finish;
  end

endmodule
