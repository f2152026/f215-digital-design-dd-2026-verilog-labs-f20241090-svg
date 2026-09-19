// tb.v
// Starter testbench template -- YOU complete this file.

module tb;
parameter WIDTH = 8;
  parameter DEPTH = 4;

  // TODO: declare the inputs and outputs
  reg  [$clog2(DEPTH)-1:0] sel;  
  wire [WIDTH-1:0]         dout; 

  integer i;

  // TODO: instantiate DUT here
  lut #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
  ) DUT (
    .sel(sel),
    .dout(dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    // TODO: apply different input combinations
sel = 0;
    #10;

    // TODO: apply different input combinations
    // Loop through all possible address combinations
    for (i = 0; i < DEPTH; i = i + 1) begin
      sel = i;
      #10; // Wait 10 time units to observe the output
    end

    $finish; 
  end

  initial
    $monitor("%0t | sel = %0d | dout = %0d", $time, sel, dout);

endmodule
