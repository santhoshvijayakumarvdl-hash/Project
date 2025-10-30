module dffsynch #(parameter pwidth=4)(
input clk,rst,
input[pwidth-1:0] ptr,
output reg[pwidth-1:0] out );
reg[pwidth-1:0] q;
always@(posedge clk) begin
  if(!rst)
        out<=0;
     else begin
        q<=ptr;
        out<=q;
        end
end
endmodule
