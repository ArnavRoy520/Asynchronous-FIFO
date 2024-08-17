`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2024 19:18:07
// Design Name: 
// Module Name: Testbench
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

module Testbench();
    parameter DATA_BITS = 8;
    parameter NUM_BITS = 4;
    parameter DEPTH = 16;
    wire [DATA_BITS-1:0] Data_out;
    reg [DATA_BITS-1:0] Data_in;
    reg w_clk, w_rst, w_en;
    reg rd_clk, rd_rst, rd_en;
    wire full, empty;
    
    // Array to store data_in
    reg [DATA_BITS-1:0] wdata_q[DEPTH-1:0];
    reg [NUM_BITS-1:0] write_pointer, read_pointer;
    reg [DATA_BITS-1:0] wdata;

    // Instantiating the Top Module
    Top_Module AsyncFIFO (
        .w_clk(w_clk),
        .w_rst(w_rst),
        .rd_clk(rd_clk),
        .rd_rst(rd_rst),
        .w_en(w_en),
        .rd_en(rd_en),
        .Data_in(Data_in),
        .Data_out(Data_out),
        .full(full),
        .empty(empty)
    );
     
    // Dumping the top_module and variables
    initial begin
        $dumpfile("Top_Module.vcd");
        $dumpvars(0, Testbench,Data_out, wdata);
    end                                 
     
    // Initializing the write clock
    // Time Period of the clock is 20ns            
    always begin
        #10 w_clk = ~w_clk;
    end
     
    // Initializing the read clock
    // Time Period of the clock is 30ns (The time period of both the clocks are different to keep it Asynchronous)             
    always begin
        #15 rd_clk = ~rd_clk;
    end
    
    // Writing the data into FIFO
    initial begin
        // Initializing all the inputs as '0'
        w_clk = 1'b0;
        w_rst = 1'b0;
        w_en = 1'b0;
        Data_in = 8'h00;
        write_pointer = 0;
        
        // Resetting after 10 clock cycles
        repeat(10) @(posedge w_clk);
        w_rst = 1'b1;

        repeat(2) begin
            for (integer i = 0; i < 30; i = i + 1) begin
                @(posedge w_clk);
                ///Duty cycle 50%
                if (!full && (i % 2 == 0)) begin
                    w_en = 1'b1;
                    Data_in = $urandom % 256;  // Limiting to 8-bit range
                    wdata_q[write_pointer] = Data_in;
                    write_pointer = write_pointer + 1;
                end 
                else begin
                    w_en = 1'b0;
                end
            end
            #50;
        end
    end 
    
    // Reading the data from FIFO
    initial begin
        rd_clk = 1'b0; 
        rd_rst = 1'b0;
        rd_en = 1'b0;
        read_pointer = 0;
        
        // Resetting after 20 clock cycles
        repeat(10) @(posedge rd_clk);
        rd_rst = 1'b1;

        repeat(2) begin
            for (integer j = 0; j < 30; j = j + 1) begin
                @(posedge rd_clk);
                ///Duty cycle 50%
                if (!empty && (j % 2 == 0)) begin
                    rd_en = 1'b1;
                    wdata = wdata_q[read_pointer];
                    read_pointer = read_pointer + 1;
                    if (Data_out !== wdata) 
                        $display("Time = %0t: Comparison Failed: expected wr_data = %h, rd_data = %h", $time, wdata, Data_out);
                    else 
                        $display("Time = %0t: Comparison Passed: wr_data = %h and rd_data = %h", $time, wdata, Data_out);
                end 
                else begin
                    rd_en = 1'b0;
                end
            end
            #50;
        end
        end
// Ensure simulation runs long enough
    initial begin
        #99999999; // Extend time as needed
        $finish;
    end                                     
endmodule
