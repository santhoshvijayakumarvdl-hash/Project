module read_pointer#(parameter pwidth=4)(
    input r_en, 
    input r_rst, 
    input r_clk,
    input [pwidth-1:0] g_wptr,
    output reg [pwidth-1:0] b_rptr, 
    output reg [pwidth-1:0] g_rptr,
    output reg empty
);
    wire [pwidth-1:0] g_rptr1;
    wire rempty;

    assign g_rptr1 = (b_rptr >> 1) ^ b_rptr;
    assign rempty = (g_rptr1 == g_wptr);

    always @(posedge r_clk or negedge r_rst) begin
        if (!r_rst) begin
            b_rptr <= 0;
            g_rptr <= 0;
            empty  <= 1;
        end 
        else begin
            if (r_en && !empty)
                b_rptr <= b_rptr + 1;
            g_rptr <= g_rptr1;
            empty  <= rempty;
        end
    end
endmodule

