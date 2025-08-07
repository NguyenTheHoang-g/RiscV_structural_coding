module mux6to1 (
    input  [31:0] data_o,
    input  [2:0]  funct3,
    output [31:0] o_ld_data
);

    wire [31:0] in0, in1, in2, in3, in4, in5;
    wire [31:0] level1_0, level1_1, level1_2;
    wire [31:0] level2_0, level2_1;

    // Tạo các đầu vào theo hình ảnh
    assign in0 = {{24{data_o[7]}},  data_o[7:0]};     // 000: LB
    assign in1 = {{16{data_o[15]}}, data_o[15:0]};    // 001: LH
    assign in2 = data_o;                              // 010: LW
    assign in3 = {24'd0, data_o[7:0]};                // 100: LBU
    assign in4 = {16'd0, data_o[15:0]};               // 101: LHU
    assign in5 = 32'd0;                               // default

    // Tầng 1: 3 cặp mux 2:1
    mux2to1_32 m1 (.in0(in0), .in1(in1), .sel(funct3[0]), .o(level1_0)); 
    mux2to1_32 m2 (.in0(in2), .in1(32'd0), .sel(funct3[0]), .o(level1_1)); 
    mux2to1_32 m3 (.in0(in3), .in1(in4), .sel(funct3[0]), .o(level1_2)); 

    // Tầng 2: 2 mux 2:1
    mux2to1_32 m4 (.in0(level1_0), .in1(level1_1), .sel(funct3[1]), .o(level2_0));
    mux2to1_32 m5 (.in0(level1_2), .in1(32'd0),       .sel(funct3[1]), .o(level2_1)); // nhánh này ít khi dùng

    // Tầng 3: mux cuối cùng
    mux2to1_32 m6 (.in0(level2_0), .in1(level2_1), .sel(funct3[2]), .o(o_ld_data));

endmodule
