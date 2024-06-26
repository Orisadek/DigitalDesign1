//
// Test Bench Module Ori_Alon_Lab_1_lib.pe_module_tester.pe_module_tester
//
// Created:
//          by - orisad.UNKNOWN (TOMER)
//          at - 22:31:00 01/18/2024
//
// Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
//
`resetall
`timescale 1ns/10ps
module pe_module_tester (clk_i,
                         rst_ni,
                         a_i,
                         b_i,
						 start_i,
                         a_o,
                         b_o,
                         res_o,
						 overflow_o
                        );

// Local declarations

parameter DATA_WIDTH = 32;


output clk_i;
output rst_ni;
output a_i;
output b_i;
output start_i;
input  a_o;
input  b_o;
input  res_o;
input overflow_o;

reg clk_i;
reg rst_ni;
reg start_i;
reg [DATA_WIDTH-1:0] a_i;
reg [DATA_WIDTH-1:0] b_i;
wire [DATA_WIDTH-1:0] a_o;
wire [DATA_WIDTH-1:0] b_o;
wire [2*DATA_WIDTH-1:0] res_o;
wire overflow_o;



initial begin: setup_clk
  clk_i = 1'b0;
  forever #1 clk_i = ~clk_i;
end

initial begin: setup_rst
  rst_ni = 1'b0;
  #10 rst_ni = 1'b1;
end

initial begin: setup_start_bit
  start_i = 1'b0;
  #20 start_i = 1'b1;
end

initial begin: setup_inputs
	a_i = 20;  
	b_i = 15;
end

always @(negedge clk_i)
begin
	if(rst_ni == 1'b1)
		begin
				a_i = a_i+1;
				b_i = b_i-1;
		end
end
		



endmodule // pe_module_tester


