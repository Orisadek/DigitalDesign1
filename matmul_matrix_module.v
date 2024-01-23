//
// Verilog Module Ori_Alon_Lab_1_lib.matmul_matrix_module
//
// Created:
//          by - orisad.UNKNOWN (TOMER)
//          at - 19:01:29 01/21/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module matmul_matrix_module(clk_i,rst_ni,operandA_i,operandB_i,N_i,K_i,M_i,res_o);
//-------------------ports----------------------------------------------
input  clk_i,rst_ni,operandA_i,operandB_i,N_i,K_i,M_i;
output res_o;
//-----------------parameters-----------------------------------------
parameter DATA_WIDTH = 32; // data width
parameter BUS_WIDTH = 64; // bus width
parameter MAX_DIM = BUS_WIDTH/DATA_WIDTH; // max dim of the matrix
//-----------------variables------------------------------------------
wire clk_i,rst_ni;
reg  [1:0] N_i,K_i,M_i;
reg  [DATA_WIDTH-1:0]   operandA_i,operandB [MAX_DIM-1:0][MAX_DIM-1:0];
reg  [2*DATA_WIDTH-1:0] res_o    [MAX_DIM-1:0][MAX_DIM-1:0];
wire [DATA_WIDTH-1:0]   a_matrix [MAX_DIM-1:0][MAX_DIM:0];
wire [DATA_WIDTH-1:0]   b_matrix [MAX_DIM:0][MAX_DIM-1:0];
wire [2*DATA_WIDTH-1:0] c_matrix [MAX_DIM-1:0][MAX_DIM-1:0];

genvar  i,j;
generate
  for (i = 0; i < MAX_DIM; i = i+1) begin : rows
    for (j = 0; j < MAX_DIM; j = j+1) begin : columns  
      pe #(.DATA_WIDTH(DATA_WIDTH)) pe (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .a_i(a_matrix[i][j]),
        .b_i(b_matrix[i][j]),
        .a_o(a_matrix[i][j+1]),
        .b_o(b_matrix[i+1][j]),
        .res_o(c_matrix[i][j])
      );
    end
  end

////   fix this part, not the same actions needed , see page 7 in project
  for (i = 0; i < MAX_DIM; i = i +1) begin : Left
     assign  a_matrix[i][0] = operandA_i[i][0]; 
  end

  for (j = 0; j < MAX_DIM; j = j +1) begin : Top
     assign b_matrix[0][j] = operandB_i[0][j];
  end
  
endgenerate


endmodule
