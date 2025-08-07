
module address_decoder (
    input wire [15:0] addr,
    input wire clk,
    input wire reset,
    output reg en_data_mem,
    output reg en_leds,
    output reg en_leds7seg,
    output reg en_lcd,
    output reg en_switches,
    output reg en_buttons
);

    
    wire [5:0] decode_out;

 
    addr_decoder_logic addr_logic (
        .addr(addr),
        .decode_out(decode_out)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            en_data_mem <= 0;
            en_leds <= 0;
            en_leds7seg <= 0;
            en_lcd <= 0;
            en_switches <= 0;
            en_buttons <= 0;
        end else begin
            en_data_mem <= decode_out[0];
            en_leds <= decode_out[1];
            en_leds7seg <= decode_out[2];
            en_lcd <= decode_out[3];
            en_switches <= decode_out[4];
            en_buttons <= decode_out[5];
        end
    end

endmodule

module addr_decoder_logic (
    input wire [15:0] addr,
    output wire [5:0] decode_out
);

    assign decode_out[0] = (~|addr[15:12]) & addr[11] & (~addr[10] | addr[9] | addr[8]); // 0x0800 -> 0x0FFF
	 assign decode_out[1] = ~|(addr ^ 16'h1C00);                   // 0x1C00
    assign decode_out[2] = (~|(addr ^ 16'h1C08) ) | (~|(addr ^ 16'h1C09)); // 0x1C08 -> 0x1C09
    assign decode_out[3] = ~|(addr ^ 16'h1C0C);                    // 0x1C0C
    assign decode_out[4] = ~|(addr ^ 16'h1E00);                    // 0x1E00
    assign decode_out[5] = ~|(addr ^ 16'h1E04);                    // 0x1E04

endmodule