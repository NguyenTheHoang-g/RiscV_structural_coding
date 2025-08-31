module Regfile(
  input  logic        clk, 
  input  logic        rst,   // active-high reset
  input  logic [4:0]  rs1_addr, rs2_addr,
  input  logic [4:0]  rd_addr,
  input  logic        rd_wren,
  input  logic [31:0] rd_data,
  output logic [31:0] rs1_data_o, rs2_data_o
);

  reg [31:0] RegArray[0:31];  // đủ 32 thanh ghi

  // Reset toàn bộ thanh ghi, x0 luôn = 0
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      for (int i = 0; i < 32; i++) begin
        RegArray[i] <= 32'b0;
      end
      RegArray[2] <= 32'd2048; // SP init
    end else if (rd_wren && rd_addr != 0) begin
      RegArray[rd_addr] <= rd_data; // không cho ghi x0
    end
  end

  // Đọc bất đồng bộ
  assign rs1_data_o = (rs1_addr == 0) ? 32'b0 : RegArray[rs1_addr];
  assign rs2_data_o = (rs2_addr == 0) ? 32'b0 : RegArray[rs2_addr];

endmodule
