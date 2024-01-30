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
parameter [1:0] IDLE_S        = 2'b00,
			          ACCESS_READ   = 2'b01,
					      ACCESS_WRITE  = 2'b10;
					      
		
wire clk_i, rst_ni; // define clk and rst
wire psel_i,penable_i,pwrite_i; // psel - choose the module (we only have one - matmul) , penable - enable to the APB ,pwrite - write mode or read mode
wire [BUS_WIDTH/8-1:0] pstrb_i; //for every byte there is a Pstrb[n]
wire [BUS_WIDTH-1:0] pwdata_i;
wire [ADDR_WIDTH-1:0] paddr_i;
reg  pready_o,pslverr_o,busy_o;
reg  [BUS_WIDTH-1:0] prdata_o;
reg  [1:0] state;  
reg  [DATA_WIDTH-1:0] RAM [0:2**ADDR_WIDTH-1];

// ### Please start your Verilog code here ### 
	
	
	
	
	
always @(posedge clk_i) //we can do Asyncronise reset if we desire
begin: apb_comb
		if(!rst_ni) //reset, go back to idle and reset all outputs.
    		begin
    			state          <= IDLE_S;
    			pready_o 	     <= 0;
    			pslverr_o	     <= 0;
    			prdata_o 	     <= 0;
    			busy_o         <= 0;
    		end
	  else 
	   begin
 	    case(state) //no reset, let us 
      		IDLE_S:
      			begin
      				if(psel_i) //if pslverr_o==1 then a reset is needed, can be changed if we want that pslverr_o	will not stop the APB			          				  
        				begin
      				     pready_o <= 0;
        				   busy_o   <= 1;  
          					if(pwrite_i)
            					 begin
        	           state <= ACCESS_WRITE;
       	          end
   	           else
   	              begin
        					     	 state <= ACCESS_READ;	
      				       	end	
      	   		end
	   		  end
	
   		   ACCESS_READ:
      			begin
      				if(psel_i && !pstrb_i) // during READ all pstrob[n] must be low.
      				  	begin
      				  	  if(penable_i)
      				  	     begin
                    pready_o <= 1;
                    prdata_o <= RAM[paddr_i]; //insert the data from ram to prdata_o bus.
 		                state    <= IDLE_S;
 		                busy_o   <= 0;
					        end
					     end
					 else
					   begin //if the psel fall betwine clocks the transaction is an error
          						state     <= IDLE_S;
          						pslverr_o <= 1'b1; //ether the sel fall during clocks or strob is not 0, transaction is not valid.
          						prdata_o  <= 0;	
          						busy_o    <= 0;
    					   end
      			end
      			
      		ACCESS_WRITE: //TODO
			    begin
      				if(psel_i)
      				  	begin
      				  	  if(penable_i)
      				  	     begin
                    pready_o      <= 1;
                    RAM[paddr_i]  <= pwdata_i;  //the stobe choose what bytes to write to RAM, need to ask ori
 		                state         <= IDLE_S;
 		                busy_o        <= 0;
					        end
					    end
					 else
					   begin //if the psel fall during the transaction its an error
          						state     <= IDLE_S;
          						pslverr_o <= 1'b1;
          						prdata_o  <= 0;	
    					   end
          end  
          
          default:
                state <= IDLE_S;  

       endcase
    end
end
endmodule
// ### Please start your Verilog code here ### 


