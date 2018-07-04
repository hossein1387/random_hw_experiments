import utils::*;

module log_shift_tester;

    parameter INPUT_WIDTH = 16;
    parameter WEIGHT_WIDTH = 4;
    logic [INPUT_WIDTH-1:0] s0;
    logic [WEIGHT_WIDTH-1:0] amt;
    logic [INPUT_WIDTH-1:0] sh;
    shift_right_logarithmic shift_right_logarithmic_inst(.s0(s0), .amt(amt), .sh(sh));
    initial begin
        test_stats test_stat;
        print_verbosity verbosity = VERB_LOW;
        int unsigned num_tests = 100;
        int unsigned s0_val, amt_val;
        test_stat.pass_cnt = 0;
        test_stat.fail_cnt = 0;
        for (int test_id=0; test_id<num_tests; test_id++) begin
            string test_res_str;
            int unsigned expected_val;
            s0_val = $urandom_range(0,2**(INPUT_WIDTH)-1);
            amt_val = $urandom_range(0, 2**(WEIGHT_WIDTH)-1);
            expected_val= s0_val >> amt_val;
            s0 = s0_val; amt = amt_val;
            #1
            if (expected_val == sh) begin
                `test_print("INFO", $sformatf("[%0d] input vector=%h shift amount=%0d output vector=%h expected val=%0d  Test PASS", test_id, s0, amt, sh, expected_val), verbosity);
                test_stat.pass_cnt++;
            end else begin
                `test_print("ERROR", $sformatf("[%0d] input vector=%h shift amount=%0d output vector=%h expected val=%0d  Test FAILED", test_id, s0, amt, sh, expected_val), verbosity);
                test_stat.fail_cnt++;
            end
        end
        $finish();
    end 

    initial begin
        $dumpfile("gcd_normal.vcd");
        $dumpvars(1);
    end

    initial begin
        #600ms;
        $display("Simulation took more than expected ( more than 600ms)");
        $finish();
    end

endmodule
