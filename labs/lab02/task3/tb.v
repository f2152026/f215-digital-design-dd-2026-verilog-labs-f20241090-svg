// tb.v
//  testbench for comp2

module tb;

  // Updated DUT inputs for 2-bit A and B
  reg  [1:0] t_a, t_b;
  // Updated DUT outputs for comparator
  wire       t_gt, t_lt, t_eq;

  // Self-checking variables
  reg        exp_gt, exp_lt, exp_eq;
  integer    errors = 0;
  integer    total = 0;
  
  // Instantiate DUT, connecting to comp2 ports
  comp2 u_dut (
    .A(t_a),
    .B(t_b),
    .GT(t_gt),
    .LT(t_lt),
    .EQ(t_eq)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, u_dut );
      // $dumpvars(0, DUT );
    end
  end

  initial begin
    // Exhaustive test applying all 16 combinations 5 time units apart
    for (integer i = 0; i < 4; i = i + 1) begin
      for (integer j = 0; j < 4; j = j + 1) begin
        t_a = i[1:0];
        t_b = j[1:0];
        #5;

        // Compute expected outputs independently
        exp_gt = (t_a > t_b);
        exp_lt = (t_a < t_b);
        exp_eq = (t_a == t_b);
        total  = total + 1;

        // Self-checking assertion
        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%b B=%b | got GT=%b LT=%b EQ=%b | expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
      end
    end

    // Summary report
    $display("--------------------------------------------------");
    $display("Test Finished: Passed %0d / %0d combinations (%0d errors).", 
             (total - errors), total, errors);
    if (errors == 0)
      $display("RESULT: PASS");
    else
      $display("RESULT: FAIL");
    $display("--------------------------------------------------");

    $finish;
  end

  initial
    $monitor($time, " A=%b B=%b | GT=%b LT=%b EQ=%b", t_a, t_b, t_gt, t_lt, t_eq);

endmodule
// end of tb.v