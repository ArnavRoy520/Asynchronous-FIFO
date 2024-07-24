`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2024 08:25:57
// Design Name: 
// Module Name: Top_Module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top_Module #(
    parameter NUM_BITS=4, DATA_BITS=8
    )
(
  input w_clk, w_rst,
  input rd_clk, rd_rst,
  input w_en, rd_en,
  input [DATA_BITS-1:0] Data_in,
  output reg [DATA_BITS-1:0] Data_out,
  output reg full, empty
    );
    ///First of all we will caluculate the depth of the FIFO
    /// As we are using the gray coded address so DEPTH can only be power of 2.
    parameter DEPTH = 2**NUM_BITS;
    
    ///Initializing all the address pointers
    reg [NUM_BITS-1:0] w_ptr_gray_sync, rd_ptr_gray_sync;
    reg [NUM_BITS-1:0] w_ptr_bin, rd_ptr_bin;
    reg [NUM_BITS-1:0] w_ptr_gray, rd_ptr_gray;
    
    Synchronizer_r2w #(NUM_BITS) syncr2w(.w_clk(w_clk),
                                         .w_rst(w_rst),
                                         .rd_ptr_gray_async(rd_ptr_gray),
                                         .rd_ptr_gray_sync(rd_ptr_gray_sync)
                                         );
    Synchronizer_w2r #(NUM_BITS) syncw2r(.rd_clk(rd_clk),
                                         .rd_rst(rd_rst),
                                         .w_ptr_gray_async(w_ptr_gray),
                                         .w_ptr_gray_sync(w_ptr_gray_sync)
                                         );
    Write_ptr_Full #(NUM_BITS) W_POINTER(.w_clk(w_clk),
                                         .w_rst(w_rst),
                                         .w_en(w_en),
                                         .rd_ptr_gray_sync(rd_ptr_gray_sync),
                                         .w_ptr_gray(w_ptr_gray),
                                         .w_ptr_bin(w_ptr_bin),
                                         .full(full)
                                         );
   Read_ptr_Empty #(NUM_BITS) Rd_POINTER(.rd_clk(rd_clk),
                                         .rd_rst(rd_rst),
                                         .rd_en(rd_en),
                                         .w_ptr_gray_sync(w_ptr_gray_sync),
                                         .rd_ptr_gray(rd_ptr_gray),
                                         .rd_ptr_bin(rd_ptr_bin),
                                         .empty(empty)
                                         );
   FIFO_memory #(DATA_BITS,NUM_BITS,DEPTH) Memory_Buffer(.w_clk(w_clk),
                                                         .w_en(w_en),
                                                         .rd_clk(rd_clk),
                                                         .rd_en(rd_en),
                                                         .w_ptr_bin(w_ptr_bin),
                                                         .rd_ptr_bin(rd_ptr_bin),
                                                         .Data_in(Data_in),
                                                         .full(full),
                                                         .empty(empty),
                                                         .Data_out(Data_out)
                                                         );                                      
endmodule
