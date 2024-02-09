//
// Verilog Module Ori_Alon_Lab_1_lib.sp_module
//
// Created:
//          by - vain.UNKNOWN (TOMER)
//          at - 19:17:45 02/ 7/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module sp_module (clk_i,sp_number_i,rst_ni,write_enable_i,address_i,c_matrix_i,read_data_o); //descripition for all inputs\outputs
input clk_i,rst_ni; // clk,reset
input  sp_number_i; //number of bits for sp_ntargets is log2 of the number of addresses
input write_enable_i; // enable writing to operands
input address_i; // adress of writing (for line/col)
input c_matrix_i; //the data we want to write
output read_data_o; // the data we read (line/col)


parameter  SP_NTARGETS = 4; //The number of addressable targets in sp
parameter  DATA_WIDTH  = 32; // data width
parameter  BUS_WIDTH   = 64; // bus width
parameter  ADDR_WIDTH  = 32; // addr width
localparam MAX_DIM     = (BUS_WIDTH / DATA_WIDTH); // max dim matrix

//--------------------Wires-------------------
wire [ADDR_WIDTH-1:0] address_i; // adress of writing (for line/col)
wire [(MAX_DIM*MAX_DIM*2*(DATA_WIDTH))-1:0] c_matrix_i; //the input result matrix we need to save
wire [2*(DATA_WIDTH)-1:0] read_data_o; // the data we read (line/col)
wire [$clog2(MAX_DIM):0] sp_number_i; // the number of matrices, aka SPN
wire write_enable_i; //enabler to write the data
wire clk_i,rst_ni; // clk and rst
reg  [2*DATA_WIDTH-1:0] mem [SP_NTARGETS*MAX_DIM*MAX_DIM-1:0]; // where we keep the resulte matries. 

genvar b; // generate a var name
generate
	for(b = 0; b < MAX_DIM*MAX_DIM ; b = b+1 )
		begin: insert_word // using generate to split the vector c_matrix_i into the sp 
			always @(posedge clk_i) 
				begin: inserting // we want it to activate during clk or rst
					if (~rst_ni) //add reset
						begin
							mem[sp_number_i*MAX_DIM*MAX_DIM + address_i + b] <= 0; //implement 0 insted.
						end 
					else if(write_enable_i) //if enable 
						begin
							mem[sp_number_i*MAX_DIM*MAX_DIM + address_i + b] <= c_matrix_i[(b+1)*2*(DATA_WIDTH)-1:b*2*DATA_WIDTH]; // sub addressing 
						end
				end
		end 
endgenerate


assign read_data_o = (write_enable_i == 0) ? mem[address_i] : 0; //read data is when not on write mod


endmodule
