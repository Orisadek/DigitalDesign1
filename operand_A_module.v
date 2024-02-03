//
// Verilog Module Ori_Alon_Lab_1_lib.operand_A_module
//
// Created:
//          by - vain.UNKNOWN (TOMER)
//          at - 01:51:38 02/ 1/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//


`resetall
`timescale 1ns/10ps

module register_file (
    input clk,
    input rst_ni,
    input write_enable,
    input [ADDR_WIDTH-1:0] address,
    input [DATA_WIDTH-1:0] write_data,
    output [DATA_WIDTH-1:0] read_data
);

    parameter DATA_WIDTH = 32;
    parameter BUS_WIDTH = 64;
    parameter ADDR_WIDTH = 32;
    parameter MAX_DIM = (BUS_WIDTH / DATA_WIDTH);

    // Declare the registers
    reg [DATA_WIDTH-1:0] registers [MAX_DIM^2-1:0];
    reg [MAX_DIM^2-1:0]  index;  // Read and Write Logic
    always @(posedge clk or negedge rst_ni) begin
        if (~rst_ni) begin
          for (index = 0; index < MAX_DIM^2; index = index + 1) 
          begin
            registers[i] <= 0;
          end
        end
        else 
          if(write_enable) begin
          registers[address] <=  write_data;
        end
    end

    // Output assignment for read data
    assign read_data = registers[address];

endmodule


/*
module operand_A_module(read_target_i,Mod_bit_i,rst_ni,data_i,addrs_i);



input read_target_i,Mod_bit_i,rst_ni,data_i;
wire read_target_i,Mod_bit_i;
wire [DATA_WIDTH-1:0] data_i;
wire [ADDR_WIDTH-1:0] addrs_i;
reg [DATA_WIDTH-1:0] RAM [MAX_DIM*MAX_DIM-1:0];

always @(posedge read_target_i) begin: insert
  if(addrs_i>
  RAM[addrs_i
end






// ### Please start your Verilog code here ### 

endmodule
*/