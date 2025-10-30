module a_fifo #(parameter pwidth=4, dwidth=8,depth=8)(
input w_clk,w_en,
input [pwidth-1:0] b_wptr,b_rptr,
input [dwidth-1:0] data_in,
input full,empty,
output [dwidth-1:0] data_out
);

  reg[dwidth-1:0] fifo [0:depth-1];

always@(posedge w_clk) begin
if(w_en & !full) 
    fifo[b_wptr[pwidth-1:0]]<=data_in;
    end
    assign data_out= fifo[b_rptr[pwidth-1:0]];
endmodule
