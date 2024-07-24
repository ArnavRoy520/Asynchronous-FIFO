`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2024 11:18:10
// Design Name: 
// Module Name: Synchronizer_r2w
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


module Synchronizer_r2w #(
    parameter NUM_BITS = 4
)
(
    input wire w_clk,
    input wire w_rst,
    input wire [NUM_BITS-1:0] rd_ptr_gray_async,
    output reg [NUM_BITS-1:0] rd_ptr_gray_sync
    );
    /// Initializing the intermediate connection between 2 D-ff
     reg [NUM_BITS-1:0]rd_ptr_gray_int;
     
     ///AT EVERY POSITIVE CLOCK EDGE THE two D-ffs assign their input to the outputs
     always @(posedge w_clk or negedge w_rst) begin
        if (!w_rst) 
            {rd_ptr_gray_sync,rd_ptr_gray_int} <= 0; 
         else 
            {rd_ptr_gray_sync,rd_ptr_gray_int} <= {rd_ptr_gray_int,rd_ptr_gray_async};         
      end
      
endmodule
