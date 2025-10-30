module top#(parameter pwidth=4,dwidth=8)(
input w_clk,w_en,r_clk,r_en,w_rst,r_rst,
input [pwidth-1:0] g_rptr,g_wptr,
input [dwidth-1:0] data_in,
input full,empty,
input [pwidth-1:0] b_wptr,b_rptr,
output [dwidth-1:0] data_out)
;

wire [pwidth-1:0] g_rptrs,g_wptrs;


dffsynch d1(w_clk,w_rst,g_rptr,g_rptrs);
dffsynch d2(r_clk,r_rst,g_wptr,g_wptrs);

write_pointer w1(w_en,w_rst,w_clk,g_rptrs,b_wptr,g_wptr,full);
read_pointer r1(r_en,r_rst,r_clk,g_wptrs,b_rptr,g_rptr,empty);

a_fifo f1(w_clk,w_en,b_wptr,b_rptr,data_in,full,empty,data_out);

endmodule
