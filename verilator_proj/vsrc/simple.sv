module simple(
    input logic clk,
    input logic rst,
    output logic [3:0] counter
);

always @(posedge clk or posedge rst) begin
    if (!rst) begin
        counter <= 4'b0000;
    end else begin
        counter <= counter + 1;
    end
end

endmodule
