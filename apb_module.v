//
// Verilog Module Ori_Alon_Lab_1_lib.apb_module
//
// Created:
//          by - orisad.UNKNOWN (TOMER)
//          at - 17:14:48 01/21/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module apb_module(clk_i,rst_ni,psel_i,penable_i,pwrite_i,pstrb_i,
pwdata_i,paddr_i,pready_o,pslverr_o,prdata_o);
input clk_i,rst_ni,psel_i,penable_i,pwrite_i; // input ports
input pstrb_i,pwdata_i,paddr_i; // input ports
output pready_o,pslverr_o,prdata_o; // output ports
parameter DATA_WIDTH = 32; // data width
parameter BUS_WIDTH = 64; // bus width
parameter ADDR_WIDTH = 32; // address width
localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH; // max dim of the matrix
parameter [1:0] 	  IDLE          = 2'b00,
			          SETUP         = 2'b01,
			          ACCESS_READ   = 2'b10,
					  ACCESS_WRITE  = 2'b10;
		
wire clk_i, rst_ni; // define clk and rst
wire psel_i,penable_i,pwrite_i; // psel - choose the module (we only have one - matmul) , penable - enable to the APB ,pwrite - write mode or read mode
wire [MAX_DIM-1:0] pstrb_i; 
wire [BUS_WIDTH-1:0] pwdata_i;
wire [ADDR_WIDTH-1:0] paddr_i;
reg  pready_o,pslverr_o;
reg  [BUS_WIDTH-1:0] prdata_o;
reg  [1:0] current_state,next_state;
reg  next_pready_o,next_pslverr_o;
reg  [BUS_WIDTH-1:0] next_prdata_o;  

// ### Please start your Verilog code here ### 

always @(posedge clk_i) // remember to add negedge!!!!!!!!!!!
begin : apb_seq
	if(~rst_ni)
		begin
			current_state  <= IDLE_S;
			pready_o 	   <= next_pready_o;
			pslverr_o	   <= next_pslverr_o;
			prdata_o 	   <= next_prdata_o;
		end
	else 
		begin
			current_state <= next_state;
			pready_o  	  <= next_pready_o;
			pslverr_o 	  <= next_pslverr_o;
			prdata_o  	  <= next_prdata_o;
		end
end
	
always @(current_state or psel_i or penable_i)
begin: apb_comb
	case(current_state)
		SETUP:
			begin
				if(psel_i == 1'b1)
					begin
						if(pwrite == 1'b0)
							begin
								next_pslverr_o = 1'b0;
								next_state = ACCESS_READ;
							end
						else if(pwrite == 1'b1)
							begin
								next_pslverr_o = 1'b0;
								next_state = ACCESS_WRITE;
							end
						else 
							begin
								next_pslverr_o = 1'b0;
							end
						next_pready_o  = 1'b0;
						next_prdata_o  = 0;
					end
				else
					begin
					  next_pready_o  = 1'b1;
					  next_pslverr_o = 1'b0;
					  next_prdata_o  = 0;
					end
			end
		ACCESS_READ:
			begin
				if(penable_i == 1'b1)
					begin
						
						next_pready_o  = 1'b0;
						next_pslverr_o = 1'b0;
						next_prdata_o  = 0;
					end
				else
					begin
						next_pready_o  = 1'b0;
						next_pslverr_o = 1'b0;
						next_prdata_o  = 0;	
					end
			end
		ACCESS_WRITE:
			begin
			  	next_state = IDLE_S;
				//To be continued..... !
			end
		default :
			next_state = IDLE_S;
	endcase	
end
endmodule
