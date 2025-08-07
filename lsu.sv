module output_buffer (
    input             clk,
    input             reset_n,
    input             store_enable,    // enable ghi từ trên
    input      [31:0] store_data,
   // input      [31:0] data_in,
    input             enable,          // <== thêm
    output reg [31:0] data_out
);
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n)
            data_out <= 32'd0;
        else if (enable) begin
            if (store_enable)
                data_out <= store_data;
        end else
            data_out <= 32'd0;
    end
endmodule
///
module input_buffer (
    input             clk,
    input             reset_n,
    input             enable,                 // <== thêm
    input      [11:0] load_store_address,
    input      [31:0] io_sw_i,
    input      [31:0] io_keys_i,
    output reg [31:0] data_out
);
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n)
            data_out <= 32'd0;
        else if (enable) begin
            case (load_store_address[7:0])
                8'h00: data_out <= io_sw_i;
                8'h04: data_out <= io_keys_i;
                default: data_out <= 32'd0;
            endcase
        end else
            data_out <= 32'd0; // nếu không enable thì trả về 0
    end
endmodule
///
module data_memory (
    input             clk,
    input             reset_n,
    input             enable,                  // <== thêm
    input      [10:0] load_store_address,
    input      [31:0] data_in,
    input             store_enable,
    output reg [31:0] data_out
);
    reg [31:0] mem [0:2047];

    always @(posedge clk) begin
        if (enable) begin
            if (store_enable)
                mem[load_store_address] <= data_in;
            data_out <= mem[load_store_address];
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

//------ lsu_top
module lsu(
	 input         clk,
    input         rst_n,
    input logic [15:0] addr,             // địa chỉ load/store 
    input logic [31:0] i_st_data,        // dữ liệu cần lưu (store)
    input         i_lsu_wren,       // enable ghi
    input logic [2:0]  funct3,           
    input  logic [31:0] io_sw_i,
    input logic [31:0] io_keys_i,
    output logic [31:0] o_ld_data,      // (load)
    output  logic [31:0] io_ledr_o,
    output logic [31:0] io_lcd_o,
   output logic [31:0] io_ledg_o,
   output logic [31:0] io_hex0_o, io_hex1_o, io_hex2_o, io_hex3_o,
   output logic [31:0] io_hex4_o, io_hex5_o, io_hex6_o, io_hex7_o);
	
	
	wire [5:0] decode_out;
	
	wire enable;
	
	wire [31:0] data_st;
	//output buffer wires
	wire [31:0] input_o, output_o, dmem_o, reserved_o ;
	
	wire [1:0]data_rom;
	
	wire [31:0] out_mux;
	
	wire [31:0] ld_data_pre_mux;
	
	addr_decoder_logic iadd( .addr(addr), .decode_out(decode_out));

	assign enable = decode_out[0] | decode_out[1]| decode_out[2]| decode_out[3]|decode_out[4]|decode_out[5];
	
 st_data_mux ist(.i_st_data(i_st_data), . funct3(funct3[1:0]), . st_data_o(data_st));
 
 output_buffer iout( clk, rst_n, i_lsu_wren, data_st, enable, output_o);
 
 input_buffer iin( clk, rst_n, enable, addr[11:0], io_sw_i, io_keys_i,input_o);
 
 data_memory idmem( clk, rst_n, enable, addr[10:0],data_st,i_lsu_wren,dmem_o);
 
 lsu_sel_rom isel( addr[12:0],data_rom);
 
 mux4to1_32 imux4( input_o, output_o, dmem_o, reserved_o , data_rom, out_mux);
 
 mux2to1_32 imux( out_mux, 32'd0, i_lsu_wren, ld_data_pre_mux);
 
 mux6to1 imux6( ld_data_pre_mux, funct3, o_ld_data);
endmodule
 
 
 
 
 
	


