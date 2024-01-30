//
// Test Bench Module Ori_Alon_Lab_1_lib.apb_slave_module_tb.apb_slave_module_tester
//
// Created:
//          by - vain.UNKNOWN (TOMER)
//          at - 12:07:10 01/30/2024
//
// Generated by Mentor Graphics' HDL Designer(TM) 2019.2 (Build 5)
//
`resetall
`timescale 1ns/10ps

module apb_slave_module_tb;

// Local declarations
parameter DATA_WIDTH = 32;
parameter BUS_WIDTH = 64;
parameter ADDR_WIDTH = 32;
parameter MAX_DIM = (BUS_WIDTH / DATA_WIDTH);
parameter IDLE_S = 2'b00;
parameter ACCESS_READ = 2'b01;
parameter ACCESS_WRITE = 2'b10;

// Internal signal declarations
wire clk_i;
wire rst_ni;
wire psel_i;
wire penable_i;
wire pwrite_i;
wire pstrb_i;
wire pwdata_i;
wire paddr_i;
wire pready_o;
wire pslverr_o;
wire prdata_o;
wire busy_o;


apb_slave_module #(32,64,32,(BUS_WIDTH / DATA_WIDTH),2'b00,2'b01,2'b10) U_0(
   .clk_i     (clk_i),
   .rst_ni    (rst_ni),
   .psel_i    (psel_i),
   .penable_i (penable_i),
   .pwrite_i  (pwrite_i),
   .pstrb_i   (pstrb_i),
   .pwdata_i  (pwdata_i),
   .paddr_i   (paddr_i),
   .pready_o  (pready_o),
   .pslverr_o (pslverr_o),
   .prdata_o  (prdata_o),
   .busy_o    (busy_o)
);

apb_slave_module_tester #(32,64,32,(BUS_WIDTH / DATA_WIDTH),2'b00,2'b01,2'b10) U_1(
   .clk_i     (clk_i),
   .rst_ni    (rst_ni),
   .psel_i    (psel_i),
   .penable_i (penable_i),
   .pwrite_i  (pwrite_i),
   .pstrb_i   (pstrb_i),
   .pwdata_i  (pwdata_i),
   .paddr_i   (paddr_i),
   .pready_o  (pready_o),
   .pslverr_o (pslverr_o),
   .prdata_o  (prdata_o),
   .busy_o    (busy_o)
);

endmodule // apb_slave_module_tb


