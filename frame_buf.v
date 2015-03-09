`ifndef ASSERT
`define ASSERT 1'b0
`define DEASSERT 1'b1
`endif

`include "data_mem/data_mem.v"

module frame_buf #(DATA_WIDTH = 24, ADDR_WIDTH = 3,
                    MEM_DEPTH = 1 << ADDR_WIDTH, NUM_BUFS = 1)
  (
    input clk, reset, wr_en_in, rd_en_in,
    input [DATA_WIDTH - 1:0] data_in,
    output [DATA_WIDTH - 1:0] data_out
  );
  
  parameter IDLE = 1'h0, FILL = 1'h1;
  
  reg wr_en, rd_en;
  reg [ADDR_WIDTH - 1:0] wr_addr, rd_addr;
  reg [1:0] curr_state, next_state;
  
  data_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(NUM_BUFS * ADDR_WIDTH))
           mem (.clk(clk), .wr_en(wr_en), .rd_en(rd_en), .reset(reset),
            .wr_addr(wr_addr), .rd_addr(rd_addr), .wr_data(data_in),
            .rd_data(data_out));
            
  always @(posedge clk) begin
    if (reset == `ASSERT) begin
      curr_state <= FILL;
      rd_en <= `DEASSERT;
      wr_en <= `DEASSERT;
    end else begin
      curr_state <= next_state;
  end
  
  always @(posedge clk) begin
    case (curr_state)
      IDLE:   begin
                if (wr_en_in == `ASSERT) begin
                  next_state <= FILL;
                  wr_addr <= {ADDR_WIDTH{1'b0}};
                end
              end
            
      FILL:   begin
                if (wr_addr == {ADDR_WIDTH{1'b1}})
                  next_state <= IDLE;
                else if (wr_en_in == `ASSERT) begin
                  mem_rdy <= 1'b1;
                  wr_en <= `ASSERT;
                  wr_addr <= wr_addr + 1;
                end else
                  wr_en <= `DEASSERT;
              end
    endcase
  end
  
  always @(*) begin
    if (rd_en_in == `ASSERT && mem_rdy <= 1'b1)
      rd_en <= `ASSERT;
  end

endmodule