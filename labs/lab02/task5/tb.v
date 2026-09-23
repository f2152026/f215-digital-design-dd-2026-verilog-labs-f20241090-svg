// tb.v
// Self-checking testbench for alu module following the t_ naming convention

module tb;

  reg  [3:0] t_a;
  reg  [3:0] t_b;
  reg        t_op;
  wire [3:0] t_result;

  // Self-checking control variables
  reg  [3:0] exp_result;
  integer    errors = 0;
  integer    total = 0;

  // Instantiate the DUT with mapped port connections
  alu u_dut (
    .a(t_a),
    .b(t_b),
    .op(t_op),
    .result(t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, u_dut);
    end
  end

  initial begin
    $display("--- Starting ALU Self-Checking Tests ---");

    // Test Group 1: Fixed operands, toggling op (checks sensitivity-list bug)
    t_a = 4'b0101; // 5
    t_b = 4'b0011; // 3

    t_op = 1'b0; #10; // ADD (5 + 3 = 8)
    check_result();

    t_op = 1'b1; #10; // SUB (5 - 3 = 2)
    check_result();

    t_op = 1'b0; #10; // Toggle back to ADD with same operands
    check_result();


    // Test Group 2: Changing operands across both operations (checks blocking/non-blocking bug)
    repeat (12) begin
      t_a = $urandom;
      t_b = $urandom;

      t_op = 1'b0; #10; // ADD
      check_result();

      t_op = 1'b1; #10; // SUB
      check_result();
    end

    // Summary Report
    $display("--------------------------------------------------");
    $display("Test Finished: Passed %0d / %0d tests (%0d errors).", 
             (total - errors), total, errors);
    if (errors == 0)
      $display("RESULT: PASS");
    else
      $display("RESULT: FAIL");
    $display("--------------------------------------------------");

    $finish;
  end

  // Task to compute expected results independently and assert correctness
  task check_result;
    begin
      total = total + 1;
      if (t_op == 1'b0)
        exp_result = t_a + t_b;
      else
        exp_result = t_a - t_b;

      #1; // Small delta delay for signal propagation
      if (t_result !== exp_result) begin
        $display("FAIL at time %0t: op=%b a=%b b=%b | got result=%b | expected=%b",
                 $time, t_op, t_a, t_b, t_result, exp_result);
        errors = errors + 1;
      end
    end
  endtask

  initial
    $monitor($time, " op=%b a=%b b=%b | result=%b", t_op, t_a, t_b, t_result);

endmodule
// end of tb.v