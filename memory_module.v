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
parameter SPN        = 4;
localparam BYTE      = 8;
localparam MAX_DIM   = BUS_WIDTH/DATA_WIDTH; // max dim of the matrix

wire clk_i;
wire pwrite_i;
wire [ADDR_WIDTH-1:0] addr_i;
wire [DATA_WIDTH-1:0] data_i;
wire [DATA_WIDTH-1:0] data_o;
reg  [DATA_WIDTH-1:0] mem [ADDR_WIDTH*ADDR_WIDTH-1:0];

assign data_o = pwrite_i?0:mem[addr_i];

always @(posedge clk_i)
	begin:write_to_mem
		if(pwrite_i)
		    begin
		      mem[addr_i] <= data_i;
		    end 
	end



// ### Please start your Verilog code here ### 

endmodule
