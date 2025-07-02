`timescale 1ns / 1ps

module adder_tb;

  // Khai báo biến cho inputs
  reg [31:0] a;
  reg [31:0] b;
  reg        c_in;

  // Khai báo biến cho outputs
  wire [31:0] sum;
  wire        c_out;

  // Gọi module adder
  adder uut (
    .a(a),
    .b(b),
    .c_in(c_in),
    .sum(sum),
    .c_out(c_out)
  );

  initial begin
    $display("Time\t\tA\t\tB\t\tCin\t\tSum\t\tCout");
    $monitor("%0t\t%h\t%h\t%b\t\t%h\t%b", $time, a, b, c_in, sum, c_out);

    // Test case 1: 5 + 10
    a = 32'd5;
    b = 32'd10;
    c_in = 1'b0;
    #10;

    // Test case 2: max value + 1
    a = 32'hFFFFFFFF;
    b = 32'd1;
    c_in = 1'b0;
    #10;

    // Test case 3: 0 + 0
    a = 32'd0;
    b = 32'd0;
    c_in = 1'b0;
    #10;

    // Test case 4: 12345678 + 87654321
    a = 32'h00BC614E; // 12345678
    b = 32'h05397FB1; // 87654321
    c_in = 1'b0;
    #10;

    // Test case 5: với c_in = 1
    a = 32'd100;
    b = 32'd200;
    c_in = 1'b1;
    #10;

    // Kết thúc mô phỏng
    $finish;
  end

endmodule
