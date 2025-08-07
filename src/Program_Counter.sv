module Program_Counter( 
input logic clk, rst,
input logic [31:0] PC_in,
output logic [31:0] PC_out);

 always_ff @(posedge clk, negedge rst) begin
 if(~rst)
 PC_out<= 32'b00;
 else 
 PC_out<= PC_in;
 end
 endmodule 
 