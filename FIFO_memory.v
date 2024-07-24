`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2024 11:50:16
// Design Name: 
// Module Name: FIFO_memory
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


module FIFO_memory #(
    parameter DATA_BITS = 8, NUM_BITS = 4, DEPTH = 16  
)
(
  input w_clk, w_en, rd_clk, rd_en,
  input [NUM_BITS-1:0] w_ptr_bin, rd_ptr_bin,
  input [DATA_BITS-1:0] Data_in,
  input full, empty,
  output reg [DATA_BITS-1:0] Data_out
    );
  reg [DATA_BITS-1:0] FIFO[0:DEPTH-1];
  
  always@(posedge w_clk) begin
    if(w_en & !full) begin
      FIFO[w_ptr_bin[NUM_BITS-1:0]] <= Data_in;
    end
  end
  
  always@(posedge rd_clk) begin
    if(rd_en & !empty) begin
      Data_out <= FIFO[rd_ptr_bin[NUM_BITS-1:0]];
    end
  end
  
endmodule
