module data_memory (
    input             clk,
    input             reset_n,
    input             enable,                  // <== thêm
    input      [10:0] load_store_address,
    input      [31:0] data_in,
    input             store_enable,
    output reg [31:0] data_out
);
    // BRAM 2048 x 32
    reg [31:0] mem [0:2047];

    always @(posedge clk) begin
        if (enable) begin
            if (store_enable)
                mem[load_store_address] <= data_in; // synchronous write
            data_out <= mem[load_store_address];    // synchronous read
        end else begin
            data_out <= 32'd0;
        end
    end

    integer i;
    initial begin
        for (i = 0; i < 2048; i = i + 1)
            mem[i] = 32'd0;
    end
endmodule
