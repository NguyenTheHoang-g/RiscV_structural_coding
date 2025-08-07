// Testbench cho sra_32_structural
module testbench_sra;

    reg  [31:0] a;
    reg  [4:0]  b;
    wire [31:0] s;
    integer i;

    // Gọi module cần test
    sra_32_structural uut (
        .s(s),
        .a(a),
        .b(b)
    );

    initial begin
        // In tiêu đề kết quả
        $display("Time\t a = %h\t b = %d\t s = %h", $time, a, b, s);
        $monitor("Time: %0t | a = %h | b = %0d | s = %h", $time, a, b, s);

        // Test các giá trị
        #0  a = 32'h00000000; b = 5'd0;
        #10;

        for (i = 1; i <= 2; i = i + 1) begin
            a = a + 32'h04040404;
            b = b + 5'd1;
            #10;
        end

        // Test số âm
        a = 32'hFFFFFFF6; // -10 ở dạng 2's complement
        b = 5'd1;
        #10;
		    // Test thêm: a có 2 bit cao nhất là 1
        a = 32'hC0000000; // 2 bit cao nhất là 1, số âm
        b = 5'd4;
        #10;

        $finish;
    end

endmodule
