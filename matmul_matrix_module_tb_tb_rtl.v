//
// Test Bench Module Ori_Alon_Lab_1_lib.matmul_matrix_module_tb.matmul_matrix_module_tester
//
// Created:
//          by - orisad.UNKNOWN (TOMER)
//          at - 23:04:22 01/30/2024
//
// Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
//
`resetall
`timescale 1ns/10ps

module matmul_matrix_module_tb;

// Local declarations
parameter DATA_WIDTH = 8;
parameter BUS_WIDTH = 16;
localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH; // max dim of the matrix

// Internal signal declarations
wire clk_i;
wire rst_ni;
wire [2:0] n_dim_i;
wire [2:0] k_dim_i;
wire [2:0] m_dim_i;
wire start_i;
wire [(MAX_DIM*MAX_DIM*DATA_WIDTH)-1:0] a_matrix_i;
wire [(MAX_DIM*MAX_DIM*DATA_WIDTH)-1:0] b_matrix_i;
wire [(MAX_DIM*MAX_DIM*2*(DATA_WIDTH))-1:0] c_matrix_o;
wire [(MAX_DIM*MAX_DIM) -1:0] flags_o;
wire finish_mul_o;

matmul_matrix_module #(.DATA_WIDTH(8),.BUS_WIDTH(16)) U_0(
   .clk_i      (clk_i),
   .rst_ni     (rst_ni),
   .n_dim_i    (n_dim_i),
   .k_dim_i    (k_dim_i),
   .m_dim_i    (m_dim_i),
   .start_i    (start_i),
   .a_matrix_i (a_matrix_i),
   .b_matrix_i (b_matrix_i),
   .c_matrix_o (c_matrix_o),
   .flags_o    (flags_o),
   .finish_mul_o (finish_mul_o)
);

matmul_matrix_module_tester #(.DATA_WIDTH(8),.BUS_WIDTH(16)) U_1(
   .clk_i      (clk_i),
   .rst_ni     (rst_ni),
   .n_dim_i    (n_dim_i),
   .k_dim_i    (k_dim_i),
   .m_dim_i    (m_dim_i),
   .start_i    (start_i),
   .a_matrix_i (a_matrix_i),
   .b_matrix_i (b_matrix_i),
   .c_matrix_o (c_matrix_o),
   .flags_o    (flags_o),
   .finish_mul_o (finish_mul_o)
);

endmodule // matmul_matrix_module_tb


