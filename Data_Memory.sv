module Data_Memory (
    input  logic         clk,
    input  logic         reset,
    input  logic         MemWrite,
    input  logic         MemRead,
    input  logic [31:0]  read_address,
    input  logic [31:0]  Write_data,
    output logic [31:0]  MemData_out
);

    logic [31:0] D_Memory [0:63]; // 64 ô nhớ, mỗi ô 32-bit

    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int k = 0; k < 64; k++) begin
                D_Memory[k] <= 32'b0;
            end
        end else if (MemWrite) begin
            D_Memory[read_address] <= Write_data;
        end
    end

    always_comb begin
        if (MemRead) begin
            MemData_out = D_Memory[read_address];
        end else begin
            MemData_out = 32'b0;
        end
    end

endmodule
