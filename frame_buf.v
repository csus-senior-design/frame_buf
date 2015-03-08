`ifndef ASSERT
`define ASSERT 1'b0
`define DEASSERT 1'b1
`endif

`include "data_mem.v"

module frame_buf #(DATA_WIDTH = 32, ADDR_WIDTH = 3)
  (
    input clk,
    input [DATA_WIDTH - 1:0] data_in,
    output [DATA_WIDTH - 1:0] data_out
  );
  
  
  
  data_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH))
           mem (.clk(clk), .wr_en(wr_en), .rd_en(rd_en), .reset(reset),
            .wr_addr(wr_addr), .rd_addr(rd_addr), .wr_data(wr_data),
            .rd_data(rd_data));
            
  always @(posedge clk) begin
    
  end
  
endmodule