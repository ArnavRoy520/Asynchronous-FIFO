`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2024 11:26:58
// Design Name: 
// Module Name: Synchronizer_w2r
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


module Synchronizer_w2r #(
    parameter NUM_BITS = 4
)
(
    input wire rd_clk,
    input wire rd_rst,
    input wire [NUM_BITS-1:0] w_ptr_gray_async,
    output reg [NUM_BITS-1:0] w_ptr_gray_sync
    );
    /// Initializing the intermediate connection between 2 D-ff
     reg [NUM_BITS-1:0]w_ptr_gray_int;
     
     ///AT EVERY POSITIVE CLOCK EDGE THE two D-ffs assign their input to the outputs
     always @(posedge rd_clk or negedge rd_rst) begin
        if (!rd_rst) 
            {w_ptr_gray_sync,w_ptr_gray_int} <= 0; 
         else 
            {w_ptr_gray_sync,w_ptr_gray_int} <= {w_ptr_gray_int,w_ptr_gray_async};         
      end
endmodule
