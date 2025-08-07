module Regfile(
input logic clk, rst,
input logic [4:0] rs1_addr, rs2_addr,
input logic [4:0] rd_addr,
input logic rd_wren,
input logic [31:0] rd_data,
output logic [31:0] rs1_data_o, rs2_data_o);

	  reg [31:0] RegArray[1:31];
	 
always @(posedge clk or negedge rst) begin
	if(~rst) begin
		for (int i = 1; i <= 31; i = i + 1) begin
		RegArray[i] <= 32'b0;
      end
	   RegArray[2] <= 32'd2048;
    end else if(rd_wren) begin
      RegArray[rd_addr] <= rd_data;
    end
  end
  
assign rs1_data_o = |rs1_addr ? RegArray[rs1_addr] : 32'b0;
assign rs2_data_o = |rs2_addr ? RegArray[rs2_addr] : 32'b0;

endmodule

