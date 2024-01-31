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
module matmul_matrix_module(clk_i,rst_ni,n_dim_i,k_dim_i,m_dim_i
,start_i,a_matrix_i,b_matrix_i,c_matrix_o,flags_o);
//-------------------ports----------------------------------------------
input  clk_i,rst_ni,start_i; // clock , reset , start bit from control
input  a_matrix_i,b_matrix_i; // the matrices are actually two long registers
input  n_dim_i,k_dim_i,m_dim_i; // matrix A is NxK , matrix B KxM
output c_matrix_o,flags_o; // output matrix is actually long matrix 
//-----------------parameters-----------------------------------------
parameter DATA_WIDTH = 8; // data width
parameter BUS_WIDTH = 16; // bus width
localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH; // max dim of the matrix
localparam MATRIX_WORD = MAX_DIM*DATA_WIDTH;
//-----------------variables------------------------------------------
wire clk_i,rst_ni,start_i;// clock , reset , start bit from control
wire [1:0] n_dim_i,k_dim_i,m_dim_i; // matrix A is NxK , matrix B KxM
wire signed [(MAX_DIM*MAX_DIM*DATA_WIDTH)-1:0] a_matrix_i; // this matrix is actually  long register
wire signed [(MAX_DIM*MAX_DIM*DATA_WIDTH)-1:0] b_matrix_i; // this matrix is actually  long register
wire  signed [(MAX_DIM*MAX_DIM*2*(DATA_WIDTH))-1:0] c_matrix_o; // output matrix is actually long matrix
wire [(MAX_DIM*MAX_DIM) -1:0]  flags_o;
wire signed [DATA_WIDTH-1:0]   matA [MAX_DIM:0][MAX_DIM:0]; // wires for pe's rows
wire signed [DATA_WIDTH-1:0]   matB [MAX_DIM:0][MAX_DIM:0]; // wires for pe's cols
wire signed [2*DATA_WIDTH-1:0] matC [MAX_DIM-1:0][MAX_DIM-1:0]; // wires for pe's results
reg  signed [DATA_WIDTH-1:0]   regMatA[MAX_DIM-1:0]; // wires for pe's rows
reg  signed [DATA_WIDTH-1:0]   regMatB[MAX_DIM-1:0]; // wires for pe's rows

reg  signed [2*MAX_DIM :0] counter,index_a,index_b;


genvar  i,j; 
generate
//-----------------------general connction (without last row and col)----------------------------
  for (i = 0; i < MAX_DIM; i = i+1)
   begin : rows 
      for (j = 0; j < MAX_DIM; j = j+1)
         begin : columns  
            pe_module #(.DATA_WIDTH(DATA_WIDTH)) U_pe (
             .clk_i(clk_i), //clk
             .rst_ni(rst_ni), // reset
             .a_i(matA[i][j]), // a element in
             .b_i(matB[i][j]), // b element in
             .a_o(matA[i][j+1]), // a element out
             .b_o(matB[i+1][j]), // b element out
             .res_o(matC[i][j]), // result out 
             .start_i(start_i),
		     .overflow_o(flags_o[i+j*MAX_DIM])
           );
    end 
  end
endgenerate

//-------------------assign values----------------------------------------
generate
  for (j = 0; j < MAX_DIM; j = j +1) begin : rows_assign
	   for (i = 0; i < MAX_DIM; i = i +1) begin : cols_assign
		     assign c_matrix_o[(j*DATA_WIDTH*MAX_DIM*2+i*(DATA_WIDTH*2))+: 2*DATA_WIDTH] = matC[i][j];
	   end
  end
 endgenerate  
//-------------------assign start----------------------------------------
generate
  for (i = 0; i < MAX_DIM; i = i +1) begin : Left_assign
     assign  matA[i][0] = regMatA[i]; 
  end
 endgenerate
 
 generate
  for (j = 0; j < MAX_DIM; j = j +1) begin : Top_assign
     assign  matB[0][j] = regMatB[j]; 
  end
 endgenerate


 
//-----------------operations with clock----------------------------------------------------
always @(posedge clk_i or negedge rst_ni)//
  begin: acc_counter
  if(~rst_ni) // in negative edge
		begin
			counter  <= 0;
		end
  else if(start_i)
		begin
			counter <= counter+1;
		end
  end
 
always @(posedge clk_i or negedge rst_ni) 
  begin: insert_vector_a
    if(~rst_ni)
     begin
        for (index_a = 0; index_a < MAX_DIM; index_a = index_a+1)
          begin : reset_a
			       regMatA[index_a] <= {DATA_WIDTH{1'b0}};
		      end
	   end
   else if(start_i && counter <(k_dim_i+m_dim_i+n_dim_i-2)) 
		begin
			for (index_a = 0; index_a < MAX_DIM; index_a = index_a+1) // TODO: change counter i  
				begin : Left
				    regMatA[index_a] <= (counter-index_a>=0 && counter-index_a<{{2*MAX_DIM-1{1'b0}},k_dim_i} && index_a < {{2*MAX_DIM-1{1'b0}},n_dim_i}) ?
					a_matrix_i[(index_a*MATRIX_WORD)+((counter-index_a)*DATA_WIDTH)+:DATA_WIDTH] : {DATA_WIDTH{1'b0}};
				end
		end
 end


always @(posedge clk_i or negedge rst_ni) 
 begin: insert_vector_b
   if(~rst_ni)
     begin
        for (index_b = 0; index_b < MAX_DIM; index_b = index_b+1)
          begin : reset_b
			       regMatB[index_b] <= {DATA_WIDTH{1'b0}};
		      end
	    end
    else if(start_i && counter<(k_dim_i+m_dim_i+n_dim_i-2)) 
		begin
			for (index_b = 0; index_b < MAX_DIM; index_b = index_b+1)  
				begin : Top  
					regMatB[index_b] <= (counter-index_b>=0 && counter-index_b<{{2*MAX_DIM-1{1'b0}},m_dim_i} && index_b < {{2*MAX_DIM-1{1'b0}},k_dim_i}) ?
					b_matrix_i[(index_b*MATRIX_WORD)+((counter-index_b)*DATA_WIDTH)+:DATA_WIDTH]: {DATA_WIDTH{1'b0}};
				end
		end	
end



endmodule
