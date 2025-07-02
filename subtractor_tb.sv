`timescale 1ns / 1ps

module subtractor_tb;

  // Inputs
  reg [31:0] a;
  reg [31:0] b;
  reg        c_in;

  // Outputs
  wire [31:0] sub;
  wire        c_out;

  // Instantiate the subtractor
  subtractor uut (
    .a(a),
    .b(b),
    .c_in(c_in),
    .sub(sub),
    .c_out(c_out)
  );

  initial begin
    $display("Time\t\tA\t\tB\t\tCin\t\tSub\t\tCout");
    $monitor("%0t\t%h\t%h\t%b\t\t%h\t%b", $time, a, b, c_in, sub, c_out);

    // Trường hợp 1: 10 - 5
    a = 32'd10;
    b = 32'd5;
    c_in = 1'b1; // Bắt buộc phải là 1 để thực hiện phép trừ
    #10;

    // Trường hợp 2: 100 - 100
    a = 32'd100;
    b = 32'd100;
    c_in = 1'b1;
    #10;

    // Trường hợp 3: 5 - 10 (kết quả âm, dưới dạng bù 2)
    a = 32'd5;
    b = 32'd10;
    c_in = 1'b1;
    #10;

    // Trường hợp 4: 0 - 1
    a = 32'd0;
    b = 32'd1;
    c_in = 1'b1;
    #10;

    // Trường hợp 5: số lớn trừ số nhỏ
    a = 32'h12345678;
    b = 32'h00001000;
    c_in = 1'b1;
    #10;

    // Kết thúc mô phỏng
    $finish;
  end

endmodule
