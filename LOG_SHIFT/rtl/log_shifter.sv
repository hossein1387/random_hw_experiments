
// :Example: Structural Description Of Logarithmic Shifter
//
// This is a structural description of a particular way of building a
// w-bit shifter, one using lg w stages, each stage consisting of a
// multiplexor. Though it is far simpler than the 16-input mux
// variations, it is still more complicated than it needs to be. A
// better solution would use what's called a generate loop.
//
module shift_right_logarithmic
  ( input wire [15:0] s0,
    input wire [3:0] amt,
    output wire [15:0] sh );

   wire [15:0] s1, s2, s3;

   // Shift by either 0 or 1 bits.
   //
   mux2 st0(.select(amt[0]), .a0(s0), .a1({1'b0, s0[15:1]}), .out( s1) );

   // Shift by either 0 or 2 bits.
   //
   mux2 st1(.select(amt[1]), .a0(s1), .a1({2'b0, s1[15:2]}), .out( s2) );

   // Shift by either 0 or 4 bits.
   //
   mux2 st2(.select(amt[2]), .a0(s2), .a1({4'b0, s2[15:4]}), .out( s3) );

   // Shift by either 0 or 8 bits.
   //
   mux2 st3(.select(amt[3]), .a0(s3), .a1({8'b0, s3[15:8]}), .out( sh) );

endmodule

module mux2
  ( input wire select,
    input wire [15:0] a0,
    input wire [15:0] a1,
    output wire [15:0] out );

    assign out = select ? a1 : a0;

endmodule
