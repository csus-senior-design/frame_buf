`ifndef ASSERT
`define ASSERT 1'b0
`define DEASSERT 1'b1
`endif

module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 4, MEM_DEPTH = 1 << ADDR_WIDTH)
  (
      input [ADDR_WIDTH - 1:0] wr_addr, rd_addr,
      input [DATA_WIDTH - 1:0] wr_data,
      input clk, wr_en, rd_en, reset,
      output reg [DATA_WIDTH - 1:0] rd_data
    );

    reg [DATA_WIDTH - 1:0] mem [MEM_DEPTH - 1:0];
    integer i;

    always @(posedge clk) begin
        if (reset == `ASSERT)
            for (i = 0; i < MEM_DEPTH; i = i + 1)
                mem[i] <= {DATA_WIDTH{1'b0}};
        else if (wr_en == `ASSERT)
            mem[wr_addr] <= wr_data;
    end
    
    always @(*) begin
        if (rd_en == `ASSERT)
          rd_data <= mem[rd_addr];
        else
          rd_data <= {DATA_WIDTH{1'bZ}};
    end
    
endmodule