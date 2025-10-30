`timescale 1ns/1ps

module tb_async_fifo;

    parameter PWIDTH = 4;
    parameter DWIDTH = 8;

    reg w_clk, r_clk;
    reg w_en, r_en;
    reg w_rst, r_rst;
    reg [DWIDTH-1:0] data_in;

    wire [DWIDTH-1:0] data_out;
    wire [PWIDTH-1:0] g_rptr, g_wptr;
    wire [PWIDTH-1:0] b_rptr, b_wptr;
    wire full, empty;
top #(PWIDTH, DWIDTH) uut (
        .w_clk(w_clk),
        .w_en(w_en),
        .r_clk(r_clk),
        .r_en(r_en),
        .w_rst(w_rst),
        .r_rst(r_rst),
        .g_rptr(g_rptr),
        .g_wptr(g_wptr),
        .data_in(data_in),
        .full(full),
        .empty(empty),
        .b_wptr(b_wptr),
        .b_rptr(b_rptr),
        .data_out(data_out)
    );

    
    always #10  w_clk = ~w_clk;   
    always #7.5 r_clk = ~r_clk;  

    
    initial begin
        $dumpfile("async_fifo.vcd");
        $dumpvars(0, tb_async_fifo);
        $display("Time\tw_en\tr_en\tfull\tempty\tb_wptr\tb_rptr\tdata_in\tdata_out");

        w_clk = 0;
        r_clk = 0;
        w_en = 0;
        r_en = 0;
        w_rst = 0;
        r_rst = 0;
        data_in = 8'hA0;

       
        #30;
        w_rst = 1;
        r_rst = 1;
        #20;

        repeat (8) begin
            @(negedge w_clk);
            if (!full) begin
                w_en = 1;
                data_in = data_in + 8'h01;
            end
        end
        @(negedge w_clk);
        w_en = 0;

       
        #200;

        repeat (8) begin
            @(negedge r_clk);
            if (!empty)
                r_en = 1;
        end
        @(negedge r_clk);
        r_en = 0;

        #200;
        $finish;
    end

endmodule
