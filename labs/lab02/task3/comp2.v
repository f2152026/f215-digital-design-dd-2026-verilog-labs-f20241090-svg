// comp2.v
// 2-bit unsigned magnitude comparator.
// Given two 2-bit values A and B, exactly one of GT, LT, EQ should be 1
// for any input combination.
//
// This module has a bug that a *self-checking* testbench should catch on
// its own -- you should not need to inspect the code below to find it.
// Write your testbench first, let it tell you something is wrong, THEN
// come back and fix this file.

module comp2 (
  input  [1:0] A,
  input  [1:0] B,
  output       GT,
  output       LT,
  output       EQ
);

  assign EQ = (A == B);
//  assign GT = (A >= B);
  assign GT = (A >  B); // Fixed: changed from >= to >
  assign LT = (A <  B);

endmodule
// BUG
// Because GT was implemented with >= instead of >, it incorrectly asserts 1 when $A$ equals $B$, 
// violating the requirement that exactly one output must be active at any given time.