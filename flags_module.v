//
// Verilog Module Ori_Alon_Lab_1_lib.flags_module
//
// Created:
//          by - vain.UNKNOWN (TOMER)
//          at - 18:59:30 02/ 5/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module flags_module (clk_i,rst_ni,write_enable_i,write_data_i,read_data_o);
input clk_i,rst_ni; // clk,reset
input write_enable_i; // enable writing to operands (can be the data ready in the matmul)
input write_data_i; //the data we want to write (Max_dim^2 bits, each for every square)
output read_data_o; // the data we read (Max_dim^2 length register)

parameter DATA_WIDTH = 32; // data width
parameter BUS_WIDTH = 64; // bus width
parameter MAX_DIM = (BUS_WIDTH / DATA_WIDTH); // max dim matrix

wire [MAX_DIM^2-1:0] write_data_i; //the data we ant to write
wire [MAX_DIM^2-1:0] read_data_o; // the data we read (line/col)

    // Declare the register
reg [MAX_DIM*MAX_DIM-1:0] Mem; // a register MAX_DIM^2 LENGTH, each bit is corspond to the matmul square that indicats where there is an over\under flow

always @(posedge clk_i or negedge rst_ni) begin: insert
    if (!rst_ni) // on negative edge
	     begin
				  Mem <= 0; // init to zero
       end
	  else if(write_enable_i) // if writing enable pass all bits of Flags in matmul
		begin
			    Mem <= write_data_i;
		end
 end

         // Output assignment for read data
assign read_data_o = Mem; // read the data async
endmodule
