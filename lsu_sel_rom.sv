module lsu_sel_rom (
    input  logic [12:0] addr,      // địa chỉ 13-bit
    output logic [1:0]  data       // output 2-bit
);

    logic [1:0] rom [0:7684];      // ROM 8K x 2-bit (địa chỉ từ 0x0000 đến 0x1FFF)

    // Nạp dữ liệu ban đầu (partial initialization)
    initial begin
        integer i;

        // Gán mặc định toàn bộ là x (ROM không đầy đủ)
       // for (i = 0; i < 8192; i = i + 1)
         //   rom[i] = 2'bxx;

        // 0x0000 đến 0x07FF → 11
        for (i = 13'h0000; i <= 13'h07FF; i = i + 1)
            rom[i] = 2'b11;

        // 0x0800 đến 0x0FFF → 10
        for (i = 13'h0800; i <= 13'h0FFF; i = i + 1)
            rom[i] = 2'b10;

        // Các địa chỉ cụ thể → 01
        rom[13'h1C00] = 2'b01;
        rom[13'h1C08] = 2'b01;
        rom[13'h1C09] = 2'b01;
        rom[13'h1C0C] = 2'b01;

        // Các địa chỉ cụ thể → 00
        rom[13'h1E00] = 2'b00;
        rom[13'h1E04] = 2'b00;
    end

    // Truy xuất ROM
    assign data = rom[addr];

endmodule
