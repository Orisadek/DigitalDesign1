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
module matmul_matrix_module(clk_i,rst_ni,N_i,K_i,M_i,start_i,a_matrix_i,b_matrix_i,c_matrix_o);
//-------------------ports----------------------------------------------
input  clk_i,rst_ni,start_i; // clock , reset , start bit from control
input  a_matrix_i,b_matrix_i; // the matrices are actually two long registers
input  N_i,K_i,M_i; // matrix A is NxK , matrix B KxM
output c_matrix_o; // output matrix is actually long matrix 
//-----------------parameters-----------------------------------------
parameter DATA_WIDTH = 32; // data width
parameter BUS_WIDTH = 64; // bus width
parameter MAX_DIM = BUS_WIDTH/DATA_WIDTH; // max dim of the matrix
//-----------------variables------------------------------------------
wire clk_i,rst_ni,start_i;// clock , reset , start bit from control
reg  [1:0] N_i,K_i,M_i; // matrix A is NxK , matrix B KxM
reg  [(MAX_DIM*MAX_DIM*DATA_WIDTH)-1:0] a_matrix_i; // this matrix is actually  long register
reg  [(MAX_DIM*MAX_DIM*DATA_WIDTH)-1:0] b_matrix_i; // this matrix is actually  long register
reg  [(MAX_DIM*MAX_DIM*2*DATA_WIDTH)-1:0] c_matrix_o; // output matrix is actually long matrix
wire [DATA_WIDTH-1:0]   matA [0:MAX_DIM-1][0:MAX_DIM-1]; // wires for pe's rows
wire [DATA_WIDTH-1:0]   matB [0:MAX_DIM-1][0:MAX_DIM-1]; // wires for pe's cols
wire [2*DATA_WIDTH-1:0] matC [0:MAX_DIM-1][0:MAX_DIM-1]; // wires for pe's results

genvar  i,j; 
generate
  for (i = 0; i < MAX_DIM; i = i+1) begin : rows 
    for (j = 0; j < MAX_DIM; j = j+1) begin : columns  
      pe #(.DATA_WIDTH(DATA_WIDTH)) pe (
        .clk_i(clk_i), //clk
        .rst_ni(rst_ni), // reset
        .a_i(matA[i][j]), // a element in
        .b_i(matB[i][j]), // b element in
        .a_o(matA[i][j+1]), // a element out
        .b_o(matB[i+1][j]), // b element out
        .res_o(matC[i][j]) // result out
      );
    end 
  end
  
/*
////   fix this part, not the same actions needed , see page 7 in project
  for (i = 0; i < MAX_DIM; i = i +1) begin : Left
     assign  a_matrix[i][0] = operandA_i[i][0]; 
  end

  for (j = 0; j < MAX_DIM; j = j +1) begin : Top
     assign b_matrix[0][j] = operandB_i[0][j];
  end
*/ 
endgenerate

always @(posedge clk_i) // TODO : add reset
  begin: insert_vector_a
	if(start_i) //TODO:add index of clk (acc)
		begin
			for (i = 0; i < MAX_DIM; i = i+1) // TODO: change counter i  
				begin : Left
				   matA[i][0] <= a_matrix_i[(i*MAX_DIM*DATA_WIDTH)+:(i*MAX_DIM*DATA_WIDTH+DATA_WIDTH)]; //TODO:change to matrix and then move the data 
				end
		end
   end

always @(posedge clk_i) //TODO: add reset
  begin: insert_vector_b
	if(start_i) //TODO:add index of clk (acc)
		begin
			for (j = 0; j < MAX_DIM; j = j+1) // TODO: change counter j  
				begin : Top  
				    matB[0][j] <= operandB_i[0][j];  //TODO:change to matrix and then move the data 
				end
		end
  end

endmodule
