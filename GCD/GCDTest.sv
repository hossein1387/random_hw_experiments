module GCDTest;
logic clk, rst, done;
logic [31:0] a,b,gcd;

GCD gcd_inst(.clk(clk),.rst_n(rst),.a_in(a), .b_in(b), .done(done), .gcd(gcd));

always #5 clk = !clk;

function int gcd_fcn(int a, int b);
    return b == 0 ? a : gcd_fcn(b, a % b);
endfunction

initial begin
  int NUM_TESTS = 100;
  int expected_val = 0;
  int test_id = 0;
  rst=1; 
  #500;
  rst = 0;
  a = 14;
  b = 161;
//  for(int i=0; i<NUM_TESTS; i++) begin
  while(test_id<NUM_TESTS) begin
    a = $urandom_range(1000,10);
    b = $urandom_range(1000,10);    
  @(posedge done)
    test_id++;
  expected_val = gcd_fcn(a,b);
  if(expected_val==gcd) begin
       $display("[%4d]-GCD(%4d,%4d): expected=%4d   actual=%4d  PASS", test_id, a, b, expected_val, gcd); 
  end else begin
       $display("[%4d]-GCD(%4d,%4d): expected=%4d   actual=%4d  FAIL", test_id, a, b, expected_val, gcd);
       $finish; 
  end
  #50;
  end
end 


initial begin
#600us;
$finish();
end

endmodule
