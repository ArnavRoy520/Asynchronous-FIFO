`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2024 08:26:36
// Design Name: 
// Module Name: Write_ptr_Full
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


module Write_ptr_Full #(
    parameter NUM_BITS = 4
)
(
    input wire w_clk, w_rst, w_en,
    input wire [NUM_BITS-1:0] rd_ptr_gray_sync,
    output reg [NUM_BITS-1:0] w_ptr_gray, w_ptr_bin,
    output reg full
    );
    
    ///// declaring w_ptr_gray_nxt and w_ptr_bin_nxt to store the incremented value of the pointer
    wire [NUM_BITS-1:0] w_ptr_gray_nxt, w_ptr_bin_nxt;
    
    /// incrementing the w_ptr_bin_nxt by 1 to point to the next address when enable is 1 and full is 0 
    assign w_ptr_bin_nxt = w_ptr_bin +(w_en & !full);
    
    /// Binary to gray conversion of the next gray pointer
    Binary2Gray converter(.bin_i(w_ptr_bin_nxt), .gray_o(w_ptr_gray_nxt));
    
    /// Assigning these next values to the w_ptr_gray and w_ptr_bin i.e. incrementing the pointers
    always @(posedge w_clk or negedge w_rst) begin
        if(!w_rst) begin
            w_ptr_gray <= 4'h0;
            w_ptr_bin <= 4'h0;
        end
        else begin
            w_ptr_gray <= w_ptr_gray_nxt;
            w_ptr_bin <= w_ptr_bin_nxt;
        end
    end
    
    /// now for the full flag output
    ///initializing the buffer full 
    wire buff_full;
    
    /// Passing the value to the full flag after analyzing the condition
    always @(posedge w_clk or negedge w_rst) begin
        if(!w_rst) 
           full <= 1'b0; 
        
        else 
            full <= buff_full;
    end
    /// if the w_ptr 's MSB is high(different) and rest all the bits are same as the rd_ptr value then we can say that the stack is full
    assign buff_full = (w_ptr_gray_nxt == {~rd_ptr_gray_sync[NUM_BITS-1:NUM_BITS-2], rd_ptr_gray_sync[NUM_BITS-3:0]});

endmodule
