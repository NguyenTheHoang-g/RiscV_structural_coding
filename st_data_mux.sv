


module st_data_mux(
input logic [31:0] i_st_data, 
input logic [1:0] funct3 ,
output logic [31:0] st_data_o);
 
 wire [31:0] data;

mux2to1_32 isel1( .in0(data), .in1(i_st_data), .sel(funct3[1]), .o(st_data_o));

mux2to1_32 isel0( .in0({24'b0,i_st_data[7:0] }), .in1({16'b0,i_st_data[15:0] }), .sel(funct3[0]), .o(data));

endmodule


