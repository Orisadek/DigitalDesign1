//
// Verilog Module Ori_Alon_Lab_1_lib.operands_module
//
// Created:
//          by - orisad.UNKNOWN (TOMER)
//          at - 00:35:28 02/ 2/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module operands_module(clk_i,rst_ni,write_enable_i,address_i,write_data_i,read_data_o); 
input clk_i,rst_ni; // clk,reset
input write_enable_i; // enable writing to operands
input  address_i; // adress of writing (for line/col)
input write_data_i; //the data we ant to write
output read_data_o; // the data we read (line/col)

parameter DATA_WIDTH = 32; // data width
parameter BUS_WIDTH = 64; // bus width
parameter ADDR_WIDTH = 32; // addr width
localparam MAX_DIM = (BUS_WIDTH / DATA_WIDTH); // max dim matrix
wire [ADDR_WIDTH-1:0] address_i; // adress of writing (for line/col)
wire [BUS_WIDTH-1:0] write_data_i; //the data we ant to write
wire [BUS_WIDTH-1:0] read_data_o; // the data we read (line/col)

    // Declare the registers
reg [BUS_WIDTH-1:0] registers [MAX_DIM-1:0]; // where we keep the operands
reg [MAX_DIM:0] index;  // Read and Write Logic

always @(posedge clk_i or negedge rst_ni)
 begin :memory_operands
    if (~rst_ni) // on negative edge
	begin
		for (index = 0; index < MAX_DIM; index = index[MAX_DIM-1:0] + 1) 
			begin
				registers[index] <= 0; // init to zero
			end
    end
	else if(write_enable_i) // if writing enable
		begin
			registers[address_i] <= write_data_i; // write the data
		end
end

    // Output assignment for read data
assign read_data_o = (write_enable_i == 0) ? registers[address_i] : 0; // read the data async

endmodule
