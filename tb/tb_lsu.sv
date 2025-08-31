    reg rst; // đổi tên cho dễ hiểu

    // Clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_lsu.vcd");
        $dumpvars(0, tb_lsu);

        // Init
        clk = 0;
        rst = 0;
        addr = 0;
        i_st_data = 0;
        i_lsu_wren = 0;
        funct3 = 3'b010; // word
        io_sw_i = 32'hAAAAAAAA;
        io_keys_i = 32'hBBBBBBBB;

        // Reset đồng bộ: giữ reset=1 ít nhất 1 cạnh clock
        #12 rst = 1;   // assert reset (sẽ tác dụng ở cạnh lên sau đó)
        #10 rst = 0;   // deassert reset

        // --- TEST CASE 1: Data Memory ghi & đọc ---
        @(posedge clk);  // đợi 1 chu kỳ sau reset
        addr = 16'h0800;
        i_st_data = 32'hDEADBEEF;
        i_lsu_wren = 1;
        @(posedge clk);
        i_lsu_wren = 0;
        @(posedge clk);
        $display("TC1 - Data Memory: Addr=0x%04h, Wrote=0x%08h, Read=0x%08h",
                  addr, 32'hDEADBEEF, o_ld_data);

        // --- TEST CASE 2: Output Buffer (LEDs) ---
        addr = 16'h1C00;
        i_st_data = 32'h12345678;
        i_lsu_wren = 1;
        @(posedge clk);
        i_lsu_wren = 0;
        @(posedge clk);
        $display("TC2 - LEDs: Addr=0x%04h, Wrote=0x%08h, LEDR=0x%08h",
                  addr, 32'h12345678, io_ledr_o);

        // --- TEST CASE 3: Input Buffer (Switches) ---
        addr = 16'h1E00;
        i_lsu_wren = 0;
        @(posedge clk);
        $display("TC3 - Switches: Addr=0x%04h, Read=0x%08h (Expected=0x%08h)",
                  addr, o_ld_data, io_sw_i);

        // --- TEST CASE 4: Input Buffer (Buttons) ---
        addr = 16'h1E04;
        i_lsu_wren = 0;
        @(posedge clk);
        $display("TC4 - Buttons: Addr=0x%04h, Read=0x%08h (Expected=0x%08h)",
                  addr, o_ld_data, io_keys_i);

        // --- TEST CASE 5: Địa chỉ ngoài vùng ---
        addr = 16'h0500;
        i_st_data = 32'hCAFEBABE;
        i_lsu_wren = 1;
        @(posedge clk);
        i_lsu_wren = 0;
        @(posedge clk);
        $display("TC5 - Outside: Addr=0x%04h, Wrote=0x%08h, Read=0x%08h",
                  addr, 32'hCAFEBABE, o_ld_data);

        $finish;
    end
