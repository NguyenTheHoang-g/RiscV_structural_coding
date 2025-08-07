`timescale 1ns/1ps

module tb_Regfile;

  logic clk, rst;
  logic [4:0] rs1_addr, rs2_addr;
  logic [4:0] rd_addr;
  logic rd_wren;
  logic [31:0] rd_data;
  logic [31:0] rs1_data_o, rs2_data_o;

  // Instantiate DUT
  Regfile uut (
    .clk(clk),
    .rst(rst),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(rd_addr),
    .rd_wren(rd_wren),
    .rd_data(rd_data),
    .rs1_data_o(rs1_data_o),
    .rs2_data_o(rs2_data_o)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Task to write register
  task write_reg(input [4:0] addr, input [31:0] data);
    begin
      rd_addr = addr;
      rd_data = data;
      rd_wren = 1;
      @(posedge clk);
      rd_wren = 0;
      @(posedge clk);
    end
  endtask

  // Task to read registers
  task read_regs(input [4:0] rs1, input [4:0] rs2);
    begin
      rs1_addr = rs1;
      rs2_addr = rs2;
      @(posedge clk);
      $display("Read rs1(x%0d) = 0x%08x, rs2(x%0d) = 0x%08x", rs1, rs1_data_o, rs2, rs2_data_o);
    end
  endtask

  // Initial block for simulation
  initial begin
    $display("Starting testbench for Regfile...");
    clk = 0;
    rst = 0;
    rd_wren = 0;
    rd_addr = 0;
    rd_data = 0;
    rs1_addr = 0;
    rs2_addr = 0;

    // Apply reset
    #2; rst = 0;
    #5; rst = 1;
    #5;

    // Check if x2 is initialized to 2048
    read_regs(5'd2, 5'd0);

    // Write some data
    write_reg(5'd1, 32'hAAAA_BBBB);
    write_reg(5'd3, 32'h1234_5678);

    // Read back
    read_regs(5'd1, 5'd3);

    // Try writing to x0 (should have no effect)
    write_reg(5'd0, 32'hFFFF_FFFF);
    read_regs(5'd0, 5'd1); // x0 should still be 0

    // ❗ Test ghi không bật rd_wren (should NOT write)
    $display("Test ghi khi rd_wren = 0 (không có tác dụng)");
    rd_addr = 5'd4;
    rd_data = 32'hDEADBEEF;
    rd_wren = 0; // không bật ghi
    @(posedge clk);
    read_regs(5'd4, 5'd0); // x4 đáng lẽ vẫn là 0

    $display("Testbench done.");
    #10 $finish;
  end

endmodule
