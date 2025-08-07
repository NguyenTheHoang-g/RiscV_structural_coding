`timescale 1ns/1ps

module tb_immgen;

  reg  [31:2] instr;
  wire [31:0] imm;

  // DUT
  immgen uut (
    .instr(instr),
    .imm(imm)
  );

  task show;
    input [31:0] full_instr;
    begin
      instr = full_instr[31:2];
      #1;
      $display("Instruction = 0x%08x | Imm = 0x%08x | Signed Imm = %0d", full_instr, imm, $signed(imm));
    end
  endtask

  initial begin
    $display("==== Test Immediate Generation (auto type detect) ====");

    // I-type (e.g., ADDI x1, x2, 5)
    show(32'b000000000101_00010_000_00001_0010011); // opcode 0010011

    // S-type (e.g., SW x5, 8(x2))
    show(32'b0000000_00101_00010_010_01000_0100011); // opcode 0100011

    // B-type (e.g., BEQ x1, x2, 16)
    show(32'b0000000_00010_00001_000_00100_1100011); // opcode 1100011

    // U-type (e.g., LUI x1, 0x12345)
    show(32'b00010010001101000101_00001_0110111);    // opcode 0110111

    // J-type (e.g., JAL x1, 2048)
    show(32'b000000100000_00000000_00001_1101111);   // opcode 1101111

    $finish;
  end
endmodule
