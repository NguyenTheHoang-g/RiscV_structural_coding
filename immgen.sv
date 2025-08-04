
module imm_Itype(
  input  [31:7] instr,
 
  output [31:0] imm
);
  assign imm = {{20{instr[31]}}, instr[30:20]};
endmodule

module imm_Stype(
  input  [31:7] instr,
  output [31:0] imm
);
  assign imm = {{20{instr[31]}}, instr[30:25], instr[11:7]};
endmodule

module imm_Btype(
  input  [31:7] instr,
  output [31:0] imm
);
  wire [12:0] imm_b;
  assign imm_b = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
  assign imm = {{19{instr[31]}}, imm_b};
endmodule

module imm_Utype(
  input  [31:7] instr,
  output [31:0] imm
);
  assign imm = {instr[31:12], 12'b0};
endmodule

module imm_Jtype(
  input  [31:7] instr,
  output [31:0] imm
);
  wire [20:0] imm_j;
  assign imm_j = {instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
  assign imm = {{11{instr[31]}}, imm_j};
endmodule

module sel0(
	input [6:2] ins,
	output sel0);
	
	assign sel0= (~ins[6] &ins[2]) |(~ins[6] & ins[5]) ;
endmodule

module sel1(
	input [6:2] ins,
	output sel1);
	
	assign sel1= (~ins[6] &ins[2]) |(ins[6] & ~ins[2]) ;
endmodule

module immgen(
  input  [31:2] instr,
 
 // input  [4:0] imm_sel,
  output [31:0] imm
);

  wire [31:0] imm_I, imm_S, imm_B, imm_U, imm_J;
  wire sel0, sel1, sel2;
  wire [31:0] out0_0, out0_1 , out_1, out_2;

  imm_Itype u_imm_I (.instr(instr), .imm(imm_I));
  imm_Stype u_imm_S (.instr(instr), .imm(imm_S));
  imm_Btype u_imm_B (.instr(instr), .imm(imm_B));
  imm_Utype u_imm_U (.instr(instr), .imm(imm_U));
  imm_Jtype u_imm_J (.instr(instr), .imm(imm_J));
  
  sel0 isel0(.ins(instr[6:2]), .sel0(sel0));
    
  sel1 isel1(.ins(instr[6:2]), .sel1(sel1));
  
mux2to1_32 isel0_1(.in0(imm_I), .in1(imm_S), .sel(sel0), .o(out0_0));

mux2to1_32 ise0_2(.in0(imm_B), .in1(imm_U), .sel(sel0), .o(out0_1));

mux2to1_32 iisel1(.in0(out0_0), .in1(out0_1), .sel(sel1), .o(out_1));

mux2to1_32 isel2(.in0(out_1), .in1(imm_J), .sel(instr[3]), .o(imm));
 endmodule
