`timescale 1ns/1ps

module tb_alu_structural;

  // Inputs
  reg [3:0] alu_control;
  reg [31:0] a, b;

  // Output
  wire [31:0] result;

  // Instantiate DUT
  alu_structural uut (
    .alu_control(alu_control),
    .a(a),
    .b(b),
    .result(result)
  );

  // Task để test một phép toán
  task test_alu;
    input [3:0] ctrl;
    input [31:0] a_in, b_in;
    input [31:0] expected;
    input [255:0] name;
    begin
      alu_control = ctrl;
      a = a_in;
      b = b_in;
      #1;
      $display("%s | a = 0x%h, b = 0x%h, result = 0x%h, expected = 0x%h %s",
        name, a, b, result, expected, (result === expected) ? "✅" : "❌");
    end
  endtask

  initial begin
    $display("\n--- ALU Structural Testbench ---");

    // ADD
    test_alu(4'b0000, 32'h00000010, 32'h00000005, 32'h00000015, "ADD");

    // SLL
    test_alu(4'b0001, 32'h00000001, 32'h00000004, 32'h00000010, "SLL");

    // SLT (signed)
    test_alu(4'b0010, 32'hFFFFFFFF, 32'h00000001, 32'h00000001, "SLT signed");

    // SLTU (unsigned)
    test_alu(4'b0011, 32'hFFFFFFFF, 32'h00000001, 32'h00000000, "SLTU unsigned");

    // XOR
    test_alu(4'b0100, 32'hF0F0F0F0, 32'h0F0F0F0F, 32'hFFFFFFFF, "XOR");

    // SRL
    test_alu(4'b0101, 32'h80000000, 32'h0000001F, 32'h00000001, "SRL");

    // OR
    test_alu(4'b0110, 32'hAAAAAAAA, 32'h55555555, 32'hFFFFFFFF, "OR");

    // AND
    test_alu(4'b0111, 32'hAAAAAAAA, 32'h55555555, 32'h00000000, "AND");

    // SUB
    test_alu(4'b1000, 32'h00000010, 32'h00000001, 32'h0000000F, "SUB");

    // SRA (arithmetic shift right)
    test_alu(4'b1101, 32'hF0000000, 32'h00000004, 32'hFF000000, "SRA");

    $finish;
  end

endmodule
