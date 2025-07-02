module slt_sltu_32bit_tb;
    // Inputs
    logic [31:0] I_OP_A;
    logic [31:0] I_OP_B;
    logic        I_U;
    // Outputs
    logic        O_Result;

    // Instantiate the Unit Under Test (UUT)
    slt_sltu_32bit uut (
        .I_OP_A(I_OP_A),
        .I_OP_B(I_OP_B),
        .I_U(I_U),
        .O_Result(O_Result)
    );

    // Test procedure
    initial begin
        // Initialize inputs
        I_OP_A = 0;
        I_OP_B = 0;
        I_U = 0;

        // Wait for global reset
        #10;

        // Test Case 1: SLT (Signed Comparison)
        $display("Testing SLT (I_U = 0)");
        // Positive vs Positive
        I_U = 0; I_OP_A = 32'd5; I_OP_B = 32'd10; #10;
        $display("SLT: A=%d, B=%d, O_Result=%b (Expected: 1)", I_OP_A, I_OP_B, O_Result);
        // Negative vs Positive
        I_U = 0; I_OP_A = -32'd5; I_OP_B = 32'd5; #10;
        $display("SLT: A=%d, B=%d, O_Result=%b (Expected: 1)", $signed(I_OP_A), $signed(I_OP_B), O_Result);
        // Positive vs Negative
        I_U = 0; I_OP_A = 32'd5; I_OP_B = -32'd5; #10;
        $display("SLT: A=%d, B=%d, O_Result=%b (Expected: 0)", $signed(I_OP_A), $signed(I_OP_B), O_Result);
        // Negative vs Negative
        I_U = 0; I_OP_A = -32'd10; I_OP_B = -32'd5; #10;
        $display("SLT: A=%d, B=%d, O_Result=%b (Expected: 1)", $signed(I_OP_A), $signed(I_OP_B), O_Result);
        // Equal values
        I_U = 0; I_OP_A = 32'd5; I_OP_B = 32'd5; #10;
        $display("SLT: A=%d, B=%d, O_Result=%b (Expected: 0)", $signed(I_OP_A), $signed(I_OP_B), O_Result);
        // Zero vs Zero
        I_U = 0; I_OP_A = 32'd0; I_OP_B = 32'd0; #10;
        $display("SLT: A=%d, B=%d, O_Result=%b (Expected: 0)", $signed(I_OP_A), $signed(I_OP_B), O_Result);
        // Max positive vs Min negative
        I_U = 0; I_OP_A = 32'h7FFFFFFF; I_OP_B = 32'h80000000; #10;
        $display("SLT: A=%d, B=%d, O_Result=%b (Expected: 0)", $signed(I_OP_A), $signed(I_OP_B), O_Result);

        // Test Case 2: SLTU (Unsigned Comparison)
        $display("\nTesting SLTU (I_U = 1)");
        // Small values
        I_U = 1; I_OP_A = 32'd5; I_OP_B = 32'd10; #10;
        $display("SLTU: A=%d, B=%d, O_Result=%b (Expected: 1)", I_OP_A, I_OP_B, O_Result);
        // Large values (unsigned interpretation)
        I_U = 1; I_OP_A = 32'hFFFFFFFF; I_OP_B = 32'd1; #10;
        $display("SLTU: A=%d, B=%d, O_Result=%b (Expected: 0)", I_OP_A, I_OP_B, O_Result);
        // Equal values
        I_U = 1; I_OP_A = 32'd100; I_OP_B = 32'd100; #10;
        $display("SLTU: A=%d, B=%d, O_Result=%b (Expected: 0)", I_OP_A, I_OP_B, O_Result);
        // Zero vs Non-zero
        I_U = 1; I_OP_A = 32'd0; I_OP_B = 32'd1; #10;
        $display("SLTU: A=%d, B=%d, O_Result=%b (Expected: 1)", I_OP_A, I_OP_B, O_Result);
        // Max unsigned vs Max unsigned - 1
        I_U = 1; I_OP_A = 32'hFFFFFFFF; I_OP_B = 32'hFFFFFFFE; #10;
        $display("SLTU: A=%d, B=%d, O_Result=%b (Expected: 1)", I_OP_A, I_OP_B, O_Result);

        // End simulation
        #10;
        $display("Testbench completed");
        $finish;
    end

endmodule