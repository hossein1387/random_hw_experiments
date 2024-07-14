module simple_tb(
    input  logic        clk,
    input  logic        rst
  );
logic [3:0] counter;

simple uut (
    .clk(clk),
    .rst(rst),
    .counter(counter)
);

initial begin
    $dumpfile("simple_tb.vcd");
    $dumpvars(0, simple_tb);
    // #1000 $finish;
end

// always #5 clk = ~clk;

endmodule
