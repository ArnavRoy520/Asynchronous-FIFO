`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2024 09:55:15
// Design Name: 
// Module Name: Binary2Gray
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


module Binary2Gray #(
    parameter NUM_BITS=4
)(
    input [NUM_BITS-1:0]bin_i,
    output [NUM_BITS-1:0]gray_o
    );
    
    assign gray_o[NUM_BITS-1] = bin_i[NUM_BITS-1];
    genvar i;
    for(i = NUM_BITS-2; i>=0; i=i-1)
        assign gray_o[i]=bin_i[i+1] ^ bin_i[i];  
endmodule
