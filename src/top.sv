module top (
    input logic clk,
    input logic rst,
    input logic [31:0] io_sw_i,
    input logic [31:0] io_keys_i,
    output logic [31:0] io_ledr_o,
    output logic [31:0] io_lcd_o,
    output logic [31:0] io_ledg_o,
    output logic [31:0] io_hex0_o,
    output logic [31:0] io_hex1_o,
    output logic [31:0] io_hex2_o,
    output logic [31:0] io_hex3_o,
    output logic [31:0] io_hex4_o,
    output logic [31:0] io_hex5_o,
    output logic [31:0] io_hex6_o,
    output logic [31:0] io_hex7_o,
    input logic sw_button
);

    // Internal signals based on the diagram
    logic [31:0] pc_out, pc_in, pc_plus_4_out, instruction_out, imm_out;
    logic [4:0] rs1_addr, rs2_addr, rd_addr;
    logic [31:0] rs1_data, rs2_data, rd_data, alu_result, pc_rs1;
    logic rd_wren, lsu_wren;
    logic [3:0] alu_op;
    logic [2:0] funct3;
    logic [11:0] ctrl_signal;
    logic [17:0] Opcode_F3_F7_brless_breq; // {opcode[6:0], funct3[2:0], funct7[6:0], br_less, br_equal}
    logic br_un, br_less, br_equal;
    
    logic [31:0] lsu_data_out;
    logic opa_sel, opb_sel;
    logic [31:0] rs2_im;

    // Program Counter
    Program_Counter pc (
        .clk(clk),
        .rst(rst),
        .PC_in(pc_in),
        .PC_out(pc_out)
    );

    // PC + 4
    pc_plus_4 pc_adder (
        .pc_i(pc_out),
        .pc_o(pc_plus_4_out),
        .carry_out()
    );

    // Instruction Memory
    Instruction_mem imem (
        .addr_i (pc_out),
        .data_out_o(instruction_out)
    );

    // Immediate Generator
    immgen imm_gen (
        .instr(instruction_out[31:2]),
        .imm(imm_out)
    );

    // Register File
    Regfile regfile (
        .clk(clk),
        .rst(rst),
        .rs1_addr(instruction_out[19:15]), // rs1_addr
        .rs2_addr(instruction_out[24:20]), // rs2_addr
        .rd_addr(instruction_out[11:7]),   // rd_addr
        .rd_wren(rd_wren),
        .rd_data(rd_data),
        .rs1_data_o(rs1_data),
        .rs2_data_o(rs2_data)
    );

	 mux2to1_32 imux21(.in0(rs1_data), .in1(pc_out), .sel(opa_sel), .o(pc_rs1));
	 mux2to1_32 imux21_2(.in0(rs2_data), .in1(imm_out), .sel(opb_sel), .o(rs2_im));
	 mux2to1_32 imux21_3( .in0(pc_plus_4_out), .in1( alu_result), .sel(PCSel ), .o(pc_out)); 

    // ALU
    alu_structural alu (
        .alu_control(alu_op),
        .a(pc_rs1),          // i_op_a
        .b(rs2_im),               // i_op_b (now selected between rs2_data and imm_out)
        .result(alu_result)    // o_alu_data	
    );

    // Branch Comparator
    brcomp brc (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .I_U(br_un),
        .less(br_less),
        .equal(br_equal)
    );

    // Load/Store Unit
    lsu lsu_unit (
        .clk(clk),
        .rst_n(rst),
        .addr(alu_result[15:0]),       // i_lsu_addr
        .i_st_data(rs2_data),  // i_st_data
        .i_lsu_wren(lsu_wren),
        .funct3(instruction_out[14:12]), // funct3
        .io_sw_i(io_sw_i),
        .io_keys_i(io_keys_i),
        .o_ld_data(lsu_data_out), // o_ld_data
        .io_ledr_o(io_ledr_o),
        .io_lcd_o(io_lcd_o),
        .io_ledg_o(io_ledg_o),
        .io_hex0_o(io_hex0_o),
        .io_hex1_o(io_hex1_o),
        .io_hex2_o(io_hex2_o),
        .io_hex3_o(io_hex3_o),
        .io_hex4_o(io_hex4_o),
        .io_hex5_o(io_hex5_o),
        .io_hex6_o(io_hex6_o),
        .io_hex7_o(io_hex7_o)
    );
	 
	 mux4to1_32 imux4(.in0(pc_plus_4_out), .in1(alu_result), .in2(lsu_data_out), .in3(lsu_data_out), .sel(wb_sel ), .out(rd_data));

    // Control Unit with new input
    control_logic ctrl (
        .address(Opcode_F3_F7_brless_breq),
        .ctrl_signal(ctrl_signal)
    );

    // Form Opcode_F3_F7_brless_breq
    assign Opcode_F3_F7_brless_breq = {instruction_out[6:0],    // opcode
                                       instruction_out[14:12],  // funct3
                                       instruction_out[31:25],  // funct7
                                       br_less,                 // br_less
                                       br_equal};               // br_equal

    // Signal unpacking from control_signal (12 bits)
    logic PCSel;
    logic [1:0] wb_sel;
    assign {PCSel, rd_wren, opa_sel, opb_sel, alu_op, wb_sel, lsu_wren} = ctrl_signal;

    
    

endmodule