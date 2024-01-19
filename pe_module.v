//
// Verilog Module Ori_Alon_Lab_1_lib.pe_module
//
// Created:
//          by - orisad.UNKNOWN (TOMER)
//          at - 20:17:33 01/18/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module pe_module(clk_i,rst_ni,a_i,b_i,a_o,b_o,res_o);//module ports
input clk_i, rst_ni,a_i,b_i; // define inputs 
output a_o,b_o,res_o; // define outputs
parameter DATA_WIDTH = 32; // parameter for data
wire clk_i, rst_ni; // define clk and rst
wire [DATA_WIDTH-1:0] a_i ,b_i; // value inputs
reg [DATA_WIDTH-1:0] a_o ,b_o; // value to move on to the next pe
reg [2*DATA_WIDTH-1:0] res_o; // result of matrix index


// ### Please start your Verilog code here ### 

always @(posedge clk_i) // wake in rising edge of clock or falling edge of reset
begin : multiply_and_acc 
  if(~rst_ni) // in negative edge
    begin
      a_o      <= 0; // initialize A out
      b_o      <= 0; // initialize B out
      res_o    <= 0; // initialize result
    end
  else
    begin  
      res_o <= res_o + (a_i * b_i); // multiple the argument and add to result
      a_o      <= a_i; // move A to next pe
      b_o      <= b_i; // move B to next pe
  end
end
endmodule
