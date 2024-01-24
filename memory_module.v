//
// Verilog Module Ori_Alon_Lab_1_lib.memory_module
//
// Created:
//          by - orisad.UNKNOWN (TOMER)
//          at - 21:50:40 01/23/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module memory_modul(clk_i,addr_i,data_i,pwrite_i,data_o);
input clk_i,addr_i,data_i,pwrite_i;
output data_o;
parameter DATA_WIDTH = 32; // parameter for data
parameter BUS_WIDTH  = 64; // bus width
parameter ADDR_WIDTH = 32; // address width
parameter MAX_DIM    = BUS_WIDTH/DATA_WIDTH; // max dim of the matrix
parameter SPN        = 4;
parameter BYTE       = 8;
wire clk_i;
wire pwrite_i;
wire [ADDR_WIDTH-1:0] addr_i;
wire [BYTE-1:0] data_i;
wire [BYTE-1:0] data_o;
reg  [BYTE-1:0] mem [0:(2**ADDR_WIDTH)-1];

assign data_o = mem[addr_i];

always @(posedge clk_i)
	begin:write_to_mem
		if(pwrite_i)
		    begin
		      mem[addr_i] <= data_i;
		    end 
	end



// ### Please start your Verilog code here ### 

endmodule
