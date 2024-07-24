`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2024 09:11:07
// Design Name: 
// Module Name: Read_ptr_Empty
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


module Read_ptr_Empty #(
    parameter NUM_BITS = 4
)(
    input rd_clk, rd_rst, rd_en,
    input wire [NUM_BITS-1:0] w_ptr_gray_sync,
    output reg [NUM_BITS-1:0] rd_ptr_gray, rd_ptr_bin,
    output reg empty
    );
    
    ///// declaring rd_ptr_gray_nxt and rd_ptr_bin_nxt to store the incremented value of the pointer
    wire [NUM_BITS-1:0] rd_ptr_gray_nxt, rd_ptr_bin_nxt;
    
    /// incrementing the rd_ptr_bin_nxt by 1 to point to the next address when enable is 1 and empty is 0 
    assign rd_ptr_bin_nxt = rd_ptr_bin +(rd_en & !empty);
    
    /// Binary to gray conversion of the next gray pointer
    Binary2Gray converter(.bin_i(rd_ptr_bin_nxt), .gray_o(rd_ptr_gray_nxt));
    
    /// Assigning these next values to the rd_ptr_gray and rd_ptr_bin i.e. incrementing the pointers
    always @(posedge rd_clk or negedge rd_rst) begin
        if(!rd_rst) begin
            rd_ptr_gray <= 4'h0;
            rd_ptr_bin <= 4'h0;
        end
        else begin
            rd_ptr_gray <= rd_ptr_gray_nxt;
            rd_ptr_bin <= rd_ptr_bin_nxt;
        end
    end
    
    /// now for the empty flag output
    ///initializing the buffer empty 
    wire buff_empty;
    
    /// Passing the value to the empty flag after analyzing the condition
    always @(posedge rd_clk or negedge rd_rst) begin
        if(!rd_rst) 
           empty <= 1'b0; 
        
        else 
            empty <= buff_empty;
    end
    /// if the rd_ptr = w_ptr then the buffer is empty 
    assign buff_empty = (rd_ptr_gray_nxt[NUM_BITS-1:0] == w_ptr_gray_sync[NUM_BITS-1:0]);

endmodule
