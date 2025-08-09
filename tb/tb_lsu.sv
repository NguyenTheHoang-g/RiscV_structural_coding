`timescale 1ns/1ps

module tb_lsu;

    reg         clk;
    reg         rst_n;
    reg  [15:0] addr;
    reg  [31:0] i_st_data;
    reg         i_lsu_wren;
    reg  [2:0]  funct3;
    reg  [31:0] io_sw_i;
    reg  [31:0] io_keys_i;

    wire [31:0] o_ld_data;
    wire [31:0] io_ledr_o, io_lcd_o, io_ledg_o;
    wire [31:0] io_hex0_o, io_hex1_o, io_hex2_o, io_hex3_o;
    wire [31:0] io_hex4_o, io_hex5_o, io_hex6_o, io_hex7_o;

    // Instantiate DUT
    lsu dut (
        .clk(clk),
        .rst_n(rst_n),
        .addr(addr),
        .i_st_data(i_st_data),
        .i_lsu_wren(i_lsu_wren),
        .funct3(funct3),
        .io_sw_i(io_sw_i),
        .io_keys_i(io_keys_i),
        .o_ld_data(o_ld_data),
        .io_ledr_o(io_ledr_o),
        .io_lcd_o(io_lcd_o),
        .io_ledg_o(io_ledg_o),
        .io_hex0_o(io_hex0_o), .io_hex1_o(io_hex1_o),
        .io_hex2_o(io_hex2_o), .io_hex3_o(io_hex3_o),
        .io_hex4_o(io_hex4_o), .io_hex5_o(io_hex5_o),
        .io_hex6_o(io_hex6_o), .io_hex7_o(io_hex7_o)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_lsu.vcd");
        $dumpvars(0, tb_lsu);

        // Init
        clk = 0;
        rst_n = 0;
        addr = 0;
        i_st_data = 0;
        i_lsu_wren = 0;
        funct3 = 3'b010; // word
        io_sw_i = 32'hAAAAAAAA;
        io_keys_i = 32'hBBBBBBBB;

        // Reset
        #20 rst_n = 1;

        // --- TEST CASE 1: Data Memory ghi & đọc ---
        addr = 16'h0800;
        i_st_data = 32'hDEADBEEF;
        i_lsu_wren = 1;
        #10 i_lsu_wren = 0;
        #10 $display("TC1 - Data Memory: Addr=0x%04h, Wrote=0x%08h, Read=0x%08h", addr, 32'hDEADBEEF, o_ld_data);

        // --- TEST CASE 2: Output Buffer (LEDs) ---
        addr = 16'h1C00;
        i_st_data = 32'h12345678;
        i_lsu_wren = 1;
        #10 i_lsu_wren = 0;
        #10 $display("TC2 - LEDs: Addr=0x%04h, Wrote=0x%08h, LEDR=0x%08h", addr, 32'h12345678, io_ledr_o);

        // --- TEST CASE 3: Input Buffer (Switches) ---
        addr = 16'h1E00;
        i_lsu_wren = 0;
        #10 $display("TC3 - Switches: Addr=0x%04h, Read=0x%08h (Expected=0x%08h)", addr, o_ld_data, io_sw_i);

        // --- TEST CASE 4: Input Buffer (Buttons) ---
        addr = 16'h1E04;
        i_lsu_wren = 0;
        #10 $display("TC4 - Buttons: Addr=0x%04h, Read=0x%08h (Expected=0x%08h)", addr, o_ld_data, io_keys_i);

        // --- TEST CASE 5: Địa chỉ ngoài vùng ---
        addr = 16'h0500;
        i_st_data = 32'hCAFEBABE;
        i_lsu_wren = 1;
        #10 i_lsu_wren = 0;
        #10 $display("TC5 - Outside: Addr=0x%04h, Wrote=0x%08h, Read=0x%08h", addr, 32'hCAFEBABE, o_ld_data);

        $finish;
    end

endmodule
