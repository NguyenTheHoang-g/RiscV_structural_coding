module testbench_srl;

    reg  [31:0] a;
    reg  [4:0]  b;
    wire [31:0] s;
    integer i;

    // Gọi module cần test
    srl_32_structural uut (
        .s(s),
        .a(a),
        .b(b)
    );

    initial begin
        $display("Time\t a = %h\t b = %d\t s = %h", $time, a, b, s);
        $monitor("Time: %0t | a = %h | b = %0d | s = %h", $time, a, b, s);

        // Test a = 1, dịch trái từ 0 đến 7 bit
        a = 32'h00010001;
        for (i = 0; i <= 7; i = i + 1) begin
            b = i;
            #10;
        end

        // Test số lớn
        a = 32'hF001000F;
        b = 5'd4;
        #10;

        // Test dịch 31 bit
        a = 32'h00000001;
        b = 5'd31;
        #10;

        // Test không dịch
        a = 32'hAAAAAAAA;
        b = 5'd0;
        #10;

        $finish;
    end

endmodule
