//
// Verilog Module Ori_Alon_Lab_1_lib.apb_slave_module
//
// Created:
//          by - vain.UNKNOWN (TOMER)
//          at - 08:32:44 01/30/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps

module apb_slave_module(clk_i,rst_ni,psel_i,penable_i,pwrite_i,pstrb_i,pwdata_i,paddr_i,pready_o,pslverr_o,prdata_o,busy_o);
input clk_i,rst_ni,psel_i,penable_i,pwrite_i; // input ports
input pstrb_i,pwdata_i,paddr_i; // input ports
output pready_o,pslverr_o,prdata_o,busy_o; // output ports
parameter DATA_WIDTH = 32; // data width
parameter BUS_WIDTH = 64; // bus width
parameter ADDR_WIDTH = 32; // address width
localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH; // max dim of the matrix/ max dim of the matrix  NEVER USED
parameter [1:0] IDLE          = 2'b00,
			    ACCESS_READ   = 2'b01,
				ACCESS_WRITE  = 2'b10;					      
	

wire clk_i, rst_ni; // define clk and rst
wire psel_i,penable_i,pwrite_i; // psel - choose the module (we only have one - matmul) , penable - enable to the APB ,pwrite - write mode or read mode
wire [BUS_WIDTH/8-1:0] pstrb_i; //for every byte there is a Pstrb[n]
wire [BUS_WIDTH-1:0] pwdata_i; // data in
wire [ADDR_WIDTH-1:0] paddr_i; // address in
reg  pready_o,pready_next;    // ready out and next
reg  pslverr_o,pslverr_next;   // error out and next
reg  busy_o,next_busy;		  // busy out and next
reg  [BUS_WIDTH-1:0] prdata_o,prdata_next; // data out and next
reg  [1:0] current_state,next_state;   // current state and next
reg  [BUS_WIDTH-1:0] RAM [MAX_DIM*MAX_DIM-1:0]; // temp RAM

always @(psel_i,penable_i,current_state)	// combinatorical always
	begin: apb_comb
		 case(current_state)  // current state
      		IDLE: // idle
      			begin
      				if(psel_i) //if pslverr_o==1 then a reset is needed, can be changed if we want that pslverr_o	will not stop the APB			          				  
        				begin
      				       pready_next = 0; 
        				   next_busy   = 1;  
						   pslverr_next = 0;
          					if(pwrite_i)
            					begin
									next_state = ACCESS_WRITE; // next state is write
								end
							else
								begin
									next_state = ACCESS_READ; // next state is read	
								end	
						end
				end
	
   		   ACCESS_READ: // read state
      			begin
					if(next_state==ACCESS_READ) // if we are in read
						begin
							if(psel_i && !pstrb_i) // during READ all pstrob[n] must be low.
								begin
									pready_next  = penable_i ? 1 : 0;  // allow next op
									prdata_next  = penable_i ? RAM[paddr_i] : 0; //insert the data from ram to prdata_o bus.
									next_state   = penable_i ? IDLE : ACCESS_READ; // go to idle / stay
									next_busy    = penable_i ? 0: 1;  //  busy
									pslverr_next = 1'b0; // without an err
									/*
									if(penable_i) // enable read 
										begin
											pready_next  = 1;  // allow next op
											prdata_next  = RAM[paddr_i]; //insert the data from ram to prdata_o bus.
											next_state   = IDLE; // go to idle
											next_busy    = 0;  // isnt busy
											pslverr_next = 1'b0; // without an err
										end
										*/
								end
							else
								begin //if the psel fall betwine clocks the transaction is an error
          						next_state   = IDLE; // go to idle
          						pslverr_next = 1'b1; //either the sel fall during clocks or strob is not 0, transaction is not valid.
          						prdata_next  = 0; // data 0	
    					   end
					end
      			end
      			
      		ACCESS_WRITE: // write state
			    begin
					if(next_state==ACCESS_WRITE) // if we are in write
						begin
							if(psel_i)
								begin
									if(penable_i) //enable write
										begin
											pready_next      = 1; // allow next op
											RAM[paddr_i]     = pwdata_i;  //the stobe choose what bytes to write to RAM, need to ask ori
											next_state       = IDLE; // go to idle
											next_busy        = 0;  // isnt busy
											pslverr_next     = 1'b0;  // without an err
										end
								end
							else
								begin //if the psel fall during the transaction its an error
          						next_state   = IDLE; // go to idle
          						pslverr_next = 1'b1; // err
							end
						end
				end  
          
          default:
                next_state = IDLE;  // move to idle
       endcase
    end	

	
always @(posedge clk_i or negedge rst_ni) // Asyncronise reset and clk
begin: apb_clk
		if(~rst_ni) //reset, go back to idle and reset all outputs.
    		begin
    			current_state    <= IDLE; // state idle
    			pready_o 	     <= 1;   // ready 1
    			pslverr_o	     <= 0;   // err 0
    			prdata_o 	     <= 0;   // out data 0
    			busy_o           <= 0;	// busy 0
    		end
	    else 
			begin
				current_state    <= next_state; // move to next state
    			pready_o 	     <= pready_next; // move to next ready
    			pslverr_o	     <= pslverr_next; // move to next pslverr
    			prdata_o 	     <= prdata_next; // move to next out data
    			busy_o           <= next_busy; // move to next busy
			end
end
endmodule
// ### Please start your Verilog code here ### 


