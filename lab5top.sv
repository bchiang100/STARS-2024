`default_nettype none
// Empty top module

module top (
  // I/O ports
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  
  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);

// 1-bit ripple carry adder
//fa onebit (.A(pb[2]), .B(pb[1]), .Cin(pb[0]), .Cout(right[1]), .S(right[0]));

// 4-bit ripple carry adder
fa4 fourbit (.A(pb[3:0]), .B(pb[7:4]), .Cin(pb[8]), .Cout(right[4]), .S(right[3:0]));

endmodule

module fa(
  input logic A, B, Cin,
  output logic Cout, S
);

  assign Cout = B && Cin || A && B || A && Cin;
  assign S = ~A && ~B && Cin || ~A && B && ~Cin || A && B && Cin || A && ~B && ~Cin;

endmodule

module fa4(
  input logic [3:0] A, B,
  input logic Cin,
  output logic Cout, 
  output logic [3:0] S
);
  logic Cin0, Cin1, Cin2;
  logic Cout0, Cout1, Cout2; 
fa adder1 (.A(A[0]), .B(B[0]), .Cin(Cin), .Cout(Cout0), .S(S[0]));
fa adder2 (.A(A[1]), .B(B[1]), .Cin(Cout0), .Cout(Cout1), .S(S[1]));
fa adder3 (.A(A[2]), .B(B[2]), .Cin(Cout1), .Cout(Cout2), .S(S[2]));
fa adder4 (.A(A[3]), .B(B[3]), .Cin(Cout2), .Cout(Cout), .S(S[3]));
endmodule
