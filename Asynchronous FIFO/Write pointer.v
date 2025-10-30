module write_pointer# (parameter pwidth=4)( 
input w_en,w_rst,w_clk,
input [pwidth-1:0] g_rptr,
output reg [pwidth-1:0] b_wptr,g_wptr,
output reg full );
wire  [pwidth-1:0] g_wptr1;
wire wfull;
always@(posedge w_clk , negedge w_rst) begin
    if(!w_rst)begin
        b_wptr<=0;
        g_wptr<=0;
        full<=0;
     end
     else begin
     
     if(!wfull&w_en) begin
        b_wptr<=b_wptr+1;
        end
        
        g_wptr<=g_wptr1;
        full<=wfull;
    end
 end
 assign g_wptr1=(b_wptr>>1)^b_wptr;
 assign wfull =(g_wptr1 =={ ~g_rptr[pwidth-1:pwidth-2], g_rptr[pwidth-3:0]});
endmodule 
