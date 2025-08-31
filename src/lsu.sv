module output_buffer (
    input             clk,
    input             reset_n,
    input             store_enable,    // enable ghi từ trên
    input      [31:0] store_data,
    input             enable,          // <== thêm
    output reg [31:0] data_out
);
    always @(posedge clk or posedge reset_n) begin
        if (reset_n)
            data_out <= 32'd0;
        else if (enable) begin
            if (store_enable)
                data_out <= store_data;
        end else
            data_out <= 32'd0;
    end
endmodule


module input_buffer (
    input             clk,
    input             reset_n,
    input             enable,                 // <== thêm
    input      [11:0] load_store_address,
    input      [31:0] io_sw_i,
    input      [31:0] io_keys_i,
    output reg [31:0] data_out
);
    always @(posedge clk or posedge reset_n) begin
        if (reset_n)
            data_out <= 32'd0;
        else if (enable) begin
            case (load_store_address[7:0])
                8'h00: data_out <= io_sw_i;
                8'h04: data_out <= io_keys_i;
                default: data_out <= 32'd0;
            endcase
        end else
            data_out <= 32'd0;
    end
endmodule


// ---------------- BRAM version ----------------
//module data_memory (
//    input             clk,
//    input             reset_n,
//    input             enable,                  // <== thêm
//    input      [10:0] load_store_address,
//    input      [31:0] data_in,
//    input             store_enable,
//    output reg [31:0] data_out
//);
//    // BRAM 2048 x 32
//    reg [31:0] mem [0:2047];
//
//    always @(posedge clk) begin
//        if (enable) begin
//            if (store_enable)
//                mem[load_store_address] <= data_in; // synchronous write
//            data_out <= mem[load_store_address];    // synchronous read
//        end else begin
//            data_out <= 32'd0;
//        end
//    end
//
//    integer i;
//    initial begin
//        for (i = 0; i < 2048; i = i + 1)
//            mem[i] = 32'd0;
//    end
//endmodule


// ---------------- LSU top ----------------
module lsu(
    input         clk,
    input         rst_n,
    input  [15:0] addr,             // địa chỉ load/store 
    input  [31:0] i_st_data,        // dữ liệu cần lưu (store)
    input         i_lsu_wren,       // enable ghi
    input  [2:0]  funct3,           
    input  [31:0] io_sw_i,
    input  [31:0] io_keys_i,
    output [31:0] o_ld_data,        // (load)
    output [31:0] io_ledr_o,
    output [31:0] io_lcd_o,
    output [31:0] io_ledg_o,
    output [31:0] io_hex0_o, io_hex1_o, io_hex2_o, io_hex3_o,
    output [31:0] io_hex4_o, io_hex5_o, io_hex6_o, io_hex7_o
);
    wire [5:0] decode_out;
    wire enable;
    wire [31:0] data_st;

    // output buffer wires
    wire [31:0] input_o, output_o, dmem_o, reserved_o;
    wire [1:0]  data_rom;
    wire [31:0] out_mux;
    wire [31:0] ld_data_pre_mux;

    addr_decoder_logic iadd( .addr(addr), .decode_out(decode_out) );

    assign enable = decode_out[0] | decode_out[1] | decode_out[2] |
                    decode_out[3] | decode_out[4] | decode_out[5];

    st_data_mux ist(
        .i_st_data(i_st_data),
        .funct3(funct3[1:0]),
        .st_data_o(data_st)
    );

    output_buffer iout(
        .clk(clk), .reset_n(rst_n),
        .store_enable(i_lsu_wren),
        .store_data(data_st),
        .enable(enable),
        .data_out(output_o)
    );

    input_buffer iin(
        .clk(clk), .reset_n(rst_n),
        .enable(enable),
        .load_store_address(addr[11:0]),
        .io_sw_i(io_sw_i),
        .io_keys_i(io_keys_i),
        .data_out(input_o)
    );

    data_memory idmem(
        .clk(clk), .reset_n(rst_n),
        .enable(enable),
        .load_store_address(addr[10:0]),
        .data_in(data_st),
        .store_enable(i_lsu_wren),
        .data_out(dmem_o)
    );

    lsu_sel_rom isel(
        .addr(addr[12:0]),
        .data(data_rom)
    );

    mux4to1_32 imux4(
        .in0(input_o),
        .in1(output_o),
        .in2(dmem_o),
        .in3(reserved_o),
        .sel(data_rom),
        .out(out_mux)
    );

    mux2to1_32 imux(
        .in0(out_mux),
        .in1(32'd0),
        .sel(i_lsu_wren),
        .o(ld_data_pre_mux)
    );

    mux6to1 imux6(
        .data_o(ld_data_pre_mux),
        .funct3(funct3),
        .o_ld_data(o_ld_data)
    );

    assign reserved_o = 32'd0;

endmodule
