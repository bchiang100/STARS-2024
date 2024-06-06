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
  logic Cout;
  logic [3:0] S;
  
   //bcdadd1 bcd1 (.A(pb[3:0]), .B(pb[7:4]), .Cin(pb[8]), .Cout_bcd(Cout), .S2(S));
  // ssdec ssdec1 (.in(pb[3:0]), .out(ss7[6:0]), .enable(1'b1));
  // ssdec ssdec2 (.in(pb[7:4]), .out(ss5[6:0]), .enable(1'b1));
  // ssdec ssdec3 (.in({3'b0, Cout}), .out(ss1[6:0]), .enable(1'b1));
  // ssdec ssdec4 (.in(S), .out(ss0[6:0]), .enable(1'b1));

  // Encoder 20 to 5
  logic [4:0] carry;
  enc20to5 enc1 (.in(pb[19:0]), .out(carry), .strobe(red));
  //bcdadd1 bcd2 (.A)
  ssdec ssdec1 (.in(carry[3:0]), .enable(1'b1), .out(ss0[6:0]));
  //ssdec ssdec2 (.in({3'b0, value[1]}), .enable(1'b1), .out(ss1[6:0]));
  assign right [4:0] = carry;
  
  
endmodule

module ssdec (
input logic [3:0] in,
input logic enable,
output logic [6:0] out
);
always_comb begin
  case(in)
    4'b0000: begin out = 7'b0111111; end
    4'b0001: begin out = 7'b0000110; end
    4'b0010: begin out = 7'b1011011; end
    4'b0011: begin out = 7'b1001111; end
    4'b0100: begin out = 7'b1100110; end
    4'b0101: begin out = 7'b1101101; end
    4'b0110: begin out = 7'b1111101; end
    4'b0111: begin out = 7'b0000111; end
    4'b1000: begin out = 7'b1111111; end
    4'b1001: begin out = 7'b1100111; end
    4'b1010: begin out = 7'b1110111; end
    4'b1011: begin out = 7'b1111100; end
    4'b1100: begin out = 7'b0111001; end
    4'b1101: begin out = 7'b1011110; end
    4'b1110: begin out = 7'b1111001; end
    4'b1111: begin out = 7'b1110001; end
    default: begin out = '0; end
  endcase
end

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
  logic Cin0,  Cin1, Cin2;
  logic Cout0, Cout1, Cout2; 
fa adder1 (.A(A[0]), .B(B[0]), .Cin(Cin), .Cout(Cout0), .S(S[0]));
fa adder2 (.A(A[1]), .B(B[1]), .Cin(Cout0), .Cout(Cout1), .S(S[1]));
fa adder3 (.A(A[2]), .B(B[2]), .Cin(Cout1), .Cout(Cout2), .S(S[2]));
fa adder4 (.A(A[3]), .B(B[3]), .Cin(Cout2), .Cout(Cout), .S(S[3]));
endmodule

module bcdadd1 (
  input logic [3:0] A, B,
  input logic Cin,
  output logic Cout_bcd, 
  output logic [3:0] S2
);
  logic [3:0] newB, S1;
  logic Cout1;
// 4-bit ripple carry adder
  fa4 fa4_1 (.A(A), .B(B), .Cin(Cin), .Cout(Cout1), .S(S1));
  //Cout_bcd || ((S1[3] && S1[2]) || (S1[3] && S1[1]) > 4'b1001) ? newB = 4'b0110 : newB = 4'b0000;
  always_comb begin
    if (Cout1 || (S1 > 4'b1001)) begin
      newB = 4'b0110;
      Cout_bcd = 1'b1;
    end
    else begin
      newB = 4'b0000;
      Cout_bcd = 1'b0;
    end
  end

  fa4 fa4_2 (.A(S1), .B(newB), .Cin(1'b0), .Cout(), .S(S2));
endmodule

module enc20to5 (
  input logic [19:0] in,
  output logic [4:0] out,
  output logic strobe
);
  

  assign strobe = |in;
  logic [31:0] i;
  always_comb begin
    out = 0;
    for(i = 0; i < 32; i++)
      if (in[i[4:0]])
      out = i[4:0];
 end
 

endmodule
