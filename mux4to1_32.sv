module mux4to1_32 (
    input  logic [31:0] in0,
    input  logic [31:0] in1,
    input  logic [31:0] in2,
    input  logic [31:0] in3,
    input  logic [1:0]  sel,
    output logic [31:0] out
);
    logic [31:0] w0, w1;

    // Tầng đầu tiên: chọn giữa in0/in1 và in2/in3
    mux2to1_32 m0 (.in0(in0), .in1(in1), .sel(sel[0]), .o(w0));
    mux2to1_32 m1 (.in0(in2), .in1(in3), .sel(sel[0]), .o(w1));

    // Tầng thứ hai: chọn giữa w0 và w1
    mux2to1_32 m2 (.in0(w0), .in1(w1), .sel(sel[1]), .o(out));
endmodule
