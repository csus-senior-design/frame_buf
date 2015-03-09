`include "data_mem.v"

module memory_tb;
  reg clk, wr_en, rd_en, reset;
  reg [2:0] wr_addr, rd_addr;
  reg [15:0] wr_data;
  wire [15:0] rd_data;

  data_mem #(.DATA_WIDTH(16), .ADDR_WIDTH(3))
           uut (.clk(clk), .wr_en(wr_en), .rd_en(rd_en), .reset(reset),
            .wr_addr(wr_addr), .rd_addr(rd_addr), .wr_data(wr_data),
            .rd_data(rd_data));
            
  always #10 clk = ~clk;

  initial begin
    $monitor("wr_addr: %h, wr_data: %h", wr_addr, wr_data);
    $monitor("rd_addr: %h, rd_data: %h", rd_addr, rd_data);
    
    clk = 1'b0;
    wr_data = 16'h1;
    wr_en = 1'b1;
    rd_en = 1'b1;
    reset = 1'b0;
    wr_addr = 3'h0;
    rd_addr = 3'h0;

    #15 wr_en = 1'b0;
    reset = 1'b1;

    #10 wr_addr = wr_addr + 3'h1;
    wr_data = 16'h02;

    #10 wr_addr = wr_addr + 3'h1;
    wr_data = 16'h03;

    #10 wr_addr = wr_addr + 3'h1;
    wr_data = 16'h04;
    rd_en = 1'b0;

    #15 rd_addr = rd_addr + 3'h1;

    #15 rd_addr = rd_addr + 3'h1;

    #15 rd_addr = rd_addr + 3'h1;

    #10 $finish;
  end


`ifndef IVERILOG
    initial $vcdpluson;
`else
    initial $dumpfile("data_mem.vcd");
    initial $dumpvars(0, uut);
`endif
endmodule